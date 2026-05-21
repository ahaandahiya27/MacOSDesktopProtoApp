# Chapter 1 — Next-Level Log

Tracks every enrichment / polish landing in Chapter 1 of Science during this 12-hour session.

## Already-shipped (cumulative — before this session)

| Commit | Module | What |
|---|---|---|
| `e917588` | Scientists / Story Mode + What-If + Glossary + Story Mode HTML | 4 ways-of-learning articles |
| `73fc2be` | Plant gallery + Mini-Project + Self-Check + Bridge | 4 more |
| `b287aae` | Common Mistakes + NCERT Q&A + Master Infographic + 4 inline SVGs | 3 articles + 4 SVG diagrams |
| `beed6ea` | SVGs for c07/c08/c09 + Ch.1 SVG-accessibility ratchet test | inline diagrams |
| `49a7790` | Modes-of-Nutrition diagram (c05) | inline diagram |
| `f108a05` | Van Helmont scene crash fix | scene stability |
| `793c4ed` | Scene1_PlantKitchen layout-recursion fix | scene stability |

Ch.1 article count: **37** (1 overview + 3 topic overviews + 21 concepts + 1 beyond + 8 ways-of-learning + 3 exam-prep).

## Open list (next-level additions)

Pick from this list during iterations 4+ (after crash hunt infrastructure):

- [ ] **CH1-L1**: New Discovery widget — "Vary light intensity and watch the rate of photosynthesis" (slider-driven, hardware-tier aware FPS).
- [ ] **CH1-L2**: Audio-narration toggle on every Ch.1 concept card (uses existing TextToSpeechManager).
- [ ] **CH1-L3**: New at-home experiment — pH of soil + how it affects plant growth.
- [ ] **CH1-L4**: New cross-chapter bridge callouts: "→ Ch.10 Respiration" and "→ Ch.17 Forests" with stable links.
- [ ] **CH1-L5**: Polish animation timings + Reduce-Motion gating via the new `.respectReduceMotion(animation:)` helper (replaces hand-rolled checks in Scene1..Scene9 + inline Ch.1 scenes).
- [ ] **CH1-L6**: Boss Quiz polish — difficulty curve, encouragement bubble after wrong answers, certificate render via `renderViewToImage`.
- [ ] **CH1-L7**: Article copy-edit pass — `ch01_beyond.html`, the 4 concept articles with inline SVGs, target ≤ 1500 words each.
- [ ] **CH1-L8**: One new SVG diagram for any Ch.1 concept article without one (currently c01 has a Venn; c02–c04 have inline diagrams; c05–c10 partial).
