#!/bin/bash
# Render a paper's HTML to a print-ready PDF using headless Chrome (Skia/PDF),
# matching the toolchain that produced the Paper-1 PDFs.
#
# Usage: ./make_pdf.sh <stem>           # stem = e.g. Science_Ch01_NutritionInPlants_P2
#        ./make_pdf.sh <input.html> <output.pdf>
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

if [[ $# -eq 1 ]]; then
  IN="$HERE/$1.html"
  OUT="$HERE/$1.pdf"
elif [[ $# -eq 2 ]]; then
  IN="$1"; OUT="$2"
else
  echo "usage: make_pdf.sh <stem> | <input.html> <output.pdf>" >&2
  exit 2
fi

"$CHROME" --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$OUT" "file://$IN" 2>/dev/null
echo "wrote $OUT"
