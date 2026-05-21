# Crash-Fix Super Prompt — desktopAhaan

A paste-ready, durable prompt for systematic crash hunting on this Big Sur
11.7.11 / Xcode 13.2.1 / Swift 5.5 / AMD R9 M290X target. Re-run any
time the user reports a fresh crash. The prompt is **a checklist of
known crash classes plus the exact greps/lints that catch each one**.

---

## Target machine (don't break)

- iMac Late-2014, Big Sur 11.7.11, Xcode 13.2.1, Swift 5.5
- AMD R9 M290X 2 GB GPU
- Universal binary (arm64 + x86_64), Release `ONLY_ACTIVE_ARCH=NO`
- Single user, offline-first, ad-hoc signed (`CODE_SIGN_IDENTITY=-`)

## The seven crash classes we've seen on this target

Each row gets a hard lint or a grep. Run them in order; fix until clean.

### A. Tuple-keypath ForEach (EXC_BAD_ACCESS in objc_release)

**Signature**: `ForEach(Array(x.enumerated()), id: \.offset) { idx, el in ... }`
on Swift 5.5 / Big Sur SwiftUI produces an unstable view identity.
SwiftUI's diffing then crashes during teardown with
`Entangling fence requested after pre-commit` followed by
`EXC_BAD_ACCESS` in `objc_release`.

**Detector**: `scripts/check_macos12_apis.py` rule
`ForEach with tuple-keypath id: \.offset`.

**Fix pattern**:
```swift
// BAD
ForEach(Array(items.enumerated()), id: \.offset) { idx, item in ... }

// GOOD — stable identity via indices
ForEach(items.indices, id: \.self) { idx in
    let item = items[idx]
    ...
}

// BETTER — proper Identifiable model
struct Row: Identifiable { let id = UUID(); let payload: ... }
ForEach(rows) { row in ... }
```

### B. macOS 12+ SwiftUI APIs that mis-bridge on Big Sur

**Signature**: same `Entangling fence` → EXC_BAD_ACCESS. The dangerous
ones are `.animation(_:value:)`, `.foregroundStyle`, `.symbolEffect`,
`.tint`, `.task`, `@Observable`, `NavigationStack`, `.refreshable`,
`Color.brown/mint/cyan/indigo/teal`, etc.

**Detector**: `scripts/check_macos12_apis.py` — 24 rules.

**Fix**: substitute the Big Sur equivalent. The lint message tells you which.

### C. Multiple `.sheet(isPresented:)` on the same view

**Signature**: only the last `.sheet` wires up; the others silently
no-op. When the user taps the silently-broken button, often nothing
visible happens, OR the view tries to mutate state during render and
fences out.

**Detector**: grep `\.sheet(isPresented:` per file, count > 1 = suspect.

**Fix pattern**: single `.sheet(item:)` with `Identifiable` enum:
```swift
@State private var presented: Sheet?
private enum Sheet: String, Identifiable {
    case foo, bar
    var id: String { rawValue }
}
.sheet(item: $presented) { kind in
    switch kind {
    case .foo: FooSheet()
    case .bar: BarSheet()
    }
}
```

### D. Force-unwrap / `try!` / `as!` in runtime paths

**Signature**: hard `EXC_BREAKPOINT` (Swift assertion failure) with a
stack inside the offending file.

**Detector**: grep `try!|as!|\[\d+\]!` excluding test target +
`FoundationTutor` (AI shim has a documented carve-out). See
`docs/ISSUE_CATEGORIES.md` rows B1/B2.

**Fix**: `guard let` / `if let` / `Result` types with graceful UI.

### E. `Dictionary(uniqueKeysWithValues:)` on possibly-duplicate keys

**Signature**: fatal "Duplicate values" in `Swift._abi_DictionaryLiteral`.

**Detector**: grep `Dictionary\(uniqueKeysWithValues:`.

**Fix**: use `Dictionary(_:uniquingKeysWith:)` and log a `DATA` entry
via `CrashReporter.logDataIssue`.

### F. ViewBuilder arity overflow (Swift 5.5 limit = 10)

**Signature**: type-check timeout at build time, or `_typeCheckExpression`
crash at runtime in a sufficiently complex VStack.

**Detector**: `scripts/check_viewbuilder_limit.py` (pre-commit hook).

**Fix**: wrap excess children in `Group { ... }`.

### G. SF Symbols 3+ names on a Big Sur SF Symbols 2 runtime

**Signature**: NSImage `imageNamed:` returns nil → SwiftUI Image draws
a blank box, sometimes followed by a layout-loop crash.

**Detector**: `scripts/check_sf_symbols_compat.py` — 44 compat-map
entries. Use `SFSymbolCompat.name("modern.icon")` everywhere.

---

## Less common but seen

### H. `@StateObject` initialized with side-effecting closure

Spinning up `SFSpeechRecognizer.authorizationStatus()` or
`AVAudioSession.sharedInstance()` inside the property default fires
the framework on every view construction. Slow + can deadlock
during launch.

**Fix**: default to a neutral value; sync lazily inside `requestPermissions()`
or equivalent. (See commit `49a7790` for the canonical fix.)

### I. State mutation during `body`

**Signature**: `Ignoring request to entangle context after pre-commit`.
SwiftUI is rendering and a `@Published` value changes mid-render.

**Fix**: defer mutation with `Task { @MainActor in ... }` or guard
with `DispatchQueue.main.async`.

### J. Test target instantiating UI ObservableObjects

Each `TranslatorViewModel()` constructs a `SpeechRecognitionManager`
and (pre-fix) fired a permission dialog. Even today, repeated
constructions thrash framework init.

**Fix**: pass `XCTestConfigurationFilePath` env-var guards into
side-effecting code paths.

---

## Operating procedure

When a crash is reported:

1. Reproduce: confirm the path that broke and grab the console output.
2. Identify the crash class from the table above by signature.
3. Run the relevant detector to find every other instance of the same
   class in the codebase — fix them all in one commit, not one at a
   time.
4. Land the fix:
   - `BuildProject` clean
   - `RunAllTests` clean (currently 310 tests)
   - `python3 scripts/check_macos12_apis.py` clean
   - `python3 scripts/check_sf_symbols_compat.py` clean
   - `python3 scripts/check_viewbuilder_limit.py` clean
5. Commit with `fix(crash):` prefix + co-author trailer.
6. Push to `origin/main` immediately so the iMac can pull.

## Rollback

```bash
git revert <hash>
git push origin main
```

If the fix is partial, leave the partial commit — never delete a
green-tested commit just to retry from clean.

## Where to look first when Try-at-Home crashes (Ch.1)

- `desktopAhaan/Subjects/Tutor/ChapterDetailView.swift` — sheet flow + HomeExperimentCard
- `desktopAhaan/Subjects/Tutor/Discover/DiscoverChapter1View.swift` — Discover Mode scenes
- `desktopAhaan/Subjects/Tutor/Discover/DiscoverMode.swift` — DiscoverShell
- Any `ForEach(Array(...))` or `.animation(_:value:)` in those files

## Co-author trailer

```
Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>
```
