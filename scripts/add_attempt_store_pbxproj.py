#!/usr/bin/env python3
"""One-shot pbxproj patcher: add the two new Olympiad-attempt-store
Swift files to the project + the OlympiadAttempt fileRef to the
OlympiadTests PBXGroup.

Files:
  • desktopAhaan/Subjects/OlympiadTests/OlympiadAttempt.swift
  • desktopAhaan/Services/Persistence/DataStore+OlympiadAttempts.swift

Idempotent. Pattern matches `add_olympiad_pbxproj.py` — deterministic
MD5-derived UUIDs, SOURCE_ROOT-anchored fileRefs.
"""
from __future__ import annotations

import hashlib
import re
import sys
from pathlib import Path

PBXPROJ = Path(__file__).resolve().parent.parent / "desktopAhaan.xcodeproj" / "project.pbxproj"

# (relative path from repo root, also the navigator name)
FILES = [
    "desktopAhaan/Subjects/OlympiadTests/OlympiadAttempt.swift",
    "desktopAhaan/Services/Persistence/DataStore+OlympiadAttempts.swift",
]
# Test files wire into the test target's Sources phase, not the main
# app target. Path is anchored at the test target's group root so we
# use the same conventions as the rest of desktopAhaanTests.
TEST_FILES = [
    "desktopAhaanTests/OlympiadAttemptStoreTests.swift",
]

# UUID of the OlympiadTests PBXGroup created by fix_recovered_references.py.
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

        # 1) PBXBuildFile entry
        build_entry = (
            f"\t\t{build_uuid} /* {name} in Sources */ = "
            f"{{isa = PBXBuildFile; fileRef = {ref_uuid} /* {name} */; }};"
        )
        m = re.search(r"(/\* Begin PBXBuildFile section \*/\n)", text)
        if not m:
            print("FATAL: PBXBuildFile section not found", file=sys.stderr)
            return 2
        text = text[:m.end()] + build_entry + "\n" + text[m.end():]

        # 2) PBXFileReference entry
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

        # 3) Sources build-phase entry — find the main app target's Sources
        #    phase by locating the line with "OlympiadHubView.swift in Sources"
        #    which is guaranteed to be in there.
        sources_marker = "OlympiadHubView.swift in Sources */,"
        idx = text.find(sources_marker)
        if idx == -1:
            print("FATAL: Sources phase anchor not found", file=sys.stderr)
            return 2
        # Insert our new line on the line AFTER the OlympiadHubView line.
        line_end = text.find("\n", idx) + 1
        new_line = f"\t\t\t\t{build_uuid} /* {name} in Sources */,\n"
        text = text[:line_end] + new_line + text[line_end:]

        # 4) For the OlympiadAttempt.swift file, also add to the
        #    OlympiadTests PBXGroup so it appears in the navigator under
        #    the right folder (not in Recovered References).
        if name == "OlympiadAttempt.swift":
            group_re = re.compile(
                r"(\t\t" + OLYMPIAD_GROUP_UUID + r" /\* OlympiadTests \*/ = \{\n"
                r"\t\t\tisa = PBXGroup;\n"
                r"\t\t\tchildren = \([\s\S]*?)(\t\t\t\);)"
            )
            gm = group_re.search(text)
            if not gm:
                print("FATAL: OlympiadTests PBXGroup not found", file=sys.stderr)
                return 2
            new_children = (
                gm.group(1).rstrip("\n") + "\n"
                + f"\t\t\t\t{ref_uuid} /* {name} */,\n"
                + gm.group(2)
            )
            text = text[:gm.start()] + new_children + text[gm.end():]

        print(f"add: {relpath} (build={build_uuid[:8]}… ref={ref_uuid[:8]}…)")

    for relpath in TEST_FILES:
        name = Path(relpath).name
        ref_uuid = uuid_for(f"fileRef::{relpath}")
        build_uuid = uuid_for(f"buildFile::{relpath}")

        # The fileRef + build + Sources entries may already be present
        # from a partial earlier run. Skip those individually, but
        # ALWAYS fall through to the group-children check below so we
        # can repair a missing navigator/group anchor on its own — Xcode
        # can't resolve a `<group>`-sourceTree fileRef's path without
        # the parent-group link.
        if ref_uuid not in text:
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
                f"path = \"{name}\"; sourceTree = \"<group>\"; }};"
            )
            m = re.search(r"(/\* Begin PBXFileReference section \*/\n)", text)
            if not m:
                print("FATAL: PBXFileReference section not found", file=sys.stderr)
                return 2
            text = text[:m.end()] + ref_entry + "\n" + text[m.end():]

            sources_anchor = "AchievementEngineTests.swift in Sources */,"
            idx = text.find(sources_anchor)
            if idx == -1:
                print("FATAL: test Sources anchor not found", file=sys.stderr)
                return 2
            line_end = text.find("\n", idx) + 1
            new_line = f"\t\t\t\t{build_uuid} /* {name} in Sources */,\n"
            text = text[:line_end] + new_line + text[line_end:]
            print(f"add (test): {relpath} (build={build_uuid[:8]}… ref={ref_uuid[:8]}…)")
        else:
            print(f"skip fileRef (already present): {name}")

        # Always check: is the fileRef listed as a child of the
        # desktopAhaanTests PBXGroup? Children use BARE UUIDs (no
        # `/* name */` suffix). Anchor on AchievementEngineTests's UUID.
        # Skip if our UUID is already in the children block.
        existing_anchor = "6D033327D5539F6B20268E1C,\n"
        bare_child_line = f"\t\t\t\t{ref_uuid},\n"
        if bare_child_line not in text:
            gi = text.find(existing_anchor)
            if gi == -1:
                print("FATAL: desktopAhaanTests group anchor not found", file=sys.stderr)
                return 2
            line_end = gi + len(existing_anchor)
            text = text[:line_end] + bare_child_line + text[line_end:]
            print(f"add (test-group-child): {name}")

    PBXPROJ.write_text(text)
    print(f"\nWrote {PBXPROJ}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
