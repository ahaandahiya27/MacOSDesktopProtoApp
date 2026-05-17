#!/usr/bin/env python3
"""Y1 — content-pack JSON round-trip reproducibility check.

Reads each pack in `desktopAhaan/Subjects/Packs/`, re-encodes it with
`json.dump(..., ensure_ascii=False, indent=2)`, and compares to the
on-disk file byte-for-byte. Fails if they differ.

This protects against two failure modes:
  1. Someone running an edit script with `ensure_ascii=True` (the
     default) — Unicode em-dashes / Devanagari / emoji come back as
     `\\u2014` / `\\u0905` / `\\ud83c\\udf3f` escapes, producing
     thousands of spurious diff lines.
  2. Indentation drift (default `indent=None` vs the project's
     `indent=2`) producing a single-line file.

Run from the repo root:
    python3 scripts/verify_pack_roundtrip.py
Exit code 0 if all packs round-trip exactly; 1 otherwise.

Useful in pre-push or CI: `bash scripts/verify_pack_roundtrip.py || exit 1`.
"""

import json
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
PACKS_DIR = REPO_ROOT / "desktopAhaan" / "Subjects" / "Packs"


def canonical_encode(obj) -> str:
    """The project's canonical JSON shape.

    Must match what any edit script produces, otherwise we'll get
    spurious diffs on every commit that touches a pack.
    """
    return json.dumps(obj, ensure_ascii=False, indent=2) + "\n"


def main() -> int:
    if not PACKS_DIR.exists():
        print(f"missing: {PACKS_DIR}", file=sys.stderr)
        return 1

    failures = []
    for path in sorted(PACKS_DIR.glob("*.json")):
        # Skip sanskrit dictionary if it ever lands in this folder (it
        # lives elsewhere) — but for now this matches all packs.
        original = path.read_text(encoding="utf-8")
        try:
            data = json.loads(original)
        except json.JSONDecodeError as e:
            failures.append((path.name, f"JSON parse error: {e}"))
            continue

        canonical = canonical_encode(data)
        if canonical == original:
            print(f"  ok  {path.name}")
        else:
            # Find first differing line to make the diff actionable.
            orig_lines = original.splitlines()
            canon_lines = canonical.splitlines()
            for i, (a, b) in enumerate(zip(orig_lines, canon_lines)):
                if a != b:
                    failures.append(
                        (path.name,
                         f"diverges at line {i+1}:\n"
                         f"  on-disk:   {a!r}\n"
                         f"  canonical: {b!r}")
                    )
                    break
            else:
                # Lengths differ but no mismatch within shared prefix.
                failures.append(
                    (path.name,
                     f"length mismatch: on-disk={len(orig_lines)} lines, "
                     f"canonical={len(canon_lines)} lines")
                )

    if failures:
        print("\nFailures:", file=sys.stderr)
        for name, msg in failures:
            print(f"  {name}: {msg}", file=sys.stderr)
        print("\nFix: re-run any edit script with"
              " json.dump(..., ensure_ascii=False, indent=2)",
              file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
