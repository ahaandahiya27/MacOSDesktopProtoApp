# File-size census — 2026-05-24 (HISTORICAL SNAPSHOT)

> **2026-06-13 update:** Snapshot represents the 2026-05-24 state. The
> live grandfathered list at `scripts/file_size_allowlist.txt` shows
> **2 entries today** (QuestionDetailView at 949 LOC, DataStore at 698 LOC)
> — not 8. The intermediate Discover surfaces that were over the line
> in May have since been split or stayed under via the J8 token
> migration's net deletions. Treat the "8 over the line" claim below
> as historical; the allowlist file is the live source of truth.

Snapshot of Swift source files exceeding the 600-LOC ceiling enforced by
`scripts/check_file_size.py`. All entries below are present in
`scripts/file_size_allowlist.txt` with a documented reason; the lint
remains clean.

| LOC | File | Allowlist reason (summary) |
|----:|------|----------------------------|
| 1399 | desktopAhaan/Subjects/Tutor/Discover/DiscoverChapter1View+InlineScenes.swift | Already split once; 12 inline scenes would need per-scene files. |
| 1270 | desktopAhaan/Subjects/Articles/ArticleIndex.swift | Article registry across 19 chapters; planned split by chapter. |
|  965 | desktopAhaan/Subjects/Tutor/Discover/Chapter2/DiscoverChapter2View.swift | Ch.2 Discover scene file frozen this session. |
|  949 | desktopAhaan/Subjects/Tutor/QuestionDetailView.swift | Earlier split attempt produced 60s type-checker timeout; reverted. |
|  740 | desktopAhaan/Services/Persistence/DataStore.swift | Already split via +Loading/+Saving; remaining is short mutator clusters. |
|  715 | desktopAhaan/Subjects/Tutor/Discover/Chapter3/DiscoverChapter3View.swift | Ch.3 Discover scene file frozen this session. |
|  631 | desktopAhaan/Subjects/Tutor/Discover/Chapter5/DiscoverChapter5View.swift | Ch.5 Discover scene file frozen this session. |
|  617 | desktopAhaan/Subjects/Tutor/Discover/Chapter4/DiscoverChapter4View.swift | Ch.4 Discover scene file frozen this session. |

**Total**: 354 Swift files in `desktopAhaan/`, 8 over the 600-LOC line, all grandfathered.

No new files cross the 600 threshold this session. The lint
(`scripts/check_file_size.py`) reports `clean — 8 pre-existing oversized
file(s) grandfathered via allowlist`.
