#!/usr/bin/env python3
"""Color(red:green:blue:) site-count freeze ratchet.

The audit (AUDIT-C, 2026-06-13) found ~85 `Color(red:..., green:...,
blue:...)` literal sites outside the sanctioned files. Many are
intentional domain palettes (soil profile, forest canopy strata,
climate bands) so a one-size-fits-all migration to
`DesignTokens.BrandColor.*` is the wrong call. Instead this lint
FREEZES the current count: refactoring is fine, but a NEW raw RGB
site fails commit.

A future "Color RGB centralization" sweep can shrink this ceiling
by either consolidating sites into a new DesignTokens.Palette.* enum
OR moving them into ChapterTheme.swift's per-chapter brand identity
namespace. As the count drops, lower CEILING in the same PR — the
J8 spacing/radius migration pattern.

Sanctioned locations (RGB literals here are intentional):
  - `desktopAhaan/Resources/ChapterTheme.swift` — per-chapter brand
    identity palette (defines `chapterBrandColor(_:)`).
  - `desktopAhaan/Extensions/Extensions.swift` — `Color.compat*`
    Big-Sur safe fallbacks (compatIndigo, compatTeal, compatCyan,
    compatBrown, compatMint).

Excluded from the scan:
  - The two sanctioned files above.
  - Test bundles (`desktopAhaanTests/`, `desktopAhaanUITests/`).
  - Article rendering shims (`NativeArticleRepresentable.swift`,
    `ArticleStructuredRenderer.swift`, `ArticleStructuredRenderer+Render.swift`).
  - Comment lines (// ...) and block comments (/* ... */).
  - Lines inside a Swift string literal.

Usage:
    python3 scripts/check_color_rgb_centralized.py [--list]
    python3 scripts/check_color_rgb_centralized.py --selftest
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SCAN_ROOT = REPO_ROOT / "desktopAhaan"

# Pattern matches `Color(red: <num>, green: <num>, blue: <num>` —
# allows whitespace, decimal or integer literal values, ignores
# trailing args (e.g. `, opacity: 0.5`).
PATTERN = re.compile(
    r"Color\(\s*red:\s*[\d.]+\s*,\s*green:\s*[\d.]+\s*,\s*blue:\s*[\d.]+"
)

# Sanctioned files (RGB literals here are by-design).
SANCTIONED = {
    "ChapterTheme.swift",
    "Extensions.swift",
    "NativeArticleRepresentable.swift",
    "ArticleStructuredRenderer.swift",
    "ArticleStructuredRenderer+Render.swift",
}

# Current site count established 2026-06-13 (audit baseline).
# RAISE this number ONLY if you genuinely need to add a new domain
# palette site (and document why in the commit message).
# LOWER this number when a future RGB-centralization sweep consolidates
# sites into a token enum.
CEILING = 85


def _strip_comments_and_strings(src: str) -> str:
    """Return `src` with // line comments, /* */ block comments, and
    "..." string literals replaced by spaces. Preserves line numbers
    (newlines kept) so a hit's reported line stays accurate.
    """
    # Block comments first (multi-line).
    out = re.sub(r"/\*.*?\*/", lambda m: " " * len(m.group(0)), src, flags=re.S)
    # Strip after line comments (// ... \n) — preserve the newline.
    out = re.sub(r"//[^\n]*", lambda m: " " * len(m.group(0)), out)
    # String literals — naive but adequate for this codebase's idioms.
    # Triple-quoted "" "..." "" first.
    out = re.sub(r'"""[\s\S]*?"""', lambda m: " " * len(m.group(0)), out)
    # Then single-line "...".
    out = re.sub(r'"(?:\\.|[^"\\\n])*"', lambda m: " " * len(m.group(0)), out)
    return out


def count_sites(src: str) -> int:
    """Count Color(red:green:blue:) matches in scrubbed source."""
    return len(PATTERN.findall(_strip_comments_and_strings(src)))


def scan_text(src: str) -> list[int]:
    """Return line numbers of Color(red:...) matches in src."""
    scrubbed = _strip_comments_and_strings(src)
    return [
        scrubbed[: m.start()].count("\n") + 1
        for m in PATTERN.finditer(scrubbed)
    ]


def is_skipped_path(path: Path) -> bool:
    if path.name in SANCTIONED:
        return True
    parts = path.parts
    if "desktopAhaanTests" in parts or "desktopAhaanUITests" in parts:
        return True
    return False


def scan_repo(list_sites: bool = False) -> int:
    total = 0
    per_file: list[tuple[Path, list[int]]] = []
    for swift_path in SCAN_ROOT.rglob("*.swift"):
        if is_skipped_path(swift_path):
            continue
        src = swift_path.read_text(encoding="utf-8")
        lines = scan_text(src)
        if lines:
            total += len(lines)
            per_file.append((swift_path, lines))

    if total > CEILING:
        print(
            f"check_color_rgb_centralized: FAILED — Color(red:green:blue:) site "
            f"count grew {CEILING} → {total}. The 2026-06-13 audit froze the "
            f"baseline; new RGB literals outside the sanctioned files "
            f"(ChapterTheme.swift, Extensions.swift) drift the design system."
        )
        if list_sites:
            for path, lines in per_file:
                rel = path.relative_to(REPO_ROOT)
                for n in lines:
                    print(f"  {rel}:{n}")
        else:
            print("  Re-run with --list to see every site, including the new ones.")
        print(
            "\nIf the new site IS the right call (domain-specific palette, "
            "intentional Big-Sur-safe substitution), raise CEILING in this "
            "lint to the new count + explain why in the commit message. "
            "Otherwise move the color into ChapterTheme.swift or "
            "DesignTokens.BrandColor.*."
        )
        return 1

    print(
        f"check_color_rgb_centralized: clean — {total} Color(red:green:blue:) "
        f"site(s) across {len(per_file)} file(s), ≤ ceiling of {CEILING}."
    )
    if list_sites:
        for path, lines in per_file:
            rel = path.relative_to(REPO_ROOT)
            for n in lines:
                print(f"  {rel}:{n}")
    return 0


# ── Embedded selftest ───────────────────────────────────────────────

_DANGER_FIXTURE = '''\
struct ChartView: View {
    let primary = Color(red: 0.85, green: 0.20, blue: 0.10)
    let accent  = Color(red: 0.1, green: 0.5, blue: 0.9, opacity: 0.7)
    var body: some View {
        Rectangle().fill(Color(red: 0, green: 0, blue: 0))
    }
}
'''

_CLEAN_FIXTURE = '''\
struct ChartView: View {
    // Color(red: 0.5, green: 0.5, blue: 0.5) — commented-out shouldn't count.
    let primary = Color.red
    let label = "Color(red: 0.5, green: 0.5, blue: 0.5) in a string literal"
    var body: some View {
        Rectangle().fill(DesignTokens.BrandColor.primaryAction)
    }
}
'''


def run_selftest() -> int:
    ok = True

    danger_count = count_sites(_DANGER_FIXTURE)
    if danger_count == 3:
        print(f"  [PASS] danger fixture flags 3 sites: got {danger_count}")
    else:
        print(f"  [FAIL] danger fixture: expected 3, got {danger_count}")
        ok = False

    clean_count = count_sites(_CLEAN_FIXTURE)
    if clean_count == 0:
        print("  [PASS] clean fixture flags 0 (comment + string excluded)")
    else:
        print(f"  [FAIL] clean fixture: expected 0, got {clean_count}")
        ok = False

    if ok:
        print("\ncheck_color_rgb_centralized --selftest: PASS")
        return 0
    print("\ncheck_color_rgb_centralized --selftest: FAIL")
    return 1


def main() -> int:
    if "--selftest" in sys.argv:
        return run_selftest()
    return scan_repo(list_sites="--list" in sys.argv)


if __name__ == "__main__":
    sys.exit(main())
