# desktopAhaan

A macOS SwiftUI study app for a Class 7 student.

## What it does

- **Sanskrit translator** — bundled 246-word Sanskrit ↔ English ↔ Hindi
  dictionary, on-device speech, OCR for handwritten input.
- **Science tutor** — 19 chapters of NCERT Class 7 content with:
  - Concepts with four explanation depths (one-line → expert).
  - Topic-scoped MCQ + short-answer quizzes (635+ questions).
  - **Discover Mode** — 8+ interactive scenes per chapter (animated
    diagrams, sliders, sandboxes, a boss-quiz).
  - HTML-rendered concept articles with Read-Aloud.
- **Global search** across every subject pack with AND-of-tokens
  matching and title-prefix > contains > body ranking.

Offline-first. No accounts. No telemetry. One outbound network call
(an optional online translator) which the user can disable.

## Platform

Builds and runs on:
- macOS 11 (Big Sur) through current.
- Universal binary — Apple Silicon and Intel.

Daily-driver targets a Late-2014 iMac with Big Sur 11.7.11 and an
AMD R9 M290X GPU. Animation budgets honour a `HardwareTier.isLegacy`
flag so the legacy GPU isn't asked to push 60-fps particles.

Toolchain on the dev Mac is whatever Xcode you have; the iMac uses
Xcode 13.2.1 / Swift 5.5. Code is written to compile under both.

## Building

```
git clone https://github.com/ahaandahiya27/MacOSDesktopProtoApp.git
cd MacOSDesktopProtoApp
open desktopAhaan.xcodeproj
```

In Xcode: Product → Run.

From the command line:

```
bash scripts/ci-build-test.sh
```

Runs a Release build pinned to `MACOSX_DEPLOYMENT_TARGET=11.0`, then
the Debug test suite. Exits non-zero on either failure.

## Repo tour

```
desktopAhaan/
    desktopAhaanApp.swift           # @main + Commands menu wiring
    ContentView.swift               # sidebar + detail-pane layout
    App/
        CrashReporter.swift         # NSException + 6 POSIX signals
                                    # → daily log file in App Support
        AppState.swift              # sidebar selection + persistence
    Models/                         # TranslationRecord, etc.
    Resources/                      # bundled JSON + Articles/Chapter*/*.html
    Services/
        Persistence/DataStore.swift # atomic .json writes
        Translation/                # local + online providers
    Subjects/
        ContentSchema/              # SubjectPack / Chapter / Topic
        Loader/SubjectRegistry.swift # off-thread JSON decode + orphan ref guard
        Tutor/                      # ConceptDetail, QuizBank, search, etc.
        Tutor/Discover/             # interactive scenes per chapter
        Articles/                   # WKWebView article renderer
        Packs/*.json                # science + sanskrit content packs
    Extensions/                     # SFSymbolCompat, Color.compat*, AppStorageKeys
    ViewModels/                     # TranslatorViewModel, PracticeViewModel
    Views/                          # Home, Settings, History, Favorites

desktopAhaanTests/                  # ~335 tests across 16 files (269 XCTest + 66 swift-testing)

docs/
    ISSUE_CATEGORIES.md             # the audit taxonomy — what's done, what's not
    SECURITY.md                     # threat model + entitlements rationale

scripts/
    ci-build-test.sh                # xcodebuild build + test
    check_viewbuilder_limit.py      # static check for SwiftUI ≤10 children
    imac-pull.sh                    # bulletproof git pull on the iMac
    generate_compat_pbxproj.py      # MACOSX_DEPLOYMENT_TARGET=11 enforcement
```

## Sandbox + entitlements

Four entitlements, each justified in `docs/SECURITY.md`:

| Key | Why it's needed |
|-----|-----------------|
| `com.apple.security.app-sandbox` | mandatory |
| `com.apple.security.network.client` | optional online translator |
| `com.apple.security.files.user-selected.read-only` | OCR "Open Image…" |
| `com.apple.security.device.audio-input` | dictation in translator + practice |

Writes are confined to `~/Library/Application Support/desktopAhaan/`.

## Crash workflow

```
Help → Reveal Crash Logs in Finder
    ↓
    Daily log at ~/Library/Application Support/desktopAhaan/crashlogs/
        crashlog-YYYY-MM-DD.txt
    ↓
    Captures EXCEPTION / SIGNAL / DATA / RECOVERY entries
    Rotated at 1 MB and capped at 30 files.
```

## Contributing

See `CLAUDE.md` for the working-agreement summary (platform rules,
naming conventions, commit conventions, where to look for what).

For a comprehensive audit checklist, see `docs/ISSUE_CATEGORIES.md`.

## License

Personal project — not for redistribution.
