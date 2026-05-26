#!/usr/bin/env python3
"""check_view_mainactor.py — project-level lint that catches the
recurring Swift 5.5 / Big Sur build error pattern:

    Call to main actor-isolated instance method '<X>' in a
    synchronous nonisolated context

DataStore (and any class typed @MainActor) is correctly isolated
to the main actor because it owns @Published state. SwiftUI Views
that call into DataStore.shared.<method> synchronously must
themselves be @MainActor-isolated so the call chain stays
nonisolated-free under Swift 5.5 (which does NOT implicitly mark
View bodies / instance methods as @MainActor — that inference
arrived in a later Swift release).

This lint flags any Swift file that:
  - Declares a `struct ___: View` (the SwiftUI View struct).
  - Contains at least one synchronous call to `DataStore.shared.<method>`
    (i.e., not wrapped in `Task { ... }`).
  - Does NOT have `@MainActor` immediately before the struct decl
    OR within the file as a struct-level annotation.

Output is line-format compatible with the rest of `ci-build-test.sh`
linters so a flagged file fails the pre-push hook the same way
the file-size and lifetime-hazards lints do.

This lint was added 2026-05-26 after the Boss-Quiz scene fix
recurred at the iMac build cycle three times. See REMEDIATION_LOG
and commit ac3944b for the lineage.
"""

from __future__ import annotations
import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SOURCE_DIR = REPO_ROOT / "desktopAhaan"

# Skip generated content, articles, JSON.
SKIP_PATTERN = re.compile(r"/(Resources|Packs)/")

# Sync @MainActor singletons whose methods would trip the
# "synchronous nonisolated context" error if called from a
# nonisolated SwiftUI View context.
MAIN_ACTOR_SINGLETONS = [
    "DataStore.shared.",
]

# We only flag files that declare a View struct. (Helpers,
# extensions, value-type wrappers don't have the SwiftUI body
# isolation issue.)
VIEW_STRUCT_PATTERN = re.compile(r"^(struct|public struct) (\w+):.*?\bView\b", re.MULTILINE)

# Each Task { ... } block is "safely hopped" — the closure body
# can call MainActor methods because @MainActor in the Task
# launches it on the main actor. Lines inside such blocks are
# excluded from the "sync call" detection by a simple stack
# counter below.


def file_has_sync_main_actor_call(src: str) -> bool:
    """Return True if `src` calls one of MAIN_ACTOR_SINGLETONS
    OUTSIDE a Task { ... } closure (i.e., synchronously from the
    view's own context)."""
    depth_in_task = 0
    for line in src.splitlines():
        stripped = line.strip()
        # Crude but effective: count opening `Task {` and the
        # matching closing `}` to track whether we're inside one.
        if "Task {" in stripped or "Task(" in stripped:
            # Count any open braces that come after Task on the
            # same line.
            depth_in_task += 1
        if depth_in_task > 0:
            if stripped.endswith("}") or stripped == "}":
                depth_in_task = max(0, depth_in_task - 1)
            continue
        for token in MAIN_ACTOR_SINGLETONS:
            if token in line:
                return True
    return False


def file_has_view_struct(src: str) -> bool:
    return bool(VIEW_STRUCT_PATTERN.search(src))


def file_has_struct_level_mainactor(src: str) -> bool:
    # Look for `@MainActor` on its own line followed by `struct ___: View`.
    pattern = re.compile(
        r"^@MainActor\s*\n(public\s+)?struct \w+:.*?\bView\b",
        re.MULTILINE,
    )
    return bool(pattern.search(src))


def main() -> int:
    findings: list[str] = []
    swift_files = sorted(SOURCE_DIR.rglob("*.swift"))
    for path in swift_files:
        rel = path.relative_to(REPO_ROOT)
        if SKIP_PATTERN.search(str(rel)):
            continue
        try:
            src = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        if not file_has_view_struct(src):
            continue
        if not file_has_sync_main_actor_call(src):
            continue
        if file_has_struct_level_mainactor(src):
            continue
        findings.append(str(rel))

    if findings:
        print("check_view_mainactor: new violations:")
        for rel in findings:
            print(f"  {rel}: SwiftUI View calls DataStore.shared.* synchronously without `@MainActor` on the struct.")
        print()
        print(
            "Fix: annotate the View struct with `@MainActor`. Under Swift 5.5\n"
            "(Big Sur deploy target) View bodies are NOT implicitly @MainActor,\n"
            "so a sync call to a @MainActor singleton fails the build. The\n"
            "struct-level annotation propagates isolation to the body, every\n"
            "instance method, and every captured `self` in closures. See\n"
            "commits 2c694a4 / ac3944b for the lineage."
        )
        return 1
    print("check_view_mainactor: clean — every SwiftUI View calling DataStore.shared.* sync is `@MainActor`-annotated.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
