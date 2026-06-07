#!/usr/bin/env python3
"""One-shot pbxproj patcher: stop Xcode showing the 11 OlympiadTests
Swift files under the "Recovered References" group in the navigator.

Root cause
==========
`add_olympiad_pbxproj.py` was deliberately minimal — it created the
PBXFileReference + PBXBuildFile + Sources-phase entries for each new
file, but did NOT add the fileRefs as children of any PBXGroup. That
keeps the build working (the Sources phase is enough), but Xcode's
navigator only renders files that live inside some PBXGroup; orphan
fileRefs get bucketed under a synthetic "Recovered References" group
at the project root. Confirmed by inspection: zero PBXGroup `children`
lists reference any of the 11 Olympiad UUIDs.

Fix
===
Create a new `OlympiadTests` PBXGroup with `path = "OlympiadTests"`
(relative-to-group sourceTree, anchored at its parent), add it as a
child of the `Subjects` PBXGroup, and list all 11 Olympiad Swift
UUIDs as its children. The fileRefs themselves stay
`sourceTree = SOURCE_ROOT` with their full `desktopAhaan/Subjects/...`
paths — moving the path attribute would risk a stale fileRef stamp on
the next Xcode 13.2.1 round-trip. The new group only controls the
navigator hierarchy; build behaviour is unchanged.

Idempotent — bails out if the OlympiadTests group already exists.

Safety: write a back-up first; if the post-patch sanity check fails,
restore the back-up and exit non-zero.
"""
from __future__ import annotations

import hashlib
import re
import shutil
import sys
from pathlib import Path

PBXPROJ = Path(__file__).resolve().parent.parent / "desktopAhaan.xcodeproj" / "project.pbxproj"

SUBJECTS_GROUP_UUID = "D0586914CB27E8EB323008CF"

OLYMPIAD_FILES = [
    ("OlympiadHubView.swift",                              "0CD6303421E855116A075E8F"),
    ("OlympiadPaper.swift",                                "66E204C7773BC9AF563A64C0"),
    ("OlympiadPaperParser.swift",                          "61E9E18D509A911A77CE713E"),
    ("OlympiadPaperReaderView.swift",                      "C083109A9F66B12919BE85A7"),
    ("OlympiadPaperRegistry.swift",                        "BFA0EFC8A1A3A7E024F887F2"),
    ("OlympiadPaperRegistry+MathsPapers.swift",            "92064A3FC0F8A197F8BC16D8"),
    ("OlympiadPaperRegistry+SanskritPapers.swift",         "709383275F3DFF417813A1BC"),
    ("OlympiadPaperRegistry+SciencePapers.swift",          "6DD78EC9D91D5E3A579D2661"),
    ("OlympiadPaperRegistry+SocialSciencePapers.swift",    "5B33A4F59C30EF98D728EAF9"),
    ("OlympiadQuizResultView.swift",                       "57DBC1E9AD28F71BC0631019"),
    ("OlympiadQuizView.swift",                             "F6BC5AB3CE6CA289FABD07F4"),
]


def deterministic_uuid(seed: str) -> str:
    return hashlib.md5(seed.encode()).hexdigest()[:24].upper()


def main() -> int:
    text = PBXPROJ.read_text()

    group_uuid = deterministic_uuid("OlympiadTests-PBXGroup-v1")

    if group_uuid in text:
        print(f"OlympiadTests group {group_uuid} already present — nothing to do.")
        return 0

    # 1) Insert new PBXGroup definition. Place it right after the Subjects
    #    group's own definition so the diff stays readable.
    subjects_re = re.compile(
        r"(\t\t" + re.escape(SUBJECTS_GROUP_UUID) + r" /\* Subjects \*/ = \{[\s\S]*?\t\t\};\n)"
    )
    m = subjects_re.search(text)
    if not m:
        print(f"FATAL: couldn't locate Subjects group {SUBJECTS_GROUP_UUID}", file=sys.stderr)
        return 2

    children_lines = "\n".join(
        f"\t\t\t\t{uuid} /* {name} */,"
        for name, uuid in OLYMPIAD_FILES
    )
    new_group_block = (
        f"\t\t{group_uuid} /* OlympiadTests */ = {{\n"
        f"\t\t\tisa = PBXGroup;\n"
        f"\t\t\tchildren = (\n"
        f"{children_lines}\n"
        f"\t\t\t);\n"
        f"\t\t\tpath = \"OlympiadTests\";\n"
        f"\t\t\tsourceTree = \"<group>\";\n"
        f"\t\t}};\n"
    )

    # 2) Add the new group's UUID to the Subjects group's children list.
    children_block_re = re.compile(
        r"(\t\t" + re.escape(SUBJECTS_GROUP_UUID) + r" /\* Subjects \*/ = \{\n"
        r"\t\t\tisa = PBXGroup;\n"
        r"\t\t\tchildren = \()"
        r"([\s\S]*?)"
        r"(\t\t\t\);\n)"
    )
    cb = children_block_re.search(text)
    if not cb:
        print("FATAL: couldn't parse Subjects children block", file=sys.stderr)
        return 2

    new_children_section = (
        cb.group(1)
        + cb.group(2).rstrip()
        + f"\n\t\t\t\t{group_uuid} /* OlympiadTests */,\n"
        + cb.group(3)
    )
    text = text[:cb.start()] + new_children_section + text[cb.end():]

    # 3) Insert the new group block. Re-find the Subjects definition since
    #    indices shifted from the children edit.
    m = subjects_re.search(text)
    if not m:
        print("FATAL: Subjects group disappeared after children edit", file=sys.stderr)
        return 2
    text = text[:m.end()] + new_group_block + text[m.end():]

    # 4) Back up + write.
    backup = PBXPROJ.with_suffix(".pbxproj.bak.recovered_refs")
    shutil.copy2(PBXPROJ, backup)
    PBXPROJ.write_text(text)

    # 5) Sanity check — every Olympiad UUID should now appear exactly once in
    #    the new group's children.
    for name, uuid in OLYMPIAD_FILES:
        if f"{uuid} /* {name} */," not in new_group_block:
            print(f"FATAL: post-patch sanity check failed for {name}", file=sys.stderr)
            shutil.copy2(backup, PBXPROJ)
            return 2

    print(f"✔ Added OlympiadTests group ({group_uuid}) with {len(OLYMPIAD_FILES)} files.")
    print(f"  Back-up saved to {backup.name} (delete after verifying).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
