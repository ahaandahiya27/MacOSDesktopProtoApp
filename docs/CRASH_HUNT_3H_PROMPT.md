# 3-Hour Crash Hunt — desktopAhaan Super-Prompt

Paste this verbatim at the top of a fresh Claude Code session when the
user reports a crash. It's a self-contained 3-hour operating plan with
exit criteria. Do not edit between sessions — update only if a new
crash class is permanently fixed and you want to add or remove a phase.

---

## MISSION

Make the desktopAhaan app crash-free for a Class-7 student running it
daily on a Late-2014 iMac. You have **3 hours** of wall-clock time.
You must finish each phase before moving on. You must push every fix
to `origin/main` immediately so the iMac can pull. You must NEVER ship
a fix you haven't built + tested locally.

## HARD CONSTRAINTS (from CLAUDE.md — re-read if uncertain)

- Target: macOS Big Sur 11.7.11, Xcode 13.2.1, Swift 5.5,
  AMD R9 M290X 2 GB GPU, universal binary (arm64 + x86_64).
- Ad-hoc signed (`CODE_SIGN_IDENTITY=-`). No Apple Developer team.
- No macOS 12+ SwiftUI APIs. No SF Symbols 3+ literals. ViewBuilder
  closures ≤ 10 direct children. No `try!` / `as!` / `[i]!` in
  runtime paths (FoundationTutor has a documented carve-out).
- All file writes use `options: .atomic`. All `@AppStorage` keys go
  through `AppStorageKeys`.
- Test target = 310 tests. Must stay green.

## EVIDENCE YOU ALREADY HAVE

1. **Crash logs**: `~/Library/Containers/com.emoha.desktopAhaan/Data/Library/Application Support/desktopAhaan/crashlogs/crashlog-YYYY-MM-DD.txt`. Four entry kinds: EXCEPTION, SIGNAL, DATA (hangs + soft data invariants), RECOVERY (previous session didn't clean-quit). Logs are append-only, human readable. *Known limitation*: LLDB intercepts EXC_BAD_ACCESS in DEBUG before the OS hands a signal, so the screenshot stack is often the only evidence of a real crash.
2. **`docs/CRASH_FIX_SUPER_PROMPT.md`** — the 10 known crash classes, the lint/grep that catches each, the canonical Big Sur fix.
3. **`docs/CRASH_DEEP_RESEARCH.md`** — forensic write-up of which bug classes are confirmed fixed, which are catalogued but unfixed, and what to look at next.
4. **`docs/ISSUE_CATEGORIES.md`** — A–Y taxonomy of every bug class this repo can have. Flip rows to ✅ as you finish.

---

## PHASE 0 — TRIAGE (10 min, MUST be in this order)

1. `git pull --rebase origin main` to make sure you're at HEAD.
2. Read the user's last screenshot (if any) and identify the crash signature: EXC_BAD_ACCESS / EXC_BREAKPOINT / hang / silent no-op / wrong UI.
3. Read the last 100 lines of today's crashlog: `tail -100 "~/Library/Containers/com.emoha.desktopAhaan/Data/Library/Application Support/desktopAhaan/crashlogs/crashlog-$(date +%Y-%m-%d).txt"`.
4. `git log --oneline -10` — what did the last 10 commits change? A new crash is most often a regression in the most recent commit.
5. State your **hypothesis in one sentence** before doing anything else. Don't jump to "fix everything"; pick the single most likely cause first.

## PHASE 1 — READ THE CODE (30 min)

Map the suspect path end-to-end. For "Try at Home crashing on Ch.1" the path is:

```
ContentView.body
  → NavigationView { sidebar / detailPane }
  → ChapterDetailView (Ch.1)
  → .sheet(item: $presentedSheet) → HomeExperimentsSheet
  → ForEach(list) { HomeExperimentCard(experiment: exp) }
  → Button → withAnimation { expanded.toggle() }
```

Read EVERY file in that path. Don't skim. Note every `@State`, `@StateObject`, `@Published`, `.sheet`, `.animation`, `ForEach`, `withAnimation`. If a crash class from `CRASH_FIX_SUPER_PROMPT.md` is in any of those files, you found it.

## PHASE 2 — SYSTEMATIC AUDIT (60 min)

Run the audit in this exact order. Each check has a precise command.
Anything that fires is a finding; record file + line + crash class.

```bash
# 1. macOS 12+ APIs
python3 scripts/check_macos12_apis.py

# 2. SF Symbols 3+ literals
python3 scripts/check_sf_symbols_compat.py

# 3. ViewBuilder ≤ 10 children
python3 scripts/check_viewbuilder_limit.py

# 4. Tuple-keypath ForEach (CRITICAL — the most-fixed class)
rg -n 'ForEach\(Array\([^)]*\.enumerated\(\)\)' desktopAhaan/

# 5. Multi-sheet collision: more than one .sheet on the same struct
rg -n '\.sheet\(isPresented:' desktopAhaan/ --type swift | awk -F: '{print $1}' | sort | uniq -c | awk '$1 > 1'

# 6. Force-unwrap in runtime paths
rg -n '(try!|as!|\[\w+\]!)' desktopAhaan/ --type swift \
   | grep -v 'desktopAhaanTests/' \
   | grep -v 'FoundationTutor.swift'

# 7. Dictionary(uniqueKeysWithValues:) — fatal on dups
rg -n 'Dictionary\(uniqueKeysWithValues:' desktopAhaan/ --type swift

# 8. SF Symbol force-construct without nil-check
rg -n 'NSImage\(systemSymbolName:[^)]*\)!' desktopAhaan/ --type swift
rg -n 'Image\(systemName: "[^"]*"\)\.resizable\(\)!' desktopAhaan/ --type swift

# 9. NotificationCenter leak — addObserver without paired removeObserver
rg -n 'NotificationCenter\.default\.addObserver' desktopAhaan/ --type swift

# 10. WKWebView lifecycle — coordinator.cleanup() must be called
rg -n 'WKWebView\(\)' desktopAhaan/ --type swift
# Cross-check each coordinator has cleanup() AND a call site that invokes it.

# 11. @StateObject with side-effecting init
rg -n '@StateObject private var \w+ = \w+\(' desktopAhaan/ --type swift
# Open each match; the right-hand class init() must NOT call AVAudioSession,
# AVAudioEngine, SFSpeechRecognizer, NSNotificationCenter, WKWebView, etc.

# 12. ObservableObject without @MainActor
rg -n 'final class .*: ObservableObject' desktopAhaan/ --type swift
# Each match must either be `@MainActor` or publish via `Task { @MainActor in }`
# / `DispatchQueue.main.async`.
```

If all 12 are clean and the user is still reporting a crash, the bug
is in one of the LOW-priority transition patterns catalogued in
`CRASH_DEEP_RESEARCH.md` — start lightening combined/scale/move
transitions in the affected scene.

## PHASE 3 — FIX (60 min)

Rules:
- One commit per crash class. Not per file. Not per finding.
- Each commit message must follow the conventional-commits prefix
  (`fix(crash):`, `fix(ch1):`, etc.) and end with the Co-Authored-By
  trailer.
- After each commit: `python3 scripts/check_macos12_apis.py` ; xcode
  `BuildProject` ; xcode `RunAllTests`. If any of those fail, fix it
  before the next commit.
- After each commit: `git push origin main`. The iMac must be able
  to pull immediately.

Canonical fix patterns (use these verbatim):

```swift
// A. Tuple-keypath ForEach → indices ForEach
// BEFORE
ForEach(Array(items.enumerated()), id: \.offset) { idx, item in ... }
// AFTER
ForEach(items.indices, id: \.self) { idx in
    let item = items[idx]
    ...
}

// B. Multi .sheet(isPresented:) → single .sheet(item:)
@State private var presentedSheet: Sheet?
private enum Sheet: String, Identifiable {
    case foo, bar
    var id: String { rawValue }
}
.sheet(item: $presentedSheet) { kind in
    switch kind {
    case .foo: FooSheet()
    case .bar: BarSheet()
    }
}

// C. Dictionary(uniqueKeysWithValues:) → uniquingKeysWith:
Dictionary(items.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in
    CrashReporter.shared.logDataIssue("Duplicate id: \(first.id)")
    return first
})

// D. .animation(_:value:) → .animation(_:) or withAnimation
// BEFORE
.animation(.easeOut(duration: 0.2), value: someState)
// AFTER (option 1)
.animation(.easeOut(duration: 0.2))
// AFTER (option 2 — better when the animation should drive a specific change)
withAnimation(.easeOut(duration: 0.2)) {
    someState = newValue
}

// E. SF Symbol 3+ literal → SFSymbolCompat.name(_:)
Image(systemName: SFSymbolCompat.name("modern.icon"))

// F. WKWebView cleanup hook in @StateObject coordinator
// In ArticleBrowserView (or any WKWebView host):
.onDisappear {
    coordinator.cleanup()  // stopLoading, invalidate observers, clear delegates
}
```

## PHASE 4 — VERIFY (20 min)

Before declaring "done":

```bash
# Lint
python3 scripts/check_macos12_apis.py     # MUST say "clean"
python3 scripts/check_sf_symbols_compat.py # MUST say "clean"
python3 scripts/check_viewbuilder_limit.py # MUST say "no obvious violations"
```

```
Xcode MCP:
- BuildProject — MUST succeed
- RunAllTests — MUST be 310/310 passing (test count grows over time;
  match the current expected number)
```

If any of those fail, **do not commit**. Fix the failure and re-verify.

## PHASE 5 — SHIP (10 min)

```bash
git add <specific files>     # NEVER `git add -A` — risks credentials
git commit -m "fix(crash): <one-line summary>"   # via HEREDOC; trailer required
git push origin main
git log --oneline -3          # confirm origin and HEAD match
```

Tell the user:
1. The commit hash.
2. The 1–2 sentence explanation of what crashed and why.
3. The iMac pull command: `bash ~/Downloads/DesktopAhaan\ 4/desktopAhaan/scripts/imac-pull.sh`.
4. The specific user action that should now work (e.g. "Open Beyond the Book, close it, then tap Try at Home").

## EXIT CRITERIA — any one stops the 3-hour timer

A. **Confirmed fix landed** — user reproduces the crash on the iMac after pull, and it no longer fires. STOP. Note the root cause in `docs/CRASH_DEEP_RESEARCH.md` and flip the corresponding row in `docs/ISSUE_CATEGORIES.md` to ✅.

B. **All 12 audit checks clean + 310/310 tests pass + user can't reproduce** — three back-to-back commits with no findings means we've exhausted the systematic-audit search space. STOP. Tell the user we've gone as far as we can without more evidence; ask for an LLDB exception breakpoint on `objc_release` and a fresh screenshot at the crash moment.

C. **3 hours elapsed** — STOP regardless. Don't burn into hour 4 without re-establishing what we know. Write a short summary commit `docs:` updating `CRASH_DEEP_RESEARCH.md` with what was audited and what's still open.

## RED FLAGS — STOP IMMEDIATELY IF YOU SEE

- A new bug class that doesn't fit any of the 12 audit checks.
  Don't invent a 13th lint on the fly — add it to
  `CRASH_FIX_SUPER_PROMPT.md` first, get the user's read, then ship.
- A "fix" that touches more than 3 files. That's a refactor, not a
  fix. Split it.
- An impulse to revert a recent commit because it might be the
  cause. Use `git log -p <hash>` to read the diff first. Most
  "regressions" turn out to be pre-existing latent bugs that the
  user only just now found.
- Any urge to skip `RunAllTests` "just this once." Don't.

## NOTES TO FUTURE-YOU

- **The user does not see your tool calls.** Tell them what you're doing in plain English before the call. One sentence is enough.
- **The Xcode debugger lies.** EXC_BAD_ACCESS at `objc_release` shows the *post-crash idle stack*, not the offending caller. Don't trust the visible stack; trust the crash class signature.
- **`docs/CRASH_DEEP_RESEARCH.md` is more useful than this file** when you have evidence. This file is the operating manual; that file is the forensic record. Update both.

---

End. Now execute the plan.
