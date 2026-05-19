#!/usr/bin/env python3
"""WCAG 2.1 contrast-ratio calculator + audit harness.

Two modes:
  1. CLI: `check_wcag_contrast.py <fg_hex> <bg_hex>` → prints ratio + pass/fail.
  2. Audit: when run with no args, scans a hard-coded list of foreground /
     background pairs used in the desktopAhaan canvas and reports which
     fall below WCAG AA. Exit code 1 if any pair fails.

The audit list mirrors the actual colours pinned in
`desktopAhaan/Extensions/Extensions.swift` (DesignTokens.BrandColor) and
`desktopAhaan/Subjects/Tutor/Discover/Components/SoftShadowCard.swift`
(DiscoverBackground gradient stops). When a pair fails, the script
prints the calling site so the fix is locatable.

Formula: WCAG 2.1 §1.4.3 / §1.4.6.
  L = 0.2126 * R + 0.7152 * G + 0.0722 * B
  where each channel is sRGB → linear-RGB transformed.
  contrast = (L_lighter + 0.05) / (L_darker + 0.05)
"""

from __future__ import annotations

import sys
from typing import Iterable

AA_NORMAL = 4.5
AA_LARGE = 3.0
AAA_NORMAL = 7.0
AAA_LARGE = 4.5


def _channel_linear(c: float) -> float:
    """sRGB channel (0…1) to linear-RGB channel."""
    return c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4


def relative_luminance(rgb: tuple[float, float, float]) -> float:
    r, g, b = (_channel_linear(c) for c in rgb)
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def contrast_ratio(fg: tuple[float, float, float],
                   bg: tuple[float, float, float]) -> float:
    l1 = relative_luminance(fg)
    l2 = relative_luminance(bg)
    lighter, darker = (l1, l2) if l1 > l2 else (l2, l1)
    return (lighter + 0.05) / (darker + 0.05)


def parse_hex(s: str) -> tuple[float, float, float]:
    s = s.lstrip("#")
    if len(s) == 3:
        s = "".join(c * 2 for c in s)
    if len(s) != 6:
        raise ValueError(f"hex must be 3 or 6 chars: {s!r}")
    r = int(s[0:2], 16) / 255.0
    g = int(s[2:4], 16) / 255.0
    b = int(s[4:6], 16) / 255.0
    return (r, g, b)


def parse_rgb_float(rgb: tuple[float, float, float]) -> tuple[float, float, float]:
    """Pass-through; accepts floats already in 0…1."""
    return rgb


def grade(ratio: float, large_text: bool = False) -> str:
    aa = AA_LARGE if large_text else AA_NORMAL
    aaa = AAA_LARGE if large_text else AAA_NORMAL
    if ratio >= aaa:
        return "AAA"
    if ratio >= aa:
        return "AA"
    return "FAIL"


# ---------------------------------------------------------------------------
# Audit list — keep in sync with the actual canvas colours

GRADIENT_TOP = (0.88, 0.95, 1.0)
GRADIENT_MID = (0.96, 1.0, 0.92)
GRADIENT_BOTTOM = (0.85, 0.95, 0.78)

CANVAS_TEXT = (0.13, 0.13, 0.13)
CANVAS_TEXT_SECONDARY = (0.36, 0.38, 0.42)

# BrandColor values pinned in `desktopAhaan/Extensions/Extensions.swift`.
# Keep in sync — `testBrandColorMatchesWCAGAuditExpectations` in
# ChapterContentTests.swift fails CI if the Swift constants drift from
# the script's expectations.
BRAND_LOOKING_AHEAD = (0.42, 0.20, 0.65)
BRAND_TRY_AT_HOME = (0.65, 0.32, 0.0)
BRAND_MNEMONIC = (0.55, 0.42, 0.0)
BRAND_RELATED_CONCEPTS = (0.0, 0.45, 0.55)
BRAND_DANGER = (0.72, 0.14, 0.10)
BRAND_PRIMARY_ACTION = (0.10, 0.52, 0.18)
COMPAT_INDIGO = (0.31, 0.31, 0.78)


def _audit_pairs() -> list[tuple[str, tuple[float, float, float],
                                   tuple[float, float, float], bool]]:
    """(role, foreground, background, large_text?)"""
    return [
        # Canvas text against each gradient stop.
        ("canvasText on gradient TOP", CANVAS_TEXT, GRADIENT_TOP, False),
        ("canvasText on gradient MID", CANVAS_TEXT, GRADIENT_MID, False),
        ("canvasText on gradient BOTTOM", CANVAS_TEXT, GRADIENT_BOTTOM, False),
        ("canvasTextSecondary on gradient TOP", CANVAS_TEXT_SECONDARY,
         GRADIENT_TOP, False),
        ("canvasTextSecondary on gradient MID", CANVAS_TEXT_SECONDARY,
         GRADIENT_MID, False),
        ("canvasTextSecondary on gradient BOTTOM", CANVAS_TEXT_SECONDARY,
         GRADIENT_BOTTOM, False),

        # BrandColor accent labels rendered as text on canvas.
        ("BrandColor.lookingAhead on gradient MID",
         BRAND_LOOKING_AHEAD, GRADIENT_MID, False),
        ("BrandColor.tryAtHome on gradient MID",
         BRAND_TRY_AT_HOME, GRADIENT_MID, False),
        ("BrandColor.mnemonic on gradient MID",
         BRAND_MNEMONIC, GRADIENT_MID, False),
        ("BrandColor.relatedConcepts on gradient MID",
         BRAND_RELATED_CONCEPTS, GRADIENT_MID, False),
        ("BrandColor.danger on white sheet",
         BRAND_DANGER, (1.0, 1.0, 1.0), False),

        # Green is used as a button background only (white text on green),
        # not as text on canvas — audit the on-button white text instead.
        ("white text on primaryAction button",
         (1.0, 1.0, 1.0), BRAND_PRIMARY_ACTION, False),

        # compatIndigo (used in Daily Practice + all-chapters celebration).
        ("compatIndigo on white sheet",
         COMPAT_INDIGO, (1.0, 1.0, 1.0), False),
        # White-on-indigo inverse (used inside the celebration overlay).
        ("white on compatIndigo card",
         (1.0, 1.0, 1.0), COMPAT_INDIGO, False),
    ]


def audit() -> int:
    pairs = _audit_pairs()
    fails: list[tuple[str, float, str]] = []
    print(f"{'role':62s} {'ratio':>6s}  grade  notes")
    print("-" * 100)
    for role, fg, bg, large in pairs:
        r = contrast_ratio(fg, bg)
        g = grade(r, large_text=large)
        note = "" if g != "FAIL" else "BELOW WCAG AA"
        print(f"{role:62s} {r:6.2f}  {g:>4s}   {note}")
        if g == "FAIL":
            fails.append((role, r, note))
    print()
    if fails:
        print(f"FAILED {len(fails)} of {len(pairs)} pairs — at least one is below WCAG AA.")
        return 1
    print(f"OK — all {len(pairs)} pairs meet WCAG AA.")
    return 0


def cli(args: Iterable[str]) -> int:
    argv = list(args)
    if len(argv) == 0:
        return audit()
    if len(argv) != 2:
        print("usage: check_wcag_contrast.py <fg_hex> <bg_hex>")
        print("       check_wcag_contrast.py            # run full audit")
        return 2
    try:
        fg = parse_hex(argv[0])
        bg = parse_hex(argv[1])
    except ValueError as e:
        print(f"error: {e}")
        return 2
    r = contrast_ratio(fg, bg)
    print(f"contrast: {r:.2f}")
    print(f"normal:   {grade(r, large_text=False)}")
    print(f"large:    {grade(r, large_text=True)}")
    return 0 if r >= AA_NORMAL else 1


if __name__ == "__main__":
    raise SystemExit(cli(sys.argv[1:]))
