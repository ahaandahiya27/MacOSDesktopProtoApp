#!/usr/bin/env python3
"""check_lifetime_hazards.py — static lint for lifetime/ownership hazards.

Concerns kept separate from check_macos12_apis.py (which gates SDK
compatibility); this script gates ownership patterns that cause
EXC_BAD_ACCESS / retain cycles / sendable lies.

Current rules (each toggleable; existing violations grandfathered via
scripts/lifetime_hazards_allowlist.txt):

  1. var delegate:  — must be `weak var delegate:` when used as an
     AppKit/UIKit/SDK delegate, otherwise it can outlive its owner and
     produce zombies on subsequent delegate callbacks. Heuristic: any
     `var delegate:` declaration not on the same line as `weak`.

  2. `\\bunowned\\b` (any use) — `unowned` makes a non-nillable assumption
     about object lifetime that's hard to prove correct under SwiftUI's
     commit model. The rule forces the author to either use `weak` (and
     handle the nil case) or — if `unowned` is truly justified (e.g. an
     immutable owned-by-parent relationship in a @MainActor init) —
     add the file:line to the allowlist with the proof.

  3. `@unchecked Sendable` — almost always a lie; converts a synchronization
     bug into a silent data race. Force the author to use a queue, lock,
     or actor instead. Allowlist with proof if a value type's invariants
     genuinely satisfy Sendable (e.g. a wrapper around a private NSLock).

  4. Escaping closure capture without `[weak self]` on three patterns the
     C1 over-release lineage taught us are dangerous:
       a. `.sink { ... }` (Combine) — owner stays alive until the
          Cancellable is released; the closure pins `self` past view
          dismount.
       b. `Timer.scheduledTimer(...) { ... }` — repeating timer keeps
          firing into a freed holder.
       c. `.assign(to: \\.x, on: self)` — keypath form is always-strong;
          prefer `.assign(to: &$x)`.
     Heuristic: look at the closure-capture span (the chars after `{`
     until the next ` in `) for `[weak self]` or `[unowned self]`.
     Allowlist if the enclosing type is a value-type struct (no retain
     cycle possible) or the closure provably doesn't reference self.

  5. Implicit `.animation(<X>)` view modifier without a Reduce-Motion
     gate. Every `.animation(<X>)` must either contain the substring
     `reduceMotion` on the same line (e.g.
     `.animation(reduceMotion ? .none : .easeInOut(...))`) or be
     replaced by the `.respectReduceMotion(animation: <X>)` helper.
     Without the gate the animation still plays when the user has
     enabled Reduce Motion — silent accessibility regression.
     Heuristic: match indented `.animation(` modifier syntax (not the
     TimelineView's `.animation(minimumInterval:)` factory, which lives
     inline inside `TimelineView(...)` parens). The helper file
     `View+RespectReduceMotion.swift` itself is exempt because it IS
     the helper.

  6. `print(` outside a `#if DEBUG ... #endif` block. Release builds
     should not emit stdout noise; use os.Logger (per-subsystem,
     filterable in Console.app) instead. The codebase has one existing
     site (SubjectRegistry's debugLog helper) and that one IS already
     gated by `#if DEBUG`. The rule keeps it that way.

Exit codes:
  0 — clean
  1 — at least one new violation (not in the allowlist)
  2 — script bug / fixture missing

Run from the repo root: `python3 scripts/check_lifetime_hazards.py`.
"""

from __future__ import annotations

import re
import sys
from dataclasses import dataclass
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SOURCE_DIR = REPO_ROOT / "desktopAhaan"
ALLOWLIST_PATH = REPO_ROOT / "scripts" / "lifetime_hazards_allowlist.txt"

# Files that are exempt from these rules. FoundationTutor is the AI shim
# carve-out documented in CLAUDE.md; tests are scanned separately if at all.
EXEMPT_PATH_FRAGMENTS = (
    "/FoundationTutor.swift",
)


@dataclass(frozen=True)
class Violation:
    rule_id: str
    rel_path: str
    line_no: int
    line: str
    why: str

    def allowlist_key(self) -> str:
        return f"{self.rel_path}:{self.line_no}"


def _is_exempt(path: Path) -> bool:
    rel = str(path)
    return any(frag in rel for frag in EXEMPT_PATH_FRAGMENTS)


def _read_allowlist() -> set[str]:
    if not ALLOWLIST_PATH.exists():
        return set()
    keys = set()
    for raw in ALLOWLIST_PATH.read_text().splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        # Lines look like  path:line:reason  — only the path:line prefix
        # is the key; everything after the second `:` is human prose.
        parts = line.split(":", 2)
        if len(parts) < 2:
            continue
        keys.add(f"{parts[0]}:{parts[1]}")
    return keys


# --- Rule implementations -------------------------------------------------

_VAR_DELEGATE_RE = re.compile(r"(?<!\bweak\s)\bvar\s+delegate\s*:")
_UNOWNED_RE = re.compile(r"\bunowned\b")
_UNCHECKED_SENDABLE_RE = re.compile(r"@unchecked\s+Sendable\b")
# Indented `.animation(` modifier (line starts with whitespace + the dot).
# TimelineView's `.animation(minimumInterval:)` factory is inline inside
# `TimelineView(...)` parens, never line-leading, so it doesn't match.
_ANIMATION_MODIFIER_RE = re.compile(r"^\s+\.animation\(")
# `print(` at the start of a line (after whitespace). The Swift method
# `print(_:_:_:)` accessed as `Foo.print(...)` or `someObject.print(...)`
# is fine and not what we're after; we only catch top-of-line calls.
_PRINT_CALL_RE = re.compile(r"^\s*print\(")
# Combine .sink trailing closure: `.sink {` or `.sink(...) {`. Earlier
# the regex had a `(?<!\w)` negative lookbehind on the dot, which was a
# bug — the typical call site is `publisher.sink { ... }`, where the
# char before `.` IS a word char (the trailing letter of the publisher
# variable name). The lookbehind failed there and the lint missed every
# real-world `.sink`. Caught by scripts/test_lints.py's LH004 fixture.
_SINK_RE = re.compile(r"\.sink\s*(?:\([^)]*\))?\s*\{")
_TIMER_SCHEDULED_RE = re.compile(r"\bTimer\.scheduledTimer\b")
# Keypath form of .assign always captures `on:` strongly. Modern alt:
# `.assign(to: &$x)` against an @Published.
_ASSIGN_STRONG_SELF_RE = re.compile(
    r"\.assign\(\s*to:\s*\\\.[\w.]+\s*,\s*on:\s*self\b"
)


def _capture_list_has_weak_self(text_after_brace: str) -> bool:
    """True if the closure's capture list contains `[weak self]` or
    `[unowned self]`. Scans up to the first ` in ` (which marks the end
    of the capture list / parameter list), capped at 300 chars."""
    # Cap the search window so we don't accidentally pick up `[weak self]`
    # from way deeper in the closure body.
    end = text_after_brace.find(" in ")
    if end == -1 or end > 300:
        end = 300
    head = text_after_brace[:end]
    return "[weak self]" in head or "[unowned self]" in head


def _scan_var_delegate(swift_path: Path) -> list[Violation]:
    rel = swift_path.relative_to(REPO_ROOT).as_posix()
    findings: list[Violation] = []
    for idx, line in enumerate(swift_path.read_text().splitlines(), start=1):
        # Skip strings, comments, etc. — cheap heuristic: skip the line
        # if its first non-whitespace token is `//` or it's a docstring.
        stripped = line.strip()
        if stripped.startswith("//") or stripped.startswith("///"):
            continue
        # Skip `var delegate:` declarations that are explicitly weak.
        if "weak var delegate" in line:
            continue
        if _VAR_DELEGATE_RE.search(line):
            findings.append(
                Violation(
                    rule_id="LH001",
                    rel_path=rel,
                    line_no=idx,
                    line=line.rstrip(),
                    why=(
                        "`var delegate:` should be `weak var delegate:` — a "
                        "strong delegate reference outlives its owner and "
                        "produces zombies on subsequent delegate callbacks. "
                        "If the type is not an AppKit/UIKit delegate (e.g. "
                        "owned protocol with no callback), add the file/line "
                        "to scripts/lifetime_hazards_allowlist.txt with a "
                        "short reason."
                    ),
                )
            )
    return findings


def _scan_unowned(swift_path: Path) -> list[Violation]:
    rel = swift_path.relative_to(REPO_ROOT).as_posix()
    findings: list[Violation] = []
    for idx, line in enumerate(swift_path.read_text().splitlines(), start=1):
        stripped = line.strip()
        if stripped.startswith("//") or stripped.startswith("///"):
            continue
        if _UNOWNED_RE.search(line):
            findings.append(
                Violation(
                    rule_id="LH002",
                    rel_path=rel,
                    line_no=idx,
                    line=line.rstrip(),
                    why=(
                        "`unowned` assumes the referenced object outlives "
                        "the holder. Under SwiftUI's commit model that is "
                        "rarely provable; if the assumption is wrong the "
                        "next access EXC_BAD_ACCESSes instead of returning "
                        "nil. Prefer `weak` and handle the nil case. If "
                        "`unowned` is genuinely justified (e.g. an immutable "
                        "owned-by-parent relationship inside a @MainActor "
                        "init), add the file:line to "
                        "scripts/lifetime_hazards_allowlist.txt with proof."
                    ),
                )
            )
    return findings


def _scan_closure_captures(swift_path: Path) -> list[Violation]:
    """LH004 — flag escaping closures that capture `self` without
    `[weak self]`. Three sub-rules: .sink, Timer.scheduledTimer, and
    .assign(to:on:self)."""
    rel = swift_path.relative_to(REPO_ROOT).as_posix()
    text = swift_path.read_text()
    # Pre-compute per-line "is comment" so we can quickly skip matches
    # whose source line is a doc comment. Without this the regex
    # happily matches mentions of these APIs inside `// ...` blocks
    # (e.g. fixture files, design comments) and double-counts violations.
    lines = text.splitlines()
    def _is_comment_line(line_no: int) -> bool:
        if line_no - 1 < 0 or line_no - 1 >= len(lines):
            return False
        stripped = lines[line_no - 1].strip()
        return stripped.startswith("//") or stripped.startswith("///")

    findings: list[Violation] = []

    # --- LH004a: .sink trailing closure ---
    for m in _SINK_RE.finditer(text):
        brace_pos = m.end() - 1  # `.sink {` — m.end() points just past `{`
        head = text[brace_pos + 1 : brace_pos + 1 + 400]
        if _capture_list_has_weak_self(head):
            continue
        line_no = text[: m.start()].count("\n") + 1
        if _is_comment_line(line_no):
            continue
        # Best-effort line content for the report.
        line = text.splitlines()[line_no - 1].rstrip() if line_no - 1 < len(text.splitlines()) else ""
        findings.append(
            Violation(
                rule_id="LH004a",
                rel_path=rel,
                line_no=line_no,
                line=line,
                why=(
                    "Combine `.sink {}` closure must capture `[weak self]`. "
                    "Without it the publisher keeps the owner alive past view "
                    "dismount and the closure fires into stale state. If the "
                    "owner is a value-type struct (e.g. ViewModifier) and the "
                    "lack of cycle is provable, add the file:line to "
                    "scripts/lifetime_hazards_allowlist.txt with the reason."
                ),
            )
        )

    # --- LH004b: Timer.scheduledTimer block ---
    # Find the call site, then walk forward to the first top-level `{` of
    # its closure body. We need to skip the call's parens.
    for m in _TIMER_SCHEDULED_RE.finditer(text):
        # Skip if the match is inside a comment line. Without this the
        # regex would happily fire on `// Timer.scheduledTimer` mentions
        # in doc comments and then walk forward to find some unrelated
        # `{` (e.g. the next class opening brace).
        call_line_no = text[: m.start()].count("\n") + 1
        if _is_comment_line(call_line_no):
            continue
        # Find the next `{` after the call, tracking paren depth so we
        # don't fall into a string-literal or another call.
        i = m.end()
        depth = 0
        brace_pos = -1
        scan_limit = i + 800  # bail on pathological lines
        while i < min(len(text), scan_limit):
            ch = text[i]
            if ch == "(":
                depth += 1
            elif ch == ")":
                depth -= 1
            elif ch == "{":
                # Either trailing closure (depth == 0) or `block:{...}`
                # parameter (depth >= 1). Both are the closure we want.
                brace_pos = i
                break
            elif ch == "\n" and depth == 0:
                # Line ended without `{` and no open paren — bail.
                pass
            i += 1
        if brace_pos == -1:
            continue
        head = text[brace_pos + 1 : brace_pos + 1 + 400]
        if _capture_list_has_weak_self(head):
            continue
        line_no = text[:brace_pos].count("\n") + 1
        line = text.splitlines()[line_no - 1].rstrip() if line_no - 1 < len(text.splitlines()) else ""
        findings.append(
            Violation(
                rule_id="LH004b",
                rel_path=rel,
                line_no=line_no,
                line=line,
                why=(
                    "`Timer.scheduledTimer` block must capture `[weak self]`. "
                    "A repeating timer pins the owner forever; a one-shot "
                    "timer still fires after the owner should be gone if the "
                    "owner dismounts between schedule and fire. If the "
                    "enclosing type is a value-type struct (no retain cycle "
                    "possible) or the closure provably doesn't reference "
                    "self, allowlist with the reason."
                ),
            )
        )

    # --- LH004c: .assign(to: \..., on: self) keypath form ---
    for m in _ASSIGN_STRONG_SELF_RE.finditer(text):
        line_no = text[: m.start()].count("\n") + 1
        if _is_comment_line(line_no):
            continue
        line = text.splitlines()[line_no - 1].rstrip() if line_no - 1 < len(text.splitlines()) else ""
        findings.append(
            Violation(
                rule_id="LH004c",
                rel_path=rel,
                line_no=line_no,
                line=line,
                why=(
                    "`.assign(to: \\.x, on: self)` always captures `self` "
                    "strongly. Prefer `.assign(to: &$x)` against an "
                    "@Published, or `.sink { [weak self] in self?.x = $0 }`."
                ),
            )
        )

    return findings


def _scan_print_call(swift_path: Path) -> list[Violation]:
    """LH006 — `print(` outside `#if DEBUG ... #endif`. Release builds
    should not emit stdout. Tracks DEBUG-block depth via a per-line
    counter so prints inside debug-gated helpers are allowed."""
    rel = swift_path.relative_to(REPO_ROOT).as_posix()
    findings: list[Violation] = []
    debug_depth = 0
    for idx, line in enumerate(swift_path.read_text().splitlines(), start=1):
        stripped = line.strip()
        if stripped.startswith("//") or stripped.startswith("///"):
            continue
        # Open / close DEBUG block tracking. `#if DEBUG` opens, matching
        # `#endif` closes (we only track DEBUG specifically, but
        # decrement against any `#endif` so nested non-DEBUG `#if`s
        # don't desync the counter).
        if stripped.startswith("#if DEBUG"):
            debug_depth += 1
            continue
        if stripped.startswith("#endif") and debug_depth > 0:
            debug_depth -= 1
            continue
        if debug_depth > 0:
            continue
        if not _PRINT_CALL_RE.match(line):
            continue
        findings.append(
            Violation(
                rule_id="LH006",
                rel_path=rel,
                line_no=idx,
                line=line.rstrip(),
                why=(
                    "Top-level `print(` in production code escapes to "
                    "release-build stdout (and Console.app's main log). "
                    "Use `os.Logger` instead — it has subsystem/category "
                    "filtering, log-level promotion, and privacy "
                    "specifiers. If the call is intentionally release-"
                    "stripped, wrap it in `#if DEBUG ... #endif` (see "
                    "SubjectRegistry's `debugLog` helper for the pattern)."
                ),
            )
        )
    return findings


def _scan_animation_gate(swift_path: Path) -> list[Violation]:
    """LH005 — every line-leading `.animation(<X>)` modifier must either
    carry the substring `reduceMotion` (the manual gate) or be replaced
    by the `.respectReduceMotion(animation: <X>)` helper. The helper file
    itself is exempt."""
    rel = swift_path.relative_to(REPO_ROOT).as_posix()
    if rel.endswith("View+RespectReduceMotion.swift"):
        return []
    findings: list[Violation] = []
    for idx, line in enumerate(swift_path.read_text().splitlines(), start=1):
        stripped = line.strip()
        if stripped.startswith("//") or stripped.startswith("///"):
            continue
        if not _ANIMATION_MODIFIER_RE.match(line):
            continue
        if "reduceMotion" in line:
            continue
        # Indented `.animation(...)` without `reduceMotion` on the same
        # line — bypasses Reduce Motion.
        findings.append(
            Violation(
                rule_id="LH005",
                rel_path=rel,
                line_no=idx,
                line=line.rstrip(),
                why=(
                    "`.animation(<X>)` without a Reduce-Motion gate ignores "
                    "the user's accessibility preference. Replace with "
                    "`.respectReduceMotion(animation: <X>)` (preferred) "
                    "or the explicit form "
                    "`.animation(reduceMotion ? .none : <X>)`. The helper "
                    "lives in desktopAhaan/Extensions/View+RespectReduceMotion.swift."
                ),
            )
        )
    return findings


def _scan_unchecked_sendable(swift_path: Path) -> list[Violation]:
    rel = swift_path.relative_to(REPO_ROOT).as_posix()
    findings: list[Violation] = []
    for idx, line in enumerate(swift_path.read_text().splitlines(), start=1):
        stripped = line.strip()
        if stripped.startswith("//") or stripped.startswith("///"):
            continue
        if _UNCHECKED_SENDABLE_RE.search(line):
            findings.append(
                Violation(
                    rule_id="LH003",
                    rel_path=rel,
                    line_no=idx,
                    line=line.rstrip(),
                    why=(
                        "`@unchecked Sendable` disables the compiler's "
                        "sendable check without proving safety. Almost "
                        "always a lie that converts a synchronization bug "
                        "into a silent data race. Use a queue, NSLock, "
                        "actor, or `nonisolated(unsafe)` on a specific "
                        "property instead. If the type genuinely satisfies "
                        "Sendable's contract (e.g. immutable value type "
                        "wrapping a private lock-guarded reference), add "
                        "the file:line to "
                        "scripts/lifetime_hazards_allowlist.txt with the "
                        "proof."
                    ),
                )
            )
    return findings


# --- Driver ---------------------------------------------------------------

def _scan_repo() -> list[Violation]:
    findings: list[Violation] = []
    for swift_path in sorted(SOURCE_DIR.rglob("*.swift")):
        if _is_exempt(swift_path):
            continue
        findings.extend(_scan_var_delegate(swift_path))
        findings.extend(_scan_unowned(swift_path))
        findings.extend(_scan_unchecked_sendable(swift_path))
        findings.extend(_scan_closure_captures(swift_path))
        findings.extend(_scan_animation_gate(swift_path))
        findings.extend(_scan_print_call(swift_path))
    return findings


def main() -> int:
    if not SOURCE_DIR.exists():
        print(
            f"check_lifetime_hazards: source dir not found at {SOURCE_DIR}",
            file=sys.stderr,
        )
        return 2

    allow = _read_allowlist()
    findings = _scan_repo()
    new_findings = [v for v in findings if v.allowlist_key() not in allow]

    if not new_findings:
        total = len(findings)
        if total:
            print(
                f"check_lifetime_hazards: clean — {total} pre-existing "
                f"violation(s) grandfathered via allowlist."
            )
        else:
            print("check_lifetime_hazards: clean — no violations.")
        return 0

    print("check_lifetime_hazards: new violations:")
    for v in new_findings:
        print(f"  [{v.rule_id}] {v.rel_path}:{v.line_no}")
        print(f"      {v.line}")
        print(f"      {v.why}")
        print()
    return 1


if __name__ == "__main__":
    sys.exit(main())
