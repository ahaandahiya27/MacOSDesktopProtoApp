# J8_DESIGN_TOKENS_LEDGER.md — DesignTokens call-site migration (J8)

J8 is the call-site migration of every raw padding / spacing / corner-radius
literal across the app over to the `DesignTokens.Spacing` and
`DesignTokens.Radius` primitives that Phase 2 of the visual sweep added to
`desktopAhaan/Extensions/Extensions.swift`. The primitives existed for months;
the call sites kept the legacy `CGFloat` literals (`.padding(.horizontal, 16)`,
`.cornerRadius(14)`, `VStack(spacing: 12) { ... }`) for source-compat. **The
mechanical sweep is now complete** across the whole codebase — six waves, ~3,150
spacing sites and ~340 radius sites migrated — and two new lints
(`check_designtokens_spacing` + `check_designtokens_radius`) wired into
`scripts/test_lints.py` + `scripts/ci-build-test.sh` prevent regression.

This is the J8-row companion to `OLYMPIAD_CONTENT_LEDGER.md` and
`ADVANCED_TIER_LEDGER.md`. Tracked under `docs/ISSUE_CATEGORIES.md` row **J8**
(plus the LY3 duplicate row).

## Token canon

The migration targets are the nested enums under `DesignTokens` in
`desktopAhaan/Extensions/Extensions.swift`. Their canonical values:

### `DesignTokens.Spacing`
| Token  | Value | Legacy alias       |
|--------|------:|--------------------|
| `xxs`  |   2   | —                  |
| `xs`   |   4   | —                  |
| `sm`   |   8   | `spacingTight`     |
| `md`   |  12   | `spacingMedium`    |
| `lg`   |  16   | `spacingRelaxed`   |
| `xl`   |  24   | `spacingWide`      |
| `xxl`  |  32   | —                  |
| `xxxl` |  48   | —                  |

### `DesignTokens.Radius`
| Token   | Value | Legacy alias          |
|---------|------:|-----------------------|
| `sm`    |   8   | `cornerRadiusSmall`   |
| `md`    |  10   | `cornerRadiusMedium`  |
| `card`  |  14   | `cornerRadiusCard`    |
| `lg`    |  16   | `cornerRadiusLarge`   |
| `xl`    |  22   | —                     |
| `pill`  | 999   | —                     |

Names of `Radius` mirror `Spacing`'s scale so a `md` radius pairs visually with
`md` spacing without a lookup table.

## Wave-by-wave history

| Wave | Description | Sites | Surfaces touched |
|-----:|-------------|------:|------------------|
| 1 | Discover Scenes padding/spacing → DesignTokens | 19 | Discover Scenes |
| 1 | Tutor core views padding/spacing → DesignTokens | 23 | Tutor core (chapter / concept / question shells) |
| 1 | Insights / Weekly / Mastery views → DesignTokens | 41 | Insights window, Weekly dashboard, Mastery map |
| 1 | Translator / Articles / Shell padding/spacing → DesignTokens | 9 | Translator, Articles browser, app shell |
| 2 | Discover surface padding/spacing → DesignTokens | 2,357 | Full Discover surface (all chapters, all scenes, all components) |
| 2 | Tutor surfaces (non-Discover) → DesignTokens | 488 | Tutor non-Discover surfaces |
| 2 | `Views/` (Progress / Home / Practice / etc) → DesignTokens | 124 | Progress, Home, Practice, Olympiad chrome |
| 2 | Articles browser directional padding | 1 | Articles browser directional pad |
| 3 | Discover corner-radius literals → `DesignTokens.Radius` | 190 | Discover surface radii |
| 3 | Tutor non-Discover radius → `DesignTokens.Radius` | 127 | Tutor non-Discover radii |
| 3 | `Views/` radius → `DesignTokens.Radius` | 20 | Views/ radii |
| 3 | Articles browser radius → `DesignTokens.Radius` | 1 | Articles browser radius |
| 4 | Mop-up: continuous radius, `Spacer minLength`, legacy consolidation | 166 | Cross-surface residuals + legacy `cornerRadius*` → tokens |
| 5 | `LazyVGrid` / `LazyHGrid` spacing → DesignTokens | 10 | Grid containers |
| 6 | Mop-up: residual padding/spacing/radius in OlympiadTests + ExpandableCard + DailyPractice | 8 files | Stragglers caught by the new lints |

**Totals:** ~3,150 spacing literals + ~340 radius literals migrated across
the J8 sweep. Plus a parallel **H2** pass landed ~169 `.accessibilityHint`
additions across ~89 files alongside the design-token waves (logged under
the H2 row in `docs/ISSUE_CATEGORIES.md`, not here).

## Regression prevention

Two new lints are now wired into `scripts/test_lints.py` and run on every
push through `scripts/ci-build-test.sh`:

- **`check_designtokens_spacing.py`** — flags new raw `CGFloat` literals on
  `.padding(...)` / `VStack(spacing:)` / `HStack(spacing:)` / `LazyVGrid(spacing:)`
  / `LazyHGrid(spacing:)` / `Spacer(minLength:)` call sites. Allowed surfaces:
  off-token N values that don't fit the 2/4/8/12/16/24/32/48 ladder, locked
  invariant files (`Extensions.swift`, article-renderer shims), and
  `frame(width:height:)` (semantically different from spacing).
- **`check_designtokens_radius.py`** — flags new raw `CGFloat` literals on
  `.cornerRadius(...)` / `RoundedRectangle(cornerRadius:)` / `.clipShape(RoundedRectangle(cornerRadius:))`.
  Allowed: off-token N values that don't fit 8/10/14/16/22/999, Path/Shape
  drawing math, and the same locked invariant files.

Lint count moved **36 → 38** with the J8 closeout commit. Both lints are
ratchets: they catch only *new* off-token literals; the existing whitelist
encodes intentional exemptions documented inline.

## Out of scope (intentionally not migrated)

The sweep was deliberately mechanical and ratchet-compatible. The following
classes of literal were left alone:

- **Off-token N values** (3, 6, 9, 10, 14, 18, 20, 28, 40, etc.) — these
  don't fit the 2 / 4 / 8 / 12 / 16 / 24 / 32 / 48 ladder. Migrating them
  needs a design discussion: either add a new token (and ratchet its
  meaning) or round the call site to the nearest existing token. Out of
  scope for the mechanical sweep.
- **`Path` / `Shape` / `Canvas` drawing math** — coordinate math inside
  custom `Path { path in ... }` or `Canvas { ctx, size in ... }` closures
  is geometry, not chrome. Tokenising these would obscure intent.
- **Locked-invariant files** — `desktopAhaan/Extensions/Extensions.swift`
  (where the tokens are *defined* — must use literals) and the two article
  renderer shims pinned by their respective ratchets.
- **`frame(width:)` / `frame(height:)`** — semantically distinct from
  spacing (a frame is a sizing constraint, not a gap). Migrating frames to
  a spacing token would lie about intent.
- **Animation timing values** — durations and delays in `.animation(...)`
  / `withAnimation(.easeInOut(duration: 0.3))` aren't spacing; they live in
  a separate (future) `DesignTokens.Motion` namespace.

## Verdict

✅ **J8 mechanical sweep complete.** ~3,150 spacing + ~340 radius call sites
migrated across six waves; two ratchet lints prevent regression.

Next: a visual-verify pass on the Big Sur iMac confirms no visible
regressions (token rounding can shift a 9 → 8 or 10 → 12 on a per-site
basis; the design intent was preserved but a side-by-side eyeball on the
target hardware is the authoritative green).
