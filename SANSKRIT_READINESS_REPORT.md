# Sanskrit Subject — Readiness Report

**Date:** 2026-05-29
**Status:** Complete — all 15 NEP "Deepakam" Grade 7 chapters + 150 articles + chapter-level enrichment, all on origin/main.
**Pack:** `desktopAhaan/Subjects/Packs/sanskrit_class7.json`

---

## What shipped

Sanskrit is the **first NEP subject** in desktopAhaan, alongside Science
(`science_class7`) and Maths (`maths_class7`). Registered in the Xcode
bundle and decoding cleanly through `SubjectRegistry` — the sidebar
shows **"Sanskrit Kosh — 16 chapters · 367 concepts · 276 questions"**.

The 16-chapter count is intentional: 15 NEP chapters (`sch01`–`sch15`)
plus the legacy `ch01` vocab deck (*Class 7 Sanskrit Vocabulary*) which
remains as a flashcard surface and is exempt from the NEP ratchets.

### Source

Authored from the **NEP-2020 "Deepakam" Grade 7 Sanskrit** textbook PDFs
in `~/Extra/Ahaan-Books/`, extracted with `pdftotext` and adapted by
hand for the Class 7 reading level. This is the NEW NEP curriculum
(15 chapters split across grammar, śloka recitation, and storytelling),
not the older NCERT *Ruchira* syllabus.

### Per-chapter coverage

| Ch | Title | Topics | Concepts | Questions | Enrichment |
|----|-------|:--:|:--:|:--:|:--:|
| sch01 | वन्दे भारतमातरम् (Vande Bhāratamātaram) | 2 | 9 | 9 | 9/9 |
| sch02 | नित्यं पिबामः सुभाषितरसम् (Nityaṃ Pibāmaḥ) | 2 | 9 | 9 | 9/9 |
| sch03 | मित्राय नमः (Mitrāya Namaḥ) | 2 | 8 | 8 | 9/9 |
| sch04 | न लभ्यते चेत् आम्लं द्राक्षाफलम् | 2 | 7 | 8 | 9/9 |
| sch05 | सेवा हि परमो धर्मः | 2 | 8 | 8 | 9/9 |
| sch06 | क्रीडाम वयं श्लोकान्त्याक्षरीम् | 2 | 8 | 8 | 9/9 |
| sch07 | ईशावास्यम् इदं सर्वम् | 2 | 8 | 8 | 9/9 |
| sch08 | हितं मनोहारि च दुर्लभं वचः | 2 | 8 | 8 | 9/9 |
| sch09 | अन्नाद् भवन्ति भूतानि | 2 | 8 | 8 | 9/9 |
| sch10 | दशमः कः? (Daśamaḥ Kaḥ?) | 2 | 8 | 8 | 9/9 |
| sch11 | द्वीपेषु रम्यः द्वीपोऽण्डमानः | 2 | 8 | 8 | 9/9 |
| sch12 | वीराङ्गना पन्नाधाया (Vīrāṅganā Pannādhāyā) | 2 | 8 | 8 | 9/9 |
| sch13 | वर्णमात्रा-परिचयः (Varṇa-Mātrā) | 2 | 8 | 8 | 9/9 |
| sch14 | शब्दरूपाणि (Śabda-Rūpāṇi) | 2 | 8 | 8 | 9/9 |
| sch15 | धातुरूपाणि (Dhāturūpāṇi) | 2 | 8 | 8 | 9/9 |
| **Total (sch only)** | | **30** | **121** | **122** | |

Enrichment = how many of the 9 chapter-level surfaces — glossary,
mnemonics, misconceptions, realWorldExamples, ncertQA, whatIfs,
miniProjects, scientists/grammarian-spotlights, conceptMap — are
populated. All 15 NEP chapters land at the full 9/9.

### Articles (all 15 chapters)

**150 article HTML files** — 10 per chapter, covering Beyond-the-Book,
Common Mistakes, Glossary, Mini Project, NCERT Q&A, Scientist /
Grammarian Spotlight, Self-Check, Story Mode, What-Ifs, and the
chapter-level Mistakes index — generated into
`Resources/Articles/SanskritChapter{N}/`. Article keys are subject-
aware: `ChapterDetailView.resolvedArticleEntry` routes any `sch*` key
through the Sanskrit branch, alongside the existing Science (`ch*`)
and Maths (`mch*`) branches.

### Chapter detail surfaces

After the 2026-05-29 enrichment backfill, every NEP chapter activates
the full ChapterDetailView stack: GlossarySheet chip, MisconceptionsSectionView,
NcertQASectionView, WhatIfsSectionView, MiniProjectsSectionView,
ScientistsSectionView, ConceptMapView CTA, RealWorldExamples,
MnemonicsSection.

Per-chapter floors (`CrossSubjectEnrichmentParityTests`):

| Field | Floor |
|---|---|
| glossary | 7 |
| mnemonics | 3 |
| misconceptions | 5 |
| realWorldExamples | 3 |
| ncertQA | 5 |
| whatIfs | 3 |
| miniProjects | 1 |
| scientists | 1 |
| conceptMap.nodes | 6 |

Concept maps each include one cross-chapter pointer
(`sch{N} → sch{(N % 15) + 1}`).

## Tests & verification

- **CrossSubjectEnrichmentParityTests** (4 cases) — ratchets the per-
  chapter density across all 3 packs (science / maths / sanskrit sch*)
  and pins the legacy `ch01` vocab deck identity so it can't morph
  into an NEP chapter without flipping the exempt list explicitly.
- **CrossPackReviewResolutionTests** — confirms colliding bare ids
  (`ch01_t01_q01` exists in both science and maths) resolve through
  `preferredPackId` so Recently Missed / Daily Practice attribute
  reviews to the right subject.
- Sibling routing ratchets (Beyond/SelfCheck/StoryMode/WhatIf/
  MiniProject/Scientists/Glossary/Mistakes/NcertQa/ExtraReadingRow)
  all extended pack-aware for the `sch` prefix.
- `verify_pack_roundtrip.py` — all 3 packs round-trip canonically
  (`json.dumps(ensure_ascii=False, indent=2) + "\n"`).
- Full `scripts/ci-build-test.sh` (Release build + unit tests + 10
  static lints) — green on every push.
- All inherited subject-agnostic surfaces work for Sanskrit
  automatically: ChapterDetail sections, ConceptDetail (predictQuestion
  + whyChain), QuestionDetail (hint ladder), MasteryDashboard, Daily
  Practice/SRS, Search, Bookmarks, ConceptMapView.

## Definition-of-done

- [x] 15 NEP chapters authored from the Deepakam PDFs.
- [x] 150 articles shipped (10 kinds × 15 chapters).
- [x] 9/9 enrichment surfaces populated per chapter.
- [x] Pack round-trips canonical JSON.
- [x] Parity test ratchets all three packs.
- [x] Chapters tab surfaces Sanskrit alongside Science and Maths.
- [x] Sidebar count reads 16 chapters / 367 concepts / 276 questions.
- [x] Legacy `ch01` vocab deck preserved and isolated.

## Out of scope

- Discover Mode for Sanskrit chapters (Science Ch.10 pilot still the
  reference; Maths Ch.10 is the only other shipped pilot).
- Native handwriting-style Devanagari rendering — bundled NotoSans
  Devanagari is the current default.
- Verse-by-verse audio for the recitation chapters; the Read Aloud
  WKWebView path covers prose articles.
