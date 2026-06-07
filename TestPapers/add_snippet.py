#!/usr/bin/env python3
"""Append a ready-to-paste OlympiadPaper(...) registry snippet to IN_APP_INTEGRATION.md.

Usage:
    python3 add_snippet.py <olyId> <subjectId> <subjectName> <chapterNum> <chapterTitle> <fileStem>

e.g. python3 add_snippet.py olympiad_socialscience_ssch06 socialscience_class7 \\
        "Social Science" 6 "The Age of Reorganisation" \\
        SocialScience_Ssch06_TheAgeOfReorganisation
"""
import os
import sys


def main():
    if len(sys.argv) != 7:
        print(__doc__)
        return 2
    oly_id, subject_id, subject_name, chnum, chtitle, stem = sys.argv[1:7]
    here = os.path.dirname(os.path.abspath(__file__))
    path = os.path.join(here, "IN_APP_INTEGRATION.md")
    block = f"""
```swift
        OlympiadPaper(
            id: "{oly_id}",
            subjectId: "{subject_id}",
            subjectName: "{subject_name}",
            chapterNumber: {chnum},
            chapterTitle: "{chtitle}",
            displayTitle: "{chtitle} — 60 MCQ Olympiad",
            questionPaperMD: "{stem}_QuestionPaper.md",
            solutionsMD: "{stem}_Solutions.md",
            questionPaperHTML: "{stem}.html",
            questionPaperPDF: "{stem}.pdf",
            solvedGuideHTML: "{stem}_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```
"""
    with open(path, "a", encoding="utf-8") as f:
        f.write(block)
    print(f"appended snippet for {oly_id}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
