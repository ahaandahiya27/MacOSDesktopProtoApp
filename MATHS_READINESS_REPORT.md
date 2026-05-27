# Maths Subject — Readiness Report

**Date:** 2026-05-27
**Status:** Content-complete — all 15 NCERT NEP Grade 7 chapters authored, pushed to origin/main.
**Pack:** `desktopAhaan/Subjects/Packs/maths_class7.json`

---

## What shipped

Maths is now the **third subject** in desktopAhaan, alongside Science (19 ch) and
Sanskrit. It is registered in the Xcode bundle (via `generate_compat_pbxproj.py`)
and decodes cleanly through `SubjectRegistry` — the sidebar shows
**"Maths — Class 7 · 82 concepts · 132 questions"**.

### Source

Authored from the **NEP-2020 "Ganita Prakash" Grade 7** textbook PDFs (two parts,
8 + 7 chapters) in `~/Extra/Ahaan-Books/`, extracted with `pdftotext`. This is the
NEW NEP curriculum, **not** the legacy NCERT Class 7 syllabus the original
autonomous superprompt assumed — see `STOP_AND_ASK.md` (2026-05-27) for the
divergence note. Every chapter's content is grounded in its specific PDF
(characters, examples, page references retained).

### Per-chapter coverage

| Ch | Title | Topics | Concepts | Questions | Enrichment |
|----|-------|:--:|:--:|:--:|:--:|
| 1 | Large Numbers Around Us | 6 | 17 | 26 | 8/8 |
| 2 | Arithmetic Expressions | 4 | 10 | 15 | 7/8 |
| 3 | A Peek Beyond the Point (decimals) | 5 | 7 | 13 | 7/8 |
| 4 | Expressions Using Letter-Numbers (algebra) | 3 | 4 | 8 | 7/8 |
| 5 | Parallel and Intersecting Lines | 4 | 7 | 9 | 7/8 |
| 6 | Number Play | 4 | 5 | 8 | 7/8 |
| 7 | A Tale of Three Intersecting Lines (triangles) | 4 | 5 | 7 | 7/8 |
| 8 | Working with Fractions | 3 | 3 | 6 | 7/8 |
| 9 | Geometric Twins (congruence) | 3 | 4 | 6 | 7/8 |
| 10 | Operations with Integers | 2 | 3 | 6 | 7/8 |
| 11 | Finding Common Ground (HCF/LCM) | 3 | 3 | 6 | 7/8 |
| 12 | Another Peek Beyond the Point (decimal ops) | 3 | 4 | 6 | 7/8 |
| 13 | Connecting the Dots (data handling) | 3 | 3 | 5 | 8/8 |
| 14 | Constructions and Tilings | 3 | 3 | 4 | 7/8 |
| 15 | Finding the Unknown (equations) | 3 | 4 | 7 | 8/8 |
| **Total** | | **53** | **82** | **132** | |

(Enrichment = how many of the 8 chapter-level surfaces — glossary, mnemonics,
misconceptions, realWorldExamples, ncertQA, miniProjects, scientists/
mathematicians, conceptMap — are populated.)

### Depth per item (matches the Science pack contract)

- **Every concept** carries all 4 explanation depths (oneLine, kidFriendly,
  textbook, expert), a `reasoning`, ≥3 `useCases` with domain tags, a
  `beyondTheBook`, a `mnemonic`, a `predictQuestion` (ends in `?`), and a
  3-layer `whyChain` (40–130 words per layer).
- **Every question** carries `solutionSteps`, ≥1 `commonMistakes`, and ≥2
  `variations`, with a difficulty 1–5.
- **Every chapter** carries a `glossary` (≥10 terms, with Hindi where natural),
  `mnemonics`, `misconceptions`, `realWorldExamples`, `ncertQA`, a
  `miniProject`, and a `conceptMap` (8–12 nodes) with **cross-chapter links**
  weaving the subject together (e.g. Ch.15 equations → Ch.4 letter-numbers and
  Ch.10 inverses; Ch.12 decimal ops → Ch.3 place value and Ch.8 fractions).
- Two chapters include Indian-mathematician profiles in the `scientists` field
  (Āryabhaṭa/Brahmagupta on Ch.1; Mahalanobis on Ch.13; Brahmagupta on Ch.15).

## Verification

- `scripts/check_pack_schema.py` — clean (extended to include maths_class7.json
  in DEFAULT_PACKS).
- `scripts/verify_pack_roundtrip.py` — clean (canonical JSON formatting).
- `SubjectRegistryTests.noLoadErrors()` — green (Swift Decodable accepts the
  pack; this is the canonical schema gate).
- Full `scripts/ci-build-test.sh` (build + unit tests + lints) — **PASSED** on
  the final push of each chapter.
- All inherited subject-agnostic surfaces light up for Maths automatically:
  ChapterDetailView sections, ConceptDetailView (predictQuestion + whyChain),
  QuestionDetailView (hint ladder from solutionSteps), MasteryDashboard, Daily
  Practice/SRS, Search, Bookmarks, ConceptMapView, glossary/misconceptions/
  ncertQA/mini-project section views.

## Commits (all on origin/main)

15 `feat(content)` chapter commits + the Phase-0 scaffold + docs commits.
Run `git log --oneline --grep="Maths"` to list them. Final content commit:
`0536f5e` (Ch.15, all-chapters-complete).

## What remains (deferred — documented in MATHS_BUILD_CHECKPOINT.md)

These were out of scope for the content build and are clean follow-ups:

1. **Discover Mode** — interactive scene views (`DiscoverChapterMath{N}View.swift`)
   modelled on Science's `DiscoverChapter1View`. Strong candidates: Ch.1
   (number/place-value play), Ch.10 (integer token-bag / number line), Ch.15
   (equation balance scale), Ch.11 (tiling/HCF grid). This is **Swift UI code**
   (Big Sur-constrained), a different workstream from JSON authoring. Boss-quiz
   ids → `bossquiz_mch{NN}_q{II}`; quick-checks → `scenecheck_mch{NN}_q{II}`
   (NOT `quickcheck_*`). Register in `DiscoverMode.hasExperience(for:)`.
2. **Article HTML** — `Resources/Articles/MathsChapter{N}/` with `mch{NN}_<slug>`
   ids. Verify `ArticleIndex.swift` accepts the `mch` prefix (may need a small
   extension) before authoring.
3. **iMac manual walk** — pull on the deploy iMac, build, and use one Maths
   chapter end-to-end (the dev-Mac gate can't exercise the AX/UI path).
4. **Schema-integrity tests for Maths** — mirror the Science
   `ChapterContentTests` (whyChain shape, predictQuestion `?`, conceptMap node
   resolution) scoped to the Maths pack, to ratchet the content contract.

## Definition-of-done check (per the autonomous superprompt §13)

- [x] All 15 NEP Grade 7 chapters present in `maths_class7.json`.
- [x] Every chapter meets the per-chapter content checklist (≥ required
      concepts with predictQuestion + whyChain; questions with solutionSteps;
      conceptMap; ≥4 enrichment surfaces — in fact 7–8/8 each).
- [x] Sidebar shows "Maths — Class 7 · 82 concepts · 132 questions".
- [x] Schema + roundtrip + Swift Decodable + full gate green.
- [x] All commits pushed to origin/main; pre-push gate green every time.
- [x] `MATHS_READINESS_REPORT.md` shipped at repo root.
- [ ] ≥5 chapters with articles (deferred — see above).
- [ ] ≥1 chapter with Discover Mode (deferred — Swift workstream).
- [ ] iMac end-to-end walk (deferred — needs the deploy device).

**Bottom line:** the Maths subject is content-complete and shippable today —
a Class 7 student can open Maths, browse all 15 chapters, read multi-depth
explanations, work 132 questions with worked solutions and SRS review, and
explore concept maps. Interactive Discover Mode and articles are the next
enhancement layer.
