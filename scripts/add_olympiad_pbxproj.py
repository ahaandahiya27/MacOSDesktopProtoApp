#!/usr/bin/env python3
"""One-time pbxproj patcher: add OlympiadTests Swift files + TestPapers
resources to desktopAhaan.xcodeproj/project.pbxproj.

Idempotent — checks if the entries already exist before adding. Safe to
re-run on a partial-add state. Generates deterministic UUIDs from the
filename so subsequent runs don't churn the project.

Convention: this is a ONE-OFF tool, not a recurring lint. Once the
feature lands, the entries are baked in and this script doesn't need
to run again. Kept in the repo so a future Agent can audit how the
files got added.

Background: the project uses objectVersion = 55 (Xcode 13.2.1 format),
which does NOT support PBXFileSystemSynchronizedRootGroup. New files
require explicit pbxproj entries. CLAUDE.md says to use Xcode's
Add Files dialog — but the dev Mac uses headless `xcodebuild` via the
MCP, so direct pbxproj manipulation is safe here.
"""
from __future__ import annotations

import hashlib
import os
import re
import sys
from pathlib import Path

PBXPROJ = Path(__file__).resolve().parent.parent / "desktopAhaan.xcodeproj" / "project.pbxproj"

# Swift files to add. Paths are RELATIVE TO THE PROJECT ROOT (i.e. they
# include the inner "desktopAhaan/" prefix). We use sourceTree =
# SOURCE_ROOT to avoid having to thread the file refs through a parent
# group's path — the absolute project-root anchor is the simpler and
# more idempotent choice.
SWIFT_FILES = [
    "desktopAhaan/Subjects/OlympiadTests/OlympiadPaper.swift",
    "desktopAhaan/Subjects/OlympiadTests/OlympiadPaperParser.swift",
    "desktopAhaan/Subjects/OlympiadTests/OlympiadPaperRegistry.swift",
    "desktopAhaan/Subjects/OlympiadTests/OlympiadHubView.swift",
    "desktopAhaan/Subjects/OlympiadTests/OlympiadQuizView.swift",
    "desktopAhaan/Subjects/OlympiadTests/OlympiadQuizResultView.swift",
]

# Resource files. These ship as bundle resources (Copy Bundle Resources
# phase), accessed via Bundle.main.url(forResource:withExtension:
# subdirectory: "TestPapers").
RESOURCE_FILES = [
    "desktopAhaan/Resources/TestPapers/Science_Ch13_MotionAndTime_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch13_MotionAndTime_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch13_MotionAndTime.html",
    "desktopAhaan/Resources/TestPapers/Science_Ch13_MotionAndTime.pdf",
    "desktopAhaan/Resources/TestPapers/Maths_Ch15_FindingTheUnknown_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch15_FindingTheUnknown_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch15_FindingTheUnknown.html",
    "desktopAhaan/Resources/TestPapers/Maths_Ch15_FindingTheUnknown.pdf",
]


def stable_uuid(seed: str) -> str:
    """Generate a 24-hex-char UUID deterministically from a seed.

    Xcode pbxproj UUIDs are 24-character uppercase hex. Using MD5 of the
    seed → take first 24 hex chars guarantees idempotent re-runs.
    """
    return hashlib.md5(seed.encode("utf-8")).hexdigest()[:24].upper()


def filetype_for(path: str) -> str:
    """Return the lastKnownFileType for the given path."""
    ext = path.rsplit(".", 1)[-1].lower()
    return {
        "swift": "sourcecode.swift",
        "html": "text.html",
        "md": "net.daringfireball.markdown",
        "pdf": "image.pdf",
    }.get(ext, "text")


def patch(text: str) -> tuple[str, list[str]]:
    """Return (new_text, log_lines). Idempotent."""
    log: list[str] = []
    out = text

    # The synthesized seed uses the basename so the same UUID is used
    # everywhere this file is referenced.
    new_build_file_lines: list[str] = []
    new_file_ref_lines: list[str] = []
    new_sources_phase_lines: list[str] = []
    new_resources_phase_lines: list[str] = []

    for rel_path in SWIFT_FILES + RESOURCE_FILES:
        bare = os.path.basename(rel_path)
        is_swift = rel_path.endswith(".swift")
        # Idempotency check: if a PBXBuildFile line already references
        # this exact basename, skip. The match looks at the line shape
        # `<24-hex-UUID> /* <bare> in <Sources|Resources> */ = {isa =
        # PBXBuildFile;` to avoid colliding with bare-name mentions in
        # comments or paths.
        if re.search(
            rf"[0-9A-F]{{24}}\s*/\*\s*{re.escape(bare)}\s+in\s+(Sources|Resources)\s*\*/\s*=\s*\{{isa\s*=\s*PBXBuildFile",
            out,
        ):
            log.append(f"skip (already present): {bare}")
            continue

        build_uuid = stable_uuid(f"buildfile:{rel_path}")
        ref_uuid = stable_uuid(f"fileref:{rel_path}")

        new_build_file_lines.append(
            f"\t\t{build_uuid} /* {bare} in {'Sources' if is_swift else 'Resources'} */"
            f" = {{isa = PBXBuildFile; fileRef = {ref_uuid} /* {bare} */; }};"
        )
        new_file_ref_lines.append(
            f"\t\t{ref_uuid} /* {bare} */ = {{isa = PBXFileReference; "
            f"lastKnownFileType = {filetype_for(rel_path)}; "
            f'name = "{bare}"; path = "{rel_path}"; '
            f"sourceTree = SOURCE_ROOT; }};"
        )
        if is_swift:
            new_sources_phase_lines.append(
                f"\t\t\t\t{build_uuid} /* {bare} in Sources */,"
            )
        else:
            new_resources_phase_lines.append(
                f"\t\t\t\t{build_uuid} /* {bare} in Resources */,"
            )
        log.append(f"add: {rel_path} (build={build_uuid[:8]}… ref={ref_uuid[:8]}…)")

    if not new_build_file_lines:
        log.append("no changes — pbxproj already up to date")
        return out, log

    # 1) Inject PBXBuildFile entries — append to the section.
    out = re.sub(
        r"(/\* End PBXBuildFile section \*/)",
        "\n".join(new_build_file_lines) + "\n\\1",
        out,
        count=1,
    )

    # 2) Inject PBXFileReference entries.
    out = re.sub(
        r"(/\* End PBXFileReference section \*/)",
        "\n".join(new_file_ref_lines) + "\n\\1",
        out,
        count=1,
    )

    # 3) Add Swift files to the Sources build phase. Locate the
    #    desktopAhaan target's Sources phase (PBXSourcesBuildPhase) and
    #    inject before its closing paren.
    if new_sources_phase_lines:
        out = re.sub(
            r"(/\* Sources \*/ = \{[\s\S]*?files = \([\s\S]*?)(\n\s*\);)",
            r"\1\n" + "\n".join(new_sources_phase_lines) + r"\2",
            out,
            count=1,
        )

    # 4) Add resource files to the Resources build phase.
    if new_resources_phase_lines:
        out = re.sub(
            r"(/\* Resources \*/ = \{[\s\S]*?files = \([\s\S]*?)(\n\s*\);)",
            r"\1\n" + "\n".join(new_resources_phase_lines) + r"\2",
            out,
            count=1,
        )

    return out, log


def main() -> int:
    if not PBXPROJ.exists():
        print(f"ERROR: {PBXPROJ} not found", file=sys.stderr)
        return 1
    original = PBXPROJ.read_text(encoding="utf-8")
    patched, log = patch(original)
    for line in log:
        print(line)
    if patched != original:
        PBXPROJ.write_text(patched, encoding="utf-8")
        print(f"\nWrote {PBXPROJ}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
