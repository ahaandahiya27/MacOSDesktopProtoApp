# Social Science Subject — Readiness Report

**Date:** 2026-06-02
**Status:** Complete — all 20 NEP Grade 7 chapters + 180 articles + chapter-level enrichment + bespoke per-chapter Discover interactives (v7), all on origin/main.
**Pack:** `desktopAhaan/Subjects/Packs/socialscience_class7.json`

---

## What shipped

Social Science is the **fourth subject** in desktopAhaan, alongside Science
(`science_class7`), Maths (`maths_class7`), and Sanskrit (`sanskrit_class7`).
Registered in the Xcode bundle and decoding cleanly through `SubjectRegistry`.
Pack id `socialscience_class7`; NEP chapter ids `ssch01`–`ssch20` (the `ss`
prefix keeps every concept/question id unique across packs — enforced by
`testNoCrossPackConceptIdCollision`).

### Source

Authored from the **NEP-2020 "Exploring Society: India and Beyond" Grade 7**
textbook (the single integrated Social Science book that replaces the older
separate History / Geography / Civics / Economics titles), extracted with
`pdftotext` and adapted by hand for the Class 7 reading level.

### Per-chapter coverage

| Ch | Title | Topics | Concepts | Questions | DeepDive | Glossary |
|----|-------|:--:|:--:|:--:|:--:|:--:|
| ssch01 | Geographical Diversity of India | 5 | 16 | 20 | 6 | 23 |
| ssch02 | Understanding the Weather | 5 | 14 | 19 | 6 | 18 |
| ssch03 | Climates of India | 5 | 17 | 19 | 6 | 20 |
| ssch04 | New Beginnings: Cities and States | 5 | 15 | 19 | 6 | 17 |
| ssch05 | The Rise of Empires | 5 | 14 | 20 | 6 | 17 |
| ssch06 | The Age of Reorganisation | 5 | 15 | 19 | 6 | 16 |
| ssch07 | The Gupta Era: An Age of Tireless Creativity | 5 | 19 | 19 | 6 | 18 |
| ssch08 | How the Land Becomes Sacred | 5 | 15 | 19 | 6 | 17 |
| ssch09 | From the Rulers to the Ruled: Types of Government | 5 | 15 | 19 | 6 | 17 |
| ssch10 | The Constitution of India — An Introduction | 5 | 15 | 19 | 6 | 16 |
| ssch11 | From Barter to Money | 5 | 14 | 19 | 6 | 18 |
| ssch12 | Understanding Markets | 5 | 13 | 19 | 6 | 17 |
| ssch13 | The Story of Indian Farming | 5 | 15 | 19 | 6 | 18 |
| ssch14 | India and Her Neighbours | 5 | 17 | 19 | 6 | 17 |
| ssch15 | Empires and Kingdoms: 6th to 10th Centuries | 5 | 17 | 19 | 6 | 17 |
| ssch16 | Turning Tides: 11th and 12th Centuries | 5 | 14 | 19 | 6 | 17 |
| ssch17 | India, a Home to Many | 4 | 12 | 17 | 6 | 17 |
| ssch18 | The State, the Government, and You | 4 | 12 | 16 | 6 | 17 |
| ssch19 | Infrastructure: Engine of India's Development | 4 | 12 | 16 | 6 | 17 |
| ssch20 | Banks and the Magic of Finance | 4 | 12 | 16 | 6 | 17 |
| **Total** | | **96** | **293** | **371** | **120** | **351** |

Plus **260 boss-quiz questions** (13/chapter) and **21 authored timelines**.

### Strands (NEP integrated structure)

| Strand | Chapters |
|---|---|
| Geography | ssch01, ssch02, ssch03, ssch14 |
| History | ssch04, ssch05, ssch06, ssch07, ssch08, ssch15, ssch16 |
| Polity / Civics | ssch09, ssch10, ssch18 |
| Economics | ssch11, ssch12, ssch13, ssch19, ssch20 |
| Society | ssch17 |

### Articles (all 20 chapters)

**180 article HTML files** — 9 per chapter (Beyond-the-Book, Common Mistakes,
Glossary, Mini Project, NCERT Q&A, Spotlight, Self-Check, Story Mode,
What-Ifs) under `Resources/Articles/SocialScienceChapter{N}/`. Article keys are
subject-aware: `ChapterDetailView.resolvedArticleEntry` routes any `ssch*` key
through the Social Science branch, alongside Science (`ch*`), Maths (`mch*`),
and Sanskrit (`sch*`).

### Bespoke Discover interactives (v7 "Discover Depth", 2026-06-02)

Every SS chapter now ships a **chapter-specific Discover experience** matched to
its strand, replacing the earlier generic data-driven view. Gated by
`socialScienceInteractivesAreEnabled(forPackId:)` (pack id) **and** an exact
chapter id, so nothing leaks across subjects — pinned by
`SocialScienceInteractiveGateTests`. Examples:

- **Geography** — `IndiaPhysiographicExplorer` (ssch01), `WeatherInstrumentLab`
  (ssch02), `ClimateFactorsExplorer` (ssch03), `IndiaNeighboursExplorer` (ssch14).
- **History** — `SSChronologyChallenge` (a "put events in order" game over each
  chapter's first authored timeline, for ssch04–08, 15, 16);
  `SacredGeographyExplorer` (ssch08).
- **Polity / Civics** — `GovernmentFormsExplorer` (ssch09), `PreambleExplorer`
  (ssch10), `ThreeOrgansSorter` (ssch18).
- **Economics** — `BarterToMoneySim` (ssch11), `MarketPriceBalance` (ssch12),
  `CroppingSeasonExplorer` (ssch13), `InfrastructureSorter` (ssch19),
  `CompoundingGrowth` (ssch20).
- **Society** — `HomeToManyExplorer` (ssch17).
- **Fallback** — any chapter without a bespoke widget falls back to
  `SSGlossaryMatchChallenge` over its own ≥10-term glossary, so **every** chapter
  has ≥1 faithful, chapter-specific interactive.

## Tests & verification

- **SocialScienceContentDepthTests** — per-chapter floors (concepts, questions,
  glossary, deepDive, boss questions).
- **SocialScienceEnrichmentParityTests** — chapter-level enrichment density.
- **SocialScienceInteractiveGateTests** — every chapter resolves to a bespoke
  interactive; leak-gate mutual exclusivity (no Science/Sanskrit interactive ever
  shows on an SS chapter and vice-versa).
- **SocialScienceDiscoverModeRoutingTests** — Discover routing for `ssch*`.
- **SocialScienceArticleRoutingTests** — `ssch*` article-key resolution.
- SS also participates in the v6 cross-subject surfaces:
  `MilestoneAssessmentIntegrationTests`, `JourneyPlanIntegrationTests`,
  `LearningJourneyReadOnlyTests` (9 SS-referencing test files total).
- `verify_pack_roundtrip.py` — the pack round-trips canonical JSON
  (`json.dumps(ensure_ascii=False, indent=2) + "\n"`).
- Full `scripts/ci-build-test.sh` (Release build + unit tests + 17 static lints)
  — green on every push (810 XCTest as of v7).

## Definition-of-done

- [x] 20 NEP chapters authored from the "Exploring Society" PDF.
- [x] 180 articles shipped (9 kinds × 20 chapters).
- [x] Chapter-level enrichment populated per chapter.
- [x] 120 deepDive stretch topics + 260 boss questions.
- [x] Bespoke per-chapter Discover interactive on all 20 chapters (v7), leak-gated.
- [x] Pack round-trips canonical JSON; cross-pack id uniqueness enforced.
- [x] Content-depth + enrichment + interactive-gate + routing tests ratchet the pack.
- [x] Chapters tab surfaces Social Science alongside the other three subjects.

## Out of scope / follow-on

- **Expert Challenge "Olympiad" tier** — `deepDive.bonusQuestions` are not yet
  authored for any SS chapter (the field is absent from the SS stretch-topic
  schema), so the Olympiad tier is dormant for Social Science. The ladder
  mechanism is complete; authoring beyond-grade MCQs lights it up automatically.
  Tracked as the cross-subject Olympiad-content follow-on.
- **Big Sur authoritative build** — like all recent work, the v7 Discover/diagram
  additions were proven green on the dev Mac; final confirmation requires an iMac
  rebuild (`git pull`, Clean Build Folder ⇧⌘K, build).
- Verse/audio narration and handwriting-style rendering remain Science-pilot-led.
