#!/usr/bin/env python3
"""One-shot pbxproj patcher: wire OlympiadExamHallTests.swift into the
test target. Same shape as the test-fileRef section of
add_attempt_store_pbxproj.py — bare-UUID children format for the
desktopAhaanTests PBXGroup; SOURCE_TREE = "<group>" with bare path.
"""
from __future__ import annotations

import hashlib
import re
import sys
from pathlib import Path

PBXPROJ = Path(__file__).resolve().parent.parent / "desktopAhaan.xcodeproj" / "project.pbxproj"

TEST_FILES = [
    "desktopAhaanTests/OlympiadExamHallTests.swift",
]


def uuid_for(seed: str) -> str:
    return hashlib.md5(seed.encode()).hexdigest()[:24].upper()


def main() -> int:
    text = PBXPROJ.read_text()
    for relpath in TEST_FILES:
        name = Path(relpath).name
        ref_uuid = uuid_for(f"fileRef::{relpath}")
        build_uuid = uuid_for(f"buildFile::{relpath}")

        if ref_uuid not in text:
            build_entry = (
                f"\t\t{build_uuid} /* {name} in Sources */ = "
                f"{{isa = PBXBuildFile; fileRef = {ref_uuid} /* {name} */; }};"
            )
            m = re.search(r"(/\* Begin PBXBuildFile section \*/\n)", text)
            if not m:
                print("FATAL: PBXBuildFile section not found", file=sys.stderr); return 2
            text = text[:m.end()] + build_entry + "\n" + text[m.end():]

            ref_entry = (
                f"\t\t{ref_uuid} /* {name} */ = "
                f"{{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; "
                f"path = \"{name}\"; sourceTree = \"<group>\"; }};"
            )
            m = re.search(r"(/\* Begin PBXFileReference section \*/\n)", text)
            if not m:
                print("FATAL: PBXFileReference section not found", file=sys.stderr); return 2
            text = text[:m.end()] + ref_entry + "\n" + text[m.end():]

            sources_anchor = "AchievementEngineTests.swift in Sources */,"
            idx = text.find(sources_anchor)
            if idx == -1:
                print("FATAL: test Sources anchor not found", file=sys.stderr); return 2
            line_end = text.find("\n", idx) + 1
            text = text[:line_end] + f"\t\t\t\t{build_uuid} /* {name} in Sources */,\n" + text[line_end:]
            print(f"add (test): {relpath} (build={build_uuid[:8]}… ref={ref_uuid[:8]}…)")
        else:
            print(f"skip fileRef (already present): {name}")

        # Group-children entry (bare UUIDs, anchor on the existing
        # AchievementEngineTests UUID line).
        existing_anchor = "6D033327D5539F6B20268E1C,\n"
        bare_child_line = f"\t\t\t\t{ref_uuid},\n"
        if bare_child_line not in text:
            gi = text.find(existing_anchor)
            if gi == -1:
                print("FATAL: desktopAhaanTests group anchor not found", file=sys.stderr); return 2
            line_end = gi + len(existing_anchor)
            text = text[:line_end] + bare_child_line + text[line_end:]
            print(f"add (test-group-child): {name}")

    PBXPROJ.write_text(text)
    print(f"\nWrote {PBXPROJ}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
