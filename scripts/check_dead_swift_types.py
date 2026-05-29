#!/usr/bin/env python3
"""
Lint that catches top-level Swift type declarations (struct, class,
enum, actor) that are declared in this codebase but referenced
nowhere except their own declaration site.

Closes Family J.4 of `BUG_FREE_CERTIFICATION_REPORT.md`.

The 2026-05-29 audit (parallel Explore agent) confirmed only 2
dead types existed at baseline (`QuizBankRoute` in
`QuizBankView.swift`, `SceneRequiresMacOS12View` in
`DiscoverMode.swift`); both were removed in the same commit that
shipped this lint, leaving an empty-surface ratchet.

Heuristic:
  1. Find every top-level `struct/class/enum/actor TypeName`
     declaration in `desktopAhaan/**/*.swift`.
  2. Skip declarations whose name starts with `_` (private
     convention) or `Preview_` (SwiftUI preview fixtures, only
     referenced by the `#Preview` macro which is invisible to
     ripgrep).
  3. Skip the app-entry type marked with `@main` (referenced by
     the compiler, not by source).
  4. For each remaining declaration, count references to the
     name elsewhere in non-test code. Reference = the name as a
     whole word, anywhere outside the declaration line itself.
  5. Flag any type with zero references.

Allowlist: if a type genuinely needs to ship dead (e.g. used
only by Objective-C runtime / NSClassFromString reflection), add
its name to `dead_types_allowlist.txt` next to this script with a
one-line rationale comment.

Usage:
    python3 scripts/check_dead_swift_types.py
"""
import glob
import os
import re
import sys

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SOURCE_GLOB = os.path.join(REPO_ROOT, "desktopAhaan", "**", "*.swift")
ALLOWLIST_PATH = os.path.join(REPO_ROOT, "scripts", "dead_types_allowlist.txt")

# Match `struct Foo`, `class Bar:`, `enum Baz {`, `actor Q` —
# with optional access modifier prefix.
DECL_RE = re.compile(
    r"^\s*(?:public |internal |private |fileprivate |open )?"
    r"(?:final |indirect )?(?:struct|class|enum|actor)\s+"
    r"(?P<name>[A-Z][A-Za-z0-9_]+)\b"
)

# Match `@main` immediately before the next declaration line — that
# annotation marks the app entry point which is referenced by the
# compiler, not by source.
MAIN_RE = re.compile(r"@main\b")

# Skip these name patterns
NAME_SKIP_RE = re.compile(r"^(_|Preview_)")


def load_allowlist() -> set[str]:
    if not os.path.exists(ALLOWLIST_PATH):
        return set()
    names: set[str] = set()
    with open(ALLOWLIST_PATH) as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#"):
                names.add(line.split()[0])
    return names


def collect_declarations() -> list[tuple[str, str, int]]:
    """Return [(name, path, line)] for every flagged top-level type."""
    decls: list[tuple[str, str, int]] = []
    for path in sorted(glob.glob(SOURCE_GLOB, recursive=True)):
        if "Tests" in os.path.basename(path):
            continue
        with open(path) as f:
            src = f.read()
        lines = src.splitlines()
        for i, line in enumerate(lines):
            m = DECL_RE.match(line)
            if not m:
                continue
            name = m.group("name")
            if NAME_SKIP_RE.match(name):
                continue
            # If the previous non-blank line contains @main, skip.
            j = i - 1
            while j >= 0 and not lines[j].strip():
                j -= 1
            if j >= 0 and MAIN_RE.search(lines[j]):
                continue
            decls.append((name, path, i + 1))
    return decls


def count_references(name: str, declaration_path: str,
                     declaration_line: int) -> int:
    """Count occurrences of `name` as a whole word across all
    non-test Swift files. Inside the declaration's own file, the
    matching declaration line itself is excluded so we count
    USAGES not the decl. Sub-View structs (defined and used in the
    same dispatcher file) are valid; we just need to avoid
    counting the `struct Foo` decl line as a self-reference."""
    pattern = re.compile(r"\b" + re.escape(name) + r"\b")
    count = 0
    for path in glob.glob(SOURCE_GLOB, recursive=True):
        if "Tests" in os.path.basename(path):
            continue
        with open(path) as f:
            src = f.read()
        is_decl_file = os.path.abspath(path) == os.path.abspath(declaration_path)
        if is_decl_file:
            # Exclude the declaration line itself (1-indexed) from the
            # count. Every other line in the file is a real usage.
            lines = src.splitlines()
            for i, line in enumerate(lines, start=1):
                if i == declaration_line:
                    continue
                count += len(pattern.findall(line))
        else:
            count += len(pattern.findall(src))
    return count


def main() -> int:
    allowlist = load_allowlist()
    decls = collect_declarations()
    dead: list[tuple[str, str, int]] = []
    for name, path, line in decls:
        if name in allowlist:
            continue
        if count_references(name, path, line) == 0:
            dead.append((name, path, line))

    if dead:
        print("check_dead_swift_types: FAILED — types declared but "
              "never referenced anywhere else in non-test code:")
        for name, path, line in dead:
            rel = os.path.relpath(path, REPO_ROOT)
            print(f"  {rel}:{line} — {name}")
        print()
        print("  Either delete the type or, if it's used via Obj-C "
              "runtime reflection (NSClassFromString) or similar, add "
              "its name to scripts/dead_types_allowlist.txt with a "
              "one-line rationale.")
        return 1
    print(f"check_dead_swift_types: clean — scanned "
          f"{len(decls)} top-level type declarations; every one is "
          "referenced elsewhere.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
