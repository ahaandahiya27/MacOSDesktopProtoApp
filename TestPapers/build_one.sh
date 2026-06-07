#!/bin/bash
# Build one Olympiad paper end-to-end: generate -> validate -> HTML -> PDF.
# Usage: build_one.sh <content.json> <OutputStem>
set -e
CONTENT="$1"; STEM="$2"
DIR="$(cd "$(dirname "$0")" && pwd)"
python3 "$DIR/gen_paper.py" "$CONTENT" "$STEM"
python3 "$DIR/validate_paper.py" "$DIR/${STEM}_QuestionPaper.md" "$DIR/${STEM}_Solutions.md"
python3 "$DIR/make_html.py" "$DIR/${STEM}_QuestionPaper.md" "$DIR/${STEM}_Solutions.md" "$DIR/${STEM}.html"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
"$CHROME" --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$DIR/${STEM}.pdf" "file://$DIR/${STEM}.html" 2>/dev/null
echo "built: ${STEM}.{html,pdf} ($(ls -la "$DIR/${STEM}.pdf" | awk '{print $5}') byte pdf)"
