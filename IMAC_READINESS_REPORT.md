# iMac Readiness Report — 2026-05-24

HEAD: `6e8aab8` · branch: `main` · origin/main: in sync.

This report captures the result of the Phase-5 verification sweep
that follows the Phase-3/Phase-4 close-out of `DEEP_AUDIT_2026.md`.
It is meant to be skimmed before pulling on the Late-2014 iMac
(Big Sur 11.7.11, Xcode 13.2.1, AMD Radeon R9 M290X 2 GB).

## Builds (target `MACOSX_DEPLOYMENT_TARGET = 11.5`)

| Configuration | Result | Code warnings | Notes |
|---------------|--------|---------------|-------|
| Debug, dest macOS | ✅ BUILD SUCCEEDED | 0 | derivedData: `/tmp/dd-desktopAhaan-debug` |
| Release, dest macOS | ✅ BUILD SUCCEEDED | 0 | derivedData: `/tmp/dd-desktopAhaan-release` |

The only `warning:` lines in either log are meta-info (`xcodebuild: WARNING: Using the first of multiple matching destinations` and `Metadata extraction skipped. No AppIntents.framework dependency found.`) — neither is a code warning.

## Tests

| Suite kind | Count | Result |
|-----------|------:|--------|
| XCTest (`Executed N tests`) | 269 | ✅ 0 failures |
| swift-testing (`Test run with N tests`) | 66 | ✅ 0 failures |
| **Total** | **335** | ✅ green |

UI tests intentionally skipped on the dev mac (AX not granted to the
runner; covered on the iMac and CI by the `--ui` flag).

## Lints (every gate on `pre-commit` + `pre-push`)

| Script | Result |
|--------|--------|
| `check_sf_symbols_compat.py` | ✅ clean (44 compat-map entries) |
| `check_macos12_apis.py` | ✅ clean |
| `check_lifetime_hazards.py` | ✅ clean (3 allowlist entries) |
| `check_file_size.py` | ✅ clean (8 allowlist entries) |
| `check_pack_schema.py` | ✅ clean (953 + 400 Decodable entities) |
| `check_color_literals.py` | ✅ clean (fixed AllChaptersCompleteOverlay this session) |
| `check_wcag_contrast.py` | ✅ all 14 pairs ≥ AA |
| `check_viewbuilder_limit.py` | ✅ no obvious violations |
| `check_callout_reading_level.py` | ⚠️ 3 callouts above Class 7 band (intentional NEET/JEE callouts — `NOT a hard gate` per the script's own description) |

## Asset catalog

| Item | Result |
|------|--------|
| `Assets.xcassets/AppIcon.appiconset/Contents.json` | 10 slots: 16/32/128/256/512 @1x and @2x |
| `Assets.xcassets/AppIcon.appiconset/*.png` | ❌ **0 PNGs present** — generic Finder icon at runtime. Logged in `POLISH_TODOS.md`; **not a launch blocker**. |
| `Assets.xcassets/AccentColor.colorset` | present |

## Bundled content

| Item | Result |
|------|--------|
| `Resources/Articles/Chapter1..19/` | 19 directories present, 11–38 HTML files each (median ≈ 14) |
| Bundled videos (`*.mp4` / `*.mov` / `*.m4v`) | 0 — no bundled video assets in the repo. MediaAssetView's `bundledVideo` backend stays inert until videos are authored. |
| `Subjects/Packs/science_class7.json` | 207 concepts · 732 questions · 19 chapters · valid JSON · round-trips clean |
| `Subjects/Packs/sanskrit_class7.json` | 246 concepts · 154 questions · 1 chapter · valid JSON · round-trips clean |

## Info.plist (embedded in pbxproj `INFOPLIST_KEY_*`)

| Key | Value |
|-----|-------|
| `NSMicrophoneUsageDescription` | "Microphone access is used for voice input translation." |
| `NSSpeechRecognitionUsageDescription` | "Speech recognition converts your spoken words into text for translation." |
| `NSHumanReadableCopyright` | (blank — acceptable for in-house build) |
| `PRODUCT_BUNDLE_IDENTIFIER` | `com.emoha.desktopAhaan` |
| `MARKETING_VERSION` | `1.0` |
| `CURRENT_PROJECT_VERSION` | `1` |
| `MACOSX_DEPLOYMENT_TARGET` | `11.5` |

## Source-control hygiene

| Check | Result |
|-------|--------|
| `git status` | clean |
| `origin/main` | synced at `6e8aab8` |
| `.git/index.lock` | absent |
| tracked `.DS_Store` / `xcuserstate` / `xcuserdata` / `.dd*` / `__pycache__` | 0 (xcuserdata untracked this session) |
| `.gitignore` coverage | `.claude/`, `*.xcuserstate`, `.dd/`, `.dd-*/`, `*.backup_xcode26`, `**/xcuserdata/`, `__pycache__/` |
| large blobs (> 5 MB) | none in `git ls-files` |

## `scripts/imac-pull.sh`

| Check | Result |
|-------|--------|
| `bash -n` syntax | ✅ OK |
| Bash 3.2 compatibility | ✅ no `mapfile` / `readarray` / `${var,,}` / `declare -A` / `local -n` / `wait -n` |
| Hardcoded iMac path | now has script-relative fallback (`J1` fix in commit `2ab6faa`) |
| Behaviour | quit Xcode (graceful + force), stash local pbxproj, `git pull origin main`, wipe `~/Library/Developer/Xcode/DerivedData/desktopAhaan-*`, verify three canary source files, re-open `desktopAhaan.xcodeproj` |
| `pre-push` gate | runs `scripts/ci-build-test.sh`; honours `CI_BUILD_TEST_FLAGS=--ui` on the iMac per its shell profile |

## Outstanding STOP_AND_ASK items

- 2026-05-22 Beyond→Discover iMac repro under the sanitizer scheme.
  Rohan's manual iMac action; **NOT** attempted on the dev mac per the
  session brief.

## Recommended iMac action (Rohan)

1. `bash "/Users/ahaandahiya/Downloads/DesktopAhaan 4/desktopAhaan/scripts/imac-pull.sh"` (or the absolute path if the iMac repo has moved — the new fallback in `2ab6faa` will catch that case).
2. In Xcode 13.2.1 once it reopens: ⇧⌘K (Clean Build Folder), ⌘B (Build), ⌘R (Run).
3. Switch to the `desktopAhaan-ThreadSanitizer` scheme and walk the Beyond → Discover sequence on Ch.1 to close the 2026-05-22 question.
4. If anything crashes, share the crashlog from `~/Library/Application Support/desktopAhaan/crashlogs/`.

## Findings that landed this session (close-out summary)

23 actionable findings closed across 12 commits (`38656be` → `6e8aab8`):

- `38656be` — `chore(gitignore)`: cover `.claude/` + sanitizer DerivedData + xcode26 backup
- `01f578b` — `fix(a11y)`: swap `.yellow → bold white` on AllChaptersComplete score
- `212fa48` — `docs`: FILE_SIZE_CENSUS.md
- `4c1a0e9` — `docs`: DEEP_AUDIT_2026.md (36 findings, triage block)
- `e440637` — `chore(gitignore)`: untrack xcuserdata + add `**/xcuserdata/` pattern (closes K1/K2)
- `af84581` — `fix(a11y)`: expand DictationButton hit area to 44×44 (closes G14)
- `bbca346` — `fix(a11y)`: RM-gate withAnimation in chrome (closes G1/G2/G12/G13)
- `997724c` — `fix(a11y)`: RM-gate residual withAnimation in Ch.1 scenes (closes G3..G11 real subset)
- `cb4fad5` — `fix(a11y)`: hide zero-frame keyboard-shortcut sinks from VoiceOver (closes G16/G17)
- `084093a` — `fix(a11y)`: Dynamic Type xLarge safety on three fixed-width match rows (closes G20/G21/G22)
- `b93bfa2` — `fix(perf)`: move PlainTextArticleFallback HTML strip off main thread (closes D1)
- `2ab6faa` — `chore(scripts)`: imac-pull.sh falls back to script-relative repo root (closes J1)
- `ef99648` — `docs`: refresh stale "254 tests" count in CLAUDE.md + README.md (closes L1/L2)
- `dc19599` — `docs`: DEEP_AUDIT_2026 close-out status block
- `6e8aab8` — `docs(polish)`: log AppIcon PNGs + withAnimation lint as deferred polish

## Verdict

**Ready for iMac pull**. Debug + Release both build clean at the
deploy target with zero code warnings, every lint gate is green, all
335 tests pass, the source tree is clean and origin-synced, and
`imac-pull.sh` is Bash 3.2 compatible with a sane fallback for the
hardcoded path. The two cosmetic gaps (missing AppIcon PNGs, broader
`withAnimation` lint) are logged for a future session and do not
block launch.
