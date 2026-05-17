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
