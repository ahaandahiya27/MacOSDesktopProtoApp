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
    # Combined transitions involving .scale or .move on Big Sur AMD R9
    # M290X are a documented render-loop trigger. They occasionally
    # crash with the same Entangling-fence → EXC_BAD_ACCESS signature
    # as the animation-value bug, especially when the transition is
    # applied to a view that re-positions during the animation. Lighten
    # to plain `.opacity` — the visual loss is barely perceptible.
    # Found 10 such sites during the 2026-05-22 deep audit (Scene7_
    # PitcherPlantTrap, Scene8_NitrogenCycle, plus 8 across Ch.2/3/4/5/6).
    (re.compile(r"\.transition\(\.[a-zA-Z]+(?:\([^)]*\))?\.combined\(with:\s*\.[a-zA-Z]+"),
     ".transition(...combined(with: ...))",
     "Big Sur AMD R9 M290X — combined transitions involving .scale/.move can " +
     "render-loop. Use plain `.transition(.opacity)` instead."),
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
    (re.compile(r"\.scrollTargetLayout\s*\("),
     ".scrollTargetLayout(...)",
     "macOS 14.0+ — no Big Sur equivalent; layout manually."),
    (re.compile(r"\.scrollTargetBehavior\s*\("),
     ".scrollTargetBehavior(...)",
     "macOS 14.0+ — no Big Sur equivalent."),
    (re.compile(r"\.scrollIndicatorsFlash\s*\("),
     ".scrollIndicatorsFlash(...)",
     "macOS 14.0+ — no Big Sur equivalent."),
    (re.compile(r"\.contentTransition\s*\("),
     ".contentTransition(...)",
     "macOS 13.0+ — use .transition(.opacity) on Big Sur."),
    (re.compile(r"\bImageRenderer\s*\("),
     "ImageRenderer(...)",
     "macOS 13.0+ — use `renderViewToImage` (in Extensions.swift) on Big Sur."),
    # Two-argument .onChange(of:) { _, _ in ... } is macOS 14+. The
    # single-argument signature is the Big Sur form. Detect the new
    # form by matching the trailing-closure double parameter list:
    # `.onChange(of: x) { oldValue, newValue in ...`. Single-line only.
    (re.compile(r"\.onChange\s*\(of:[^)]*\)\s*\{\s*\w+\s*,\s*\w+\s+in\b"),
     ".onChange(of:) { _, _ in } (two-argument)",
     "macOS 14.0+ — use single-argument `.onChange(of:) { newValue in }` on Big Sur."),
    (re.compile(r"\.fontWidth\s*\("),
     ".fontWidth(...)",
     "macOS 13.0+ — no Big Sur equivalent; pick a different font weight/family."),
    (re.compile(r"\.fontDesign\s*\("),
     ".fontDesign(...)",
     "macOS 13.0+ — use `.font(.system(size:weight:design:))` on Big Sur."),
    # === Crash-class forward-prevention rules (12h-spec iter 4) ===
    # C1: `unowned` produces objc_release EXC_BAD_ACCESS on Big Sur if the
    # owning object outlives the unowned reference. Always use `weak` and
    # nil-bind. The whole production codebase scanned clean during the
    # 12h-spec iter 2 deep scan; this rule keeps it that way.
    (re.compile(r"\bunowned\s+(let|var|self)\b"),
     "unowned reference",
     "C1 hazard — `unowned` over-releases on Big Sur when the owning " +
     "object outlives the reference. Use `weak` + nil-bind."),
    # C1: NSObject subclass with `var delegate:` (no `weak`). On Big Sur
    # the AppKit runtime over-releases such delegates during view
    # teardown. Match `var delegate:` not preceded by `weak`.
    (re.compile(r"^\s*var\s+delegate\s*:"),
     "var delegate: (must be weak var)",
     "C1 hazard — delegates on NSObject-rooted classes must be `weak var`. " +
     "Strong delegate pointers over-release on Big Sur teardown."),
    # C1: @unchecked Sendable is by definition concurrency-unsafe. Use
    # an actor or an internal NSLock instead.
    (re.compile(r"@unchecked\s+Sendable\b"),
     "@unchecked Sendable",
     "C1/C5 hazard — concurrency-unsafe. Convert to an actor or wrap " +
     "internal state in NSLock."),
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
    # Not a macOS-version API but the same Big Sur SwiftUI fragility
    # class: `ForEach(Array(x.enumerated()), id: \.offset)` produces an
    # unstable view identity on Swift 5.5 → "Entangling fence requested
    # after pre-commit" → EXC_BAD_ACCESS. Same bug class that crashed
    # Try-at-Home / Van Helmont. Use `ForEach(x.indices, id: \.self)`
    # and subscript x[i] inside, OR a proper Identifiable model struct.
    (re.compile(r"ForEach\(Array\(.*\.enumerated\(\)\)[^)]*id:\s*\\\.offset"),
     "ForEach with tuple-keypath id: \\.offset",
     "Swift 5.5 / Big Sur SwiftUI fragility — unstable view identity. " +
     "Use ForEach(x.indices, id: \\.self) { i in let item = x[i]; ... }."),
    # Same fragility class but with `\.element.id` instead of `\.offset`.
    # On Swift 5.5 the tuple identity still flickers during scroll/swap
    # because the (offset, element) tuple is rebuilt every render. Found
    # in CommandPalette + Scene1_FastOrSlow during the 2026-05-21 audit;
    # both converted to ForEach(x.indices, id: \.self) + subscript.
    (re.compile(r"ForEach\(Array\(.*\.enumerated\(\)\)[^)]*id:\s*\\\.element"),
     "ForEach with tuple-keypath id: \\.element.<...>",
     "Swift 5.5 / Big Sur SwiftUI fragility — even with `\\.element.id` the " +
     "tuple wrapper rebuilds on render. Use ForEach(x.indices, id: \\.self) " +
     "{ i in let item = x[i]; ... }."),
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
    """Returns (line_no, rule_name, why, line) for each match.

    Two-pass scan:
    1. Per-line scan strips line comments and runs each rule against the
       single line. Catches the common-case banned API calls.
    2. Whole-file scan against a comment-stripped concatenated text with
       newlines collapsed to single spaces, so a multi-line `.animation(
           ..., value: x)` call is still caught. This second pass exists
       because we missed a multi-line `.animation(_:value:)` in
       Scene1_HeartBeats during the 2026-05-21 audit — Big Sur crash
       class slipped through the per-line regex.
    """
    hits: list[tuple[int, str, str, str]] = []
    try:
        text = path.read_text()
    except Exception:
        return hits

    # Pass 1: per-line
    matched_rules_perline: set[str] = set()
    for lineno, raw_line in enumerate(text.splitlines(), start=1):
        line = strip_line_comments(raw_line)
        if not line.strip():
            continue
        for pat, name, why in RULES:
            if pat.search(line):
                hits.append((lineno, name, why, raw_line.strip()))
                matched_rules_perline.add(name)

    # Pass 2: bounded multi-line scan. Only for rules where the banned
    # API is plausibly typed across multiple lines (currently just
    # `.animation(_:value:)`). For each line that starts a `.animation(`
    # call but doesn't close its parens on the same line, collect the
    # next-N lines until the parens balance, then test the rule.
    cleaned_lines: list[str] = [strip_line_comments(r) for r in text.splitlines()]
    multiline_rules = [
        (pat, name, why) for (pat, name, why) in RULES
        if name == ".animation(_:value:)"
    ]
    if multiline_rules:
        for start_idx, line in enumerate(cleaned_lines):
            if ".animation(" not in line:
                continue
            # Find the column of `.animation(`.
            ani_col = line.find(".animation(")
            # Walk forward to balance parens, up to 6 lines (typical
            # multi-line `.animation(...)` calls span 2-4 lines; 6 is
            # comfortable headroom without re-introducing the line-190
            # false-positive class).
            depth = 0
            buf: list[str] = []
            ended = False
            for j in range(start_idx, min(len(cleaned_lines), start_idx + 6)):
                seg = cleaned_lines[j] if j > start_idx else line[ani_col:]
                buf.append(seg)
                for ch in seg:
                    if ch == "(":
                        depth += 1
                    elif ch == ")":
                        depth -= 1
                        if depth == 0:
                            ended = True
                            break
                if ended:
                    break
            if not ended or len(buf) < 2:
                # Either unbalanced (skip — likely a parse oddity)
                # or single-line (already covered by pass 1).
                continue
            collapsed = " ".join(buf)
            for pat, name, why in multiline_rules:
                if pat.search(collapsed):
                    hits.append((start_idx + 1, name, why,
                                 "[multi-line match] " + collapsed[:80].strip()))
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
