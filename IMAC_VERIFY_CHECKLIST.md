# iMac Visual-Verification Checklist

This file is the bridge between dev-Mac logic-closure and Big-Sur-iMac
perception-closure. Every row below is a `docs/ISSUE_CATEGORIES.md` 🟡
row whose code is believed correct but cannot be verified headlessly on
the dev Mac (macOS 26.x) — only a fresh-install eyeball on Ahaan's
**Late-2014 5K iMac, Big Sur 11.7.11, AMD R9 M290X, Xcode 13.2.1**
flips them ✅.

**How to use**: walk top-to-bottom on the iMac. Each row has an exact
menu/shortcut path, what "correct" looks like, and the taxonomy ID to
flip in `docs/ISSUE_CATEGORIES.md` if it passes. Report back via paste
of "row X passed / failed because Y" and the dev-Mac side will close
the rows.

> Generated 2026-06-23 from the bug-free super-prompt pass. Refresh
> when new 🟡 rows surface that need an iMac eyeball.

---

## How to run

Open Xcode 13.2.1 on the iMac with the project at
`/Users/ahaandahiya/Downloads/DesktopAhaan 4/desktopAhaan/`. Use
`scripts/imac-pull.sh` to bring `origin/main` down (it auto-stashes
pbxproj churn, wipes DerivedData, and re-opens the project). Then:

```
⇧⌘K  (clean)
⌘B   (build Debug — zero warnings expected)
⌘R   (run)
```

For UI-test rows, the runner needs an AX grant:
**System Settings → Privacy & Security → Accessibility →
`desktopAhaanUITests-Runner.app` (toggle ON)**. Then in Terminal:

```
export CI_BUILD_TEST_FLAGS=--ui
bash scripts/ci-build-test.sh
```

For each row that passes, paste back "row {ID} ✅" and the taxonomy
gets flipped on the dev Mac.

---

## Rows to verify

### Display / Layout

| # | ID | What to do | What "correct" looks like | Flip on pass |
|---|----|------------|---------------------------|---------------|
| 1 | **J4 / LY6** | Drag the main window down to its minimum (the OS will hard-stop at 1024×640). Walk every sidebar entry: Welcome / each subject pack / Daily Practice / Bookmarks / Settings / Search. | No content overflows the bottom edge; no horizontal scroll on any panel; chrome (header, sidebar, status row) stays readable; the canvas reading panel respects `contentMaxWidth = 1100pt`. | J4 + LY6 |
| 2 | **TY1** | Open Discover Mode for any chapter (e.g. Science Ch.1). Read the chapter-accent header at 5K @ 2×. | Header title is large enough to anchor the canvas — not lost in whitespace. `.title2.bold` (~22pt) feels appropriate for the 5K design canvas. | TY1 (or comment-bump if too small) |
| 3 | **LY2** | Maximize the window on the 5K iMac. Open any reading article (Help → desktopAhaan Help, or a chapter's Beyond / Mistakes article). | The reading column letterboxes to ~1100pt, with comfortable margin on each side. Not so narrow it feels cramped, not so wide that lines exceed ~80 characters. | LY2 (or bump `contentMaxWidth`) |

### Dynamic Type

| # | ID | What to do | What "correct" looks like | Flip on pass |
|---|----|------------|---------------------------|---------------|
| 4 | **H4 / TY4** | System Settings → Displays → Larger Text → bump to **Larger** then **Largest**. Re-open the app. Walk a chapter's concept cards, question detail, Mock Test runner, Mastery Map, Daily Plan. | No card title gets truncated mid-word; no body text gets clipped to a single line; fixed-width `Text` blocks use `.minimumScaleFactor(0.8)`. The pre-existing test pins concept titles at ≤90 chars, which is the proxy. | H4 + TY4 |

### Dark Mode + Theming

| # | ID | What to do | What "correct" looks like | Flip on pass |
|---|----|------------|---------------------------|---------------|
| 5 | **J1 / TH1** | System Settings → Appearance → Dark. Walk: home / sidebar / chapter list / Discover canvas / article browser / OCR translator / Settings. | Chrome (sidebar, navigation chrome) adapts to Dark mode automatically (NSColor semantic colours). Discover canvas stays fixed-light (sunshine theme — intentional per CN1/CL1). Body text on the canvas stays ~#212121 (BrandColor.canvasText) and remains legible against the gradient. | J1 + TH1 |
| 6 | **CL3 / TH2** | Same dark-mode walk. Look at the sidebar / canvas boundary. | The sidebar's NSVisualEffectView is darker than the canvas — this is the macOS NavigationView convention (Mail, Notes, Reminders). Should NOT feel like a bug. | CL3 + TH2 |
| 7 | **TH5** | If you actually use Dark Mode in daily use: open a chapter article (e.g. Science Ch.1 Overview). Compare Light vs Dark. | Articles for Ch.1–7 + Ch.19 adapt via CSS variables. Ch.8–18 use direct hex (legacy) — they will look identical Light/Dark. If Dark Mode is in scope, those need migration. If you never use Dark Mode → leave 🟡 as deferred. | TH5 (decide in scope or defer) |

### Accessibility

| # | ID | What to do | What "correct" looks like | Flip on pass |
|---|----|------------|---------------------------|---------------|
| 8 | **H6** | Stay in Dark mode. Walk the same surfaces. | Every text-on-background combination clears WCAG AA 4.5:1 contrast (rough check: text should never feel "ghosted" against the background). | H6 |
| 9 | **TH7** | System Settings → Accessibility → Display → Increase Contrast ON. Re-open the app. | Buttons get heavier borders; text contrast bumps slightly. Nothing breaks. App still readable. | TH7 |
| 10 | **TH8** | System Settings → Accessibility → Display → Reduce Transparency ON. Re-open the app. | Sidebar's vibrancy falls back to a solid window background. No transparency-layered visual glitches. | TH8 |
| 11 | **H7** | With keyboard only: Tab from the sidebar through any chapter to a question. Use ⌘[ / ⌘] / arrow keys per the menu shortcuts. | Every interactive surface can be reached and activated via keyboard. No widget is unreachable. | H7 (or list any blocked widgets) |
| 12 | **H8 / CN5** | Same keyboard walk. Watch the focus ring. | System-blue focus ring is visible against pale-blue / pale-green Discover gradients (system-blue ≠ pale-blue at full saturation). On chrome surfaces, the ring sits clearly on every focused control. | H8 + CN5 |

### First-launch + Behavior

| # | ID | What to do | What "correct" looks like | Flip on pass |
|---|----|------------|---------------------------|---------------|
| 13 | **EM3** | If you can afford it: trash the app's `~/Library/Application Support/desktopAhaan/` then open the app. (Or skip if not safe.) | The 4-page `FirstLaunchTourView` sheet presents once. Skip / Get Started both work. The kid lands on a sensible default pack. | EM3 |
| 14 | **LC8** | Open the app. Put the iMac to sleep (close lid / Apple menu → Sleep). Wake 10+ minutes later. | App resumes in <2s. No frozen UI. No crashlog written. Timers and audio recovered cleanly. | LC8 |

### UI Tests (need AX grant)

| # | ID | What to do | What "correct" looks like | Flip on pass |
|---|----|------------|---------------------------|---------------|
| 15 | **T3** | After AX grant, run `export CI_BUILD_TEST_FLAGS=--ui; bash scripts/ci-build-test.sh`. Watch for `NavigationSmokeUITests/test_homeToQuestionDetail_endToEnd`. | Test passes (end-to-end home → chapter → topic → concept → question walk). pbxproj wiring confirmed on dev Mac; this iMac run is the final gate. | T3 |
| 16 | **T2 (Social Science walks)** | After AX grant, run the `--ui` suite. SocialScience bespoke interactives currently have no smoke walk — flag any specific scene where the kid's tap doesn't reach a meaningful state. | If you have AX grant + want to flip this: add stable container IDs to each `socialScienceInteractives` scene and a walk per scene. Otherwise leave 🟡 — it's "gravy" per the taxonomy. | T2 (or note Social Science gap) |

### Instruments / Diagnostics (real-iMac only)

| # | ID | What to do | What "correct" looks like | Flip on pass |
|---|----|------------|---------------------------|---------------|
| 17 | **DG3** | Xcode → Product → Profile → Time Profiler. Drive a 30-second session: open 2 chapters, take a quiz, view Mastery Map. | Top-of-stack samples are SwiftUI compositing + dispatch source ticks (expected). No hot Swift function blowing >10% of main-thread time on the launch + browse path. | DG3 |
| 18 | **DG4** | Xcode → Product → Profile → Leaks. Same 30-second drive. | No leaks reported. No retained ObservableObject sub-trees ballooning over the session. | DG4 |
| 19 | **DG8** | Xcode → Product → Profile → Energy Log. Same drive. | Energy stays Low while idle on a chapter; bumps briefly during transition; comes back down. No sustained Medium/High. | DG8 |

---

## Reporting back

When you finish a row, paste one line like:

```
row 3 (LY2) ✅
row 7 (TH5) defer — Dark Mode not in scope on the iMac
row 11 (H7) ❌ — Cmd-Opt-arrow doesn't reach the article browser CTAs
```

The dev-Mac side will:
- Flip ✅ rows in `docs/ISSUE_CATEGORIES.md`
- Open a fresh `fix(<surface>):` commit for ❌ rows with a repro test
- Leave `defer` rows 🟡 with the deferral reason appended

This is how the app actually reaches **pure / issue-less**: dev-Mac
closes logic, iMac closes perception.
