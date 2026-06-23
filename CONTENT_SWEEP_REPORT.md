# Content Sweep Report — 2026-06-23

End-of-day content-integrity pass across the four shipping streams plus
the standing Y3 per-concept page-ref backfill. Report-first protocol:
inventory + cross-check; fix only unambiguous, low-risk issues; log any
judgment-call work for the owner instead of guessing. Per-commit gate
applies to any fix.

**Result: every stream is integrity-clean. Zero fixes applied this
turn. Y3 flipped to ✅** (the remaining gap is the documented Sanskrit
`ch01` legacy-vocabulary carve-out, not a missing-data bug).

---

## 1. TestPapers — clean

Authoritative location: `desktopAhaan/Resources/TestPapers/`
(1,380 files = base + Advanced + P3/P4/P5).

| Subject | Chapters | Bases | P3 | P4 | P5 | Advanced MDs | Status |
|---------|---------:|------:|---:|---:|---:|-------------:|--------|
| Maths | 15 | 15 | 15 | 15 | 15 | 15 | ✅ |
| Science | 19 | 19 | 19 | 19 | 19 | 19 | ✅ |
| Sanskrit | 15 | 15 | 15 | 15 | 15 | 15 | ✅ |
| Social Science | 20 | 20 | 20 | 20 | 20 | 20 | ✅ |
| **Total** | **69** | **69** | **69** | **69** | **69** | **69** | ✅ |

Checks run:
- Every chapter has bases + P3 + P4 + P5 variants (no missing variant PDFs).
- Per-variant 4-file completeness (`.pdf` + `.html` + `_QuestionPaper.md` + `_Solutions.md`).
- No blank/truncated `.md` files (`find … -size -32c` returned empty).
- `OlympiadPaperRegistry.allPapers.count == 345` (138 base/advanced + 207 P3/P4/P5) and `OlympiadPaperVariantTests` pin every variant's 4 bundled files resolve via `Bundle.main.url(...)`.

**Findings: 0 discrepancies. 0 fixes applied.**

## 2. BrutalSeries — clean

Authoritative location: `desktopAhaan/Resources/BrutalSeries/`
(130 files = 63 papers × 2 + MANIFEST + INDEX + REFERENCE pair).

| Check | Result |
|---|---|
| `Paper_B<NN>_Questions.pdf` count (B01..B63) | 63 ✅ |
| `Paper_B<NN>_Solutions.html` count | 63 ✅ |
| Q→Sol pair completeness (every PDF has a matching HTML) | 0 missing ✅ |
| Orphan `_Solutions.html` (no matching PDF) | 0 ✅ |
| `MANIFEST.md` row count (`- Paper B` lines) vs PDF count | 63 == 63 ✅ |
| `BRUTAL_INDEX.json` parses + has `fingerprints` / `combos` / `papers` keys | 12,065 entries indexed ✅ |
| `BrutalSeriesPapersCatalogTests` pinning shape + bundle resolution | 8/8 cases green ✅ |

**Findings: 0 discrepancies. 0 fixes applied.**

## 3. Boss Challenge Papers — clean

Authoritative location: `desktopAhaan/Resources/BossChallengePapers/`
(218 files = 55 numbered Paper_NN ×{PDF+HTML(08+)+QuestionPaper.md+Solutions.html} + Boss_Paper_00 trio + manifest + index).

| Check | Result |
|---|---|
| Numbered `Paper_NN_QuestionPaper.pdf` (1..55) | 55 ✅ |
| Numbered `Paper_NN_Solutions.html` | 55 ✅ |
| Numbered `Paper_NN_Questions.md` | 55 ✅ |
| `Boss_Paper_00_*` trio (MCQ_Questions.pdf + Questions.md + Solutions.html) | 3/3 ✅ |
| Orphan `_Solutions.html` (no matching `_QuestionPaper.pdf`) | 0 ✅ |
| Papers 01–07 PDF-only QP shape (original set) | 7 ✅ as designed |
| Papers 08–55 dual-format (PDF + HTML) QP shape | 48 ✅ as designed by the factory |
| `PAPERS_MANIFEST.md` row count vs paper count | 55 == 55 ✅ |
| `BossChallengePapersCatalogTests` pinning shape + bundle resolution | 5/5 cases green ✅ |

**Findings: 0 discrepancies. 0 fixes applied.**

Note: papers 08–55 ship an extra `_QuestionPaper.html` alongside the
`_QuestionPaper.pdf` (a dependency-free fallback the factory writes
in addition to PDF). The catalog surfaces only the PDF — the HTML is
bundled-but-inert. Flagged for awareness in the BrutalSeries commit
(`5c538d2`); not a defect.

## 4. Y3 — Per-concept pageRefs — closed

Pack-wide scan of `desktopAhaan/Subjects/Packs/*_class7.json`.

| Pack | Concepts | With `pageRefs` | Without | Chapter-range-only |
|------|---------:|----------------:|--------:|-------------------:|
| `maths_class7` | 90 | **90 (100%)** | 0 | 0 |
| `science_class7` | 207 | **207 (100%)** | 0 | 0 |
| `socialscience_class7` | 293 | **293 (100%)** | 0 | 0 |
| `sanskrit_class7` | 367 | 121 (33%) | 246 | 0 |
| **TOTAL** | **957** | **711 (74%)** | 246 | **0** |

The 246 Sanskrit concepts without `pageRefs` are **all in chapter
`ch01`** — the legacy vocabulary deck (`अहम् — I`, `भवान् — you (respectful)`,
…). This is the documented **Sanskrit `ch01` carve-out** declared in
`CLAUDE.md`:

> Sanskrit `ch01` carve-out: the legacy vocabulary deck stays at `ch01`
> and is intentionally exempt from the NEP cross-subject parity ratchets.
> NEP chapters use `sch01`–`sch15` additively.

The vocab deck entries are curated word lists, not textbook excerpts —
they have no natural page reference. **Every NEP textbook concept**
(`maths`, `science`, `socialscience`, Sanskrit `sch01`–`sch15`) **carries
precise `pageRefs`** (0 chapter-range-only). Y3's "per-concept pageRefs
audit remains for a future pass" note in `docs/ISSUE_CATEGORIES.md` is
satisfied: there is no remaining textbook content with imprecise refs.

**Y3 flipped 🟡 → ✅** in the same commit as this report, with the
carve-out cited verbatim in the row note so a future maintainer
doesn't re-open it.

## Roll-up

| Stream | Files inspected | Discrepancies | Fixes applied | Status |
|--------|----------------:|--------------:|--------------:|--------|
| TestPapers | 1,380 | 0 | 0 | ✅ |
| BrutalSeries | 130 | 0 | 0 | ✅ |
| Boss Challenge | 218 | 0 | 0 | ✅ |
| Y3 concept pageRefs | 957 concepts | 0 (all "without" are the documented ch01 carve-out) | 0 | ✅ |
| **TOTAL** | **1,728 + 957** | **0** | **0** | **✅** |

Lint coverage that locks the state going forward:
- `scripts/check_testpaper_triplet.py` — every bundled `_QuestionPaper.md`
  has its `_Solutions.md` (and `_SolvedGuide.html` for base/Advanced).
  P3/P4/P5 variants are exempted from the SolvedGuide requirement via
  `_is_practice_variant(stem)`.
- `scripts/check_pack_schema.py` — pack JSON parses + no duplicate IDs.
- `BrutalSeriesPapersCatalogTests`, `BossChallengePapersCatalogTests`,
  `OlympiadPaperVariantTests` — every emitted filename must resolve to
  a real bundle file. A drop in any future commit fails the test gate.

## Judgment-call items flagged for the owner

**None.** Every finding was either clean or a documented carve-out
already recorded in `CLAUDE.md` / `docs/ISSUE_CATEGORIES.md`. No
content-rewrite decisions were left dangling.

---

**Conclusion**: dev-Mac work (code + content) is complete. The only
remaining path to a pure / issue-less state is the iMac visual
verification walk in `IMAC_VERIFY_CHECKLIST.md` and the standing
content-generation loop (the factory pushes new Boss / Brutal papers;
the existing lints + catalog tests catch any structural regression in
those automatically).
