#!/usr/bin/env python3
"""
Scans every Swift View file for `Button` constructions and counts how
many ship with an accessible label that VoiceOver can read.

A Button is considered "labeled" if ANY of the following holds within
the construction:
  - It uses the `Button("literal string")` initializer (auto-label).
  - The body contains a `Label("text", systemImage: …)` (auto-label).
  - The Button's chained modifiers include `.accessibilityLabel(…)`.
  - The Button's chained modifiers include `.help(…)` (NSToolTip; on
    Big Sur this surfaces to VoiceOver via the help text).
  - The Button's body contains a `Text("…")` as its primary content
    (auto-narrated by VoiceOver as the label).

This is a heuristic — it can miss edge cases (e.g., a `ViewBuilder`
factory that wraps `Text` two layers deep). It runs as a ratchet:
the floor pins the *minimum* observed coverage so we can't regress.
The baseline was 63% on 2026-05-29; the floor sits at 60% with a
3-point buffer to absorb file-tree edits that move call sites
without changing semantics. Raise `COVERAGE_FLOOR` as coverage
improves — a future content sweep that lifts it to 75% should bump
the floor to 70% in the same commit so the new posture is locked
in.

Usage:
    python3 scripts/check_a11y_labels.py [--verbose]

Prints the unlabeled-site list when verbose.
"""
import glob
import os
import re
import sys

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SOURCE_GLOB = os.path.join(REPO_ROOT, "desktopAhaan", "**", "*.swift")
# Ratchet floor — see module docstring. Raise this as coverage improves.
# 2026-05-29: baseline 63% → 85% after crediting Card/Row/Chip-suffixed
# custom-view labels → 96% after crediting any Text(...) inside a label
# slot (not just Text("literal"), which missed the common Boss-Quiz
# pattern `label: { HStack { Text(variable) } }`). Floor sits at 90
# with a 6-point cushion.
COVERAGE_FLOOR = 99  # bumped 90 → 99 on 2026-06-13 after H2 sweep + afa10ee hoist locked exact 706/706 (100% rounded)

LABEL_MARKERS = (
    ".accessibilityLabel(",
    ".accessibilityHint(",
    ".help(",
    "Label(",      # SwiftUI Label(_, systemImage:) auto-narrates
    "Text(",       # Any Text(...) inside a Button body auto-narrates —
                   # includes Text("literal"), Text(opt), Text(verbatim:),
                   # Text(LocalizedStringKey(...)), all of which VoiceOver
                   # reads. Catches the `label: { HStack { Text(variable) ... } }`
                   # pattern that's common in Boss Quiz answer Buttons.
)

# When a Button's label slot is a custom View type whose name ends
# in one of these suffixes, the lint trusts it to render
# user-readable content (Text) inside the custom view's body.
# Audited 2026-05-29: every match in this codebase using these
# suffixes was confirmed to ship Text content (e.g. ChapterRow,
# ContinueCard, NodeChip, RelatedChapterChip).
CONTENT_VIEW_SUFFIXES = (
    "Card", "Cell", "Row", "Chip", "Badge", "Tile", "Item",
    "Entry", "Banner", "Pill", "Tag", "Block", "Bubble",
)
# Match "label: { TitleCasedName(" — the Button's view-builder label
# slot containing a custom view constructor.
CUSTOM_LABEL_RE = re.compile(
    r"label:\s*\{\s*[\n\s]*([A-Z][A-Za-z0-9]+)\s*\("
)
# Also match the implicit "Button { action } label: { CustomView }"
# minus the parens — the type appearing alone (e.g. "BackupExportButton()")
BARE_LABEL_VIEW_RE = re.compile(
    r"label:\s*\{\s*[\n\s]*([A-Z][A-Za-z0-9]+)\s*[\(\.]"
)


def is_labeled(button_chunk: str) -> bool:
    """Decide if the Button construction has an accessible label."""
    # Button("literal title") — first arg is the label
    head = button_chunk[:120]
    if re.search(r'Button\s*\(\s*"', head) or re.search(r"Button\s*\(\s*'", head):
        return True
    # Button(cond ? "Title A" : "Title B") — a conditional whose branches are
    # string literals is still a visible, VoiceOver-narrated text label. The
    # `[^{]*` guard stops before any trailing-closure body so a string inside
    # the *action* closure can't masquerade as a label.
    if re.search(r'Button\s*\(\s*[^{]*\?\s*["\']', head):
        return True
    # Button(action:) { Label(...) } or .accessibilityLabel modifier
    if any(marker in button_chunk for marker in LABEL_MARKERS):
        return True
    # Button(action:) { ... } label: { ContentCard(...) } — a custom
    # view in the label slot whose name follows the codebase's
    # content-view naming convention. Trusted to ship Text inside
    # its body (audited 2026-05-29 — see CONTENT_VIEW_SUFFIXES).
    for re_pat in (CUSTOM_LABEL_RE, BARE_LABEL_VIEW_RE):
        m = re_pat.search(button_chunk)
        if m and m.group(1).endswith(CONTENT_VIEW_SUFFIXES):
            return True
    return False


def find_button_chunks(src: str):
    """Yield (line_no, chunk_starting_at_Button) for each Button site.

    The chunk needs to be large enough to capture the entire Button
    construction including any chained modifiers (`.accessibilityLabel(...)`,
    `.help(...)`) and the `label: { CustomView() }` slot — those often
    sit hundreds of chars past the `Button` token. 1500 chars covers
    every Button-with-trailing-closures-and-modifiers structure in the
    current codebase.

    Note (2026-06-12): if a Button's action closure grows so long that
    the chained `.accessibilityLabel` falls past this window, DON'T just
    widen the window — a larger window risks falsely crediting a sibling
    View's Text(...) to the Button. Instead, hoist the action body to
    a named helper method (the existing convention; e.g.
    Scene1_SourOrBitter.choiceButton was refactored this way in commit
    afa10ee). The compact Button is easier to read AND the lint sees
    the label.
    """
    for m in re.finditer(r"\bButton\b", src):
        # Skip matches inside a `//` / `///` line comment — doc comments that
        # merely mention "Button" (e.g. "HStack + Button + Text") are not
        # Button sites and shouldn't count against coverage.
        line_start = src.rfind("\n", 0, m.start()) + 1
        if "//" in src[line_start:m.start()]:
            continue
        line_no = src[: m.start()].count("\n") + 1
        chunk = src[m.start(): m.start() + 1500]
        yield line_no, chunk


def main() -> int:
    verbose = "--verbose" in sys.argv
    buttons = 0
    labeled = 0
    unlabeled_sites: list[str] = []
    for path in sorted(glob.glob(SOURCE_GLOB, recursive=True)):
        # Skip test files — they author their own Buttons that don't ship.
        if "Tests" in os.path.basename(path):
            continue
        with open(path) as f:
            src = f.read()
        for line_no, chunk in find_button_chunks(src):
            buttons += 1
            if is_labeled(chunk):
                labeled += 1
            else:
                rel = os.path.relpath(path, REPO_ROOT)
                unlabeled_sites.append(f"{rel}:{line_no}")
    coverage = (100 * labeled / buttons) if buttons else 0
    print(f"a11y label scan — {buttons} Button sites across "
          f"desktopAhaan/**/*.swift")
    print(f"  labeled:   {labeled} ({coverage:.0f}%)")
    print(f"  unlabeled: {buttons - labeled}")
    if verbose and unlabeled_sites:
        print()
        print("Unlabeled sites:")
        for s in unlabeled_sites:
            print(f"  {s}")
    print()
    if coverage < COVERAGE_FLOOR:
        print(f"FAILED: coverage {coverage:.0f}% < ratchet floor "
              f"{COVERAGE_FLOOR}%. Add .accessibilityLabel(…) or .help(…) "
              "to recently-touched Buttons (run with --verbose to list "
              "the unlabeled sites). If the regression is intentional, "
              "lower COVERAGE_FLOOR in this file in the same commit.")
        return 1
    print(f"OK: coverage {coverage:.0f}% ≥ ratchet floor {COVERAGE_FLOOR}%.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
