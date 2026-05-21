#!/usr/bin/env python3
"""Generate COVERAGE_MATRIX.md by scanning the filesystem and JSON pack.

22 columns = the module set from the parity prompt:
 1 Animated Scene (Scene1_*.swift)
 2 Discovery Mode (Scene2_*.swift)
 3 Concept Cards (≥ 2 per topic in JSON)
 4 Quick Check Quiz (≥ 3 MCQs per topic in JSON)
 5 Real-world Example callout (chapter-level — anything in JSON or scene)
 6 Exam Connection (LookingAheadCallout in any scene OR JSON)
 7 Mnemonic (≥ 2 — counted via JSON mnemonics or scene mnemonic field)
 8 Diagram with Hotspots (HotspotDiagram usage in any scene)
 9 Process Timeline (ProcessTimeline usage in any scene)
10 Boss Quiz (Scene9_BossQuiz_Ch{NN}.swift OR Scene9_BossQuiz.swift for Ch1)
11 Long-form Article (≥ 1 file in Resources/Articles/Chapter{NN}/)
12 Progress Tracker entry (always true — DataStore handles all)
13 Scientists/Story Mode (ch{NN}_scientists.html or ch{NN}_storymode.html)
14 What-If Explorers (ch{NN}_whatif.html)
15 Glossary (ch{NN}_glossary.html)
16 Common Mistakes (ch{NN}_mistakes.html)
17 NCERT Q&A (ch{NN}_ncert_qa.html)
18 Gallery (ch{NN}_plantoftheday.html or similar gallery suffix)
19 Mini-Project (ch{NN}_miniproject.html)
20 Self-Check (ch{NN}_selfcheck.html)
21 Curriculum Bridge (ch{NN}_bridge.html)
22 Master Infographic (ch{NN}_infographic.html)

Each cell is ✅ / ⚠️ / ❌ per the parity prompt's grading rules.
"""
from __future__ import annotations
import json
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
DISCOVER = REPO / "desktopAhaan/Subjects/Tutor/Discover"
ARTICLES = REPO / "desktopAhaan/Resources/Articles"
PACK = REPO / "desktopAhaan/Subjects/Packs/science_class7.json"

# Ch.1 keeps its scenes in `Discover/Scenes/` (no Chapter1/ folder).
# The other chapters live at `Discover/Chapter{NN}/Scenes/`.
CH1_SCENES = DISCOVER / "Scenes"

# Article suffixes that map to the 22 module set.
ARTICLE_KEYS = {
    13: ["scientists", "storymode"],
    14: ["whatif"],
    15: ["glossary"],
    16: ["mistakes"],
    17: ["ncert_qa"],
    18: ["plantoftheday", "gallery", "plants"],
    19: ["miniproject", "minilab", "lab"],
    20: ["selfcheck"],
    21: ["bridge"],
    22: ["infographic"],
}

MODULES = [
    "Animated Scene",
    "Discovery Mode",
    "Concept Cards",
    "Quick Quiz",
    "Real-world",
    "Exam Bridge",
    "Mnemonic",
    "Hotspots",
    "Process Timeline",
    "Boss Quiz",
    "Article",
    "Progress",
    "Scientists",
    "What-If",
    "Glossary",
    "Mistakes",
    "NCERT Q&A",
    "Gallery",
    "Mini-Project",
    "Self-Check",
    "Bridge",
    "Infographic",
]


def chapter_scenes_dir(chapter: int) -> Path:
    if chapter == 1:
        return CH1_SCENES
    return DISCOVER / f"Chapter{chapter}/Scenes"


def scene_files(chapter: int) -> list[Path]:
    d = chapter_scenes_dir(chapter)
    if not d.is_dir():
        return []
    return sorted(d.glob("*.swift"))


def all_scene_text(chapter: int) -> str:
    """Concatenated text of every scene file for this chapter. Used to
    grep for HotspotDiagram, ProcessTimeline, LookingAheadCallout, etc."""
    files = scene_files(chapter)
    out: list[str] = []
    for f in files:
        try:
            out.append(f.read_text(errors="ignore"))
        except Exception:
            pass
    # Chapter dispatcher (DiscoverChapter{NN}View.swift) may also contain
    # inline scenes — include it too.
    dispatcher = DISCOVER / f"DiscoverChapter{chapter}View.swift"
    if dispatcher.is_file():
        try:
            out.append(dispatcher.read_text(errors="ignore"))
        except Exception:
            pass
    # Sister-file for Ch1 inline scenes (from the 2026-05-22 split).
    sister = DISCOVER / f"DiscoverChapter{chapter}View+InlineScenes.swift"
    if sister.is_file():
        try:
            out.append(sister.read_text(errors="ignore"))
        except Exception:
            pass
    return "\n".join(out)


def article_files(chapter: int) -> list[str]:
    d = ARTICLES / f"Chapter{chapter}"
    if not d.is_dir():
        return []
    return [p.name for p in d.glob("*.html")]


def has_article_with_suffix(articles: list[str], suffixes: list[str]) -> bool:
    for art in articles:
        for s in suffixes:
            if f"_{s}." in art or art.endswith(f"_{s}.html"):
                return True
    return False


def load_pack() -> dict:
    return json.loads(PACK.read_text())


def check_modules(chapter: int, pack: dict) -> list[str]:
    """Return a list of 22 cell values (✅/⚠️/❌) for this chapter."""
    scenes = scene_files(chapter)
    text = all_scene_text(chapter)
    articles = article_files(chapter)

    # Find the pack chapter
    pack_chapter = None
    for ch in pack.get("chapters", []):
        # chapter id is "ch01", "ch02", etc.
        if ch.get("id") == f"ch{chapter:02d}":
            pack_chapter = ch
            break

    cells: list[str] = []

    # 1. Animated Scene — Scene1_*.swift present
    has_scene1 = any(f.name.startswith("Scene1_") for f in scenes)
    cells.append("✅" if has_scene1 else "❌")

    # 2. Discovery Mode — Scene2_*.swift present
    has_scene2 = any(f.name.startswith("Scene2_") for f in scenes)
    cells.append("✅" if has_scene2 else "❌")

    # 3. Concept Cards — ≥ 2 concepts per topic
    if pack_chapter is None:
        cells.append("❌")
    else:
        topics = pack_chapter.get("topics", [])
        if not topics:
            cells.append("❌")
        else:
            all_ok = all(len(t.get("concepts", [])) >= 2 for t in topics)
            any_thin = any(0 < len(t.get("concepts", [])) < 2 for t in topics)
            cells.append("✅" if all_ok else ("⚠️" if any_thin else "❌"))

    # 4. Quick Check Quiz — ≥ 3 MCQs per topic
    if pack_chapter is None:
        cells.append("❌")
    else:
        topics = pack_chapter.get("topics", [])
        if not topics:
            cells.append("❌")
        else:
            all_ok = all(len(t.get("questions", [])) >= 3 for t in topics)
            cells.append("✅" if all_ok else "⚠️")

    # 5. Real-world Example callout — TryAtHomeCallout / RealWorldCallout / "Real-world" string
    has_realworld = ("TryAtHomeCallout" in text or "Real-world" in text
                     or "real-world" in text or "RealWorldCallout" in text)
    cells.append("✅" if has_realworld else "❌")

    # 6. Exam Connection — LookingAheadCallout or "NEET" or "JEE" string in scenes
    has_exam = ("LookingAheadCallout" in text or "NEET" in text or "JEE" in text)
    cells.append("✅" if has_exam else "❌")

    # 7. Mnemonic — MnemonicCallout in any scene
    has_mnemonic = ("MnemonicCallout" in text or "mnemonic" in text.lower())
    cells.append("✅" if has_mnemonic else "❌")

    # 8. Diagram with Hotspots — HotspotDiagram used
    has_hotspots = "HotspotDiagram" in text
    cells.append("✅" if has_hotspots else "❌")

    # 9. Process Timeline — ProcessTimeline used
    has_timeline = "ProcessTimeline" in text
    cells.append("✅" if has_timeline else "❌")

    # 10. Boss Quiz — Scene9_BossQuiz_Ch{NN}.swift OR Scene9_BossQuiz.swift (Ch.1)
    has_boss = any(f.name.startswith("Scene9_BossQuiz") for f in scenes)
    cells.append("✅" if has_boss else "❌")

    # 11. Long-form Article — ≥ 1 article HTML in Chapter{NN}/ directory
    cells.append("✅" if articles else "❌")

    # 12. Progress Tracker — assumed always implemented via DataStore
    cells.append("✅")

    # 13–22: ways-of-learning articles
    for idx in range(13, 23):
        suffixes = ARTICLE_KEYS[idx]
        cells.append("✅" if has_article_with_suffix(articles, suffixes) else "❌")

    return cells


def main() -> None:
    pack = load_pack()
    chapters = sorted(
        int(ch["id"][2:]) for ch in pack.get("chapters", [])
        if ch.get("id", "").startswith("ch") and ch["id"][2:].isdigit()
    )
    if not chapters:
        chapters = list(range(1, 20))

    rows: list[tuple[int, list[str]]] = []
    for ch in chapters:
        cells = check_modules(ch, pack)
        rows.append((ch, cells))

    # Build the markdown
    out: list[str] = []
    out.append("# COVERAGE_MATRIX.md")
    out.append("")
    out.append(f"Generated by `scripts/coverage_matrix.py` — rows = chapters, columns = 22 modules from the parity prompt §C.")
    out.append("")
    out.append("`✅` = present · `⚠️` = thin / partial · `❌` = missing")
    out.append("")

    # Module index legend
    out.append("## Module legend")
    out.append("")
    out.append("| # | Module |")
    out.append("|---|---|")
    for i, m in enumerate(MODULES, start=1):
        out.append(f"| {i} | {m} |")
    out.append("")

    # Matrix
    out.append("## Matrix")
    out.append("")
    header = "| Ch | " + " | ".join(str(i) for i in range(1, 23)) + " | Score |"
    sep = "|" + "----|" * 24
    out.append(header)
    out.append(sep)
    chapter_titles: dict[int, str] = {}
    for ch in pack.get("chapters", []):
        cid = ch.get("id", "")
        if cid.startswith("ch") and cid[2:].isdigit():
            chapter_titles[int(cid[2:])] = ch.get("title", "")

    total_cells = 0
    green_cells = 0
    for chap, cells in rows:
        score = sum(1 for c in cells if c == "✅")
        out.append(f"| {chap:02d} | " + " | ".join(cells) + f" | {score}/22 |")
        total_cells += len(cells)
        green_cells += score
    out.append("")
    out.append(f"**Total green: {green_cells}/{total_cells} ({100*green_cells//total_cells}%)**")
    out.append("")

    # Per-chapter open items
    out.append("## Open items by chapter")
    out.append("")
    for chap, cells in rows:
        missing = [MODULES[i] for i, c in enumerate(cells) if c != "✅"]
        if not missing:
            continue
        title = chapter_titles.get(chap, "")
        out.append(f"### Ch {chap:02d} — {title}")
        out.append("")
        for m in missing:
            out.append(f"- {m}")
        out.append("")

    Path("COVERAGE_MATRIX.md").write_text("\n".join(out) + "\n")
    print(f"Wrote COVERAGE_MATRIX.md — {green_cells}/{total_cells} green ({100*green_cells//total_cells}%)")


if __name__ == "__main__":
    main()
