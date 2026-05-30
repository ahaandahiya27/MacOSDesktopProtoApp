#!/bin/bash
# run_overnight_v3_3agents.sh — launch 3 parallel Claude agents overnight with
# ISOLATED per-agent DerivedData paths.
#
# Why v3 exists
# -------------
# The v2 run (commit b7118dd / STOP_AND_ASK.md) deadlocked: all three agents'
# pre-push gates shared one TMPDIR DerivedData path, so 7-8 concurrent
# xcodebuild jobs corrupted each other's module caches and OOM-killed the
# 8 GB Late-2014 iMac's Swift compiler. v3 fixes the root cause:
#
#   1. Each agent gets its OWN DerivedData path: /tmp/dd-agent-<LETTER>-<PID>.
#      Exported as CI_DERIVED_OVERRIDE (honoured by scripts/ci-build-test.sh's
#      pre-push gate) AND XCODEBUILD_DERIVED_DATA_PATH (for any per-commit
#      gate block that calls xcodebuild -derivedDataPath directly). No two
#      agents ever share build artifacts.
#   2. A pre-flight clean (scripts/clean_overnight_artifacts.sh) nukes stale
#      dd-agent-* paths from prior runs before the fleet starts.
#   3. The pre-push hook serializes the xcodebuild-bearing gate behind
#      scripts/hooks/build-mutex.sh, so even simultaneous gates can't run two
#      heavy builds at once. (Belt-and-suspenders on top of #1.)
#
# See DISTRIBUTION.md "Per-agent DerivedData policy" for the rationale.
#
# Usage
# -----
#   bash scripts/run_overnight_v3_3agents.sh             # launch the fleet
#   bash scripts/run_overnight_v3_3agents.sh --dry-run   # validate setup only
#   bash scripts/run_overnight_v3_3agents.sh --force     # ignore an existing lock
#
# Per-agent prompts (operator-supplied at the repo root before launch):
#   SUPERPROMPT_10H_OVERNIGHT_v3_A_ADAPTIVE_PRACTICE.md
#   SUPERPROMPT_10H_OVERNIGHT_v3_B_CERT_100_AND_CRASHLOG.md
#   SUPERPROMPT_10H_OVERNIGHT_v3_C_INFRA_HARDENING.md
#
# Logs land under .overnight-v3-<LETTER>-logs/. Sentinels to grep for on
# completion are printed at launch.
#
# BSD/Big Sur only. set -u (NOT -e: we must keep going past a single agent's
# launch hiccup to start the others).

set -u

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

# ── Config ────────────────────────────────────────────────────────────────
LOCK_DIR="$REPO_ROOT/.overnight-v3.lock"
DD_ROOT="/tmp"                       # per-agent DerivedData lives in /tmp
# How to invoke a headless dangerous-mode agent. Override via $CLAUDE_INVOKE.
# The prompt file path is appended as the final argument target via stdin.
CLAUDE_BIN="${CLAUDE_BIN:-claude}"

# Agent table: LETTER | prompt file | log dir | sentinel
AGENTS="
A|SUPERPROMPT_10H_OVERNIGHT_v3_A_ADAPTIVE_PRACTICE.md|.overnight-v3-A-logs|ADAPTIVE_PRACTICE_COMPLETE_SENTINEL_v1
B|SUPERPROMPT_10H_OVERNIGHT_v3_B_CERT_100_AND_CRASHLOG.md|.overnight-v3-B-logs|CERT_100_AND_CRASHLOG_COMPLETE_SENTINEL_v1
C|SUPERPROMPT_10H_OVERNIGHT_v3_C_INFRA_HARDENING.md|.overnight-v3-C-logs|INFRA_HARDENING_COMPLETE_SENTINEL_v1
"

DRY_RUN=0
FORCE=0
for arg in "$@"; do
    case "$arg" in
        --dry-run|-n) DRY_RUN=1 ;;
        --force|-f)   FORCE=1 ;;
        --help|-h)    sed -n '2,45p' "$0"; exit 0 ;;
        *) echo "unknown flag: $arg" >&2; exit 2 ;;
    esac
done

# ── Pre-flight: clean stale artifacts ───────────────────────────────────────
if [ -x "$REPO_ROOT/scripts/clean_overnight_artifacts.sh" ]; then
    echo "==> pre-flight: cleaning stale DerivedData"
    if [ "$DRY_RUN" -eq 1 ]; then
        bash "$REPO_ROOT/scripts/clean_overnight_artifacts.sh" --dry-run
    else
        bash "$REPO_ROOT/scripts/clean_overnight_artifacts.sh"
    fi
else
    echo "WARN: scripts/clean_overnight_artifacts.sh missing — skipping pre-flight clean." >&2
fi

# ── Acquire fleet lock (mkdir is atomic) ─────────────────────────────────────
if [ "$DRY_RUN" -eq 0 ]; then
    if ! mkdir "$LOCK_DIR" 2>/dev/null; then
        if [ "$FORCE" -eq 1 ]; then
            echo "==> --force: removing existing lock $LOCK_DIR"
            rm -rf "$LOCK_DIR"; mkdir "$LOCK_DIR"
        else
            echo "ERROR: $LOCK_DIR exists — a fleet may already be running." >&2
            echo "       Re-run with --force to override, or remove the dir manually." >&2
            exit 1
        fi
    fi
    echo "$$" > "$LOCK_DIR/launcher.pid"
fi

# ── Validate prompts ─────────────────────────────────────────────────────────
missing=0
echo "$AGENTS" | while IFS='|' read -r L PROMPT LOGDIR SENTINEL; do
    [ -z "$L" ] && continue
    if [ ! -f "$REPO_ROOT/$PROMPT" ]; then
        echo "WARN: prompt for agent $L not found: $PROMPT" >&2
    fi
done
# (the subshell above can't set `missing`; re-check in the launch loop below)

# ── Launch loop ──────────────────────────────────────────────────────────────
echo ""
echo "==> launching 3-agent fleet (dry-run=$DRY_RUN)"
LAUNCH_TS="$(date +%Y%m%d-%H%M%S)"

printf '%s\n' "$AGENTS" | while IFS='|' read -r L PROMPT LOGDIR SENTINEL; do
    [ -z "$L" ] && continue

    DD_PATH="$DD_ROOT/dd-agent-${L}-$$"
    LOG_PATH="$REPO_ROOT/$LOGDIR"
    PROMPT_PATH="$REPO_ROOT/$PROMPT"

    echo ""
    echo "── Agent $L ───────────────────────────────────"
    echo "   prompt:       $PROMPT"
    echo "   DerivedData:  $DD_PATH"
    echo "   log dir:      $LOGDIR"
    echo "   sentinel:     $SENTINEL"

    if [ ! -f "$PROMPT_PATH" ]; then
        echo "   SKIP: prompt file missing (place it at repo root before launch)."
        continue
    fi

    if [ "$DRY_RUN" -eq 1 ]; then
        echo "   (dry-run) would export CI_DERIVED_OVERRIDE=$DD_PATH"
        echo "   (dry-run) would export XCODEBUILD_DERIVED_DATA_PATH=$DD_PATH"
        echo "   (dry-run) would launch: $CLAUDE_BIN --dangerously-skip-permissions"
        continue
    fi

    mkdir -p "$DD_PATH" "$LOG_PATH"
    AGENT_LOG="$LOG_PATH/agent-${L}-${LAUNCH_TS}.log"

    # Launch the agent with its OWN isolated DerivedData. Both env vars are
    # exported so the pre-push gate (CI_DERIVED_OVERRIDE) and any direct
    # per-commit xcodebuild (-derivedDataPath "$XCODEBUILD_DERIVED_DATA_PATH")
    # stay on this agent's private path. nohup + & detaches so all three run
    # concurrently; output is teed to the per-agent log.
    (
        export CI_DERIVED_OVERRIDE="$DD_PATH"
        export XCODEBUILD_DERIVED_DATA_PATH="$DD_PATH"
        export OVERNIGHT_AGENT_LETTER="$L"
        cd "$REPO_ROOT"
        nohup "$CLAUDE_BIN" --dangerously-skip-permissions -p "$(cat "$PROMPT_PATH")" \
            > "$AGENT_LOG" 2>&1 &
        echo "$!" > "$LOCK_DIR/agent-${L}.pid"
    )
    echo "   launched → PID $(cat "$LOCK_DIR/agent-${L}.pid" 2>/dev/null || echo '?'), log: $AGENT_LOG"
done

echo ""
if [ "$DRY_RUN" -eq 1 ]; then
    echo "==> dry-run complete. No agents launched. Lock not taken."
    exit 0
fi

echo "==> fleet launched. Watch for completion sentinels:"
echo "    ADAPTIVE_PRACTICE_COMPLETE_SENTINEL_v1   (Agent A)"
echo "    CERT_100_AND_CRASHLOG_COMPLETE_SENTINEL_v1 (Agent B)"
echo "    INFRA_HARDENING_COMPLETE_SENTINEL_v1     (Agent C)"
echo ""
echo "    Tail logs:   tail -f .overnight-v3-*-logs/agent-*-${LAUNCH_TS}.log"
echo "    PIDs:        $LOCK_DIR/agent-*.pid"
echo "    When done:   rm -rf $LOCK_DIR  (releases the fleet lock)"
exit 0
