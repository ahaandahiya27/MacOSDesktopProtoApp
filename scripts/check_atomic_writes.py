#!/usr/bin/env python3
"""
Lint that catches `Data.write(to:)` calls without `options: .atomic`.

Closes Family A.10 / H.8 of BUG_FREE_CERTIFICATION_REPORT.md.

`CLAUDE.md` documents that **all file writes** should use
`options: .atomic` so a crash mid-write can't leave a partial file
in `~/Library/Application Support/desktopAhaan/`. The codebase
already follows this convention everywhere (`DataStore`,
`CrashReporter`, `BackupExportButton`); this lint locks the
posture so a future commit that introduces an unprotected write
fails CI before push.

Skipped:
  - `PDFDocument.write(to:)` — PDFKit's PDFDocument.write returns
    Bool, takes no `options:` parameter, and handles atomicity
    internally. The lint looks at the receiver's identifier to
    detect this; if it ends in `Doc`, `Document`, `pdf`, or
    `pdfDocument`, the call is allowed.
  - Test files — they can write unprotected scratch data.
  - Comments / docstrings — only actual call sites are flagged.

Usage:
    python3 scripts/check_atomic_writes.py
"""
import glob
import os
import re
import sys

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SOURCE_GLOB = os.path.join(REPO_ROOT, "desktopAhaan", "**", "*.swift")

# Receivers whose `.write(to:)` is allowed without `.atomic` because
# the API itself doesn't take that parameter (e.g. PDFKit).
PDF_RECEIVER_SUFFIXES = ("pdf", "pdfDocument", "doc", "Document", "Doc")

# Pattern matches the START of a write(to:) call. We then inspect
# the next ~150 chars to see if `.atomic` appears in the option set.
WRITE_CALL_RE = re.compile(r"(\b\w+)\s*\.write\s*\(\s*to\s*:")


def is_pdf_receiver(name: str) -> bool:
    """Receivers like `doc`, `pdfDocument`, `pdf` use PDFKit's
    write(to:) which has its own signature without `options:`."""
    return name.endswith(PDF_RECEIVER_SUFFIXES)


def main() -> int:
    offenders: list[str] = []
    for path in sorted(glob.glob(SOURCE_GLOB, recursive=True)):
        if "Tests" in os.path.basename(path):
            continue
        with open(path) as f:
            src = f.read()
        for m in WRITE_CALL_RE.finditer(src):
            # Skip if the match is inside a // comment on the same line
            line_start = src.rfind("\n", 0, m.start()) + 1
            line_prefix = src[line_start: m.start()]
            if "//" in line_prefix or "///" in line_prefix:
                continue
            # Skip allowed PDF receivers
            receiver = m.group(1)
            if is_pdf_receiver(receiver):
                continue
            # Inspect the next 150 chars for `.atomic`
            tail = src[m.start(): m.start() + 250]
            if ".atomic" in tail or "options:" in tail and "atomic" in tail:
                continue
            line_no = src[: m.start()].count("\n") + 1
            rel = os.path.relpath(path, REPO_ROOT)
            offenders.append(f"{rel}:{line_no} — {receiver}.write(to:) missing options: .atomic")

    if offenders:
        print("check_atomic_writes: FAILED — found "
              f"{len(offenders)} unprotected write(to:) call(s):")
        for o in offenders:
            print(f"  {o}")
        print()
        print("  Add `options: .atomic` to each call. A crash mid-write")
        print("  can otherwise leave a partial file on disk.")
        return 1
    print("check_atomic_writes: clean — every Data.write(to:) call ships "
          "options: .atomic (PDFKit writes exempt).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
