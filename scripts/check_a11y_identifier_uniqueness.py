#!/usr/bin/env python3
"""accessibilityIdentifier same-file uniqueness ratchet.

The 2026-06-12 accessibilityIdentifier sweep added 259 stable kebab-case
identifiers across 82 files (lifting total coverage from 11 → 270 sites)
so XCUITest selectors can target controls by stable id instead of by
a11y-label text that may change for VoiceOver reasons.

This lint locks in that win by flagging same-file identifier collisions:
two siblings in the same .swift file with the same literal
`.accessibilityIdentifier("foo")` argument. That's a real test-bug class
— XCUITest's `app.buttons["foo"]` would resolve nondeterministically.

Parameterized identifiers (`.accessibilityIdentifier("foo-\\(id)")`)
are skipped — those are inherently unique per ForEach iteration.

The lint is repo-clean at the time it lands (verified by a pre-commit
audit: 0 collisions across 73 files with identifiers). Adding a new
duplicate identifier in the same file will fail commit + push.

Cross-file duplicates are NOT flagged — XCUITest binds to the visible
button, so `concept-toolbar-bookmark` in both ConceptDetailView and
QuestionDetailView is fine (only one is visible at a time).

Usage:
    python3 scripts/check_a11y_identifier_uniqueness.py
    python3 scripts/check_a11y_identifier_uniqueness.py --selftest
"""
from __future__ import annotations

import re
import sys
from collections import defaultdict
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SCAN_ROOT = REPO_ROOT / "desktopAhaan"

# Match `.accessibilityIdentifier("literal-string")` — only bare literals,
# not interpolated forms with `\(`.
LITERAL_ID = re.compile(r'\.accessibilityIdentifier\(\s*"([^"\\]+)"\s*\)')


def scan_text(src: str) -> dict[str, list[int]]:
    """Return {identifier_string: [line_numbers]} for this source.

    Only counts each occurrence once, by line. Comment-stripping is left
    to a future enhancement — in the current codebase every
    .accessibilityIdentifier call is in real code (not commented-out).
    """
    sites: dict[str, list[int]] = defaultdict(list)
    for n, line in enumerate(src.splitlines(), 1):
        m = LITERAL_ID.search(line)
        if m:
            sites[m.group(1)].append(n)
    return sites


def find_collisions(sites: dict[str, list[int]]) -> list[tuple[str, list[int]]]:
    """Return [(identifier, line_numbers)] for any identifier with >1 site."""
    return [(ident, lines) for ident, lines in sites.items() if len(lines) > 1]


def scan_repo() -> int:
    """Walk SCAN_ROOT, find collisions, return exit code 0/1."""
    total_files = 0
    files_with_ids = 0
    total_ids = 0
    flagged: list[tuple[Path, str, list[int]]] = []

    for swift_path in SCAN_ROOT.rglob("*.swift"):
        total_files += 1
        src = swift_path.read_text(encoding="utf-8")
        sites = scan_text(src)
        if not sites:
            continue
        files_with_ids += 1
        total_ids += sum(len(v) for v in sites.values())
        for ident, lines in find_collisions(sites):
            flagged.append((swift_path, ident, lines))

    rel = lambda p: str(p.relative_to(REPO_ROOT))
    if flagged:
        print(
            f"check_a11y_identifier_uniqueness: {len(flagged)} same-file "
            f"collision(s) across {files_with_ids} file(s) with identifiers."
        )
        for path, ident, lines in flagged:
            line_str = ", ".join(f"line {n}" for n in lines)
            print(f"  {rel(path)}: {ident!r} appears on {line_str}")
        print(
            "\nTwo siblings with the same accessibilityIdentifier resolve "
            "nondeterministically in XCUITest. Pick distinct kebab-case "
            "names per Button. For dynamic content, use the parameterized "
            "form: .accessibilityIdentifier(\"foo-\\(id)\")."
        )
        return 1

    print(
        f"check_a11y_identifier_uniqueness: clean — {total_ids} literal "
        f"identifier(s) checked across {files_with_ids} file(s), no "
        f"same-file collisions."
    )
    return 0


# ── Embedded selftest ───────────────────────────────────────────────

_DANGER_FIXTURE = '''\
struct Foo: View {
    var body: some View {
        VStack {
            Button("A") { }
                .accessibilityIdentifier("primary-cta")
            Button("B") { }
                .accessibilityIdentifier("primary-cta")
            Button("C") { }
                .accessibilityIdentifier("secondary-cta")
        }
    }
}
'''

_CLEAN_FIXTURE = '''\
struct Foo: View {
    var body: some View {
        VStack {
            Button("A") { }
                .accessibilityIdentifier("primary-cta")
            Button("B") { }
                .accessibilityIdentifier("secondary-cta")
            ForEach(items) { item in
                Button(item.title) { }
                    .accessibilityIdentifier("row-\\(item.id)")
            }
        }
    }
}
'''


def run_selftest() -> int:
    ok = True

    danger = scan_text(_DANGER_FIXTURE)
    danger_collisions = find_collisions(danger)
    if len(danger_collisions) == 1 and danger_collisions[0][0] == "primary-cta":
        print("  [PASS] danger fixture: detects primary-cta collision")
    else:
        print(f"  [FAIL] danger fixture: expected 1 collision on 'primary-cta', got {danger_collisions}")
        ok = False

    clean = scan_text(_CLEAN_FIXTURE)
    clean_collisions = find_collisions(clean)
    if len(clean_collisions) == 0:
        print("  [PASS] clean fixture: no collisions (interpolated row-\\(id) ignored)")
    else:
        print(f"  [FAIL] clean fixture: expected 0 collisions, got {clean_collisions}")
        ok = False

    if ok:
        print("\ncheck_a11y_identifier_uniqueness --selftest: PASS")
        return 0
    print("\ncheck_a11y_identifier_uniqueness --selftest: FAIL")
    return 1


def main() -> int:
    if "--selftest" in sys.argv:
        return run_selftest()
    return scan_repo()


if __name__ == "__main__":
    sys.exit(main())
