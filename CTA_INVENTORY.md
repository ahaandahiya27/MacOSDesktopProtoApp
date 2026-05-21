# CTA Inventory — desktopAhaan

Every clickable CTA, screen by screen, with the navigation path to reach it. Re-generated every 4 iterations via `scripts/cta_inventory.py` (TBD).

## Sidebar (always visible)

| CTA | Path | Notes |
|---|---|---|
| Sanskrit Kosh | sidebar → Subjects | always-on |
| Science — Class 7 (PW Science Era) | sidebar → Subjects | always-on |
| Practice Questions | sidebar → Quiz Bank | always-on |
| Stomata, xylem, and the plumbing of a leaf (concept) | Recent | dynamic, last-visited concept |
| Autotrophs and heterotr... (concept) | Recent | dynamic |
| Neutralisation in our daily life (concept) | Recent | dynamic |
| Who serves as the ultim... (question) | Recent · QUESTIONS | dynamic |
| Why do we need ancient... (question) | Recent · QUESTIONS | dynamic |
| Search · Bookmarks · Daily Practice · Discover Progress · Settings | Tools | always-on |

## Ch.1 detail page (the path that's been crashing)

| CTA | Path | Notes |
|---|---|---|
| ← Back | top-left | dismisses chapter detail |
| Try Discover Mode | green card | opens DiscoverChapter1View |
| Beyond the Book | purple card | opens ArticleBrowserView (`ch01_beyond.html`) via ArticleWindowManager |
| Try at Home | red/orange card | opens HomeExperimentsSheet |
| My Notebook | green card | opens ChapterNotebookSheet |
| How green plants make their own food | topic row | opens topic detail |
| Plants that don't make their own food | topic row | opens topic detail |
| Soil, Nitrogen and the Food Chain | topic row | opens topic detail |

Each topic row opens a list of concept cards which are themselves CTAs.

## Ch.1 Discover Mode (the inner shell)

| CTA | Path | Notes |
|---|---|---|
| Prev / Next | shell footer | scene navigation |
| Try Discover Mode (first time) → Scene 1 | shell load | Scene1_PlantKitchen |
| Got It! | every scene | advances to next scene |
| 22+ scenes (Scene1..SceneN inline + Scene9_BossQuiz) | shell currentScene | dispatcher in DiscoverChapter1View + InlineScenes |

## Status

This inventory is a manual seed. Iter 2 will add `accessibilityIdentifier(...)` to each CTA so an XCUITest walker can address them by ID instead of by AppleScript heuristics.
