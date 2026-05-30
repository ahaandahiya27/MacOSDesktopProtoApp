#!/bin/bash
# run_overnight_template.sh — reusable engine for multi-agent overnight runs.
#
# Purpose
# -------
# run_overnight_v3_3agents.sh hard-codes the v3 fleet. Future runs (v4, v5, …)
# shouldn't copy-paste 150 lines of launch/clean/lock logic and risk drifting
# from the per-agent-DerivedData policy that fixed the v2 contention blocker
# (b7118dd). This template factors out the common machinery so a new run is
# just a small config: a version tag and an AGENTS table.
#
# This file is intentionally self-contained and v3 stays independently
# functional — the template is the convenience path, not a hard dependency.
#
# How to use (two ways)
# ---------------------
# 1. Source it and call run_overnight_fleet after setting config vars:
#
#       #!/bin/bash
#       OVERNIGHT_VERSION="v4"
#       OVERNIGHT_AGENTS="
#       A|SUPERPROMPT_v4_A.md|.overnight-v4-A-logs|A_DONE_SENTINEL
#       B|SUPERPROMPT_v4_B.md|.overnight-v4-B-logs|B_DONE_SENTINEL
#       "
#       . "$(dirname "$0")/run_overnight_template.sh"
#       run_overnight_fleet "$@"
#
# 2. Run it directly with the config supplied via environment:
#
#       OVERNIGHT_VERSION=v4 OVERNIGHT_AGENTS="A|promptA.md|.logsA|SENT_A" \
#         bash scripts/run_overnight_template.sh --dry-run
#
# Config contract
# ---------------
#   OVERNIGHT_VERSION   short tag, e.g. "v3" → lock dir .overnight-v3.lock
#   OVERNIGHT_AGENTS    newline-separated "LETTER|PROMPT|LOGDIR|SENTINEL" rows
#   CLAUDE_BIN          claude binary (default: claude)
#   DD_ROOT             where per-agent DerivedData lives (default: /tmp)
#
# Invariant enforced for EVERY agent (the whole point of the template):
#   CI_DERIVED_OVERRIDE = XCODEBUILD_DERIVED_DATA_PATH = $DD_ROOT/dd-agent-<L>-<PID>
# so no two agents share build artifacts and the pre-push gate stays isolated.
#
# Flags: --dry-run (validate only), --force (ignore existing lock).
# BSD/Big Sur, set -u (not -e).

set -u

# ── Defaults (overridable by the caller's config) ────────────────────────────
: "${OVERNIGHT_VERSION:=vX}"
: "${OVERNIGHT_AGENTS:=}"
: "${CLAUDE_BIN:=claude}"
: "${DD_ROOT:=/tmp}"

_overnight_repo_root() {
    cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." && pwd
}

run_overnight_fleet() {
    local REPO_ROOT LOCK_DIR DRY_RUN FORCE arg LAUNCH_TS
    REPO_ROOT="$(_overnight_repo_root)"
    cd "$REPO_ROOT" || return 1
    LOCK_DIR="$REPO_ROOT/.overnight-${OVERNIGHT_VERSION}.lock"
    DRY_RUN=0; FORCE=0

    for arg in "$@"; do
        case "$arg" in
            --dry-run|-n) DRY_RUN=1 ;;
            --force|-f)   FORCE=1 ;;
            --help|-h)    sed -n '2,55p' "${BASH_SOURCE[0]:-$0}"; return 0 ;;
            *) echo "unknown flag: $arg" >&2; return 2 ;;
        esac
    done

    if [ -z "$OVERNIGHT_AGENTS" ]; then
        echo "ERROR: OVERNIGHT_AGENTS is empty — nothing to launch." >&2
        return 2
    fi

    # ── Pre-flight clean ─────────────────────────────────────────────────────
    if [ -x "$REPO_ROOT/scripts/clean_overnight_artifacts.sh" ]; then
        echo "==> pre-flight: cleaning stale DerivedData"
        if [ "$DRY_RUN" -eq 1 ]; then
            bash "$REPO_ROOT/scripts/clean_overnight_artifacts.sh" --dry-run
        else
            bash "$REPO_ROOT/scripts/clean_overnight_artifacts.sh"
        fi
    fi

    # ── Fleet lock ───────────────────────────────────────────────────────────
    if [ "$DRY_RUN" -eq 0 ]; then
        if ! mkdir "$LOCK_DIR" 2>/dev/null; then
            if [ "$FORCE" -eq 1 ]; then
                echo "==> --force: removing existing lock $LOCK_DIR"
                rm -rf "$LOCK_DIR"; mkdir "$LOCK_DIR"
            else
                echo "ERROR: $LOCK_DIR exists — a fleet may already be running (use --force)." >&2
                return 1
            fi
        fi
        echo "$$" > "$LOCK_DIR/launcher.pid"
    fi

    # ── Launch loop ──────────────────────────────────────────────────────────
    LAUNCH_TS="$(date +%Y%m%d-%H%M%S)"
    echo ""
    echo "==> ${OVERNIGHT_VERSION} fleet (dry-run=$DRY_RUN)"

    printf '%s\n' "$OVERNIGHT_AGENTS" | while IFS='|' read -r L PROMPT LOGDIR SENTINEL; do
        [ -z "$L" ] && continue
        local DD_PATH="$DD_ROOT/dd-agent-${L}-$$"
        local PROMPT_PATH="$REPO_ROOT/$PROMPT"
        local LOG_PATH="$REPO_ROOT/$LOGDIR"

        echo ""
        echo "── Agent $L ──  prompt=$PROMPT  dd=$DD_PATH  sentinel=$SENTINEL"

        if [ ! -f "$PROMPT_PATH" ]; then
            echo "   SKIP: prompt file missing ($PROMPT) — place it at repo root before launch."
            continue
        fi
        if [ "$DRY_RUN" -eq 1 ]; then
            echo "   (dry-run) CI_DERIVED_OVERRIDE=$DD_PATH XCODEBUILD_DERIVED_DATA_PATH=$DD_PATH"
            echo "   (dry-run) would launch: $CLAUDE_BIN --dangerously-skip-permissions"
            continue
        fi

        mkdir -p "$DD_PATH" "$LOG_PATH"
        local AGENT_LOG="$LOG_PATH/agent-${L}-${LAUNCH_TS}.log"
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
    else
        echo "==> ${OVERNIGHT_VERSION} fleet launched. Release the lock when done: rm -rf $LOCK_DIR"
    fi
    return 0
}

# If executed directly (not sourced), run with whatever config the environment
# provided. When sourced, the caller invokes run_overnight_fleet itself.
if [ "${BASH_SOURCE[0]:-$0}" = "${0}" ]; then
    run_overnight_fleet "$@"
fi
