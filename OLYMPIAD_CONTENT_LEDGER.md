# OLYMPIAD_CONTENT_LEDGER.md — Expert Challenge "Olympiad" tier content

Authoring beyond-grade `.mcq` questions into `deepDive[].bonusQuestions` across
the four packs to light up the dormant Olympiad tier. The engine/UI already
consume them (`DataStore+ExpertChallenge.swift`, `isDeepDive:true` → Olympiad);
**no Swift change** is needed — this is pure pack JSON + a coverage test.

Resume from this file. Read `SUPERPROMPT_OLYMPIAD_CONTENT_v1.md` (workspace root)
for the full contract.

## Authoring contract (per bonus question)
- `questionType: "mcq"`, exactly 4 `options`, `answer` ∈ `options`.
- `solutionSteps` (2–4), `commonMistakes` (≥1 tied to a distractor), `variations` (≥2).
- `difficulty` 4 or 5 (beyond-grade reach). `pageRefs` within the chapter's page set.
- `needsHumanReview: false` only if confident; else `true` + note here.
- **ID scheme:** `{stretchTopicId}_b{NN}` → e.g. `ch01_dd01_b01`. Inherits the
  pack/chapter prefix, so it's collision-free across packs and ignored by
  `check_quiz_id_format.py` (which only validates `bossquiz_`/`scenecheck_` ids).
- Anchor each question to its `StretchTopic.parentConceptId` concept; be factually
  accurate (a wrong key is a real defect).

## Validation gate (every chapter, before commit/push)
`check_pack_schema` · `check_quiz_id_format` · `check_cross_pack_ids` ·
`check_orphan_refs` · `check_page_ref_bounds` · `verify_pack_roundtrip` →
`bash scripts/ci-build-test.sh` (Release build + full XCTest). Re-emit packs
canonically: `json.dumps(d, ensure_ascii=False, indent=2) + "\n"`.

---

## Progress

### Science (`science_class7`, 19 chapters, 57 stretch topics)
- [x] **ch01 — Nutrition in Plants (3 topics, 6 MCQs)** — pipeline proven end-to-end.
  - `ch01_dd01` (limiting factors / law of the minimum, class_8): `_b01`, `_b02`.
  - `ch01_dd02` (light vs dark reactions, class_9): `_b01`, `_b02`.
  - `ch01_dd03` (C3/C4/CAM, class_11): `_b01`, `_b02`.
  - All 6: mcq, answer∈options, ≥2 variations, difficulty 4–5, pageRefs [4], needsHumanReview false. Content lints + roundtrip clean.
- [x] **ch02 — Nutrition in Animals (3 topics, 6 MCQs)** — enzyme pH optima, villi surface-area math, hormonal control (gastrin/CCK/secretin).
- [x] **ch03 — Fibre to Fabric (3 topics, 6 MCQs)** — synthetic polymers, addition vs condensation polymerisation, keratin vs fibroin.
- [x] **ch04 — Heat (3 topics, 6 MCQs)** — thermal expansion (worked ΔL=LαΔT), specific heat / coastal climate, kinetic theory of heat.
- [x] **ch05 — Acids, Bases and Salts (3 topics, 6 MCQs)** — pH scale (log), salt hydrolysis, Arrhenius/Brønsted–Lowry/Lewis theories.
- [x] **ch06 — Physical and Chemical Changes (3 topics, 6 MCQs)** — word→symbolic equations, balancing (conservation of mass), enthalpy (exo/endothermic).
- [x] **ch07 — Weather/Climate/Adaptations (3 topics, 6 MCQs)** — lapse rate (worked), El Niño/La Niña & the monsoon, biomes & convergent evolution.
- [x] **ch08 — Winds, Storms and Cyclones (3 topics, 6 MCQs)** — Coriolis & hemisphere spin, cyclone genesis conditions, air pressure vs altitude / cabin pressurisation.
- [x] **ch09 — Soil (3 topics, 6 MCQs)** — NPK fertiliser labels, erosion types & remedies, pedogenesis (CLORPT).
- [x] **ch10 — Respiration in Organisms (3 topics, 6 MCQs)** — cellular respiration stages, ATP currency & turnover, lung volumes.
- [x] **ch11 — Transportation in Animals and Plants (3 topics, 6 MCQs)** — heart chambers/double circulation, transpiration pull (cohesion-tension), nephron filtration math.
- [x] **ch12 — Reproduction in Plants (3 topics, 6 MCQs)** — asexual vs sexual trade-offs, Mendel's laws & 3:1 ratio, double fertilisation/endosperm.
- [x] **ch13 — Motion and Time (3 topics, 6 MCQs)** — speed-time graphs (area=distance), three equations of motion (worked), pendulum T=2π√(L/g).
- [ ] ch14–ch19 (18 topics) — ~2 MCQs each. **78 Science MCQs done so far.**

**Tooling note:** inject scripts use a variadic `V(p,a,*steps)` helper so step strings can't be mis-bracketed (the earlier source of two SyntaxErrors). `ast.parse` the inject script before running.

### Maths (`maths_class7`, 15 chapters, 45 stretch topics)
- [ ] mch01–mch15 — MCQ form with numeric option strings (the ladder grades MCQs only).

### Sanskrit (`sanskrit_class7`, sch01–sch15, 45 stretch topics; legacy ch01 exempt)
- [ ] sch01–sch15 — Devanagari allowed in prompt/options (UTF-8, ensure_ascii=False).

### Social Science (`socialscience_class7`, 20 chapters, 120 stretch topics)
- [ ] ssch01–ssch20 — **add the `bonusQuestions` array** to each `deepDive[]` entry
  (new key; the `StretchTopic` model already declares the optional field, so no
  Swift change is needed to decode it).

## Phase 5 (after content) — coverage test
- [ ] Add `ExpertChallengeOlympiadContentTests`: each pack yields a non-empty
  Olympiad tier; every `bonusQuestions` entry is a gradable `.mcq` with `answer ∈ options`.

## Notes
- Doing this directly in-session proved the pipeline (ch01). The autonomous
  `run_olympiad_content.sh` can resume from here — **do not run it concurrently
  with hand-authoring** (two uncoordinated writers to the same packs).
