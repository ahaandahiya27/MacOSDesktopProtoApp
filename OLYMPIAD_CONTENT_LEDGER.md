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
- [x] **ch14 — Electric Current and its Effect (3 topics, 6 MCQs)** — Ohm's law (worked I=V/R), series vs parallel wiring, electromagnetic induction.
- [x] **ch15 — Light (3 topics, 6 MCQs)** — lens formula (worked image position), total internal reflection / optical fibres, wave optics (diffraction & interference).
- [x] **ch16 — Water: A Precious Resource (3 topics, 6 MCQs)** — aquifer mechanics (porosity vs permeability), groundwater budget as a bank account, drip vs flood efficiency.
- [x] **ch17 — Forest: Our Lifeline (3 topics, 6 MCQs)** — trophic levels & 10% rule, ecological niche/succession/Gause, decomposer (N & C cycle) chemistry.
- [x] **ch18 — Wastewater Story (3 topics, 6 MCQs)** — sewage contaminant classes, BOD/COD pollution measurement, anaerobic digestion → biogas.
- [x] **ch19 — Earth, Moon and the Sun (3 topics, 6 MCQs)** — time zones (15°/hr, date line), Milankovitch cycles & ice ages, circadian clock (SCN).
- ✅ **SCIENCE COMPLETE — 57/57 stretch topics, 114 Olympiad MCQs, all 19 chapters. Every topic ≥2 gradable .mcq.**

**Tooling note:** inject scripts use a variadic `V(p,a,*steps)` helper so step strings can't be mis-bracketed (the earlier source of two SyntaxErrors). `ast.parse` the inject script before running.

### Maths (`maths_class7`, 15 chapters, 45 stretch topics)
- [x] **ch01–ch05 (15 topics, 30 MCQs)** — standard form / sig figs / Fermi; distributive law / BODMAS / commutativity; terminating decimals / reals / place value; identities / polynomials / functions; Euclid's 5th / triangle-angle-sum / slope. MCQ form, difficulty 4–5.
- [x] **ch06–ch10 (15 topics, 30 MCQs)** — parity invariants / Fibonacci-golden ratio / modular arithmetic; triangle inequality / Pythagoras / triangle centres; rationals & closure / 'of'=multiply & percentages / unit fractions; congruence (SSS/SAS/ASA, why not SSA) / similarity / isosceles theorem; integer closure / (-)(-)=+ proof / coordinate plane.
- [x] **ch11–ch15 (15 topics, 30 MCQs)** — Euclid's algorithm / Fundamental Theorem of Arithmetic / LCM; powers-of-ten / repeating-decimal→fraction / estimation; mean-median-mode / standard deviation / misleading graphs; impossible constructions / regular-polygon tilings / perpendicular-bisector locus; equations both sides / simultaneous equations / quadratics.
- ✅ **MATHS COMPLETE — 45/45 stretch topics, 90 Olympiad MCQs, all 15 chapters.**

### Sanskrit (`sanskrit_class7`, sch01–sch15, 45 stretch topics; legacy ch01 exempt)
- [x] **sch01–sch05 (15 topics, 30 MCQs)** — Vande Mataram history / समास / स्तुति; subhāṣita & Bhartrihari / अनुष्टुप् metre / दृष्टान्त & alankāra; नमः+dative कारक / twelve Ādityas / yoga & योगसूत्र; तसिल् suffix / Panchatantra-नीतिकथा / उपसर्ग prefixes; धर्म & puruṣārthas / वति suffix / आयुर्वेद.
- [x] **sch06–sch10 (15 topics, 30 MCQs)** — अक्षर/syllable / विद्या verses / -विन् suffix; Īśopaniṣad & वेदान्त / future tense लृट् / Advaita & महावाक्य; वाक्-सूक्ति / शस् suffix / matup क्रियावान्; Gītā cycle verse / optative विधिलिङ् / Sanskrit science-coinage; tenth-man parable / क्त्वा gerund / imperfect लङ्.
- [x] **sch11–sch15 (15 topics, 30 MCQs)** — Cellular Jail/कालापानी / क्तवतु past-active participle / instrumental plural; Panna Dhai-Mewar / तुमुन् infinitive & causative / ordinals & locative-of-time; मात्रा & metre / प्लुत vowel / शिक्षा vedanga; कारक theory / declension & dual / vocative & सुप्; ten गण / लकार system / parasmaipada-atmanepada.
- ✅ **SANSKRIT COMPLETE — 45/45 stretch topics, 90 Olympiad MCQs, all 15 NEP chapters (legacy ch01 exempt).**

### Social Science (`socialscience_class7`, 20 chapters, 120 stretch topics)
The `bonusQuestions` array is ADDED to each `deepDive[]` entry (new key; the optional model field decodes it with no Swift change).
- [x] **ssch01–ssch02 (12 topics, 24 MCQs)** — Geographical Diversity (orographic rain, GPS plate-motion, Tethys fossils, alluvium depth, river tilt, snow vs rain-fed); Weather (pressure/oxygen-altitude, dew point, forecasting & chaos, convection/sea-breeze, Stevenson screen, rain-gauge depth).
- [x] **ssch03–ssch04 (12 topics, 24 MCQs)** — Climates (orographic/Deccan, temp range, monsoon=giant sea breeze, weather vs climate, six ṛitus, El Niño teleconnection); New Beginnings (Magadha's edge, early republics vs democracy, archaeology/NBPW, money vs barter, iron & surplus, Uttarāpatha/Dakṣiṇāpatha).
- [x] **ssch05–ssch06 (12 topics, 24 MCQs)** — Rise of Empires (Ashoka's edicts & Prinsep, Kautilya's mandala, why Magadha, śhrenī guild-banks, Kalinga & dhammavijaya, why empires fall); Age of Reorganisation (Indo-Roman trade & Periplus, Gandhara/Mathura Buddha, queen's-name social history, Shaka calendar, Grand Anicut, Kushanas & Silk Route).
- [x] **ssch07–ssch08 (12 topics, 24 MCQs)** — Gupta Era (Iron Pillar passivation, Aryabhata/zero & place value, traveller's-diary method, land grants & decentralisation, spinning Earth & eclipses, Prabhavati Gupta); Sacred geography (cultural infrastructure, legal personhood for nature, sacred groves, Kumbh astronomy, tīrtha=crossing, mountains as gateways).
- [x] **ssch09–ssch10 (12 topics, 24 MCQs)** — Types of Government (federalism, constitutionalism, ancient gaṇa-saṅghas, separation of powers, direct vs representative, constitutional vs absolute monarchy); Constitution (Directive Principles non-justiciable, basic-structure doctrine, borrowed bricks, why 26 Jan, 'We the People'/popular sovereignty, Constituent Assembly).
- [x] **ssch11–ssch12 (12 topics, 24 MCQs)** — From Barter to Money (general acceptance/trust, inflation, numismatics, UPI/QR, double coincidence of wants, fiat money); Understanding Markets (equilibrium, externalities, middlemen-add-value, quality marks, online markets/long tail, why countries trade).
- [x] **ssch13–ssch14 (12 topics, 24 MCQs)** — Indian Farming (hybrid seeds, Green-Revolution externalities, kharif/rabi/zaid, traditional water structures, soils, the half-workers/small-output puzzle); India & Neighbours (maritime choke points, Sanskrit Cosmopolis, why neighbours cooperate, three Buddhist vehicles, India–Nepal open border, the Himalayas).
- [ ] ssch15–ssch20 (36 topics) — 2 MCQs each. **168 SS MCQs done so far.**

## Phase 5 (after content) — coverage test
- [ ] Add `ExpertChallengeOlympiadContentTests`: each pack yields a non-empty
  Olympiad tier; every `bonusQuestions` entry is a gradable `.mcq` with `answer ∈ options`.

## Notes
- Doing this directly in-session proved the pipeline (ch01). The autonomous
  `run_olympiad_content.sh` can resume from here — **do not run it concurrently
  with hand-authoring** (two uncoordinated writers to the same packs).
