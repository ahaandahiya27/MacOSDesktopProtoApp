# iMac Visual-Verification Checklist

This file is the bridge between dev-Mac logic-closure and Big-Sur-iMac
perception-closure. Every taxonomy ID below is a `docs/ISSUE_CATEGORIES.md`
🟡 or ❌ row whose final state can only be set by running the deploy
machine: **Late-2014 5K iMac, Big Sur 11.7.11, AMD R9 M290X 2 GB,
Xcode 13.2.1, Swift 5.5**.

**Split into two sections, because they're different kinds of work:**

- **(i) Visual pass/fail** — passive checks. Look at the screen, decide
  if it's right. A failure here surfaces a tweak, not a re-architecture.
- **(ii) Action / run** — running Instruments or AX-granted UI tests
  produces *data* (a profile, a leak report, a UI-test pass/fail). A
  failure or unexpected finding here **may surface new fixes** that
  weren't on the dev-Mac radar. These are explicitly not "just look at
  it" rows.

Coverage: this file accounts for **31 of the 102 open ledger rows** —
the 22 (i) and 9 (ii) IDs enumerated below. The remaining 71 rows are
deliberate non-bugs and are listed in `REMAINING_WORK.md` (bucket C).

---

## How to run

```
# On the iMac:
bash scripts/imac-pull.sh    # auto-stash, wipe DerivedData, re-open Xcode
# Xcode: ⇧⌘K  ⌘B  ⌘R    (zero warnings expected)
```

For UI-test rows (section ii), grant Accessibility:
**System Settings → Privacy & Security → Accessibility →
`desktopAhaanUITests-Runner.app` ON**. Then:

```
export CI_BUILD_TEST_FLAGS=--ui
bash scripts/ci-build-test.sh
```

After each row: paste back `"row N (ID) ✅"` / `"row N (ID) ❌ because Y"`
/ `"row N (ID) defer because Y"`. Dev-Mac side closes in batch.

---

## Section (i) — Pure visual pass/fail (22 IDs)

These rows fail or pass at the screen. No data captured; no follow-up
fix expected unless an outright defect is visible. If anything looks
clearly wrong, the dev Mac opens a `fix(ui):` commit with a repro test.

### Display / layout

| # | IDs | What to do | What "correct" looks like |
|---|-----|------------|---------------------------|
| 1 | **J4 + LY6** | Drag the main window to its minimum (OS caps at 1024×640). Walk every sidebar entry: Welcome / each subject pack / Daily Practice / Bookmarks / Settings / Search / Olympiad Tests / Boss Challenge / Brutal Series. | No content overflows; no horizontal scroll on any panel; chrome stays readable; reading panels respect `contentMaxWidth = 1100pt`. |
| 2 | **TY1** | Maximize on 5K. Open Discover Mode for any chapter. | Header `.title2.bold` (~22pt) anchors the canvas — not lost in whitespace. |
| 3 | **LY2** | Maximize on 5K. Open any reading article (Help → desktopAhaan Help, or a chapter's Beyond / Mistakes). | Reading column letterboxes to ~1100pt with comfortable margins; lines ≤ 80 chars; not cramped, not stretched. |
| 4 | **LY5** | Look at the sidebar/canvas boundary on any screen. | macOS NavigationView 1pt separator (NSSplitView divider) is visible. |

### Dynamic Type

| # | IDs | What to do | What "correct" looks like |
|---|-----|------------|---------------------------|
| 5 | **H4 + TY4** | System Settings → Displays → Larger Text → bump to **Larger** then **Largest**. Re-open the app. Walk a chapter's concept cards, question detail, Mock Test runner, Mastery Map, Daily Plan. | No card title gets truncated mid-word; no body text gets clipped to a single line; fixed-width `Text` blocks use `.minimumScaleFactor(0.8)`. |

### Dark Mode + theming

| # | IDs | What to do | What "correct" looks like |
|---|-----|------------|---------------------------|
| 6 | **J1 + TH1** | System Settings → Appearance → Dark. Walk: home / sidebar / chapter list / Discover canvas / article browser / OCR translator / Settings. | Chrome adapts to Dark (NSColor semantic). Discover canvas stays fixed-light (intentional CN1/CL1). Body text stays `BrandColor.canvasText` and legible against the gradient. |
| 7 | **CL3 + TH2** | Same Dark Mode walk; look at the sidebar/canvas boundary. | macOS NavigationView convention: vibrant sidebar + lighter content area (Mail/Notes/Reminders pattern). Should not feel like a bug. |
| 8 | **TH5** | If Dark Mode is in scope: open a chapter article for Ch.1–7 + Ch.19 (CSS-variable-driven) then for Ch.8–18 (legacy hex). | Ch.1–7 + 19 adapt; Ch.8–18 stay light. If Dark Mode is never used → defer. |
| 9 | **SB6** | In the sidebar, click each top-level row (subjects, tools). | macOS system-blue selection fill appears on the selected row, consistent across Subject / QuizBank / Tool rows. Recent rows don't show the blue fill (by design — they're transient). |

### Accessibility

| # | IDs | What to do | What "correct" looks like |
|---|-----|------------|---------------------------|
| 10 | **H6** | Stay in Dark Mode. Walk the same surfaces. | Every text-on-background combination clears WCAG AA 4.5:1 contrast (rough check: text should never feel ghosted). |
| 11 | **TH7 + AC5** | System Settings → Accessibility → Display → Increase Contrast ON. Re-open the app. | Buttons get heavier borders; text contrast bumps. Bold-text-friendly text styles auto-apply. |
| 12 | **TH8** | System Settings → Accessibility → Display → Reduce Transparency ON. Re-open the app. | Sidebar's vibrancy falls back to solid window background. No transparency-layered glitches. |
| 13 | **CN5 + AC1** | Stay on default Appearance. Tab through chrome (Search box, sidebar, chapter detail). | System-blue focus ring is visible on the pale-blue/green Discover gradient. Every focused control shows the ring clearly. |

### Discover & sidebar feel

| # | IDs | What to do | What "correct" looks like |
|---|-----|------------|---------------------------|
| 14 | **EM3** | If safe: trash `~/Library/Application Support/desktopAhaan/` then open the app. | The 4-page `FirstLaunchTourView` sheet presents once. Skip + Get Started both work. Lands on a sensible default pack. |
| 15 | **DM8** | Open Science Ch.1 → Boss Quiz scene. | Title (`.largeTitle.bold`) anchors as an event; `ProgressView`, per-question MCQ rows, completion screen all feel "event-like" not "just-another-card". Screenshot-level judgment. |
| 16 | **IF6** | From any subject pack, switch to another (e.g. Maths → Sanskrit) via the sidebar rows. | Sidebar's Subjects section is the standard switching surface (no separate "Switch Subject" button needed). Switch feels obvious. |

---

## Section (ii) — Action / run rows (9 IDs)

These rows **run** something on the iMac. The output is data: a UITest
pass/fail, an Instruments profile, a sleep/wake recovery log. A
finding here may surface new fixes. **Don't treat these as "just look
at it" rows — they can generate code work.**

### UI tests (need AX grant on the runner)

| # | ID | What to do | What "correct" looks like | If it fails |
|---|----|------------|---------------------------|-------------|
| 17 | **T3** | After AX grant, run `--ui` suite. Watch for `NavigationSmokeUITests/test_homeToQuestionDetail_endToEnd`. | Passes end-to-end (home → chapter → topic → concept → question). pbxproj wiring confirmed on dev Mac; this is the final gate. | Paste the assertion log. Likely fix: missing `.accessibilityIdentifier` on a step in the chain. Dev-Mac opens `fix(test):`. |
| 18 | **T2** | After AX grant, run `--ui`. SocialScience bespoke interactives currently have no smoke walk. | If you want this row ✅ requires adding stable container IDs to each `socialScienceInteractives` scene + per-scene walks. Otherwise leave 🟡 — "gravy" per the taxonomy. | n/a — opt-in extension work, not a regression. |
| 19 | **H7 + H8** | Keyboard-only walk: Tab through sidebar → chapter detail → question. Use ⌘[ / ⌘] / arrows per menu shortcuts. | Every interactive surface reachable and activatable via keyboard. Focus traversal moves in expected reading order. | List any blocked widgets. Dev-Mac adds `.focusable()` / explicit `.focused` to the gap site. |

### Sleep / wake

| # | ID | What to do | What "correct" looks like | If it fails |
|---|----|------------|---------------------------|-------------|
| 20 | **LC8** | Open the app. Apple menu → Sleep (or close lid). Wake 10+ minutes later. | App resumes in <2s. No frozen UI. No crashlog written. Timers + audio recovered cleanly. | Paste the crashlog from `~/Library/Application Support/desktopAhaan/crashlogs/`. Dev-Mac opens `fix(crash):` with the diagnosed cause. |

### Instruments runs (real-iMac only — dev Mac can't profile the AMD R9 M290X)

| # | ID | What to do | What "correct" looks like | If it fails |
|---|----|------------|---------------------------|-------------|
| 21 | **DG3** | Xcode → Product → Profile → Time Profiler. Drive 30s: open 2 chapters, take a quiz, view Mastery Map. | Top samples are SwiftUI compositing + dispatch source ticks (expected). No hot Swift function >10% of main-thread time on launch + browse. | Paste the top function. Dev-Mac diagnoses + optimises. |
| 22 | **DG4** | Xcode → Product → Profile → Leaks. Same 30s drive. | No leaks. No retained ObservableObject sub-trees ballooning. | Paste the leaked-object class. Dev-Mac adds `[weak self]` or teardown. |
| 23 | **DG7** | Xcode → Product → Profile → Core Animation. Look at FPS during scene animations + particle bursts. | On the legacy iMac, frame rate stays ≥ the `HardwareTier` cap (20 fps target). No dips below. | Note the dipping scene. Dev-Mac caps particle counts further via `HardwareTier.particleBudget`. |
| 24 | **DG8** | Xcode → Product → Profile → Energy Log. Same 30s drive. | Energy Low while idle on a chapter; brief bumps during transitions; comes back down. No sustained Medium/High. | Note the sustained-high surface. Dev-Mac investigates per-frame work. |

---

## Reporting back

```
row 3 (LY2) ✅
row 8 (TH5) defer — Dark Mode not in scope
row 17 (T3) ❌ — test_homeToQuestionDetail_endToEnd fails on the topic-list tap; expected button "topic-row-…" not found
row 21 (DG3) — top sample is `ConceptDetailView.body` at 14% of main; flagging
```

For `defer` rows, dev-Mac leaves 🟡 with the deferral reason appended.
For `❌` rows, dev-Mac opens a `fix(crash):` / `fix(ui):` / `polish(<surface>):`
commit. For `✅` rows, dev-Mac flips the taxonomy ID in
`docs/ISSUE_CATEGORIES.md` and confirms back.

This is how the app reaches **pure / issue-less**: dev-Mac closes logic
(done — see `REMAINING_WORK.md`), this checklist closes perception, and
the Instruments + UI-test section catches anything the lints couldn't.
