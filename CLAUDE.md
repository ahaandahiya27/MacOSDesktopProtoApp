# CLAUDE.md — Working agreement for the desktopAhaan repo

Read this before touching the codebase. It's the durable summary of how
this project is built, what platform it must run on, and the conventions
every session has converged on.

## What this project is

A single-window macOS SwiftUI app for a Class 7 student (Ahaan). Bundles:

- **Sanskrit translator** with on-device dictionary + speech.
- **Science tutor** — 19 chapters of NCERT Class 7 content (concepts,
  questions, Discover Mode interactive scenes, articles).
- **OCR translator** for scanned Sanskrit text.

Single user. Offline-first. No accounts. No telemetry. The only outbound
network call is the optional `FreeOnlineTranslationProvider`, which the
user can disable in Settings.

## Hard platform constraints (don't break these)

The deploy target is **a Late-2014 iMac running Big Sur 11.7.11** with
**Xcode 13.2.1 / Swift 5.5** and an AMD R9 M290X 2 GB GPU.

| Rule | Why | Where to look |
|------|-----|---------------|
| **No macOS 12+ APIs.** No `@Observable`, `Bindable`, `.scrollPosition`, `Layout`, `.foregroundStyle`, `Charts`, `Image.resizable(capInsets:)` macOS 12 variants. | Compiles for Big Sur, runs there. | `docs/ISSUE_CATEGORIES.md` row A2 |
| **`@ViewBuilder` closures ≤ 10 direct children.** Wrap with `Group { ... }` when you hit the limit. | Swift 5.5 buildBlock arity ceiling. | `scripts/check_viewbuilder_limit.py` |
| **No SF Symbols 3+/4+ names directly.** Route through `SFSymbolCompat.name(_:)`. | SF Symbols 2 on Big Sur. | `desktopAhaan/Extensions/Extensions.swift` |
| **No `try!` / `as!` / `[i]!` in runtime paths.** Only `FoundationTutor` (an AI shim) gets a pass. | One crash on the iMac kills the morning's session. | `docs/ISSUE_CATEGORIES.md` rows B1/B2 |
| **Particle counts honour `HardwareTier.isLegacy`.** Cap at 20 fps on legacy. | The AMD R9 M290X is the bottleneck. | `desktopAhaan/Subjects/Tutor/Discover/Components/HardwareTier.swift` |
| **Universal binary** (arm64 + x86_64). Release config: `ONLY_ACTIVE_ARCH = NO`. | Dev Macs are Apple Silicon; deploy iMac is Intel. | `desktopAhaan.xcodeproj/project.pbxproj` |

If you're tempted to use a macOS 12+ API, search for the symbol in
`docs/ISSUE_CATEGORIES.md` first — there's almost always a Big Sur
substitute already documented (e.g. `Color.compatIndigo` instead of
`.foregroundStyle(.tint)`).

## Cross-machine workflow

```
dev Mac  ─ git push ─►  GitHub origin/main  ◄─ git pull ─  iMac
   (newer Xcode)                                  (Xcode 13.2.1)
```

The iMac has its own bulletproof pull script — `scripts/imac-pull.sh`
— that quits Xcode, stashes pbxproj auto-edits, pulls, wipes
DerivedData, and re-opens the project. Always **push** your fix
before telling the user to pull — a commit that never reaches origin
might as well not exist.

Repo layout on the iMac:
```
/Users/ahaandahiya/Downloads/DesktopAhaan 4/desktopAhaan/   ← git repo root
    .git/
    desktopAhaan.xcodeproj/
    scripts/imac-pull.sh
```

(The outer `DesktopAhaan 4/` is a wrapper folder, NOT the repo root.
Reference paths only inside `desktopAhaan/`.)

## Common gotchas

- **`Dictionary(uniqueKeysWithValues:)`** fatally crashes on duplicate
  keys. Use `Dictionary(_:uniquingKeysWith:)` and log to
  `CrashReporter.logDataIssue` instead.
- **`@AppStorage` keys** all go through the `AppStorageKeys` enum so a
  typo doesn't silently fork a fresh cursor across the chapter
  dispatchers.
- **WKWebView in-page JavaScript is disabled** per-navigation. Native
  `evaluateJavaScript` for the Read Aloud feature still works — that
  gate is for JS authored inside the loaded HTML.
- **All file writes** use `options: .atomic`. Don't introduce a
  non-atomic write to `~/Library/Application Support/desktopAhaan/`.
- **JSON content packs** must run through `SubjectPack.validateRelatedRefs()`
  — orphan `relatedConceptIds` / `relatedQuestionIds` go into the
  crashlog as `DATA` entries.

## Issue taxonomy

Every category of bug or risk this app can have is enumerated in
`docs/ISSUE_CATEGORIES.md` (A–Y). When you finish a fix, flip the row
to ✅ with a one-line note describing what landed. The doc is the
single source of truth for "what's done, what's pending."

When the user asks for a status pass, walk the 🟡 and ❌ rows.

## Crash workflow

```
iMac crashes  →  CrashReporter writes ~/Library/Application Support/desktopAhaan/crashlogs/crashlog-YYYY-MM-DD.txt
              →  user shares the log (Help → Reveal Crash Logs in Finder)
              →  Claude reads, identifies root cause, fixes, pushes
              →  user pulls, clears logs (Help → Clear Crash Logs)
```

The log format includes `EXCEPTION`, `SIGNAL`, `DATA`, and `RECOVERY`
entry kinds. Recovery breadcrumbs appear when the previous session
didn't go through `applicationWillTerminate` — i.e. it crashed.

## Tests

```
scripts/ci-build-test.sh         # Release build + Debug test suite
```

~335 tests across 16 files (269 XCTest + 66 swift-testing as of
2026-05-24). Keep them green. When you change a model's encoder or a
content pack's schema, the matching test in `desktopAhaanTests/` is
the canary.

## Conventional commits

Use one of these prefixes:
- `feat:` new feature
- `fix:` bug fix
- `fix(content):` content data fix
- `polish:` low-risk hygiene / one-row taxonomy flip
- `docs:` documentation only
- `chore(scripts):` build / dev-tool changes
- `refactor:` no behavioural change

End every commit body with the trailer:
```
Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>
```

## Memory files

A separate `memory/` directory carries durable context across sessions:
target hardware, pbxproj pull recipes, iMac paths, and feedback rules.
Read them at session start; update them when something changes.
