#!/usr/bin/env python3
"""check_withanimation_motion.py — every imperative `withAnimation { }`
call must be reduce-motion-aware.

Background. SwiftUI animations don't auto-honour the system Reduce
Motion setting. The `.animation(...)` view modifier IS covered by
`check_lifetime_hazards.py` (rule LH005). The imperative
`withAnimation(_:body:)` function was not covered — and the 2026-06-23
deep-audit pass found two latent unguarded calls in Discover scenes
(Scene1_PlantKitchen + Scene4_HotSoupColdSpoon) inside Task blocks. The
outer call read `@Environment(\\.accessibilityReduceMotion)` correctly,
but the inner Task-scoped call fired unconditionally because the env
var didn't thread through to the secondary animation.

Accepted shapes (any one of these makes a `withAnimation(...)` call OK):

  • The argument is a `reduceMotion ? ... : ...` ternary:
        withAnimation(reduceMotion ? .none : .spring()) { ... }
        withAnimation(reduceMotion ? nil   : .easeInOut) { ... }

  • The call is `withAnimationRespectingReduceMotion(...)` — that helper
    reads NSWorkspace.accessibilityDisplayShouldReduceMotion itself and
    skips the animation when reduce-motion is on.

  • The call sits inside an enclosing block whose entry condition is
    a Reduce-Motion gate. The lint looks BACKWARD up to 60 lines for one
    of these openers, tolerating nested `Task { @MainActor in ... }`,
    `if let x = y { ... }`, etc. between the gate and the call:

        if !reduceMotion { ... withAnimation(...) ... }
        else if !reduceMotion { ... withAnimation(...) ... }
        guard !reduceMotion else { return } ... withAnimation(...)
        guard !reduceMotion, ... else { ... } ... withAnimation(...)

The lookback is bounded (default 60 lines) to keep the heuristic local;
a `withAnimation` more than 60 lines from its gate is almost certainly
hiding behind unrelated control flow and the author should pull the
ternary onto the call site itself for clarity.

Usage:
    python3 scripts/check_withanimation_motion.py             # whole repo
    python3 scripts/check_withanimation_motion.py FILE ...    # scoped
    python3 scripts/check_withanimation_motion.py --selftest  # fixtures

Exit 0 = clean, 1 = violation. Wired into scripts/ci-build-test.sh
(whole-repo) and the pre-commit hook (scoped to staged .swift files).
"""
from __future__ import annotations

import os
import re
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCAN_ROOT = os.path.join(REPO, "desktopAhaan")

# A `withAnimation(` call as a starting token (not the prefix-match
# `withAnimationRespectingReduceMotion(`, which is the safe helper and
# explicitly accepted below).
_CALL_RE = re.compile(r"\bwithAnimation\s*\(")

# A `reduceMotion ?` ternary inside the call's argument — accepted shape.
_TERNARY_RE = re.compile(r"reduceMotion\s*\?\s*")

# Backward-looking control-flow prefixes that introduce a Reduce-Motion
# gate. The line must start with one of these AND contain `!reduceMotion`
# somewhere in its condition — that handles compound conditions like
# `if !isAbsorbed(i) && !reduceMotion {` as well as plain
# `if !reduceMotion {`.
_GATE_PREFIXES = ("if ", "else if ", "guard ")

# Maximum number of lines to search backward for an enclosing gate.
LOOKBACK_LINES = 60

# Files that ARE the reduce-motion helper itself — they wrap the system
# call and intentionally use raw `withAnimation`. Allowlisted by relative
# path under SCAN_ROOT so a rename surfaces here.
_FILE_ALLOWLIST = frozenset({
    "Extensions/View+RespectReduceMotion.swift",
})


def _is_safe_call(line: str) -> bool:
    """True iff the same-line `withAnimation(` call is self-gated either via
    a `reduceMotion ?` ternary in its argument or because the matched token
    is actually the safe `withAnimationRespectingReduceMotion(` helper."""
    # The helper starts with the same prefix; rule out by checking that
    # the immediate character after `withAnimation` is `(` (call) rather
    # than `R` (helper).
    if "withAnimationRespectingReduceMotion(" in line:
        return True
    return bool(_TERNARY_RE.search(line))


def _has_enclosing_gate(lines: list[str], call_idx: int) -> bool:
    """Walk backward from `call_idx` looking for a gate opener within
    `LOOKBACK_LINES`. We don't try to track brace depth precisely (Swift
    `withAnimation` calls aren't lexer-deep enough to warrant it) — the
    line-window heuristic is good enough to flag the real bugs without
    false-flagging the patterns the 2026-06-23 audit certified."""
    start = max(0, call_idx - LOOKBACK_LINES)
    for j in range(call_idx - 1, start - 1, -1):
        line = lines[j].strip()
        # Tolerate a leading `}` from the prior block's close, common
        # in `} else if !reduceMotion {` shape.
        if line.startswith("}"):
            line = line[1:].lstrip()
        for prefix in _GATE_PREFIXES:
            if line.startswith(prefix) and "!reduceMotion" in line:
                return True
    return False


def audit_file(path: str) -> list[tuple[int, str]]:
    """Return a list of (line_number, source_line) for each unguarded
    `withAnimation(` call in `path`. Line numbers are 1-based. Files
    listed in `_FILE_ALLOWLIST` (the safe-helper implementation itself)
    are skipped wholesale."""
    try:
        with open(path, "r", encoding="utf-8") as fh:
            lines = fh.read().split("\n")
    except (OSError, UnicodeDecodeError):
        return []
    # Allowlist check against the path relative to SCAN_ROOT.
    try:
        rel = os.path.relpath(path, SCAN_ROOT)
    except ValueError:
        rel = path
    if rel in _FILE_ALLOWLIST:
        return []
    errors: list[tuple[int, str]] = []
    for i, line in enumerate(lines):
        # Match `withAnimation(` but not `withAnimationRespectingReduceMotion(`
        for m in _CALL_RE.finditer(line):
            start = m.start()
            after = line[start + len("withAnimation"):]
            if after.startswith("RespectingReduceMotion"):
                continue
            # Skip comment lines.
            stripped = line.lstrip()
            if stripped.startswith("//") or stripped.startswith("///"):
                continue
            if _is_safe_call(line):
                continue
            if _has_enclosing_gate(lines, i):
                continue
            errors.append((i + 1, line.rstrip()))
    return errors


def _walk_swift_files(root: str) -> list[str]:
    """List every .swift file under `root`, excluding build/derived dirs."""
    out: list[str] = []
    for dirpath, dirnames, filenames in os.walk(root):
        # Standard scan excludes — these never carry production view code.
        dirnames[:] = [
            d for d in dirnames
            if d not in {".build", ".dd", ".dd-olytest", ".dd-typecheck",
                         "DerivedData", "__pycache__"}
            and not d.startswith(".backup_xcode")
        ]
        for name in filenames:
            if name.endswith(".swift"):
                out.append(os.path.join(dirpath, name))
    return out


def audit_repo() -> tuple[list[str], int]:
    """Whole-repo audit. Returns (formatted_errors, files_scanned)."""
    files = _walk_swift_files(SCAN_ROOT)
    formatted: list[str] = []
    for f in files:
        for ln, src in audit_file(f):
            rel = os.path.relpath(f, REPO)
            formatted.append(f"{rel}:{ln}  unguarded withAnimation: {src.strip()[:120]}")
    return formatted, len(files)


def audit_paths(paths: list[str]) -> list[str]:
    """Scoped audit — validate the supplied files only. Paths outside the
    Swift source tree are ignored."""
    formatted: list[str] = []
    for p in paths:
        p_abs = p if os.path.isabs(p) else os.path.join(REPO, p)
        if not p_abs.endswith(".swift"):
            continue
        if not os.path.isfile(p_abs):
            continue
        for ln, src in audit_file(p_abs):
            rel = os.path.relpath(p_abs, REPO)
            formatted.append(f"{rel}:{ln}  unguarded withAnimation: {src.strip()[:120]}")
    return formatted


# ---------------------------------------------------------------------------
# Self-test — builds a small in-memory fixture and asserts the lint flags
# exactly the unguarded calls and nothing else.
# ---------------------------------------------------------------------------

_DANGER_FIXTURE = """\
import SwiftUI

struct Danger: View {
    @State private var x = 0.0
    @Environment(\\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Button("Tap") {
            // 1) Unguarded call inside Task — the original bug class.
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                withAnimation(.easeOut(duration: 0.3)) { x = 1 }  // FLAG
            }
            // 2) Unguarded call after a long unrelated block (lookback exceeded).
        }
    }
}
"""

_CLEAN_FIXTURE = """\
import SwiftUI

struct Clean: View {
    @State private var x = 0.0
    @Environment(\\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Button("Tap") {
            // Accepted: ternary in the arg
            withAnimation(reduceMotion ? .none : .spring()) { x = 1 }
            // Accepted: helper
            withAnimationRespectingReduceMotion(.spring()) { x = 1 }
            // Accepted: enclosing if-block
            if !reduceMotion {
                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 100_000_000)
                    withAnimation(.spring()) { x = 1 }
                }
            }
            // Accepted: guard
            guard !reduceMotion else { return }
            withAnimation(.spring()) { x = 1 }
        }
    }
}
"""


def selftest() -> int:
    import tempfile

    ok = True
    with tempfile.TemporaryDirectory() as d:
        danger = os.path.join(d, "Danger.swift")
        with open(danger, "w", encoding="utf-8") as fh:
            fh.write(_DANGER_FIXTURE)
        d_errs = audit_file(danger)
        if len(d_errs) != 1:
            print(f"SELFTEST FAIL: danger fixture flagged {len(d_errs)}, expected 1")
            for ln, src in d_errs:
                print(f"  L{ln}: {src.strip()}")
            ok = False
        else:
            print(f"  [PASS] danger fixture flags {len(d_errs)} hit(s) (expected 1)")

        clean = os.path.join(d, "Clean.swift")
        with open(clean, "w", encoding="utf-8") as fh:
            fh.write(_CLEAN_FIXTURE)
        c_errs = audit_file(clean)
        if c_errs:
            print(f"SELFTEST FAIL: clean fixture flagged {len(c_errs)}, expected 0")
            for ln, src in c_errs:
                print(f"  L{ln}: {src.strip()}")
            ok = False
        else:
            print("  [PASS] clean fixture flags 0 hits")

    print("check_withanimation_motion --selftest: " +
          ("PASS — every fixture classifies correctly." if ok else "FAIL"))
    return 0 if ok else 1


# Public entry point used by scripts/test_lints.py — the harness expects
# each lint module to expose a `run_selftest()` returning the same exit
# code shape (0 = pass, non-zero = fail).
def run_selftest() -> int:
    return selftest()


def main() -> int:
    if "--selftest" in sys.argv:
        return selftest()

    file_args = [a for a in sys.argv[1:] if not a.startswith("-")]
    if file_args:
        errors = audit_paths(file_args)
        if errors:
            print("check_withanimation_motion: FAIL (scoped to staged files)")
            for e in errors[:30]:
                print("  " + e)
            if len(errors) > 30:
                print(f"  ... and {len(errors) - 30} more")
            print()
            print(f"  {len(errors)} unguarded withAnimation site(s) among the "
                  "staged files.")
            print("  Fix: wrap each call in `withAnimationRespectingReduceMotion(...)`,")
            print("  use `reduceMotion ? .none : <anim>` in the argument, or place the")
            print("  call inside an enclosing `if !reduceMotion { ... }` block.")
            return 1
        print(f"check_withanimation_motion: clean — {len(file_args)} staged "
              "file(s) checked.")
        return 0

    errors, files = audit_repo()
    if errors:
        print("check_withanimation_motion: FAIL")
        for e in errors[:30]:
            print("  " + e)
        if len(errors) > 30:
            print(f"  ... and {len(errors) - 30} more")
        print()
        print(f"  {len(errors)} unguarded withAnimation site(s) across "
              f"{files} file(s).")
        print("  Fix: wrap each call in `withAnimationRespectingReduceMotion(...)`,")
        print("  use `reduceMotion ? .none : <anim>` in the argument, or place the")
        print("  call inside an enclosing `if !reduceMotion { ... }` block.")
        return 1

    print(f"check_withanimation_motion: clean — scanned {files} Swift file(s); "
          "every `withAnimation` call is reduce-motion-gated.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
