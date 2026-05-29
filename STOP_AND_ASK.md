# Stop-and-Ask — desktopAhaan (12-hour session)

Per §E of the 12-hour spec, this file is only written for the six exception conditions. Otherwise: decide and continue.

## Open questions

### 2026-05-27 — RESOLVED: Maths articles now ship via subject-aware (mch-prefix) keying

**Resolution (implemented):** chose option (b) — Maths article ids are namespaced
with an `m` prefix (`mch01_mistakes`, `mch01_glossary`, `mch01_ncert_qa`). The
key derivation now lives in ONE place: `ChapterDetailView.resolvedArticleEntry`
and `ExtraReadingRow.resolvedEntry` prepend `"m"` to the lookup key when
`pack.id == "maths_class7"`, so the existing card logic (`{chapter.id}_mistakes`
etc.) resolves to `mch…` for Maths and `ch…` for Science with no collision and
no call-site changes. 45 Maths article HTML files (mistakes/glossary/ncert_qa
× 15 chapters) were generated from the pack via `/tmp/gen_maths_articles.py`,
registered in `ArticleIndex.entries`, and bundled (verified in the built app).
Every Maths chapter now shows a Common-Mistakes card + Vocabulary-Deck and
NCERT-Q&A reading chips. The two deeper glossary resolvers (GlossarySheet,
ChapterGlossaryCTA) still lack `pack` and remain Science-gated (minor, noted).

--- original entry (kept for history) ---

### 2026-05-27 — Article system is not subject-aware (Maths reuses ch01… ids); design decision needed for Maths articles

`ArticleIndex.entries` is keyed by bare chapter/topic/concept id (`ch01`,
`ch01_mistakes`, `ch01_glossary`, …) with no pack/subject qualifier. Maths
chapters use the same ids (`ch01`…`ch15`), so a Maths chapter mis-resolves to
**Science's** same-id article. This was a live cross-subject leak (e.g. Maths
Ch.1's "Common Mistakes" card linked to Science's *Nutrition in Plants*
article).

**Fixed this iteration (pack guard, mirroring `DiscoverMode.hasExperience`):**
- `ChapterDetailView.resolvedArticleEntry(forKey:)` — guards `pack.id == "science_class7"`
  (covers the Common Mistakes card + the glossary-article handoff `openGlossaryArticleFromSheet`).
- `ChapterDetailView` line ~112 — the `ExtraReadingRow(chapter:)` invocation is
  now wrapped in `if pack.id == "science_class7"`.

**Still leaking — need `pack` threaded through (not in scope there):**
- `GlossarySheet.swift:~128` — its internal article resolver (the glossary
  sheet itself shows the correct Maths glossary terms; only the optional
  "read full article" handoff would resolve to Science). `GlossarySheet` has
  only `let chapter`, no `pack`.
- `ConceptDetailView+ChapterGlossaryCTA.swift:~27` — `ChapterGlossaryCTA` is a
  separate struct without `pack`.

**Decision for the human:** to ship *actual Maths articles* (not just stop the
leak), article ids must become subject-aware. Two options: (a) prefix keys with
the pack id (e.g. `maths_class7/ch01_overview`) and thread `pack` into every
resolver + GlossarySheet/ChapterGlossaryCTA initialisers; or (b) namespace
Maths article ids as `mch01_…` AND change the key derivation in ChapterDetailView
to use a subject-prefix. Either is a cross-cutting change touching ~4 files and
the article folder convention — out of scope for an autonomous content
iteration, so deferred here for a deliberate design choice.

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

---

## 2026-05-30 — Agent C: push to origin deferred (environmental, not code)

**Status of work:** COMPLETE. All Distribution + Onboarding deliverables are
committed locally on `main` and are part of the shared HEAD `de6ce38`:
- `211fce7` feat(dist): onboarding tour + DMG packaging + parent docs
- `d04a1af` chore(dist): wire onboarding into target + checkpoint/log/gitignore
- (`de6ce38` is Agent A's commit stacked on top; my two commits are ancestors)

**Verified in isolation:** full app target builds; `OnboardingFirstLaunchTests`
(10) + `OnboardingSkipTests` (3) = 13/13 green via a direct `xcodebuild` run on
an isolated DerivedData. `check_release_build.sh` passes (zero-warning Release
build, entitlements, icons, deploy target).

**Blocker (deferred, not stopped):** the pushes could not complete because the
pre-push gate (`scripts/ci-build-test.sh`) **deadlocks/OOM-kills under 3-way
parallel contention**. Root cause: every agent's `ci-build-test.sh` uses the
same `TMPDIR` DerivedData (`/tmp/claude-501/desktopAhaan-ci-derived`), so
concurrent gate runs (observed 7–8 simultaneous `xcodebuild` processes)
corrupt each other's build artifacts and starve memory. One run hung 37+ min
on `BossQuizSRSWiringTests.testEvery19ChaptersHasBossQuizSRSWiring` (normally
milliseconds). This is environmental — not caused by any Agent C change.

**Resolution in flight (no human action required if agents finish overnight):**
- A background watcher (`/tmp/agentC_push_watcher.sh`, log
  `/tmp/agentC_push_watcher.log`) lands the push automatically once machine
  contention drops, using an **isolated** DerivedData (`CI_DERIVED_OVERRIDE`)
  so the gate can't be corrupted by other agents' builds.
- Independently, the moment **any** agent lands a clean push of `de6ce38` (or a
  descendant), Agent C's work ships too, since `211fce7`/`d04a1af` are ancestors.

**If still un-pushed in the morning:** from a quiet machine (no other
`xcodebuild` running), run:
```
cd <repo>
git pull --rebase --autostash origin main
CI_DERIVED_OVERRIDE=/tmp/dd-agentC-isolated git push origin main
```
No `--no-verify` / `--force` was ever used for a push; the gate must pass.

**Suggested infra fix (out of Agent C's domain — scripts/ owned elsewhere):**
make `ci-build-test.sh`'s DerivedData unique per-invocation (e.g. include
`$$`) so parallel agent gates never share build artifacts.
