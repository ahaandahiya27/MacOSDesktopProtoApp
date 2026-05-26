# Maths Build Checkpoint

**Last updated:** 2026-05-27 00:40 +05:30
**Wrapper attempt:** 0 (interactive session — wrapper not yet launched)
**Last good commit SHA:** (no maths commit yet; tree still dirty from PID 9353's quick-check migration)
**Current phase:** Phase 0 — pack scaffolding (header written, awaiting clean tree for commit)
**Current chapter under construction:** ch01 — Large Numbers Around Us

---

## Curriculum source — IMPORTANT DIVERGENCE FROM AUTONOMOUS PROMPT

The autonomous prompt at `../SUPERPROMPT_MATHS_AUTONOMOUS_20H.md` assumed
the source PDFs were the **legacy NCERT Class 7 Maths** curriculum:
Integers, Fractions and Decimals, Data Handling, Simple Equations, Lines
and Angles, Triangle Properties, Congruence, Comparing Quantities,
Rational Numbers, Practical Geometry, Perimeter and Area, Algebraic
Expressions, Exponents and Powers, Symmetry, Visualising Solid Shapes.

The actual PDFs in
`/Users/mac/Extra/Ahaan-Books/Maths-1-Books/` and
`/Users/mac/Extra/Ahaan-Books/Maths-Part-2-Pdf_Topics/`
are the **NEW NEP-2020 "Ganita Prakash" Grade 7** textbook (header
"Ganita Prakash | Grade 7", "Reprint 2026-27", 15 chapters split
across two parts: 8 + 7). The chapter list is **different** from the
legacy curriculum the prompt expected.

Decision (per autonomy contract §10 trigger #1 — NCERT-content
discrepancy): build from the actual PDFs (what Ahaan is being taught
under the 2025-26 NEP rollout). Logged in STOP_AND_ASK.md.

---

## PDF mapping (verified by `pdftotext` extraction)

| Ch# | NCERT NEP title              | PDF path | Notes |
|-----|------------------------------|----------|-------|
| 1   | Large Numbers Around Us      | Maths-1-Books/gegp101.pdf | lakh, crore, place value, estimation |
| 2   | Arithmetic Expressions       | Maths-1-Books/gegp102.pdf | arithmetic expressions, order of ops |
| 3   | A Peek Beyond the Point      | Maths-1-Books/gegp103.pdf | decimals — units smaller than 1 |
| 4   | Expressions Using Letter-Numbers | Maths-1-Books/gegp104.pdf | algebra introduction |
| 5   | Parallel and Intersecting Lines | Maths-1-Books/gegp105.pdf | geometry — lines, angles, transversals |
| 6   | Number Play                  | Maths-1-Books/gegp106.pdf | number patterns, properties |
| 7   | A Tale of Three Intersecting Lines | Maths-1-Books/gegp107.pdf | triangles |
| 8   | Working with Fractions       | Maths-1-Books/gegp108.pdf | fractions — multiplication, division |
| 9   | Geometric Twins              | Maths-Part-2-Pdf_Topics/gegp201.pdf | symmetry, congruence |
| 10  | Operations with Integers     | Maths-Part-2-Pdf_Topics/gegp202.pdf | integers recap + operations |
| 11  | Finding Common Ground        | Maths-Part-2-Pdf_Topics/gegp203.pdf | GCD/LCM and common factors |
| 12  | Another Peek Beyond the Point | Maths-Part-2-Pdf_Topics/gegp204.pdf | decimals — advanced operations |
| 13  | Connecting the Dots          | Maths-Part-2-Pdf_Topics/gegp205.pdf | deductive reasoning, statements |
| 14  | Constructions and Tilings    | Maths-Part-2-Pdf_Topics/gegp206.pdf | geometric constructions, tilings |
| 15  | Finding the Unknown          | Maths-Part-2-Pdf_Topics/gegp207.pdf | algebraic equations, unknowns |

Full text extracted to `/tmp/maths-pdf-text/gegp1{01..08}.txt` and
`/tmp/maths-pdf-text/gegp2{01..07}.txt` (562 KB total).

---

## Per-chapter status

| Ch# | Schema | Content | Articles | Discover | Notes |
|-----|--------|---------|----------|----------|-------|
| 1   | 🟡 stub | ⚪      | ⚪       | ⚪       | pilot — in progress |
| 2   | ⚪     | ⚪      | ⚪       | ⚪       |       |
| 3   | ⚪     | ⚪      | ⚪       | ⚪       |       |
| 4   | ⚪     | ⚪      | ⚪       | ⚪       |       |
| 5   | ⚪     | ⚪      | ⚪       | ⚪       |       |
| 6   | ⚪     | ⚪      | ⚪       | ⚪       |       |
| 7   | ⚪     | ⚪      | ⚪       | ⚪       |       |
| 8   | ⚪     | ⚪      | ⚪       | ⚪       |       |
| 9   | ⚪     | ⚪      | ⚪       | ⚪       |       |
| 10  | ⚪     | ⚪      | ⚪       | ⚪       |       |
| 11  | ⚪     | ⚪      | ⚪       | ⚪       |       |
| 12  | ⚪     | ⚪      | ⚪       | ⚪       |       |
| 13  | ⚪     | ⚪      | ⚪       | ⚪       |       |
| 14  | ⚪     | ⚪      | ⚪       | ⚪       |       |
| 15  | ⚪     | ⚪      | ⚪       | ⚪       |       |

---

## Defer queue (also in POLISH_TODOS)

- Wait for PID 9353's quick-check migration to land + push before
  the Maths Phase 0 pack registration commit (would race pbxproj
  + SubjectRegistry).
- Once pbxproj is touchable, register `maths_class7.json` as bundle
  resource via `scripts/generate_compat_pbxproj.py`.
- Article id prefix `mch{NN}_<slug>` may need ArticleIndex.swift
  extension if the loader assumes the legacy `ch{NN}_<slug>` form;
  verify before authoring articles.

---

## STOP_AND_ASK count: 1

Curriculum divergence note — see STOP_AND_ASK.md `2026-05-27` entry.

---

## Wrapper attempt log

| Attempt | Started | Ended | Phase progress |
|---------|---------|-------|----------------|
| — (interactive) | 2026-05-27 00:00 +05:30 | in progress | Phase 0 scaffolding |

---

## Resume hints for next instance

If you re-launch and read this checkpoint:

1. Check `git log -1 --format=%H` against `Last good commit SHA` above.
2. Check `git status` — if dirty with non-Maths files, another agent
   may still be working. Wait or work on non-overlapping content.
3. Resume by reading `/tmp/maths-pdf-text/gegp{NN}.txt` for any
   chapter you're authoring — that's the source of truth.
4. The pack scaffold (`maths_class7.json`) is at the path in the
   prompt. Chapter content goes into the `chapters: []` array.
5. PR ids: chapters use `ch01`..`ch15` (NOT `mch01` — only the
   article + discover id namespaces use the `m` prefix to
   disambiguate from Science).
