#!/usr/bin/env python3
"""Class-7-appropriate reading level lint for Discover callout content.

Closes the CT6 row in docs/ISSUE_CATEGORIES.md: validates that the
`detail:` strings inside `LookingAheadCallout(...)` and
`TryAtHomeCallout(...)` invocations across every Scene*.swift sit at
a reading grade level appropriate for Class 7 (~12-year-old) readers.

Uses the Flesch-Kincaid Grade Level formula — no external dependency:

  grade = 0.39 × (words / sentences)
        + 11.8 × (syllables / words)
        - 15.59

Target band: grade <= 9.0 for accessible Class-7 reading. A grade of
12 means high-school senior; 16 means undergraduate. The callouts
are *Class 11 / NEET / IIT preview content* by design, so the bar is
somewhat lenient: grade 11 is acceptable, grade 13+ triggers a warning.

The script does NOT enforce a hard ceiling — callouts are educator
content with mature vocabulary by design. It flags outliers so the
content author can review.

Usage:
    python3 scripts/check_callout_reading_level.py [--threshold 12.0]
    python3 scripts/check_callout_reading_level.py --json
"""
import argparse
import json
import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SCENES_ROOT = REPO_ROOT / "desktopAhaan/Subjects/Tutor/Discover"

# Match the multi-line `LookingAheadCallout(...)` and `TryAtHomeCallout(...)`
# invocations and capture the `detail:` string. The callouts span multiple
# lines but always pass `title:` then `detail:` as named arguments with
# string literals, so this regex is sufficient for the current codebase.
CALLOUT_RE = re.compile(
    r'\b(LookingAheadCallout|TryAtHomeCallout)\s*\(\s*'
    r'title:\s*"(?P<title>[^"]+)"\s*,\s*'
    r'detail:\s*"(?P<detail>(?:[^"\\]|\\.)*)"',
    re.DOTALL,
)


def count_syllables(word: str) -> int:
    """Rough syllable count for English words (no external dictionary).

    The standard heuristic: count vowel groups (consecutive vowels = one
    syllable), subtract one for trailing silent 'e', add one if the word
    ends in 'le' preceded by a consonant. Good enough for grade-level
    estimation; the absolute number matters less than the relative
    ranking across callouts.
    """
    w = word.lower()
    # Strip non-alpha (punctuation already stripped upstream, but just in case).
    w = re.sub(r"[^a-z]", "", w)
    if not w:
        return 0
    # Vowel-group count.
    syllables = len(re.findall(r"[aeiouy]+", w))
    # Silent trailing 'e'.
    if w.endswith("e") and syllables > 1:
        syllables -= 1
    # 'le' at end preceded by consonant adds one (e.g., "table").
    if len(w) >= 3 and w.endswith("le") and w[-3] not in "aeiouy":
        syllables += 1
    return max(1, syllables)


SENTENCE_END = re.compile(r"[.!?]+")
WORD_RE = re.compile(r"\b[A-Za-z][A-Za-z'-]*\b")


def grade_level(text: str) -> tuple[float, int, int, int]:
    """Flesch-Kincaid grade level + raw counts (words, sentences, syllables)."""
    # Decode escape sequences (text comes from a Swift string literal with \"
    # and \\ already escaped; standard json-style decoding does the trick).
    text = text.encode("utf-8").decode("unicode_escape")
    sentences = [s for s in SENTENCE_END.split(text) if s.strip()]
    words = WORD_RE.findall(text)
    if not sentences or not words:
        return 0.0, len(words), len(sentences), 0
    syllables = sum(count_syllables(w) for w in words)
    grade = (
        0.39 * (len(words) / len(sentences))
        + 11.8 * (syllables / len(words))
        - 15.59
    )
    return grade, len(words), len(sentences), syllables


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "--threshold", type=float, default=13.0,
        help="grade-level threshold above which a callout is flagged (default 13.0). "
             "Class-7 baseline is ~9; the callouts are exam-prep with mature "
             "vocabulary, so 13 is the practical warning line."
    )
    ap.add_argument("--json", action="store_true", help="emit JSON report")
    args = ap.parse_args()

    findings: list[dict] = []
    callout_count = 0
    for swift_path in SCENES_ROOT.rglob("Scene*.swift"):
        text = swift_path.read_text(encoding="utf-8")
        for m in CALLOUT_RE.finditer(text):
            callout_count += 1
            kind = m.group(1)
            title = m.group("title")
            detail = m.group("detail")
            grade, w, s, syl = grade_level(detail)
            rel = str(swift_path.relative_to(REPO_ROOT))
            if grade > args.threshold:
                findings.append({
                    "file": rel,
                    "kind": kind,
                    "title": title,
                    "grade": round(grade, 1),
                    "words": w,
                    "sentences": s,
                    "syllables": syl,
                })

    if args.json:
        print(json.dumps({
            "callouts_scanned": callout_count,
            "threshold": args.threshold,
            "flagged_count": len(findings),
            "flagged": findings,
        }, indent=2))
        return 0 if not findings else 1

    print(
        f"check_callout_reading_level: scanned {callout_count} callout(s) across "
        f"{SCENES_ROOT.relative_to(REPO_ROOT)}/, flagging grade > {args.threshold}"
    )
    if not findings:
        print("clean — every callout reads at or below the threshold.")
        return 0
    print(f"\n{len(findings)} callout(s) above the threshold:")
    for f in findings:
        print(f"  {f['file']} · {f['kind']}('{f['title'][:50]}') · grade={f['grade']} "
              f"(words={f['words']}, sentences={f['sentences']})")
    print(
        f"\nThese are above the Class-7-appropriate band. Consider shortening "
        f"sentences or simplifying vocabulary in the detail strings. "
        f"NOT a hard gate — callouts are exam-prep with intentional mature "
        f"vocabulary; review case by case."
    )
    return 1


if __name__ == "__main__":
    sys.exit(main())
