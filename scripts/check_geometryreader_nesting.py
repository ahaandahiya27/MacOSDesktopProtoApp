#!/usr/bin/env python3
"""check_geometryreader_nesting.py — flag files with more than 2
`GeometryReader { ... }` occurrences.

Background. Nested / multiplied `GeometryReader` on Big Sur SwiftUI
has a documented layout-collapse class (DEEP_AUDIT_2026 row C1).
Concretely: an inner `GeometryReader` whose parent doesn't pin its
own size via `.frame(maxHeight:)` collapses to its zero intrinsic,
which in turn shrinks the inner diagram to invisible. The 2026-05-19
sweep verified all 99 existing `GeometryReader` sites are
frame-bounded; the 10 files below that carry 3-4 GR instances each
have been spot-audited and confirmed safe (each inner GR has an
explicit `.frame(maxHeight: ...)` cap).

What this lint blocks: NEW files added with > 2 `GeometryReader` calls.
Forces the author to either flatten to ≤ 2 (and pass `geo.size` down
to computed sub-views), or explicitly request an allowlist entry with
a verified-frame-bounded rationale.

Comment lines + lines inside `///` doc comments are excluded from the
count (a doc-comment mention of "GeometryReader" must not trigger).

Allowlist file: `scripts/geometryreader_nesting_allowlist.txt`.
One repo-relative path per line. Format:
    <path>: <one-line reason>

Usage:
    python3 scripts/check_geometryreader_nesting.py             # whole repo
    python3 scripts/check_geometryreader_nesting.py FILE [...]  # scoped
    python3 scripts/check_geometryreader_nesting.py --selftest  # fixtures

Exit 0 = clean, 1 = violation. Wired into ci-build-test.sh + pre-commit.
"""
from __future__ import annotations

import os
import re
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCAN_ROOT = os.path.join(REPO, "desktopAhaan")
ALLOWLIST_PATH = os.path.join(
    REPO, "scripts", "geometryreader_nesting_allowlist.txt")

# Threshold above which a file is flagged. > 2 (i.e., 3+) is the failure
# band. A single outer GR + one nested = 2, still OK; >= 3 is the
# layout-density signal.
MAX_GEOMETRYREADER_PER_FILE = 2

# Line starts that mean "this is a comment line, not code". Note that
# `// ` at start-of-line is recognized; mid-line `//` after code stays
# part of the code (rare to put `GeometryReader` after a `//` mid-line,
# but the mask below handles it).
_COMMENT_PREFIXES = ("//", "///")


def _load_allowlist() -> dict[str, str]:
    """Return {path -> reason} for each allowlisted file. Paths are
    repo-relative, normalised to forward slashes. Lines starting with
    `#` or blank lines are skipped."""
    out: dict[str, str] = {}
    if not os.path.isfile(ALLOWLIST_PATH):
        return out
    with open(ALLOWLIST_PATH, "r", encoding="utf-8") as fh:
        for raw in fh:
            line = raw.strip()
            if not line or line.startswith("#"):
                continue
            if ":" in line:
                path, _, reason = line.partition(":")
                out[path.strip()] = reason.strip()
            else:
                out[line] = ""
    return out


def count_geometryreader(src: str) -> int:
    """Count non-comment, non-string-literal `GeometryReader` occurrences
    in `src`. Token-only (doesn't require the trailing `{`)."""
    count = 0
    in_block_comment = False
    for line in src.split("\n"):
        # Track simple block comments (// rare in this repo, but defensive).
        if in_block_comment:
            if "*/" in line:
                in_block_comment = False
            continue
        if "/*" in line and "*/" not in line:
            in_block_comment = True
            continue
        stripped = line.lstrip()
        if any(stripped.startswith(p) for p in _COMMENT_PREFIXES):
            continue
        # Mask end-of-line // comments + string literals before counting.
        # Replace any `// ...` tail with nothing.
        no_eol_comment = re.sub(r"//.*$", "", line)
        # Mask string literals so a "GeometryReader" inside an os.Logger
        # log line doesn't count.
        no_strings = re.sub(r'"(?:[^"\\]|\\.)*"', "", no_eol_comment)
        count += no_strings.count("GeometryReader")
    return count


def _walk_swift_files(root: str) -> list[str]:
    out: list[str] = []
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [
            d for d in dirnames
            if d not in {".build", ".dd", ".dd-olytest", ".dd-typecheck",
                         "DerivedData", "__pycache__"}
            and not d.startswith(".backup_xcode")
        ]
        for n in filenames:
            if n.endswith(".swift"):
                out.append(os.path.join(dirpath, n))
    return out


def audit_paths(paths: list[str]) -> list[str]:
    """Scoped audit — caller hands in a list of paths. Allowlist applies."""
    allow = _load_allowlist()
    out: list[str] = []
    for p in paths:
        p_abs = p if os.path.isabs(p) else os.path.join(REPO, p)
        if not p_abs.endswith(".swift") or not os.path.isfile(p_abs):
            continue
        rel = os.path.relpath(p_abs, REPO)
        try:
            with open(p_abs, "r", encoding="utf-8") as fh:
                src = fh.read()
        except (OSError, UnicodeDecodeError):
            continue
        n = count_geometryreader(src)
        if n > MAX_GEOMETRYREADER_PER_FILE and rel not in allow:
            out.append(f"{rel}: {n} GeometryReader sites (limit {MAX_GEOMETRYREADER_PER_FILE}; not allowlisted)")
    return out


def audit_repo() -> tuple[list[str], int]:
    allow = _load_allowlist()
    files = _walk_swift_files(SCAN_ROOT)
    violations: list[str] = []
    grandfathered = 0
    for f in files:
        try:
            with open(f, "r", encoding="utf-8") as fh:
                src = fh.read()
        except (OSError, UnicodeDecodeError):
            continue
        n = count_geometryreader(src)
        if n > MAX_GEOMETRYREADER_PER_FILE:
            rel = os.path.relpath(f, REPO)
            if rel in allow:
                grandfathered += 1
            else:
                violations.append(
                    f"{rel}: {n} GeometryReader sites (limit {MAX_GEOMETRYREADER_PER_FILE})")
    return violations, grandfathered


# ---------------------------------------------------------------------------
# Self-test
# ---------------------------------------------------------------------------

_DANGER_FIXTURE = """\
import SwiftUI
struct Bad: View {
    var body: some View {
        GeometryReader { g1 in
            GeometryReader { g2 in
                GeometryReader { g3 in
                    Text("3 GR nested")
                }
            }
        }
    }
}
"""

_CLEAN_FIXTURE = """\
import SwiftUI
// Doc comment mentions GeometryReader but doesn't count.
/// GeometryReader is documented here.
let s = "GeometryReader in string"  // also doesn't count
struct Good: View {
    var body: some View {
        GeometryReader { geo in   // 1
            VStack {
                GeometryReader { _ in Text("2") }   // 2 — at limit, OK
            }
        }
    }
}
"""


def selftest() -> int:
    import tempfile
    ok = True
    with tempfile.TemporaryDirectory() as d:
        bad = os.path.join(d, "Bad.swift")
        with open(bad, "w") as fh:
            fh.write(_DANGER_FIXTURE)
        n_bad = count_geometryreader(_DANGER_FIXTURE)
        if n_bad != 3:
            print(f"SELFTEST FAIL: danger fixture has {n_bad} GR, expected 3")
            ok = False
        else:
            print(f"  [PASS] danger fixture: {n_bad} GR > limit {MAX_GEOMETRYREADER_PER_FILE}")

        n_good = count_geometryreader(_CLEAN_FIXTURE)
        if n_good != 2:
            print(f"SELFTEST FAIL: clean fixture has {n_good} GR, expected 2 (comments + strings excluded)")
            ok = False
        else:
            print(f"  [PASS] clean fixture: {n_good} GR at limit {MAX_GEOMETRYREADER_PER_FILE}")

    print("check_geometryreader_nesting --selftest: " +
          ("PASS — every fixture classifies correctly." if ok else "FAIL"))
    return 0 if ok else 1


def run_selftest() -> int:
    return selftest()


def main() -> int:
    if "--selftest" in sys.argv:
        return selftest()

    file_args = [a for a in sys.argv[1:] if not a.startswith("-")]
    if file_args:
        errors = audit_paths(file_args)
        if errors:
            print("check_geometryreader_nesting: FAIL (scoped)")
            for e in errors[:30]:
                print("  " + e)
            print()
            print("  Big Sur SwiftUI: multiple GeometryReaders in one file is a layout-collapse risk class.")
            print("  Either flatten to ≤ 2 (pass `geo.size` to computed sub-views) or add the file to")
            print(f"  {os.path.relpath(ALLOWLIST_PATH, REPO)} with a verified-frame-bounded rationale.")
            return 1
        print(f"check_geometryreader_nesting: clean — {len(file_args)} staged file(s) checked.")
        return 0

    errors, grandfathered = audit_repo()
    if errors:
        print("check_geometryreader_nesting: FAIL")
        for e in errors[:30]:
            print("  " + e)
        if len(errors) > 30:
            print(f"  ... and {len(errors) - 30} more")
        print()
        print("  Big Sur SwiftUI: > 2 GeometryReaders per file is the layout-collapse risk class.")
        print("  Either flatten to ≤ 2 (pass `geo.size` to computed sub-views) or add the file to")
        print(f"  {os.path.relpath(ALLOWLIST_PATH, REPO)} with a verified-frame-bounded rationale.")
        return 1
    print(f"check_geometryreader_nesting: clean — {grandfathered} pre-existing site(s) grandfathered via allowlist.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
