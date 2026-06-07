#!/usr/bin/env bash
# Render one ladder paper: gen -> validate -> HTML -> PDF.
# Usage: bash ladder_render.sh <content.json> <Stem>
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
JSON="$1"; STEM="$2"
python3 "$HERE/gen_paper.py" "$JSON" "$STEM"
python3 "$HERE/validate_paper.py" "$HERE/${STEM}_QuestionPaper.md" "$HERE/${STEM}_Solutions.md"
python3 "$HERE/make_html.py" "$HERE/${STEM}_QuestionPaper.md" "$HERE/${STEM}_Solutions.md" "$HERE/${STEM}.html"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
"$CHROME" --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$HERE/${STEM}.pdf" "file://$HERE/${STEM}.html" 2>/dev/null
echo "rendered ${STEM} ($(ls -la "$HERE/${STEM}.pdf" | awk '{print $5}') byte pdf)"
