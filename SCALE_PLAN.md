# Scale Plan — Plugin Architecture for Subjects & Chapters

Goal: adding a new chapter / topic / subject becomes content-only. Drop in a JSON pack + register one Swift module, no Swift surgery elsewhere.

## Target shape

```
SubjectsRegistry.shared
    .register(SanskritKoshPlugin())
    .register(ScienceClass7Plugin())
    // Future:
    // .register(MathClass7Plugin())
    // .register(HindiClass7Plugin())
```

Every screen (sidebar, search, daily practice, discover-progress) iterates the registry. Zero hard-coded `subject.id == "science_class7"` switches.

## Steps (atomic, reversible, run one per iteration)

- [x] **S1**: Define `SubjectPlugin` protocol in `Subjects/Plugins/SubjectPlugin.swift`. (2026-05-22, commit pending — pure addition, no call site touched.)
- [x] **S2**: Define `ChapterPlugin` protocol in `Subjects/Plugins/ChapterPlugin.swift`. (2026-05-22, same commit.)
- [x] **S3**: Define `ChapterManifest` + `ChapterModule` enum in `Subjects/Plugins/ChapterManifest.swift`. (2026-05-22, same commit.)
- [ ] **S4**: Add `SubjectsRegistry` class. Register `SanskritKosh` + `ScienceClass7` from `desktopAhaanApp.init`.
- [ ] **S5**: Wrap each existing chapter in a `ChapterPlugin` adapter (no behavior change — pure shim) — Ch.1 first, then Ch.2..Ch.19.
- [ ] **S6**: Replace hard-coded `Chapter1View`, `Chapter2View`, … `Chapter19View` references with iteration over `subjectPlugin.allChapters()` in:
    - `ContentView.swift` (`detailPane` switch)
    - `Subjects/Tutor/Discover/DiscoverMode.swift` (`DiscoverDispatcher`)
    - Any other site grep'd via `Chapter\d+View|DiscoverChapter\d+View`
- [ ] **S7**: Implement `GenericChapterView` — renders a chapter purely from JSON (concept list, quiz, article reader, mnemonic stack). Used when no `ChapterPlugin` is registered.
- [ ] **S8**: Snapshot ratchet — capture pixel snapshots of every chapter index, every Discover dispatcher, every Boss Quiz BEFORE refactor. After each S5–S7 commit, re-snapshot and diff. Zero pixel delta required.
- [ ] **S9**: `docs/ADD_A_SUBJECT.md` — HOWTO for adding Math/English/Hindi/History.
- [ ] **S10**: `docs/ADD_A_CHAPTER.md` — HOWTO for adding Ch.20 with optional Swift.

## Invariants (non-negotiable across the whole refactor)

1. Existing chapters 1–19 must render pixel-identically before and after every commit.
2. Persistence keys (`discoverProgress.sceneId`, `chapterId`, `subjectId`) MUST NOT change. If a key would change, write a `runSchemaMigrationsIfNeeded()` step in the same commit.
3. Each refactor commit is independently revertible. No "atomic 50-file rewrite" landings.
4. The four crash classes (C1–C4 in `CRASH_LEDGER.md`) must remain provably absent (sanitizer walker green) after every commit.

## Sequencing rationale

S1–S4 are pure additions — no existing call sites touched, so they can never regress anything. S5–S7 are adapter shims that route existing views through the new protocols; the snapshot ratchet (S8) is what locks them. S9–S10 are documentation.
