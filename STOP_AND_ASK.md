# Stop-and-Ask — desktopAhaan (12-hour session)

Per §E of the 12-hour spec, this file is only written for the six exception conditions. Otherwise: decide and continue.

## Open questions

### 2026-05-22 — Beyond→Discover crash: iMac re-repro required after pull

Step 1 of the Beyond→Discover crash hunt could not be executed on the dev Mac because the UI automation surface is unavailable (osascript lacks AX, no UI-test target in the pbxproj, no `cliclick`). The defensive dismantle-ordering fix has been applied at the only article-surface dismantle pinch-point that exists in the current working tree — `NativeArticleRepresentable.dismantleNSView` and `ArticleCoordinator.cleanup()` — and pushed.

**Owner: Rohan (manual repro on iMac).**

After `scripts/imac-pull.sh`:
1. Launch the `desktopAhaan` sanitizer scheme (NSZombie + ASan).
2. Sidebar → Science → Ch.1 → Beyond the Book → ⌘W → Try Discover Mode.
3. If clean: close `ZOMBIE_LOG_FINDINGS.md` and the corresponding `CRASH_LEDGER.md` row, archive this question.
4. If still crashes: capture the new zombie line / ASan stack / `.ips` and paste into a fresh `ZOMBIE_LOG_FINDINGS.md` — that points the next Step-2 ordering fix at the actually-affected site.

Also: the prompt's `log stream … --signpost …` invocation fails on modern macOS (`--signpost` was replaced by `--type signpost`). If you copy/paste it again on the iMac (Big Sur, older log CLI), it should work; just noting the dev-Mac syntax mismatch.

## Resolved (archived from REMEDIATION_LOG.md)

(none yet)
