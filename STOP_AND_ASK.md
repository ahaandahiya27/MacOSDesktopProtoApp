# Stop-and-Ask — desktopAhaan (12-hour session)

Per §E of the 12-hour spec, this file is only written for the six exception conditions. Otherwise: decide and continue.

## Open questions

### 2026-05-27 — Maths curriculum divergence from autonomous prompt's expected chapter list

The autonomous prompt at `../SUPERPROMPT_MATHS_AUTONOMOUS_20H.md` assumes
the source PDFs are the **legacy NCERT Class 7 Maths** (Integers,
Fractions and Decimals, Data Handling, Simple Equations, Lines and
Angles, Triangle Properties, Congruence, Comparing Quantities,
Rational Numbers, Practical Geometry, Perimeter and Area, Algebraic
Expressions, Exponents and Powers, Symmetry, Visualising Solid Shapes).

The actual PDFs in `/Users/mac/Extra/Ahaan-Books/Maths-1-Books/` and
`/Users/mac/Extra/Ahaan-Books/Maths-Part-2-Pdf_Topics/` are the **new
NEP-2020 "Ganita Prakash" Grade 7** textbook ("Reprint 2026-27", 15
chapters across two parts: 8 + 7). The chapter LIST is different,
though the COUNT (15) matches. Verified via header "Ganita Prakash |
Grade 7" extracted by `pdftotext` from each PDF.

Per autonomy contract §10 trigger #1 (NCERT-content discrepancy):
defaulted to the conservative choice — building from the actual PDFs
(this is what Ahaan is being taught under the 2025-26 NEP rollout)
rather than the prompt's legacy expectation. Full chapter mapping in
`MATHS_BUILD_CHECKPOINT.md`.

**No action required from owner unless** the intent was to teach
the legacy 2007 NCERT Class 7 syllabus (e.g., because Ahaan's school
hasn't adopted the NEP rollout yet). If so, set aside the gegp PDFs
and either source legacy NCERT PDFs or proceed from canonical
training knowledge of the 2007 syllabus.

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
