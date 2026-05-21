#!/usr/bin/env python3
"""Big Sur macOS 12+ API lint.

Deploy target is Big Sur 11.7.11 (CLAUDE.md). Any SwiftUI API that was
introduced in macOS 12.0 or later either fails to link on the iMac or
mis-bridges in subtle ways. The mis-bridging path is the dangerous
one — it compiled clean on the dev Mac and "worked" in the simulator,
but tripped a SwiftUI internal assertion ("Entangling fence requested
after pre-commit") and crashed with EXC_BAD_ACCESS on the dev Mac too
(commit 594e781 introduced `.animation(_:value:)` and crashed Try
Discover Mode on Ch.1 — that's the regression class this lint blocks).

Hard gate: any match in non-comment, non-string code is a refusal.

Bypass: `git commit --no-verify` if a genuine guarded-by-#available
call needs to land.
"""
from __future__ import annotations
import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

# Each rule = (regex, name, why-banned-on-Big-Sur).
# Each regex must match the actual call/use site, not declarations or
# comments. We strip line-comments before matching so explanatory text
# (// uses .animation(_:value:) on macOS 12+) doesn't false-trip.
RULES: list[tuple[re.Pattern[str], str, str]] = [
    # Use .* (greedy) instead of [^)]* so we span nested parens like
    # `.animation(.easeOut(duration: 0.2), value: x)`.
    (re.compile(r"\.animation\s*\(.*\bvalue\s*:"),
     ".animation(_:value:)",
     "macOS 12.0+ — use .animation(_:) without value: on Big Sur; or wrap state changes in withAnimation."),
    (re.compile(r"\.foregroundStyle\s*\("),
     ".foregroundStyle(...)",
     "macOS 12.0+ — use .foregroundColor(_:) on Big Sur."),
    (re.compile(r"\.symbolEffect\s*\("),
     ".symbolEffect(...)",
     "macOS 14.0+ — no Big Sur equivalent; remove or guard by #available."),
    (re.compile(r"\.symbolRenderingMode\s*\("),
     ".symbolRenderingMode(...)",
     "macOS 12.0+ — Big Sur SF Symbols 2 only supports monochrome."),
    (re.compile(r"\.scrollPosition\s*\("),
     ".scrollPosition(...)",
     "macOS 14.0+ — use ScrollViewReader on Big Sur."),
    (re.compile(r"\.scrollDismissesKeyboard\s*\("),
     ".scrollDismissesKeyboard(...)",
     "macOS 13.0+ — no equivalent on Big Sur."),
    (re.compile(r"\.scrollContentBackground\s*\("),
     ".scrollContentBackground(...)",
     "macOS 13.0+ — no equivalent on Big Sur."),
    (re.compile(r"\.formStyle\s*\("),
     ".formStyle(...)",
     "macOS 13.0+ — Big Sur Form is single-column-only."),
    (re.compile(r"\.dynamicTypeSize\s*\("),
     ".dynamicTypeSize(...)",
     "macOS 12.0+ — use .environment(\\.sizeCategory, ...) on Big Sur."),
    (re.compile(r"\.refreshable\s*\("),
     ".refreshable(...)",
     "macOS 12.0+ — no pull-to-refresh on Big Sur SwiftUI."),
    (re.compile(r"\.toolbarRole\s*\("),
     ".toolbarRole(...)",
     "macOS 13.0+ — no Big Sur equivalent."),
    (re.compile(r"\.searchable\s*\("),
     ".searchable(...)",
     "macOS 12.0+ — implement search bar manually on Big Sur."),
    (re.compile(r"\bColor\.brown\b"),
     "Color.brown",
     "macOS 12.0+ — use Color.compatBrown (in Extensions.swift) on Big Sur."),
    (re.compile(r"\bColor\.mint\b"),
     "Color.mint",
     "macOS 12.0+ — use a custom Color(red:green:blue:) on Big Sur."),
    (re.compile(r"\bColor\.cyan\b"),
     "Color.cyan",
     "macOS 12.0+ — use a custom Color(red:green:blue:) on Big Sur."),
    (re.compile(r"\bColor\.indigo\b"),
     "Color.indigo",
     "macOS 12.0+ — use Color.compatIndigo (in Extensions.swift) on Big Sur."),
    (re.compile(r"\bColor\.teal\b"),
     "Color.teal",
     "macOS 12.0+ — use Color.compatTeal (in Extensions.swift) on Big Sur."),
    (re.compile(r"@Observable\b"),
     "@Observable macro",
     "macOS 14.0+ — use ObservableObject + @Published on Big Sur."),
    (re.compile(r"@Bindable\b"),
     "@Bindable",
     "macOS 14.0+ — use @ObservedObject / @StateObject on Big Sur."),
    (re.compile(r"\bNavigationStack\b"),
     "NavigationStack",
     "macOS 13.0+ — use NavigationView on Big Sur (or custom routing)."),
    (re.compile(r"\bNavigationSplitView\b"),
     "NavigationSplitView",
     "macOS 13.0+ — use NavigationView { sidebar / content } on Big Sur."),
    (re.compile(r"\.font\s*\([^)]*\.monospaced\(\)"),
     "Font.monospaced()",
     "macOS 12.0+ — use .system(size:weight:design:.monospaced) on Big Sur."),
    (re.compile(r"\bAsyncImage\b"),
     "AsyncImage",
     "macOS 12.0+ — use AppKit NSImage + URLSession on Big Sur."),
    (re.compile(r"\.task\s*\("),
     ".task(...) / .task {",
     "macOS 12.0+ — use .onAppear { Task { ... } } on Big Sur."),
    # Match `.task {` (no opening paren — most common form).
    (re.compile(r"\.task\s*\{"),
     ".task { ... }",
     "macOS 12.0+ — use .onAppear { Task { ... } } on Big Sur."),
    (re.compile(r"@FocusState\b"),
     "@FocusState",
     "macOS 12.0+ — use first-responder management on Big Sur."),
    (re.compile(r"\.focused\s*\("),
     ".focused(...)",
     "macOS 12.0+ — manage focus through FirstResponder on Big Sur."),
    (re.compile(r"\.tint\s*\("),
     ".tint(...)",
     "macOS 12.0+ — use .accentColor(...) on Big Sur."),
    (re.compile(r"\bChart\s*\{"),
     "Chart { ... }",
     "macOS 13.0+ — Charts framework — draw with Path on Big Sur."),
    (re.compile(r"^import\s+Charts\b", re.MULTILINE),
     "import Charts",
     "macOS 13.0+ — framework unavailable on Big Sur."),
]


def strip_line_comments(line: str) -> str:
    """Drop // ... tail so a comment mentioning a banned API doesn't trip.
    Also drop /* ... */ on the same line. Won't handle multi-line block
    comments — fine, they're rare and rg-style line scanning suffices."""
    # Remove block comment on same line first.
    line = re.sub(r"/\*.*?\*/", "", line)
    # Remove tail-of-line comment, but preserve string contents.
    # Simple heuristic: find the first // that isn't inside a string.
    out_chars: list[str] = []
    in_string = False
    i = 0
    while i < len(line):
        c = line[i]
        if c == '"' and (i == 0 or line[i - 1] != "\\"):
            in_string = not in_string
        if (not in_string) and c == "/" and i + 1 < len(line) and line[i + 1] == "/":
            break
        out_chars.append(c)
        i += 1
    return "".join(out_chars)


def scan_file(path: Path) -> list[tuple[int, str, str, str]]:
    """Returns (line_no, rule_name, why, line) for each match."""
    hits: list[tuple[int, str, str, str]] = []
    try:
        text = path.read_text()
    except Exception:
        return hits
    for lineno, raw_line in enumerate(text.splitlines(), start=1):
        line = strip_line_comments(raw_line)
        if not line.strip():
            continue
        for pat, name, why in RULES:
            if pat.search(line):
                hits.append((lineno, name, why, raw_line.strip()))
    return hits


def main() -> int:
    sources = list((REPO_ROOT / "desktopAhaan").rglob("*.swift"))
    # Skip test target — XCTest is allowed to use anything modern; tests
    # don't ship to the iMac.
    sources = [p for p in sources if "desktopAhaanTests" not in p.parts]

    total_hits = 0
    for path in sorted(sources):
        hits = scan_file(path)
        for lineno, name, why, line in hits:
            rel = path.relative_to(REPO_ROOT)
            print(f"{rel}:{lineno}: {name} — {why}")
            print(f"    {line}")
            total_hits += 1

    if total_hits == 0:
        print("check_macos12_apis: clean — no banned modern SwiftUI APIs found.")
        return 0
    else:
        print()
        print(f"check_macos12_apis: refusing — found {total_hits} macOS 12+ API usage(s).")
        print("Deploy target is Big Sur 11.7.11; CLAUDE.md forbids macOS 12+ APIs.")
        return 1


if __name__ == "__main__":
    sys.exit(main())
