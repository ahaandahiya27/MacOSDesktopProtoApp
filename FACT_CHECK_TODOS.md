# Fact Check & Deferred Work

Open items the autonomous content-expansion arc consciously deferred,
with the reason. Each entry tells the next person what's needed and
why I (Claude) chose to defer rather than synthesise.

## Visual media — M1 illustrations (bundled PNG/PDF)

**Scope:** Every chapter's `mediaAssets[]` has the M2 / M3 / M5 floor
met (shape diagrams, scene refs, narration flags). The spec also
called for M1 ≥ 6 (bundled illustrations in the asset catalog) per
chapter — across 19 chapters that's 114 licensed images.

**Why deferred:** Bundled illustrations need licensed source
material. I cannot generate PNG/PDF art and cannot license
royalty-free images without the developer (Rohan) reviewing the
license terms. Synthesising would mean either AI-image-generation
(legal/quality risks for a kid's app) or copying from search results
(copyright violation).

**What to do next:** Source CC-BY / CC0 illustrations from OpenStax
or other open-licensed sources; document each entry in
`desktopAhaan/Resources/Illustrations/LICENSES.md`; add to asset
catalog; replace the corresponding `shapeDiagram` MediaAsset entry
with `illustration` kind referencing the asset-catalog name.

## Visual media — M4 bundled video (≤ 20 s MP4)

**Scope:** Spec called for ≥ 1 bundled MP4 per chapter.

**Why deferred:** Same constraint as M1 — needs licensed clean
source video, file-size optimisation, closed-caption authoring,
and developer-side asset-catalog integration.

**What to do next:** Source open-licensed clips (e.g., from
Wikimedia Commons, Internet Archive, or NCERT video portal),
encode to H.264 ≤ 2 MB, add to `Resources/Videos/Chapter{NN}/`,
document license in `Resources/Videos/LICENSES.md`, add
MediaAsset entry with `kind: bundledVideo` and `durationSeconds`
populated.

## UI scaffolding — ShapeDiagramRegistry + MediaAssetView + DeepDiveDisclosure

**Scope:** Three new UI files needed to actually RENDER what the
new schema describes:
- `ShapeDiagramRegistry.swift` — id → SwiftUI view factory map
- `MediaAssetView.swift` — five-backend dispatcher
- `DeepDiveDisclosure.swift` — chapter detail "Go deeper" disclosure

**Why deferred:** Schema landed (commit `29108b9`), tests pass, but
the rendering UI needs careful integration with the existing
chapter detail view, the existing TextToSpeechManager, and the
Discover scene routing system. A safe integration needs ≥ 90 minutes
of focused work + manual verification on the iMac. Pushing schema +
content first means a future session can integrate the UI with the
content already in place.

**What to do next:** Build the three files per the spec sketches in
the session's `--dangerously-skip-permissions` launch prompt. Verify
on Big Sur target (no macOS 12+ APIs). Wire DeepDiveDisclosure
into ChapterDetailView under existing CTAs, closed by default,
SceneStorage-persisted.

## Concept count below floor (Conc cell, 11 chapters)

**Scope:** Spec sets "Conc ≥ 8 per chapter" as a parity floor.
11 chapters in the PW Class 7 baseline have 6-7 concepts each
(ch08, ch09, ch10, ch11, ch12, ch13, ch14, ch16, ch17, ch18 —
checking the matrix). These show as `6/8 ⚠️` or `7/8 ⚠️` in
`CONTENT_PARITY_MATRIX.md`.

**Why deferred:** The PW Class 7 textbook itself has fewer than 8
concepts in these chapters. The Class-7 anchor rule (every piece
of content must trace to the PW baseline) means I CANNOT invent
extra concepts to pad the count — that would violate the user's
explicit instruction. The Deep-Dive content extends these existing
concepts; it doesn't add to the base count.

**What to do next:** Either (a) lower the Conc floor for these
chapters in `content-parity-matrix.py` to reflect the PW
baseline's actual distribution (annotate why), or (b) add new
Class-7-baseline concepts where the textbook genuinely supports
them (e.g., Ch.10 could add a concept on "Respiratory diseases —
asthma, COVID lessons" that the PW chapter touches but doesn't
formally name as a concept). Option (b) requires content authoring
discipline; option (a) is a simpler matrix tweak.

## Article backfill (Ch.1-9 articles)

**Status:** RESOLVED via the matrix fix in commit `1b78070`. The
Chapter1..Chapter9 vs Chapter01..Chapter09 folder-naming bug was
masking the existing extensive articles. All chapters now show
✅ on the Art cell.
