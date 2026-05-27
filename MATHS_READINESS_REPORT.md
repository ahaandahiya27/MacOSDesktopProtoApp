# Maths Subject — Readiness Report

**Date:** 2026-05-27
**Status:** Complete — all 15 NEP Grade 7 chapters + articles + a Discover Mode pilot, all on origin/main.
**Pack:** `desktopAhaan/Subjects/Packs/maths_class7.json`

---

## What shipped

Maths is the **third subject** in desktopAhaan, alongside Science and Sanskrit.
Registered in the Xcode bundle and decoding cleanly through `SubjectRegistry` —
the sidebar shows **"Maths — Class 7 · 90 concepts · 148 questions"**.

### Source

Authored from the **NEP-2020 "Ganita Prakash" Grade 7** textbook PDFs (two
parts, 8 + 7 chapters) in `~/Extra/Ahaan-Books/`, extracted with `pdftotext`.
This is the NEW NEP curriculum, not the legacy NCERT Class 7 syllabus the
original superprompt assumed — see `STOP_AND_ASK.md` (2026-05-27). Every
chapter is grounded in its specific PDF (characters, examples, page refs).

### Per-chapter coverage

| Ch | Title | Topics | Concepts | Questions | Enrichment |
|----|-------|:--:|:--:|:--:|:--:|
| 1 | Large Numbers Around Us | 6 | 17 | 26 | 8/8 |
| 2 | Arithmetic Expressions | 4 | 10 | 15 | 7/8 |
| 3 | A Peek Beyond the Point (decimals) | 5 | 7 | 13 | 7/8 |
| 4 | Expressions Using Letter-Numbers (algebra) | 3 | 5 | 10 | 7/8 |
| 5 | Parallel and Intersecting Lines | 4 | 8 | 11 | 7/8 |
| 6 | Number Play | 4 | 6 | 10 | 7/8 |
| 7 | A Tale of Three Intersecting Lines (triangles) | 4 | 5 | 7 | 7/8 |
| 8 | Working with Fractions | 3 | 4 | 8 | 7/8 |
| 9 | Geometric Twins (congruence) | 3 | 4 | 6 | 7/8 |
| 10 | Operations with Integers | 2 | 4 | 8 | 7/8 |
| 11 | Finding Common Ground (HCF/LCM) | 3 | 4 | 8 | 7/8 |
| 12 | Another Peek Beyond the Point (decimal ops) | 3 | 4 | 6 | 7/8 |
| 13 | Connecting the Dots (data handling) | 3 | 4 | 7 | 8/8 |
| 14 | Constructions and Tilings | 3 | 4 | 6 | 7/8 |
| 15 | Finding the Unknown (equations) | 3 | 4 | 7 | 8/8 |
| **Total** | | **53** | **90** | **148** | |

(Enrichment = how many of the 8 chapter-level surfaces — glossary, mnemonics,
misconceptions, realWorldExamples, ncertQA, miniProjects, scientists/
mathematicians, conceptMap — are populated.)

### Depth per item

- **Every concept**: 4 explanation depths (oneLine/kidFriendly/textbook/expert)
  + reasoning + ≥3 useCases + beyondTheBook + mnemonic + predictQuestion (ends
  in `?`) + 3-layer whyChain.
- **Every question**: solutionSteps + ≥1 commonMistakes + ≥2 variations, difficulty 1–5.
- **Every chapter**: glossary (≥10), mnemonics (≥3), misconceptions (≥5),
  realWorldExamples (≥3), ncertQA (≥8), a miniProject, and a conceptMap (8–12
  nodes) with cross-chapter links. Indian-mathematician profiles where they fit
  (Āryabhaṭa, Brahmagupta, Mahalanobis).

### Articles (all 15 chapters)

45 article HTML files — `mch{NN}_mistakes`, `mch{NN}_glossary`, `mch{NN}_ncert_qa`
— generated from pack data into `Resources/Articles/MathsChapter{N}/`. Article
keys are subject-aware: `ChapterDetailView.resolvedArticleEntry` and
`ExtraReadingRow.resolvedEntry` prepend `m` for `pack.id == "maths_class7"`, so
Maths resolves `mch…` and Science resolves `ch…` with no collision. Each Maths
chapter surfaces a Common-Mistakes card + Vocabulary-Deck and NCERT-Q&A chips.

### Discover Mode (Ch.10 pilot)

`DiscoverChapterMath10View` (Operations with Integers) — 4 Big-Sur-safe scenes:
number-line intro, adding-integers quick-check, sign-rules card + quick-check,
and a 4-question integer boss quiz. `DiscoverMode.hasExperience` / `view(for:)`
route `maths_class7` / `ch10`; namespaced via `discoverScene(110)` and chapterId
`mch10` to avoid cross-subject state collisions with Science's Ch.10.

## Tests & verification

- **MathsChapterContentTests** (11 cases): 15 chapters in order, ≥82 concepts /
  ≥132 questions, 4 depths, predictQuestion `?`, 3-layer whyChain, ≥3 useCases,
  solutionSteps + ≥2 variations, enrichment floors, conceptMap resolution, and
  **no duplicate concept/question ids**.
- Science article-routing ratchets scoped to `ch…` keys (exclude Maths `mch…`).
- `check_pack_schema.py`, `verify_pack_roundtrip.py`, full `ci-build-test.sh`
  (build + unit tests + lints) — green on every push.
- All inherited subject-agnostic surfaces work for Maths automatically:
  ChapterDetail sections, ConceptDetail (predictQuestion + whyChain),
  QuestionDetail (hint ladder), MasteryDashboard, Daily Practice/SRS, Search,
  Bookmarks, ConceptMapView.

## Definition-of-done

- [x] All 15 NEP Grade 7 chapters present.
- [x] Every chapter meets the content checklist (7–8/8 enrichment each).
- [x] Sidebar shows "Maths — Class 7 · 90 concepts · 148 questions".
- [x] Schema + roundtrip + Swift Decodable + full gate green.
- [x] All commits pushed to origin/main; pre-push gate green every time.
- [x] Articles: all 15 chapters (mistakes/glossary/ncert_qa), subject-aware keying.
- [x] Discover Mode: Ch.10 pilot (4 scenes).
- [x] Maths schema-integrity tests shipped.
- [ ] **iMac end-to-end walk** — pull on the deploy iMac, build, and use a Maths
      chapter (incl. the Discover scenes) by hand. The dev-Mac gate can't drive
      the AX/UI path; this is the one verification only you can run.

## Remaining / optional follow-ups

1. **iMac walk** (above) — the only true to-do.
2. **More Discover chapters** — Ch.10 is the pilot; the same pattern extends to
   Ch.15 (equation balance), Ch.11 (HCF tiling), etc. Plan in the checkpoint.
3. **Two deeper glossary-article resolvers** (`GlossarySheet`, `ChapterGlossaryCTA`)
   still lack `pack` and remain Science-gated — minor, noted in STOP_AND_ASK.

**Bottom line:** the Maths subject is complete and shippable — 15 chapters of
multi-depth content, 148 worked questions with SRS, concept maps, articles on
every chapter, and an interactive Discover pilot. The only step left is a manual
run on the deploy iMac.
