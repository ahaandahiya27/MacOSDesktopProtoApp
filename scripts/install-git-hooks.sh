#!/usr/bin/env bash
# install-git-hooks.sh — wire up the repo's pre-commit + pre-push hooks.
#
# Run once after cloning:
#   bash scripts/install-git-hooks.sh
#
# The hooks themselves live under scripts/hooks/ so they're versioned.
# Git doesn't track .git/hooks/, so we copy from scripts/hooks/ into
# .git/hooks/ here. Re-run any time the source hooks change.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC_DIR="$REPO_ROOT/scripts/hooks"
DST_DIR="$REPO_ROOT/.git/hooks"

if [ ! -d "$DST_DIR" ]; then
    echo "no .git/hooks dir — is this a git checkout?" >&2
    exit 1
fi

for hook in pre-commit pre-push; do
    if [ -f "$SRC_DIR/$hook" ]; then
        cp "$SRC_DIR/$hook" "$DST_DIR/$hook"
        chmod +x "$DST_DIR/$hook"
        echo "installed: $hook"
    fi
done
echo "git hooks installed under $DST_DIR"
echo ""
echo "Optional: opt-in to UI tests in the pre-push gate."
echo "If THIS machine has granted Accessibility to the test runner"
echo "(System Settings → Privacy & Security → Accessibility → toggle"
echo "desktopAhaanUITests-Runner.app on), add this line to your shell"
echo "profile (~/.zshrc on zsh, ~/.bash_profile on bash):"
echo ""
echo "    export CI_BUILD_TEST_FLAGS=--ui"
echo ""
echo "The pre-push hook will then also run GoldenPathUITests on every"
echo "push, catching surface regressions before they land on origin/main."
echo "The iMac (where AX is granted) is the canonical venue for this."
echo "Dev Macs and CI runners without an AX grant should leave the var"
echo "unset — the default unit-only path stays clean for them."
