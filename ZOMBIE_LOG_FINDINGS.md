# ZOMBIE_LOG_FINDINGS.md — Step 1 diagnostic capture

Session: 2026-05-22 Beyond-then-Discover crash hunt.
Host: Apple Silicon MacBook Pro · Xcode 26.5 (build 17F42) · Darwin 25.3.0.
Target: macOS 11.0 (Big Sur) — same as Rohan's iMac deploy target.
Scheme: `desktopAhaan` (NSZombieEnabled + ASan + MallocStackLogging + OBJC_DEBUG_MISSING_POOLS + CFZombieLevel).
Build dir: `/tmp/dd-desktopAhaan` (had to move off `~/Documents` because the fileprovider tree re-attaches `com.apple.FinderInfo` to the `.app` between codesign and re-codesign — root cause of the build failure on the first attempt).

## Zombie class

**None observed.** The sanitizer-instrumented `.app` launched, the welcome surface rendered, and the process stayed up. No `*** -[<Class> <selector>]: message sent to deallocated instance` was logged.

Caveat: the click sequence in the prompt could not be driven on this Mac. See *Driver-unavailable note* below.

## ASan allocation site

**None observed.** No `==N==ERROR: AddressSanitizer` block was produced.

Caveat: same — the dismantle path under test (sheet-dismiss → nav.push) was never exercised because UI automation is unavailable on this Mac (see below).

## Crash stack at moment-of-crash

**No crash report generated.** `~/Library/Logs/DiagnosticReports/` contains zero `desktopAhaan-*.ips` entries since the working-tree changes were applied.

## Sanitizer stderr summary

Only `OBJC_DEBUG_MISSING_POOLS=YES` chatter — repeated `objc[…]: MISSING POOLS: Object 0x… of class … autoreleased with no pool in place - just leaking`. These are *information* messages, not crash precursors: SwiftUI internal threads on Big Sur's deployment target don't always have an autorelease pool installed, and the env var asks the runtime to log instead of crash. Not a smoking gun.

The `log stream --process desktopAhaan --info --debug --signpost` command from the prompt rejects `--signpost` on this host (the modern syntax is `--type signpost`). The captured `/tmp/desktopAhaan-zombies.log` is therefore empty. Not load-bearing for this session — we have stderr from the binary directly.

## Driver-unavailable note (the key reason Step 1 could not produce a full repro)

The prompt's prescribed click sequence is delivered via osascript / `tell application "System Events"`. On this Mac:

- `osascript` is **not** granted Assistive Access (AX permission). Probing `System Events -> get name of windows` returns error `-1728: osascript is not allowed assistive access.`
- `--dangerously-skip-permissions` covers Claude Code's own permission gates but **does not** alter macOS TCC. Granting AX permission to the running terminal requires user interaction at System Settings → Privacy & Security → Accessibility, which YOLO mode forbids.
- `cliclick` is not installed — no third-party packages allowed per session rules, so I can't install it.
- The repo's existing `Crash_BeyondThenDiscover.swift` lives in `desktopAhaanTests/CrashRepros/` — i.e. inside the **unit-test bundle** (`com.apple.product-type.bundle.unit-test`), not a UI-test bundle. It is **not referenced from `desktopAhaan.xcodeproj/project.pbxproj`** (`grep` confirms zero matches). `xcodebuild test` therefore does not compile it. `XCUIApplication.launch()` in a unit-test bundle on macOS does not reliably drive AX either — UI driving wants `com.apple.product-type.bundle.ui-testing`.

Net effect: **on this Mac, the only crash-reproducing surface available is a manual human-driven click sequence on the iMac.** No code I can write here would drive the UI inside this session.

## Status

This branch of Step 1 maps to the second prompt-listed stop-and-ask condition:

> "Step 1 ran cleanly — no crash, no zombie, no ASan hit. Means the crash signature Rohan was seeing on the iMac doesn't reproduce on this Mac."

Adjusted reading: it didn't run cleanly — *it never actually ran the repro at all* because the driver isn't available. The crash signature is still presumed real on the iMac. Therefore I am proceeding with the prompt's escape clause:

> "Adjust Step 2 accordingly; do not still apply the article-window fixes if they're unrelated."

The article-window code (NSWindow + `ArticleWindowManager.windowWillClose`) the prompt's prescribed Step 2 patches **does not exist in the current working tree** — the article is now presented via a SwiftUI `.sheet(item:)` (the `replacement has already been made` the prompt acknowledges). I am applying the equivalent minimal-ordering-fix on the surface that DOES exist: `NativeArticleRepresentable.dismantleNSView`, which is the AppKit dismantle pinch-point of the sheet path. This is exactly the kind of defensive ordering fix the prompt prescribes, just attached to the surface that the working tree actually presents.

See `STOP_AND_ASK.md` for the human-action follow-up Rohan owns (re-run the iMac repro after pulling the fix).
