#!/usr/bin/env bash
# Build one chapter: validate -> HTML -> PDF (headless Chrome).
# Usage: bash build_chapter.sh Science_Ch01_NutritionInPlants
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
STEM="$1"
QP="$HERE/${STEM}_QuestionPaper.md"
SOL="$HERE/${STEM}_Solutions.md"
HTML="$HERE/${STEM}.html"
PDF="$HERE/${STEM}.pdf"

echo "== validate =="
python3 "$HERE/validate_paper.py" "$QP" "$SOL"

echo "== html =="
python3 "$HERE/make_html.py" "$QP" "$SOL" "$HTML"

echo "== pdf =="
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
if [ -x "$CHROME" ]; then
  "$CHROME" --headless --disable-gpu --no-pdf-header-footer \
    --print-to-pdf="$PDF" "file://$HTML" 2>/dev/null && echo "wrote $PDF" \
    || echo "PDF step failed; printable HTML left at $HTML"
elif command -v pandoc >/dev/null 2>&1; then
  pandoc "$HTML" -o "$PDF" && echo "wrote $PDF (pandoc)"
elif command -v wkhtmltopdf >/dev/null 2>&1; then
  wkhtmltopdf "$HTML" "$PDF" && echo "wrote $PDF (wkhtmltopdf)"
else
  echo "no PDF renderer; printable HTML left at $HTML"
fi
