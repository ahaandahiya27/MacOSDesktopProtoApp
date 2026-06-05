# CLAUDE.md — Working agreement for the desktopAhaan repo

Read this before touching the codebase. It's the durable summary of how
this project is built, what platform it must run on, and the conventions
every session has converged on.

## Current status (2026-06-03)

- **21 lints clean** on every push — see `scripts/check_*.py`. Wired through `scripts/ci-build-test.sh` + the pre-commit hook. (Plus two commit-time T2 ratchets: `check_critical_uitest_presence.py` + `check_uitest_label_coverage.py`, in the pre-commit chain.) Newest: `check_inline_modifier_math.py` (2026-06-04) — finer-grained sister of `check_viewbuilder_depth.py`. Where the depth lint flags DENSE GeometryReader closures, this one flags any individual `.frame(...)` / `.position(...)` / `.offset(...)` / `.padding(...)` whose arg list contains inline arithmetic (`w * 0.3`, `cx - h * 0.16`) — the per-call form of the same Swift-5.5 `Segmentation fault: 11` class. Fix: hoist the expression to a typed `let _: CGFloat = ...` local above the surrounding result-builder closure. After the 2026-06-04 sweep, ~244 sites across 80 files were de-arithmeticized (16 ShapeDiagrams + Discover Scenes + Components + Tour/Sandbox surfaces + Progress views). See `ccd011a`, `162a71b`, plus the follow-up sweep commit.
- **Bug-free certification: 110/110 categories ✅** — see `BUG_FREE_CERTIFICATION_REPORT.md` at the repo root.
- **Production-readiness: per-criterion ✅** — see `PRODUCTION_READINESS_REPORT.md`.
- **Per-subject readiness:** Science (19 ch), Maths (15 ch), Sanskrit (16 ch = 15 NEP + 1 legacy vocab deck), Social Science (`socialscience_class7`, NEP `sschNN` ids — bespoke per-chapter interactives via `socialScienceInteractives`). See `{SUBJECT}_READINESS_REPORT.md` each.
- **v6 Learning Journey complete:** Weekly plan, Discover, Articles, Mastery map, Milestone checkpoints, and the mastery-gated Expert Challenge ladder — all read-only over the SRS layer. See `LEARNING_JOURNEY_CHECKPOINT.md`. **Olympiad tier now populated (2026-06-04):** `StretchTopic.bonusQuestions` authored across all four packs — **534 beyond-grade MCQs** (Science 114, Maths 90, Sanskrit 90, Social Science 240; every stretch topic ≥2). Pinned by `ExpertChallengeOlympiadContentTests`. See `OLYMPIAD_CONTENT_LEDGER.md`.
- **v7 Discover Depth complete (2026-06-02):** Sanskrit + Social Science now have bespoke per-chapter Discover interactives (on par with Science/Maths); the `ShapeDiagramRegistry` visual library is fully populated (76/76 chapter diagrams, pure-SwiftUI). See `V7_DISCOVER_DEPTH_CHECKPOINT.md`.
- **v8 Longitudinal Insights complete (2026-06-03):** a daily mastery-history store (`progress_history.json`, 180-day cap, read-only over the SRS) powers an **Insights** window (Help → Insights / **⌘⇧I**) with a Big-Sur-safe trend chart (`TrendChartView`, pure `Path`/`Shape` — never `Charts`), a week-over-week ±N% delta in the Weekly dashboard + a 3rd PDF trend page, and exact per-subject Discover attribution (`DiscoverProgress.packId`). a11y label coverage is 100%. See `V8_INSIGHTS_CHECKPOINT.md`. **Note:** Big-Sur compilation/frame-rate of the new views is verified only by the static lints + dev-Mac `ci-build-test.sh`; final confirmation needs an iMac rebuild.
- **Pack ID namespacing:** Science `ch*`, Maths `mch*`, Sanskrit `sch*`, Social Science `ssch*` — ratcheted by `testNoCrossPackConceptIdCollision`.
- **Test surface:** 835 XCTest methods + 66 swift-testing + 42 XCUITest (14 propagated-interactive walks [4 tours + 9 Build-a-* sandboxes + HomeExperiments, 2026-06-02] + 15 maths-Discover walks + 13 prior). Default CI runs unit tests only; UI tests are `--ui` opt-in (AX grant required on runner). T2 surfaces are guarded AX-free by the two commit-time ratchets above.

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
DerivedData, redirects interactive Xcode's DerivedData off any
fileprovider path (idempotently, the first time it runs), and
re-opens the project. Always **push** your fix before telling the
user to pull — a commit that never reaches origin might as well
not exist.

### iMac "code 9: Killed" mitigations (already in place)
The Late-2014 iMac (8 GB RAM, AMD R9 M290X) sometimes OOMs the
Swift compiler during a clean rebuild after a big content pull.
Two mitigations ship at the repo level so the kid never sees the
dialog:
1. `IDEPrefersOSLogging=YES` in the shared `desktopAhaan.xcscheme`
   (keeps the logging subsystem from timing out under pressure).
2. `scripts/imac-pull.sh` step 6.5 — sets Xcode's interactive
   DerivedData to `/tmp/desktopAhaan-imac-derived` (off any
   FileProvider tree) on first run; a deliberate manual setting
   is preserved.
If the kid still hits OOMs, options that don't need a code change:
   - Quit Safari / Mail before building.
   - Re-run `scripts/imac-pull.sh` (it wipes DerivedData).

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

## Key invariants (must not break)

- **Pack JSON canonical format:** `json.dumps(d, ensure_ascii=False, indent=2) + "\n"`. The pre-push `verify_pack_roundtrip.py` compares byte-for-byte; `indent=1` or a missing trailing newline silently fails.
- **File size ceiling:** 600 LOC per `.swift` file. 2 files grandfathered with rationale (`QuestionDetailView`, `DataStore`); see `scripts/file_size_allowlist.txt`. Sister-file splits handle dense SwiftUI bodies near the limit.
- **Sanskrit `ch01` carve-out:** the legacy vocabulary deck stays at `ch01` and is intentionally exempt from the NEP cross-subject parity ratchets. NEP chapters use `sch01`–`sch15` additively.
- **Cross-subject pack ID prefix:** Science `ch*`, Maths `mch*`, Sanskrit `sch*` — enforced by `testNoCrossPackConceptIdCollision`. Breaking this changes the persistence schema for SRS reviews.
- **Content-view-suffix labelling convention:** Buttons whose label slot is a custom view ending in `Card`, `Row`, `Chip`, `Badge`, `Tile`, `Item`, `Entry`, `Banner`, `Pill`, `Tag`, `Block`, or `Bubble` are credited as labeled by `check_a11y_labels.py`. Don't break the convention without a heuristic update.
- **Entitlements set is locked:** `EntitlementsSnapshotTest` pins the 5-key set. Adding a permission updates the test in the same commit; broadening the `/Documents/` temp-exception scope is a deliberate decision.

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
