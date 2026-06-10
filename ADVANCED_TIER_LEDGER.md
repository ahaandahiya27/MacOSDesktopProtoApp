# ADVANCED_TIER_LEDGER.md — `_Advanced_` test-paper tier coverage

The bundled SolvedGuide stream (`desktopAhaan/Resources/TestPapers/`) ships, per
chapter, a base triplet (QuestionPaper.md + Solutions.md + SolvedGuide.html) and,
for the **Advanced** tier, a parallel `_Advanced_` triplet — a harder 60-MCQ
Olympiad-style paper that does NOT repeat any question from the base paper.

This ledger is the per-chapter ✅/❌ grid for the Advanced tier. It is **sourced
by** `scripts/check_testpaper_triplet.py` (which hard-gates triplet completeness)
and tracked under `docs/ISSUE_CATEGORIES.md` row **Y5**.

## Authoring contract (per Advanced chapter)
- **60 single-correct MCQs**, options (A)–(D); marking **+4 / −1 / 0**, max **240**,
  suggested **90 min**. Mirror the gold-standard header of
  `Maths_Ch15_FindingTheUnknown_Advanced_QuestionPaper.md`.
- Questions are **beyond-grade reach** but grounded in the chapter's pack JSON and
  the source PDFs under `/Users/mac/Extra/Ahaan-Books/`. Must NOT duplicate the
  base paper.
- `_Solutions.md`: every answer keyed `**N. (X)**` followed by worked prose; teach
  the *move*, flag the trap, and check by substitution where it applies. The
  parser in `make_solved_guide.py` requires this exact heading shape.
- `_SolvedGuide.html`: **auto-generated** — never hand-authored. Run
  `python3 scripts/make_solved_guide.py --bulk desktopAhaan/Resources/TestPapers`
  (bulk mode renders any paper lacking a guide; ≥50 merged Qs required).
- **One chapter = one commit.** Validate (`check_testpaper_triplet` +
  `ci-build-test.sh`) before each push.

## Gate
`python3 scripts/check_testpaper_triplet.py` → `bash scripts/ci-build-test.sh`.

---

## Coverage grid (run start: 2 / 69)

Legend: ✅ Advanced triplet complete · ❌ missing · 🟡 in progress

### Mathematics (15 chapters)
| Ch | Title | Advanced |
|----|-------|:--------:|
| Ch01 | Large Numbers Around Us | ✅ |
| Ch02 | Arithmetic Expressions | ✅ |
| Ch03 | A Peek Beyond the Point | ✅ |
| Ch04 | Expressions Using Letter-Numbers | ✅ |
| Ch05 | Parallel and Intersecting Lines | ✅ |
| Ch06 | Number Play | ✅ |
| Ch07 | A Tale of Three Intersecting Lines | ✅ |
| Ch08 | Working with Fractions | ✅ |
| Ch09 | Geometric Twins (Symmetry) | ✅ |
| Ch10 | Operations with Integers | ✅ |
| Ch11 | Finding Common Ground (HCF/LCM) | ✅ |
| Ch12 | Another Peek Beyond the Point | ✅ |
| Ch13 | Connecting the Dots (Data Handling) | ✅ |
| Ch14 | Constructions and Tilings | ✅ |
| Ch15 | Finding the Unknown | ✅ (prototype) |

### Science (19 chapters)
| Ch | Title | Advanced |
|----|-------|:--------:|
| Ch01 | Nutrition in Plants | ✅ |
| Ch02 | Nutrition in Animals | ✅ |
| Ch03 | Fibre to Fabric | ✅ |
| Ch04 | Heat | ✅ |
| Ch05 | Acids, Bases and Salts | ✅ |
| Ch06 | Physical and Chemical Changes | ✅ |
| Ch07 | Weather, Climate & Animal Adaptations | ✅ |
| Ch08 | Winds, Storms and Cyclones | ✅ |
| Ch09 | Soil | ✅ |
| Ch10 | Respiration in Organisms | ✅ |
| Ch11 | Transportation in Animals and Plants | ❌ |
| Ch12 | Reproduction in Plants | ❌ |
| Ch13 | Motion and Time | ✅ (prototype) |
| Ch14 | Electric Current and Its Effects | ✅ |
| Ch15 | Light | ✅ |
| Ch16 | Water: A Precious Resource | ❌ |
| Ch17 | Forests: Our Lifeline | ❌ |
| Ch18 | Wastewater Story | ❌ |
| Ch19 | Earth, Moon and the Sun | ❌ |

### Social Science (20 chapters)
| Ch | Title | Advanced |
|----|-------|:--------:|
| Ssch01 | Geographical Diversity of India | ✅ |
| Ssch02 | Understanding the Weather | ✅ |
| Ssch03 | Climates of India | ✅ |
| Ssch04 | New Beginnings: Cities and States | ✅ |
| Ssch05 | The Rise of Empires | ❌ |
| Ssch06 | The Age of Reorganisation | ❌ |
| Ssch07 | The Gupta Era | ❌ |
| Ssch08 | How the Land Becomes Sacred | ❌ |
| Ssch09 | Types of Governments | ❌ |
| Ssch10 | The Constitution of India | ❌ |
| Ssch11 | From Barter to Money | ❌ |
| Ssch12 | Understanding Markets | ❌ |
| Ssch13 | The Story of Indian Farming | ❌ |
| Ssch14 | India and Her Neighbours | ❌ |
| Ssch15 | Empires and Kingdoms (6th–10th c.) | ❌ |
| Ssch16 | Turning Tides (11th–12th c.) | ❌ |
| Ssch17 | India: A Home to Many | ❌ |
| Ssch18 | The State, the Government and You | ❌ |
| Ssch19 | Infrastructure | ❌ |
| Ssch20 | Banks and the Magic of Finance | ❌ |

### Sanskrit (15 chapters)
| Ch | Title | Advanced |
|----|-------|:--------:|
| Sch01 | Vande Bhāratamātaram | ❌ |
| Sch02 | Nityaṁ Pibāmaḥ Subhāṣitarasam | ❌ |
| Sch03 | Mitrāya Namaḥ | ❌ |
| Sch04 | The Fox and the Grapes | ❌ |
| Sch05 | Sevā Hi Paramo Dharmaḥ | ❌ |
| Sch06 | Krīḍāma Vayam (Shlokāntyākṣarī) | ❌ |
| Sch07 | Īśāvāsyam Idaṁ Sarvam | ❌ |
| Sch08 | Hitaṁ Manohāri Cha Durlabhaṁ Vachaḥ | ❌ |
| Sch09 | Annād Bhavanti Bhūtāni | ❌ |
| Sch10 | Daśamaḥ Kaḥ | ❌ |
| Sch11 | Dvīpeṣu Ramyaḥ Dvīpo'ndamānaḥ | ❌ |
| Sch12 | Vīrāṅganā Pannādhāyā | ❌ |
| Sch13 | Varṇa-Mātrā Parichayaḥ | ❌ |
| Sch14 | Śabda-Rūpāṇi | ❌ |
| Sch15 | Dhātu-Rūpāṇi (Verb Conjugations) | ❌ |

---

## Running total
- **Run start:** 2 / 69 chapters (Maths Ch15, Science Ch13 — prototypes).
- **2026-06-10 (Wave 3):** **19 / 69** chapters — Maths Ch01–Ch15, Science
  Ch04/Ch13/Ch15, Social Science Ssch01.
- **2026-06-10 (Wave 4):** **26 / 69** chapters — added Science Ch01/Ch02/Ch05/
  Ch06/Ch08/Ch10/Ch14 (authored by concurrent content agents, integrated here).
  All 26 are both **authored** (complete triplet on disk, triplet lint clean)
  **and integrated** (wired into `OlympiadPaperRegistry` with `tier: .advanced`,
  bundled via the regenerated pbxproj, pinned by `OlympiadExamHallTests` → 95
  papers / 69 foundation + 26 advanced). Build + full XCTest GREEN.
- **2026-06-10 (Wave 5):** **28 / 69** chapters — added Science Ch03 (Fibre to
  Fabric, authored this session) and Social Science Ssch02 (Understanding the
  Weather, authored by a concurrent content agent, integrated here). Both are
  **authored** (complete triplet on disk, triplet lint clean — 373 papers, 0
  orphans) **and integrated** (wired into `OlympiadPaperRegistry` with
  `tier: .advanced`, bundled via the regenerated pbxproj, pinned by
  `OlympiadExamHallTests` → 97 papers / 69 foundation + 28 advanced). Build +
  full XCTest GREEN. Coverage now: Maths 15/15, Science 11/19, Social Science
  2/20, Sanskrit 0/15.
- **2026-06-11 (Wave 6):** **29 / 69** chapters — added Science Ch07 (Weather,
  Climate and Adaptations of Animals to Climate, authored this session: 60
  beyond-grade MCQs on weather-vs-climate, climate factors, weather
  instruments, polar/tropical/migratory adaptations, and climate change /
  coral bleaching). Authored + integrated (registry `tier: .advanced`, pbxproj
  regenerated, `OlympiadExamHallTests` → 98 papers / 69 foundation + 29
  advanced). Build + full XCTest GREEN. Coverage: Maths 15/15, Science 12/19,
  Social Science 2/20, Sanskrit 0/15.
- **2026-06-11 (Wave 7):** **30 / 69** chapters — added Social Science Ssch03
  (Climates of India, authored this session: 60 beyond-grade MCQs on weather/
  season/climate, the five climate factors, windward/leeward & rain-shadow, the
  southwest/northeast monsoon, climate types, disasters and climate change, with
  a balanced 15/15/15/15 answer key). Authored + integrated (registry
  `tier: .advanced`, pbxproj regenerated, `OlympiadExamHallTests` → 99 papers /
  69 foundation + 30 advanced). Build + full XCTest GREEN. Coverage: Maths 15/15,
  Science 12/19, Social Science 3/20, Sanskrit 0/15.
- **2026-06-11 (Wave 8):** **32 / 69** chapters — added Science Ch09 (Soil,
  authored by a concurrent agent) and Social Science Ssch04 (New Beginnings:
  Cities and States, authored this session: 60 beyond-grade MCQs on the Second
  Urbanisation, janapadas → mahaajanapadas, monarchies vs gana-sangha republics,
  punch-marked coins, varna/jaati, the great trade routes and iron metallurgy,
  balanced 15/15/15/15 key). Both authored + integrated (registry
  `tier: .advanced`, pbxproj regenerated, `OlympiadExamHallTests` → 101 papers /
  69 foundation + 32 advanced). Build + full XCTest GREEN. Coverage: Maths 15/15,
  Science 14/19, Social Science 4/20, Sanskrit 0/15.
- Flip each cell to ✅ as its commit lands; update the headline count here and in
  `V8_NEXT10H_LEDGER.md`.
