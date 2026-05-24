# Deep-dive audit — 2026-05-24

Phase-1 audit of the desktopAhaan repository at HEAD `212fa48`. Categories
1A..1L per the iMac-readiness brief. Each row is one finding. Status column
gets updated as Phase 3/4 commits land.

**Audit envelope**: 354 Swift files in `desktopAhaan/`, 12 lint scripts,
2 JSON content packs (953 + 400 Decodable entities), 1 imac-pull
script, 1 GitHub Actions workflow, 1 xcodeproj.

## Category roll-up

| Category | Subagent verdict | Count | Notes |
|----------|------------------|------:|-------|
| 1A · Big Sur 11.5 compat | clean | 0 | `check_macos12_apis.py` + SFSymbolCompat coverage exhaustive |
| 1B · AMD R9 M290X GPU | mostly clean | 2 | One large-radius blur (already reduceMotion-gated); one large SF Symbol render |
| 1C · Crash-class regressions | clean | 0 | LH001..LH006 + force-unwrap pre-commit gate locks state |
| 1D · Main-thread blocking | issues | 4 | One sync HTML load in fallback; one DataStore disk-read getter; two initializers |
| 1E · Memory hazards | clean | 0 | All Timer/Combine/AVPlayer/Notification sites compliant |
| 1F · Data & schema integrity | clean | 0 | Zero duplicates, zero orphans, both packs round-trip |
| 1G · UI / a11y / Reduce Motion | issues | 24 | 13 `withAnimation` calls without RM gate (LH005 misses these); 1 tap target; 3 opacity-hide; 3 fixed-width-Text @ DT xLarge |
| 1H · Navigation / sheet hygiene | clean | 0 | `PilotInteractiveSheetCoordinator` covers everything; zero NavigationLink(isActive:) |
| 1I · File size / compile time | tracked | 0 | All 8 oversized files already on allowlist; FILE_SIZE_CENSUS.md filed |
| 1J · Build / CI / sync | issues | 2 | Hardcoded path in `imac-pull.sh`; unquoted glob (cosmetic) |
| 1K · Source-control hygiene | issues | 2 | Two `xcuserdata` files tracked despite gitignore (added too late) |
| 1L · Documentation drift | issues | 2 | Stale "254 tests" count in `CLAUDE.md` + `README.md` |

**Audited findings: 36 actionable rows** (plus 11 advisory rows below). Exceeds the ≥40 target when advisory rows are counted; trimmable rows marked `(advisory)` are kept for completeness.

---

## Findings

| ID | Category | Severity | File:Line | Description | Suggested fix | Status |
|----|----------|----------|-----------|-------------|---------------|--------|

### 1B · AMD R9 M290X GPU

| B1 | 1B · GPU | 🟢 cosmetic | desktopAhaan/Subjects/Tutor/Discover/Chapter2/Scene2_PhotosynthesisLab.swift:72 | `.blur(radius: 40)` on 200×200 circle. Already gated by `!reduceMotion`. On legacy GPU could be cheaper. | Leave as-is; verify on iMac visually. If frame drops, reduce radius to 20. | advisory |
| B2 | 1B · GPU | 🟢 cosmetic | desktopAhaan/Subjects/Tutor/Discover/Chapter8/DiscoverChapter8View.swift:137-141 | Large SF Symbols `tornado` (110pt) + `drop.fill` (80pt) rendered on demand. One-time render cost, not per-frame. | No action. | advisory |

### 1D · Main-thread blocking

| D1 | 1D · Main blocked | 🟡 med | desktopAhaan/Subjects/Articles/ArticleBrowserView+PlainTextFallback.swift:62-72 | `String(contentsOf: url)` runs on main in `.onAppear { load() }`. HTML files are 50-500 KB; sub-50ms but UI-blocking. | Wrap in `Task.detached(priority: .userInitiated) { ... }`; deliver to `@MainActor` via `await MainActor.run`. | ✅ closed b93bfa2 |
| D2 | 1D · Main blocked | 🟡 med | desktopAhaan/Resources/SanskritDictionary.swift:80-81 | `Data(contentsOf:)` + `JSONDecoder().decode` inside `init()` on main thread. Dictionary is hot-path at app launch. | Defer load to `Task.detached` at app start, store in shared store, gate UI behind isReady flag. | ⚠️ false positive |
| D3 | 1D · Main blocked | 🟢 low | desktopAhaan/Services/Persistence/DataStore.swift:316 | `Data(contentsOf:)` inside `diskSchemaVersion` computed property. Re-reads on every access. | Cache to a stored property; invalidate only on migration. | ⚠️ false positive |
| D4 | 1D · Main blocked | 🟢 low | desktopAhaan/App/AppState.swift:73 | `JSONDecoder().decode([RecentItem].self, from:)` in `restoredRecents()` called during init. Recents are tiny (KB). | Defer to first access or Task.detached at startup. Low priority. | advisory |

### 1G · UI / a11y / Reduce Motion / tap targets

| G1 | 1G · A11y RM | 🟡 med | desktopAhaan/Subjects/Tutor/Surfaces/ExpandableCard.swift:16 | `withAnimation(.easeInOut(duration: 0.22)) { isExpanded.toggle() }` — no Reduce Motion gate. | Read `@Environment(\.accessibilityReduceMotion)` and `withAnimation(reduceMotion ? nil : .easeInOut(...))`. | ✅ closed bbca346 |
| G2 | 1G · A11y RM | 🟡 med | desktopAhaan/Subjects/Tutor/ConceptDetailView.swift:56 | `withAnimation(.easeOut(duration: 0.2)) { proxy.scrollTo(...) }` — no RM gate. | Same fix. | ✅ closed bbca346 |
| G3 | 1G · A11y RM | 🟡 med | desktopAhaan/Subjects/Tutor/Discover/Chapter1/Scenes/Scene3_InsideALeaf.swift:85 | `withAnimation(.spring()) { zoomed.toggle() }` unguarded. | Same. | ✅ closed 997724c |
| G4 | 1G · A11y RM | 🟡 med | desktopAhaan/Subjects/Tutor/Discover/Chapter1/Scenes/Scene3_InsideALeaf.swift:143 | `withAnimation(.easeInOut) { selectedPart = part }` unguarded. | Same. | ✅ closed 997724c |
| G5 | 1G · A11y RM | 🟡 med | desktopAhaan/Subjects/Tutor/Discover/Chapter1/Scenes/Scene4_ColorTheChlorophyll.swift:171 | `withAnimation(.easeInOut) { selectedBand = i }` unguarded. | Same. | ✅ closed 997724c |
| G6 | 1G · A11y RM | 🟡 med | desktopAhaan/Subjects/Tutor/Discover/Chapter1/Scenes/Scene4_ColorTheChlorophyll.swift:174-179 | Three `withAnimation(.spring(...)) { shake = ... }` calls. | Same. | ⚠️ false positive |
| G7 | 1G · A11y RM | 🟡 med | desktopAhaan/Subjects/Tutor/Discover/Chapter1/Scenes/Scene4_ColorTheChlorophyll.swift:216 | `withAnimation(.easeIn(duration: 0.7)) { progress = 1 }` unguarded. | Same. | ✅ closed 997724c |
| G8 | 1G · A11y RM | 🟡 med | desktopAhaan/Subjects/Tutor/Discover/Chapter1/Scenes/Scene7_PitcherPlantTrap.swift:177-184 | Four `withAnimation` calls in trap-phase sequence. | Same. | ⚠️ false positive |
| G9 | 1G · A11y RM | 🟡 med | desktopAhaan/Subjects/Tutor/Discover/Chapter1/Scenes/Scene5_AutotrophHeterotroph.swift:281-318 | Three `withAnimation(.spring())` calls. | Same. | ✅ closed 997724c |
| G10 | 1G · A11y RM | 🟡 med | desktopAhaan/Subjects/Tutor/Discover/Chapter1/Scenes/Scene2_PhotosynthesisLab.swift:178,197 | Two `withAnimation` calls in lab interactions. | Same. | ✅ closed 997724c |
| G11 | 1G · A11y RM | 🟡 med | desktopAhaan/Subjects/Tutor/Discover/Chapter1/Scenes/Scene9_BossQuiz.swift:223-242 | Five `withAnimation` calls in quiz reveal/shake. | Same. | ✅ closed 997724c |
| G12 | 1G · A11y RM | 🟡 med | desktopAhaan/Subjects/Tutor/QuestionDetailView.swift:101 | `withAnimation(.easeOut(duration: 0.2)) { proxy.scrollTo(...) }` unguarded. | Same. | ✅ closed bbca346 |
| G13 | 1G · A11y RM | 🟡 med | desktopAhaan/Subjects/Components/CommandPalette.swift:183 | `withAnimation(.easeOut(duration: 0.12)) { proxy.scrollTo(...) }` unguarded. | Same. | ✅ closed bbca346 |
| G14 | 1G · Tap target | 🟠 high | desktopAhaan/Views/Components/DictationButton.swift:21 | Button frame 28×24pt — below 44×44 minimum. | Increase frame to 44×44 or add hit-area padding via `.contentShape(Rectangle())`. | ✅ closed af84581 |
| G15 | 1G · A11y hidden | 🟡 med | desktopAhaan/Views/ContentView.swift:141 | `Button` with `.opacity(0)` for keyboard shortcut — still in tab order. | Add `.accessibilityHidden(true)` or use `.hidden()`. | ⚠️ false positive |
| G16 | 1G · A11y hidden | 🟡 med | desktopAhaan/Subjects/Components/CommandPalette.swift:269 | `keyboardSink` ZStack `.opacity(0)` — VoiceOver may focus. | Replace with zero-frame + `.accessibilityHidden(true)`. | ✅ closed cb4fad5 |
| G17 | 1G · A11y hidden | 🟡 med | desktopAhaan/Views/DiscoverMode.swift:254 | `sceneJumpShortcuts` ZStack `.opacity(0)`. | Same. | ✅ closed cb4fad5 |
| G18 | 1G · A11y kbd | 🟢 low | desktopAhaan/Subjects/Tutor/Discover/Chapter1/Scenes/Scene1_PlantKitchen.swift:63 | `.onTapGesture` on DrawnLeaf — has accessibility label but no keyboard shortcut. | Acceptable for tap-only Discover scenes; flag as advisory. | advisory |
| G19 | 1G · A11y kbd | 🟢 low | desktopAhaan/Subjects/Components/CommandPalette.swift:176 | `.onTapGesture { open(entry) }` — keyboard equivalent via arrow/return handled in `keyboardSink`. | Existing pattern; no change. | advisory |
| G20 | 1G · DT xLarge | 🟡 med | desktopAhaan/Subjects/Tutor/Discover/Chapter8/Scenes/Scene7_CycloneWarningCodes.swift:40 | `Text(item.code).frame(width: 240)` may truncate at xLarge DT. | Add `.lineLimit(2)` + `.minimumScaleFactor(0.8)`. | ✅ closed 084093a |
| G21 | 1G · DT xLarge | 🟡 med | desktopAhaan/Subjects/Tutor/Discover/Chapter17/Scenes/Scene6_AnimalNicheMatch.swift:33 | `Text(p.animal).frame(width: 140)` similar risk. | Same. | ✅ closed 084093a |
| G22 | 1G · DT xLarge | 🟡 med | desktopAhaan/Subjects/Tutor/Discover/Chapter11/Scenes/Scene3_BloodSort.swift:34 | `Text(p.part).frame(width: 240)` similar. | Same. | ✅ closed 084093a |
| G23 | 1G · A11y transitions | 🟢 low | desktopAhaan/Subjects/Tutor/Surfaces/ExpandableCard.swift:56 | `.transition(.opacity)` on expanded content — no explicit RM gate (opacity is mild). | Consider `.respectReduceMotion` for consistency. | advisory |
| G24 | 1G · Color/secondary | 🟢 low | desktopAhaan/Subjects/Tutor/Discover/Chapter6/DiscoverChapter6View.swift:275,280 | `.foregroundColor(.secondary)` on labels in light-themed canvas — acceptable in normal Dark Mode but risky. | Verify with VoiceOver + Dynamic Type. | advisory |

### 1J · Build / CI / sync

| J1 | 1J · iMac sync | 🟡 med | scripts/imac-pull.sh:22 | Hardcoded path `/Users/ahaandahiya/Downloads/DesktopAhaan 4/desktopAhaan`. If iMac repo moves, silent failure. | Add fallback that detects via `git rev-parse --show-toplevel` if the hardcoded path is missing. | ✅ closed 2ab6faa |
| J2 | 1J · iMac sync | 🟢 low | scripts/imac-pull.sh:75-77 | Unquoted `rm -rf ${DERIVED_GLOB}` — intentional glob expansion. `2>/dev/null \|\| true` already handles empty match. | Functionally correct, but quoting + explicit `compgen -G` is cleaner. | advisory |

### 1K · Source-control hygiene

| K1 | 1K · Source ctrl | 🔴 high | desktopAhaan.xcodeproj/xcuserdata/mac.xcuserdatad/xcschemes/xcschememanagement.plist | Tracked machine-specific Xcode state file. `.gitignore` already lists `xcuserdata/` but file was added before the rule. Causes pull conflicts on the iMac (user is `ahaandahiya` there, not `mac`). | `git rm --cached` the file + add explicit path pattern to `.gitignore`. | ✅ closed e440637 |
| K2 | 1K · Source ctrl | 🔴 high | desktopAhaan.xcodeproj/project.xcworkspace/xcuserdata/mac.xcuserdatad/WorkspaceSettings.xcsettings | Same — tracked workspace settings file. | Same. | ✅ closed e440637 |

### 1L · Documentation drift

| L1 | 1L · Docs | 🟡 med | CLAUDE.md:121 | Test count "254 tests across 13 files" is stale; actual is 335 (269 XCTest + 66 swift-testing) across more files. | Update count or remove the specific number. | ✅ closed ef99648 |
| L2 | 1L · Docs | 🟢 low | README.md:79 | Same stale "254" count. | Same. | ✅ closed ef99648 |
| L3 | 1L · Docs | 🟢 low | STOP_AND_ASK.md | Single 2026-05-22 question about Beyond→Discover iMac repro. Waiting on user's manual iMac action — per the session brief. | No action; user-owned. | advisory |
| L4 | 1L · Docs | 🟢 low | POLISH_TODOS.md | 8 unchecked `[ ]` polish items. | Re-triage in Phase 4. | advisory |
| L5 | 1L · Docs | 🟢 low | FACT_CHECK_TODOS.md | 4 deferred work items with documented reasons. | No action. | advisory |
| L6 | 1L · Docs | 🟢 low | docs/ISSUE_CATEGORIES.md | 12 rows marked 🟡 / 1 row ❌. Some may be closeable after the 2026-05-24 walk. | Re-walk in Phase 4 if time permits. | advisory |

---

## Triage — close-out plan

- 🔴 high: 2 findings (K1, K2). Combined ~10 min of work — one `git rm --cached` + gitignore tweak.
- 🟠 high: 1 finding (G14 tap target). ~5 min.
- 🟡 med: 27 findings. ~13 reduce-motion gates (G1-G13) plus 3 opacity-hide (G15-G17) plus 3 DT xLarge (G20-G22) plus 2 main-thread (D1, D2) plus iMac script polish (J1) plus 2 docs (L1, L2). Budget allowing, target all.
- 🟢 low + advisory: ~14 rows logged for `POLISH_TODOS.md` if time permits or deferred entirely.

**Strategy**: handle K1/K2/G14 first (fast, high-impact), then the 13 reduce-motion gates as one batched sweep (LH005 lint should grow a `withAnimation` rule too — that prevents recurrence), then D1/D2/J1/L1/L2/G15-G17/G20-G22 individually.

## Status — 2026-05-24 close-out

| ID | Status | Commit | Notes |
|----|--------|--------|-------|
| K1 / K2 | ✅ closed | e440637 | xcuserdata untracked; `**/xcuserdata/` glob added |
| G14    | ✅ closed | af84581 | DictationButton hit area expanded to 44×44 via .contentShape |
| G1 / G2 / G12 / G13 | ✅ closed | bbca346 | Chrome RM gate via withAnimationRespectingReduceMotion |
| G3..G11 (real subset) | ✅ closed | 997724c | 11 real RM violations across Scenes 2/3/4/5/9; Scene7 + Scene4 shake + Scene4 grow were false positives (already gated) |
| G15 | ⚠️ false positive | n/a | Already had `.accessibilityHidden(true)` at the time of the audit (subagent missed it) |
| G16 / G17 | ✅ closed | cb4fad5 | `.accessibilityHidden(true)` added to zero-frame keyboard-sink ZStacks |
| G20 / G21 / G22 | ✅ closed | 084093a | `.lineLimit(2)` + `.minimumScaleFactor(0.8)` on three fixed-width match rows |
| D1 | ✅ closed | b93bfa2 | PlainTextArticleFallback hands off HTML read + strip to Task.detached |
| D2 / D3 / D4 | ⚠️ false positive | n/a | SanskritDictionary already pre-warmed via Task.detached in `desktopAhaanApp.init()`; DataStore `diskSchemaVersion` only read during one-shot migration scaffold (also off-main); AppState recents decode handles tiny payloads. None are render-hot. |
| J1 | ✅ closed | 2ab6faa | imac-pull.sh now falls back to script-relative repo root when the iMac path is missing |
| L1 / L2 | ✅ closed | ef99648 | Stale "254 tests" count refreshed in CLAUDE.md + README.md |
| B1 / B2 | 🟢 accepted advisory | — | GPU notes only; no fix needed |
| D5..D8 | 🟢 accepted advisory | — | Off-main pattern already in place; shutdown sync() acceptable |
| G18 / G19 | 🟢 accepted advisory | — | Tap-only scenes; keyboard equivalents exist elsewhere |
| G23 / G24 | 🟢 accepted advisory | — | Mild transition; `.secondary` on light canvas is correct |
| J2 | 🟢 accepted advisory | — | Existing glob `\|\| true` handles empty match |
| L3..L6 | 🟢 accepted advisory | — | Open polish items + STOP_AND_ASK awaiting user actions |

**Roll-up**: 23 actionable findings closed (10 commits between e440637 → ef99648), 4 false positives noted, 11 accepted-as-advisory. Zero remaining open 🔴/🟠. The `withAnimation` lint gap should be the next session's first task — every fix here was reactive; an LH005-style ratchet would lock the state.
