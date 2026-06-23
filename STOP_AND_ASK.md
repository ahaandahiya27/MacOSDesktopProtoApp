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

## Resolved (archived from the open list)

### 2026-05-27 — Article system not subject-aware (archived 2026-06-24)
The "Open question" entry near the top carries an inline **Fixed this
iteration** resolution: `ChapterDetailView.resolvedArticleEntry` and
`ExtraReadingRow.resolvedEntry` now prepend `"m"` to the lookup key when
`pack.id == "maths_class7"`, with Maths articles namespaced under
`mch01`–`mch15`. The two deeper resolvers (`GlossarySheet`,
`ChapterGlossaryCTA`) stay Science-gated; minor follow-up tracked in
`POLISH_TODOS.md`. **Status: RESOLVED for the in-scope leak.**

### 2026-05-27 — Maths curriculum: NEP-2020 "Ganita Prakash" (archived 2026-06-24)
The autonomous prompt assumed legacy 2007 NCERT; actual PDFs are
NEP-2020 "Ganita Prakash" Grade 7. Per autonomy contract §10 trigger #1
the conservative call was made: build from actual PDFs. 15-chapter
mapping in `MATHS_BUILD_CHECKPOINT.md`. **Status: RESOLVED — no owner
action unless legacy 2007 syllabus was intended.**

### 2026-05-22 — Beyond→Discover crash iMac re-repro (still queued, owner-owned)
**Status: PENDING IMAC WALK.** Not silently archived — the defensive
dismantle-ordering fix is shipped, the `Crash_BeyondThenDiscover`
XCUITest is in the UITests target locking the fix, and `CRASH_LEDGER.md`
row C2 tracks the closure. The remaining step is owner-side: run the
sanitizer scheme on the iMac to confirm the crash is gone. This is
now folded into `IMAC_VERIFY_CHECKLIST.md` section (ii) as a
companion to row T3 (Navigation smoke UITest), since the AX grant
needed for one covers the other.

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

---

## 2026-05-31 — Duplicate dispatch: two agents given the SAME "Big Sur Compile-Safety Hardening v4" superprompt (stood down to avoid collision)

**What happened:** I (an autonomous agent) was launched on the v4
"Big Sur Compile-Safety Hardening" superprompt. After completing Phase 0
verification (origin/main `732246a`, tonight's fix already committed +
pushed, baseline lints + build + tests green), I discovered that a SECOND
agent had been given the **identical** superprompt and was executing it
concurrently in the **same working tree** — well ahead of me:

- `c9d9ada` 13:34 — extend check_viewbuilder_limit to menus + @ViewBuilder/@CommandsBuilder (Phase 1)
- `0986e7b` 13:38 — add check_mainactor_closure_refs Swift 5.5 lint (Phase 2)
- `87dd68d` 13:41 — wrap 12 @MainActor method refs in explicit closures (Phase 3, in progress)
- plus uncommitted Phase-3 edits in the working tree (ArticleBrowserView{,+PlainTextFallback},
  SoftShadowCard, QuestionDetailView, OCRTranslationScreen) actively being written.

This is NOT the safe Agent-A/B/C partition described above (those work on
DISJOINT files). It is the SAME plan, SAME files, SAME commits — true
duplication. All three commits are local-only (origin still at `732246a`,
local is 3 ahead).

**Why I stopped instead of proceeding:** with another agent actively editing
the index + working tree and committing in real time, ANY mutation from me
(file edit, `git add -A`, commit, push) would corrupt its in-flight work —
sweeping its uncommitted edits into a wrong-message commit, racing its commit
sequence, duplicating the two new lints, and ultimately producing two
competing completion sentinels + a push race. The hard invariants forbid
`--force`/`--no-verify`/destructive git, and the safe push flow can't
reconcile two agents independently advancing the same branch. So I did NOT
edit, commit, or push anything.

**Read-only verification I DID do (no tree mutation):** ran both new lints'
deterministic `--selftest` (they use embedded fixtures, independent of the
racing tree). BOTH PASS:
- `check_viewbuilder_limit.py --selftest` — 6/6 fixtures correct (CommandGroup
  11→flag, 10→pass, @ViewBuilder var 11→flag/10→pass, nested-Group bucketing→pass,
  stored @ViewBuilder closure prop→pass).
- `check_mainactor_closure_refs.py --selftest` — 3/3 fixtures correct.
The other agent's Phase 1 + 2 deliverables are sound. As of this note, the
mainactor lint is committed but **not yet wired** into pre-commit / pre-push /
test_lints.py (the other agent is presumably still in Phase 3 and will reach
Phase 4 next).

**Decision needed from owner (launcher config, not code):** de-duplicate the
overnight dispatch so two agents are never handed the identical superprompt.
The launcher (`scripts/run_overnight_v3_3agents.sh` / `run_overnight_template.sh`)
should assign each agent a distinct prompt or a distinct file/phase lease.

**No action needed on the v4 work itself** if the other agent finishes: it is
executing the plan correctly. I did not print the completion sentinel and made
no commits, precisely so the other agent's run is the single source of truth.
Final Big Sur confirmation still requires an iMac rebuild (`git pull`, Clean
Build Folder ⇧⌘K, build) regardless of which agent lands it.

---

## 2026-05-31 — Resolution (from the agent that completed the v4 run)

I am the agent the note above deferred to. Confirming the outcome so this
file stays an honest record:

- The duplicate dispatch resolved **cleanly** — the other agent stood down
  without editing/committing/pushing, so there was no commit race, no
  competing sentinel, and no corrupted in-flight work. Thank you to that
  agent for the conservative call.
- I completed all five phases. Final commits on `main`: `c9d9ada` (ViewBuilder
  extension), `0986e7b` (mainactor lint), `87dd68d` (12 method-ref fixes),
  `f6d7441` (pre-commit gating + test_lints wiring), plus the docs commit.
  Both lints are now wired into `pre-commit` and `test_lints.py`.
- **Separate anomaly, recovered:** an unrelated `git stash pop`
  (`stash@{0}: On bigsur-compat: WIP backport state`) and a sync collision
  (four untracked `" 2"` duplicate files) landed on the working tree mid-run.
  No committed work was at risk. Recovered with `git reset --merge` (NOT
  `--hard`; HEAD stayed at `87dd68d`, the stash was left intact for its owner)
  and moved the `" 2"` artifacts to `/tmp/bigsur_collision_artifacts/`.
  Post-recovery: all lints clean, `test_lints` green, dev-Mac Release build +
  full test suite green.

**STOP_AND_ASK blocker count for the v4 task itself: 0.** The only open item is
the launcher de-duplication request above (owner/infra decision, not code) so
two agents are never handed the identical superprompt in the same working tree.
Final Big Sur confirmation still requires an iMac rebuild — see
`BIGSUR_COMPILE_SAFETY_CHECKPOINT.md`.
