# Production-Grade Audit — desktopAhaan (Big Sur iMac Target)

A self-running, paste-ready audit prompt covering every class of issue
that can stop this app from shipping cleanly to a Class-7 student on a
Late-2014 iMac. Designed to be executable for a long unattended run
(claimed 7 hours; realistically 1–3 hours of useful work depending on
how many findings turn up). Sits alongside:

- `CRASH_FIX_SUPER_PROMPT.md` — the bug-class catalogue
- `CRASH_DEEP_RESEARCH.md`    — forensic record
- `CRASH_HUNT_3H_PROMPT.md`   — the 3-hour crash-only operating plan
- **this file**               — the broader prod-readiness audit

The earlier docs are crash-focused. This one is **everything else**:
performance, accessibility, security, privacy, memory, error UX,
content invariants, persistence, build hygiene, future-proofing.

## OPERATING RULES

- One commit per finding class. Push immediately. Never batch.
- Build + 310 tests + 3 lints must all be green before any commit.
- Never use `try!` / `as!` / `[i]!` in runtime paths (test target +
  FoundationTutor are exempt).
- Never edit `project.pbxproj` while Xcode is open. Use `XcodeWrite`
  MCP for new files (auto-registers); for existing files use Edit/Write.
- Never use macOS 12+ SwiftUI APIs or SF Symbols 3+ literals. Lint
  catches them.
- Never `git add -A` — stage specific files.
- If a "fix" touches more than 3 files, split it.
- Match scope to ask: prod-grade != gold-plating. Don't redesign.

## TARGET CONSTRAINTS (re-read CLAUDE.md if uncertain)

- Big Sur 11.7.11, Xcode 13.2.1, Swift 5.5, AMD R9 M290X 2 GB GPU.
- Universal binary (arm64 + x86_64), Release `ONLY_ACTIVE_ARCH=NO`.
- Ad-hoc signed (`CODE_SIGN_IDENTITY=-`).
- Offline-first. One outbound HTTP call (`FreeOnlineTranslationProvider`),
  user can disable via Settings.
- No accounts. No telemetry. Single-user.
- 310 tests across 13 files.

---

## PHASE A — RE-AUDIT FOR KNOWN CRASH CLASSES (30 min)

Run the 12-check audit from `CRASH_HUNT_3H_PROMPT.md`. Anything fired
gets fixed before moving on. The 3 lints + the manual greps in that
doc cover this phase end-to-end.

## PHASE B — PERFORMANCE & THERMALS (45 min)

The R9 M290X 2 GB is the bottleneck. Goals:
- Cold launch under 2 s on a fresh boot.
- No main-thread hang > 2 s after launch settles.
- Discover-scene particle effects capped at 20 fps on `HardwareTier.isLegacy`.

Commands:
```bash
# 1. Find all particle / animation loops
rg -n 'TimelineView|Animation\.repeatForever|Timer\.scheduledTimer' desktopAhaan/ --type swift
rg -n 'HardwareTier|\.isLegacy' desktopAhaan/ --type swift
# Every TimelineView and repeating Animation in a Discover scene MUST
# read HardwareTier and degrade. Any one that doesn't is a finding.

# 2. Find synchronous JSON decode / file IO on main
rg -n 'JSONDecoder\(\)\.decode|Data\(contentsOf:' desktopAhaan/ --type swift
# Each must be either off-main (Task.detached / DispatchQueue.global)
# OR small enough to ignore (Sanskrit dictionary at 246 entries is fine,
# Science pack at 19 chapters is off-thread per SubjectRegistry).

# 3. Find expensive ops in body { ... }
rg -n 'var body: some View' desktopAhaan/ --type swift | wc -l
# Spot-check 5 random body computed properties for filter/map/reduce
# over large collections — those should be cached in computed props
# or @State.
```

## PHASE C — MEMORY LIFECYCLE (45 min)

Check every long-lived ObservableObject and every closure capture.

```bash
# 1. Timers — find ones that aren't invalidated in deinit/onDisappear
rg -n 'Timer\.scheduledTimer|Timer\.publish' desktopAhaan/ --type swift
# For each match, the file must have a paired `.invalidate()` or
# `.cancel()` in deinit/onDisappear.

# 2. NotificationCenter observers without removal
rg -n 'addObserver' desktopAhaan/ --type swift
rg -n 'removeObserver' desktopAhaan/ --type swift
# Counts should match; mismatches are leaks.

# 3. NSKeyValueObservation arrays
rg -n 'NSKeyValueObservation|observe\(\\' desktopAhaan/ --type swift
# Every owner must call .invalidate() or release the array on cleanup.

# 4. WKWebView() construction sites
rg -n 'WKWebView\(' desktopAhaan/ --type swift
# Each must have a cleanup hook in onDisappear.

# 5. AVAudioEngine / AVAudioSession
rg -n 'AVAudioEngine|AVAudioSession' desktopAhaan/ --type swift
# .stop() and .setActive(false) must be paired with .start() and
# .setActive(true).

# 6. Task { } closures without cancellation
rg -n 'Task\s*\{' desktopAhaan/ --type swift | wc -l
rg -n 'task\?\.cancel\(\)|task\.cancel\(\)' desktopAhaan/ --type swift | wc -l
# Long-running Tasks (sleep ≥ 1 s inside) need to be stored on @State
# and cancelled on .onDisappear. One-shot Tasks (state mutation, then
# return) are fine to fire-and-forget.

# 7. Strong-ref closure captures
rg -n '\[self\]|\[weak self\]|\[unowned self\]' desktopAhaan/ --type swift
# Long-lived closures (Combine sinks, Notification observers, Timer
# callbacks, async Task bodies) should use [weak self]. Short-lived
# (.onChange, .onTapGesture body) can use plain `self`.
```

## PHASE D — SECURITY & PRIVACY (30 min)

```bash
# 1. Hard-coded secrets — should be zero
rg -nE '(API[_-]?KEY|SECRET|TOKEN|PASSWORD|PASSWD)\s*=' desktopAhaan/ --type swift
rg -nE 'https?://[^\s"]*\?(api_key|apikey|key|token)=' desktopAhaan/ --type swift
rg -nE 'Bearer [A-Za-z0-9_\-\.]+' desktopAhaan/ --type swift

# 2. Network access outside FreeOnlineTranslationProvider
rg -n 'URLSession|NSURLSession|URLRequest' desktopAhaan/ --type swift
# Only FreeOnlineTranslationProvider should appear.

# 3. PII or telemetry uploads
rg -nE 'NSLog|os_log|Logger\b' desktopAhaan/ --type swift | wc -l
rg -nE 'analytics|telemetry|mixpanel|amplitude' desktopAhaan/ -i
# Should be zero analytics references.

# 4. JavaScript enabled inside WKWebView
rg -n 'javaScriptEnabled.*true' desktopAhaan/ --type swift
# Must be explicitly false on Big Sur.

# 5. NSAllowsArbitraryLoads in Info.plist
rg -n 'NSAllowsArbitraryLoads' desktopAhaan/ -g '*.plist' -g '*.swift'

# 6. Entitlements minimal
cat desktopAhaan/desktopAhaan.entitlements
# Expected: app-sandbox, network.client, files.user-selected.read-only,
# device.audio-input. Anything else needs justification.
```

## PHASE E — ACCESSIBILITY (30 min)

```bash
# 1. Buttons without accessibility labels
rg -n 'Button\(action:' desktopAhaan/ --type swift -A 6 \
    | grep -v 'accessibilityLabel' \
    | grep 'Image(systemName:' \
    | head -20
# An icon-only Button must have .accessibilityLabel("…").

# 2. Color literals (hard-coded RGB) without WCAG check
rg -n 'Color\(red:.*green:.*blue:' desktopAhaan/ --type swift | head -10
# Anything in a callout body must be WCAG AA against its background.
# The testWCAG_* suite covers known callouts; new ones should be added.

# 3. .font(.system(size:)) below 12pt
rg -n '\.font\(\.system\(size: ([0-9]+)' desktopAhaan/ --type swift -o
# Below 12pt is hard for Dynamic Type users.

# 4. Images without descriptions
rg -n 'Image\(' desktopAhaan/ --type swift -A 1 \
    | grep -v 'accessibilityHidden\|accessibilityLabel\|systemName: "chevron'
```

## PHASE F — ERROR UX (20 min)

The kid should never see a stack trace, an LLDB-style address, or
raw NSError descriptions.

```bash
# 1. error.localizedDescription shown to UI without massaging
rg -n 'error\.localizedDescription' desktopAhaan/ --type swift -B 2 -A 2

# 2. Fatal errors / preconditions in non-test paths
rg -n 'fatalError|preconditionFailure|assertionFailure' desktopAhaan/ --type swift | grep -v 'desktopAhaanTests'

# 3. NSAlert with raw error strings
rg -n 'NSAlert|alertWithError' desktopAhaan/ --type swift
```

## PHASE G — CONTENT-PACK INTEGRITY (30 min)

The Science and Sanskrit packs are the source of truth for everything
the kid sees. A typo in either can wipe a morning.

```bash
# 1. JSON pack validity
python3 -c "import json; json.load(open('desktopAhaan/Resources/science_class7.json'))" && echo OK
python3 -c "import json; json.load(open('desktopAhaan/Resources/sanskrit_class7.json'))" && echo OK

# 2. Orphan related-id references
python3 scripts/audit_pack_health.py 2>&1 | tail -20

# 3. Article files exist for every ArticleIndex entry
# (covered by testAllArticleHTMLFilesExistInBundle — re-run tests)

# 4. Every Discover scene mentioned in totalDiscoverScenes pin actually exists
grep -n totalDiscoverScenes desktopAhaan/Services/Persistence/DataStore.swift
# Cross-check against `testTotalDiscoverScenesPinnedAt382`.

# 5. Every Boss Quiz has at least N questions
# (covered by testEveryScienceChapterHasAtLeastThreeL4AndThreeL5)
```

## PHASE H — PERSISTENCE & UPGRADES (20 min)

```bash
# 1. Every file write uses .atomic
rg -n '\.write\(' desktopAhaan/ --type swift | grep -v 'atomic'
# Any write without `.atomic` is a finding. Atomic prevents half-written
# state on app crash.

# 2. @AppStorage keys go through AppStorageKeys
rg -n '@AppStorage\(' desktopAhaan/ --type swift | grep -v 'AppStorageKeys'
# Each match should reference `AppStorageKeys.foo`, not a string literal.

# 3. JSON encode/decode round-trip tests exist for every Codable type
# (covered by testNotebook_ChapterNoteRoundTripCodable, testSM2_RoundTripCodableSurvivesEncoding)
```

## PHASE I — BUILD HYGIENE (30 min)

```bash
# 1. Compiler warnings
xcodebuild -project desktopAhaan.xcodeproj -scheme desktopAhaan -configuration Debug build 2>&1 \
    | grep ' warning:' | head -20

# 2. Type-check timeouts
xcodebuild ... 2>&1 | grep -i 'took.*to type-check\|expression too complex'

# 3. Dead code
rg -n 'TODO|FIXME|XXX|HACK' desktopAhaan/ --type swift | wc -l
# A few are fine; a sudden spike means something was rushed.

# 4. Universal binary verification
file desktopAhaan/build/.../desktopAhaan.app/Contents/MacOS/desktopAhaan 2>/dev/null
# Should show: Mach-O universal binary with 2 architectures
```

## PHASE J — REGRESSION RATCHETS (20 min)

For every fixed bug class, there must be either:
- A lint rule in `scripts/check_*.py` that catches re-introduction, OR
- A test in `desktopAhaanTests/` that fails if the invariant breaks

```bash
# 1. List the ratchet tests
grep -rn '^    func test' desktopAhaanTests/ | wc -l
# Should be ~310.

# 2. List the lints
ls scripts/check_*.py
# Should include: macos12_apis, sf_symbols_compat, viewbuilder_limit,
# pack_schema, callout_reading_level, color_literals, wcag_contrast.
```

## PHASE K — FUTURE-PROOFING WRITE-UP (15 min)

When all of A–J are clean (or all findings are committed), append a
section to `docs/CRASH_DEEP_RESEARCH.md` summarising:
1. What was audited this run.
2. What was clean.
3. What was fixed (commit hashes).
4. What's still open (catalogued, not yet fixed).
5. What new lint or test was added to prevent re-introduction.

---

## EXIT CRITERIA

- **A**: Three consecutive audit passes turn up zero findings → STOP, app
  is prod-grade by this audit's measure. Write the section in
  `CRASH_DEEP_RESEARCH.md` and stand down.
- **B**: User says "stop" or "ship" → STOP, write the summary.
- **C**: 7 hours wall clock → STOP, write the summary, NEVER burn into
  hour 8 without re-establishing priorities with the user.
- **D**: Build or tests broken and you've spent 30+ min on a single
  fix → STOP, revert the breaking commit, write a "blocker" note in
  `CRASH_DEEP_RESEARCH.md`.

## RED FLAGS — STOP IMMEDIATELY IF YOU SEE

- A "fix" that requires editing `project.pbxproj`. Don't.
- An impulse to add a feature ("while I'm here, let me also…"). No.
- A test that fails and you're tempted to delete it. Don't.
- A `git push --force` urge. Never on `main`.
- A change that touches the iMac pull script (`scripts/imac-pull.sh`)
  without explicit user request.

---

End. Execute the plan, one phase at a time, one commit per finding-class.
