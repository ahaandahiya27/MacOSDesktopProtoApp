# Catching Big Sur build errors before they hit the iMac

This project ships to a **27" 5K iMac (Late 2014)** running **macOS Big Sur
11.7.11** with **Xcode 13.2.1** / **Swift 5.5** / the **macOS 12.1 SDK**.

Everything on `origin/main` MUST build on that machine. Some classes of bug
compile silently on modern Xcode (26+) but explode on Big Sur because of
older SDK or compiler differences.

## The traps that hit you, and how to dodge them

### 1. SwiftUI `@ViewBuilder` 10-child cap (Swift 5.5)

Swift 5.5's `@ViewBuilder` is overloaded only up to **10 direct children**
per closure. The 11th child compiles silently on modern Swift (which
synthesizes a different builder) but fails on Big Sur with a confusing
**"Extra argument in call"**.

**Symptom (Build log on iMac)**:
```
desktopAhaan/Subjects/Tutor/QuestionDetailView.swift:71:17: Extra argument in call
```

**Detect**: run the lint script from the repo root before pushing:
```sh
python3 scripts/check_viewbuilder_limit.py
```

**Fix**: wrap groups of children in `Group { ... }` or extract a computed
`@ViewBuilder var subgroup: some View { ... }` so each closure has ≤ 10
direct statements. See `QuestionDetailView.answerInteractionGroup` and
`ConceptDetailView.explanationGroup` for examples.

### 2. SF Symbols 3+ glyphs

Big Sur ships **SF Symbols 2.0**. Anything added in SF Symbols 3 (macOS 12)
or later renders as an empty square. The repo has a `SFSymbolCompat.name(_:)`
helper in `Extensions/Extensions.swift` — always route new symbols through
it.

**Detect**: when adding a symbol, eyeball it against
[SF Symbols app](https://developer.apple.com/sf-symbols/). If its "Available"
badge says iOS 15+ / macOS 12+ or later, it needs a fallback.

### 3. macOS 12+ SwiftUI / Foundation APIs

These compile silently on modern Xcode but fail (or run wrong) on Big Sur:
- `Canvas`, `TimelineView` — macOS 12+ only.
- `.foregroundStyle`, `.tint(_:)` modifier, `.searchable`, `.refreshable`,
  `NavigationStack`, `Material.regular`, `.regularMaterial`.
- ShapeStyle short forms like `.fill(.red)`, `.background(.white)` — use
  `Color.red` / `Color(NSColor.controlBackgroundColor)` instead.
- `Color.mint` / `.cyan` / `.indigo` / `.teal` / `.brown` — use the
  `Color.compat*` shims defined in `Extensions/Extensions.swift`.
- `.task` / `.task(id:)` — use `.onAppear { Task { ... } }`.
- `FormatStyle`, `URLSession.data(for:)` async — use the older `dataTask`
  callback API, or guard with `if #available(macOS 12, *)`.
- `.buttonStyle(.borderedProminent)` — macOS 12+. Use `.bordered` +
  `.accentColor(...)` for the same look on Big Sur.

### 4. Empty / "View not constructed" type-checker timeouts

Swift 5.5's type-checker times out on long inline expressions in
`@ViewBuilder` closures. If you see "compiler unable to type-check this
expression in reasonable time" in the Big Sur build log, extract pieces
into per-element View structs (see `Discover/Components/ParticleEmitter.swift`
for the `ParticleDot` pattern).

---

## How to verify on the modern Mac before pushing

The most accurate way is to install Xcode 13.2.1 alongside your current
Xcode on the modern Mac and switch between them with `xcode-select`. But
that's a 10 GB install and only catches the static issues that depend on
the older SDK.

**Faster, partial verification**:

```sh
# Run the @ViewBuilder lint:
python3 scripts/check_viewbuilder_limit.py

# Build for macOS 11 target with the modern toolchain:
xcodebuild -scheme desktopAhaan \
           -destination 'platform=macOS' \
           -configuration Debug \
           CODE_SIGNING_ALLOWED=NO CODE_SIGN_IDENTITY="" \
           build
```

The `-destination 'platform=macOS'` build catches deployment-target
mismatches (anything using a `@available(macOS 12, *)` API without the
guard). It does NOT catch `@ViewBuilder` 11-child issues — only Big Sur's
older Swift sees those.

**Authoritative verification**: pull on the iMac and let Xcode 13.2.1
compile. If it fails, the error message is usually enough to point at the
exact file/line.

---

## When a Big Sur build does fail

1. Copy the exact compile error including file:line into your prompt.
2. Most failures fall into one of the four categories above; reach for the
   matching fix pattern.
3. Re-run the lint script to confirm no other instances of the same class.
4. Push the fix on its own commit so the iMac can `git pull` and rebuild
   without pulling unrelated work.
