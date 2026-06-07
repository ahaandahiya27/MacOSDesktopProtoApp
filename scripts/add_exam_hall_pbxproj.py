#!/usr/bin/env python3
"""One-shot pbxproj patcher: wire the 3 new Olympiad Exam Hall files.

  • desktopAhaan/Subjects/OlympiadTests/OlympiadInProgress.swift
  • desktopAhaan/Subjects/OlympiadTests/OlympiadScoreReportRenderer.swift
  • desktopAhaan/Services/Persistence/DataStore+OlympiadInProgress.swift

Idempotent. Uses the same convention as add_attempt_store_pbxproj.py:
deterministic MD5-derived UUIDs, SOURCE_ROOT-anchored fileRefs, and
adds the two OlympiadTests Swift files to the OlympiadTests PBXGroup
so they appear in Xcode's navigator instead of Recovered References.
"""
from __future__ import annotations

import hashlib
import re
import sys
from pathlib import Path

PBXPROJ = Path(__file__).resolve().parent.parent / "desktopAhaan.xcodeproj" / "project.pbxproj"

FILES = [
    "desktopAhaan/Subjects/OlympiadTests/OlympiadInProgress.swift",
    "desktopAhaan/Subjects/OlympiadTests/OlympiadScoreReportRenderer.swift",
    "desktopAhaan/Services/Persistence/DataStore+OlympiadInProgress.swift",
]

OLYMPIAD_GROUP_UUID = "50FC70F307728604197360C9"


def uuid_for(seed: str) -> str:
    return hashlib.md5(seed.encode()).hexdigest()[:24].upper()


def main() -> int:
    text = PBXPROJ.read_text()

    for relpath in FILES:
        name = Path(relpath).name
        ref_uuid = uuid_for(f"fileRef::{relpath}")
        build_uuid = uuid_for(f"buildFile::{relpath}")

        if ref_uuid in text:
            print(f"skip (already present): {name}")
            continue

        build_entry = (
            f"\t\t{build_uuid} /* {name} in Sources */ = "
            f"{{isa = PBXBuildFile; fileRef = {ref_uuid} /* {name} */; }};"
        )
        m = re.search(r"(/\* Begin PBXBuildFile section \*/\n)", text)
        if not m:
            print("FATAL: PBXBuildFile section not found", file=sys.stderr)
            return 2
        text = text[:m.end()] + build_entry + "\n" + text[m.end():]

        ref_entry = (
            f"\t\t{ref_uuid} /* {name} */ = "
            f"{{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; "
            f"name = \"{name}\"; path = \"{relpath}\"; sourceTree = SOURCE_ROOT; }};"
        )
        m = re.search(r"(/\* Begin PBXFileReference section \*/\n)", text)
        if not m:
            print("FATAL: PBXFileReference section not found", file=sys.stderr)
            return 2
        text = text[:m.end()] + ref_entry + "\n" + text[m.end():]

        sources_anchor = "OlympiadHubView.swift in Sources */,"
        idx = text.find(sources_anchor)
        if idx == -1:
            print("FATAL: Sources phase anchor not found", file=sys.stderr)
            return 2
        line_end = text.find("\n", idx) + 1
        new_line = f"\t\t\t\t{build_uuid} /* {name} in Sources */,\n"
        text = text[:line_end] + new_line + text[line_end:]

        # The two OlympiadTests-folder Swift files belong in the
        # OlympiadTests PBXGroup so Xcode's navigator shows them under
        # the right folder (not in Recovered References). The
        # Services/Persistence file lives elsewhere — leaving its
        # group-membership alone matches the existing
        # DataStore+OlympiadAttempts.swift convention.
        if relpath.startswith("desktopAhaan/Subjects/OlympiadTests/"):
            group_re = re.compile(
                r"(\t\t" + OLYMPIAD_GROUP_UUID + r" /\* OlympiadTests \*/ = \{\n"
                r"\t\t\tisa = PBXGroup;\n"
                r"\t\t\tchildren = \([\s\S]*?)(\t\t\t\);)"
            )
            gm = group_re.search(text)
            if gm:
                new_children = (
                    gm.group(1).rstrip("\n") + "\n"
                    + f"\t\t\t\t{ref_uuid} /* {name} */,\n"
                    + gm.group(2)
                )
                text = text[:gm.start()] + new_children + text[gm.end():]

        print(f"add: {relpath} (build={build_uuid[:8]}… ref={ref_uuid[:8]}…)")

    PBXPROJ.write_text(text)
    print(f"\nWrote {PBXPROJ}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
