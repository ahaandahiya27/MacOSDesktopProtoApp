#!/usr/bin/env python3
"""check_mainactor_closure_refs.py — Big Sur / Swift 5.5 lint that catches
the second build break that slipped to the iMac on 2026-05-30:

    Converting function value of type '@MainActor () -> ()' to '() -> Void'
    loses global actor 'MainActor'

On Swift 5.5 (the Xcode 13.2.1 / Big Sur deploy target) passing a
`@MainActor` instance method *by bare reference* where SwiftUI expects a
plain, non-isolated `() -> Void` is a HARD ERROR. On the dev Mac's newer
toolchain it is only a warning, so it sails through the pre-push gate and
detonates on the iMac. Examples that broke tonight:

    .onAppear(perform: reload)              // reload is a @MainActor method
    Button(action: toggleRun)               // toggleRun is a @MainActor method
    SubView(onStart: startDayOne)           // startDayOne is a @MainActor method

The mechanical fix is to wrap the reference in an explicit closure, which
hops onto the main actor at the call site instead of surfacing the global
actor in the parameter type:

    .onAppear { reload() }
    Button(action: { toggleRun() })
    SubView(onStart: { startDayOne() })

What this lint flags
--------------------
In every `.swift` file under `desktopAhaan/` that contains an `@MainActor`
annotation (the project convention for any View / type that touches
`DataStore.shared`; enforced by check_view_mainactor.py), it inspects the
argument values passed to:

    perform:        (.onAppear / .onChange / .onReceive / .onDrop …)
    action:         (Button / Toggle / NSToolbar items …)
    on<Capital>…:   (custom callbacks: onStart, onDone, onSkip, onPick …)

A value is a hazard only when it is a BARE method reference — a plain
identifier (optionally `self.`) that is NOT a closure literal `{ … }` and
NOT a call `foo(…)`. Each such value is then classified against the
declarations in the same file:

  * the identifier is a `func` defined in the file   → FLAG (method ref —
    the exact pattern that breaks the iMac build).
  * the identifier is a closure-typed property / parameter
    (`let onDone: () -> Void`, `init(onSkip: @escaping () -> Void)`)
    → ALLOWED. Forwarding a stored `() -> Void` callback by name does NOT
    lose actor isolation — it never had any.
  * neither (can't be told apart cheaply) → ADVISORY FLAG with the
    message "wrap in { } if this is a @MainActor method", so the lint is
    advisory-strict but never an unfixable false block.

Escape hatch
------------
Append `// mainactor-ok` to a line to suppress it (e.g. a confirmed
non-isolated free function reference). Prefer wrapping in `{ }` — it is the
real fix and costs nothing — but the comment exists so the gate can never
hard-block on a case the heuristic genuinely cannot classify.

Usage:
    python3 scripts/check_mainactor_closure_refs.py
    python3 scripts/check_mainactor_closure_refs.py --selftest
"""

from __future__ import annotations
import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SOURCE_DIR = REPO_ROOT / "desktopAhaan"

# Skip generated content / resources.
SKIP_PATTERN = re.compile(r"/(Resources|Packs)/")

# Argument labels SwiftUI feeds a non-isolated `() -> Void`.
#   perform: / action:  — fixed names.
#   on<Capital>…:        — custom callback labels (onStart, onDone, …).
# `.onAppear` / `.onChange` etc. are method names followed by `(`, never
# `:`, so the on-label arm (which requires a trailing `:`) doesn't match
# them — only true argument labels like `onStart:` do.
ARG_REF = re.compile(r"\b(perform|action)\s*:\s*(self\.)?([A-Za-z_]\w*)")
ON_REF = re.compile(r"\b(on[A-Z]\w*)\s*:\s*(self\.)?([A-Za-z_]\w*)")

# Declaration scanners (run over the comment/string-scrubbed file text).
FUNC_DEF = re.compile(r"\bfunc\s+(\w+)\s*[(<]")
# Closure-typed property OR parameter: a `name:` whose type is a function
# type — an argument list `(…)` followed by `->`. The optional leading
# `\(?` absorbs an Optional wrapper (`(() -> Void)?`). Catches
# `let onDone: () -> Void`, `var onTap: (() -> Void)?`,
# `let onPick: (Int) -> Void`, and `init(onSkip: @escaping () -> Void)`.
CLOSURE_NAME = re.compile(r"\b(\w+)\s*:\s*(?:@escaping\s+)?\(?\s*\([^)]*\)\s*->")

# Comment / string scrubbing (per-line so line numbers stay exact).
LINE_COMMENT = re.compile(r"//[^\n]*")
SINGLE_STRING = re.compile(r'"(?:\\.|[^"\\])*"')

ALLOW_COMMENT = "mainactor-ok"


def scrub_line(line: str) -> str:
    """Blank out string contents and the trailing // comment of one line."""
    line = SINGLE_STRING.sub('""', line)
    line = LINE_COMMENT.sub("", line)
    return line


def collect_decls(scrubbed_text: str) -> tuple[set, set]:
    funcs = set(FUNC_DEF.findall(scrubbed_text))
    closures = set(CLOSURE_NAME.findall(scrubbed_text))
    return funcs, closures


def scan_src(src: str) -> list:
    """Return [(line_no, label, ident, kind, raw_line), ...] for hazards in
    one file's source. `kind` is 'method' (func ref → hard) or 'unknown'
    (advisory)."""
    if "@MainActor" not in src:
        return []

    raw_lines = src.splitlines()
    scrubbed_text = "\n".join(scrub_line(ln) for ln in raw_lines)
    funcs, closures = collect_decls(scrubbed_text)

    findings = []
    for i, raw in enumerate(raw_lines):
        if ALLOW_COMMENT in raw:
            continue
        line = scrub_line(raw)
        for rx in (ARG_REF, ON_REF):
            for m in rx.finditer(line):
                label = m.group(1)
                ident = m.group(3)
                end = m.end()
                # Reject calls `foo(` and member chains `foo.bar` — only a
                # bare reference loses the actor.
                after = line[end:end + 1]
                if after in ("(", "."):
                    continue
                # Classify.
                if ident in funcs and ident not in closures:
                    kind = "method"
                elif ident in closures:
                    continue  # stored () -> Void callback — legitimate
                else:
                    kind = "unknown"
                findings.append((i + 1, label, ident, kind, raw.rstrip()))
    return findings


def main() -> int:
    swift_files = sorted(SOURCE_DIR.rglob("*.swift"))
    all_findings = []
    for path in swift_files:
        rel = path.relative_to(REPO_ROOT)
        if SKIP_PATTERN.search(str(rel)):
            continue
        try:
            src = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        for (line_no, label, ident, kind, raw) in scan_src(src):
            all_findings.append((rel, line_no, label, ident, kind, raw))

    if not all_findings:
        print(
            f"check_mainactor_closure_refs: clean — scanned {len(swift_files)} "
            "files; no bare @MainActor method references in perform:/action:/on…: args."
        )
        return 0

    methods = [f for f in all_findings if f[4] == "method"]
    unknowns = [f for f in all_findings if f[4] == "unknown"]
    print(
        f"check_mainactor_closure_refs: {len(all_findings)} potential "
        f"violation(s) ({len(methods)} method ref(s), {len(unknowns)} advisory):"
    )
    print()
    for rel, line_no, label, ident, kind, raw in all_findings:
        tag = "[method-ref]" if kind == "method" else "[advisory]  "
        print(f"  {rel}:{line_no}  {tag}  {label}: {ident}")
        print(f"    {raw.strip()}")
        if kind == "method":
            print(f"    fix:  {label}: {{ {ident}() }}   (wrap so the @MainActor isolation isn't surfaced)")
        else:
            print(f"    note: wrap in {{ {ident}() }} if this is a @MainActor method, "
                  f"else append `// {ALLOW_COMMENT}`")
        print()
    print(
        "On Swift 5.5 (Big Sur deploy target) passing a @MainActor method by\n"
        "bare reference where a plain () -> Void is expected is a HARD ERROR\n"
        '("loses global actor \'MainActor\'"). The dev Mac treats it as a\n'
        "warning, so wrap each reference in an explicit closure before pushing."
    )
    return 1


# --------------------------------------------------------------------------
# Self-test fixtures.
# --------------------------------------------------------------------------

_VIOLATION = """\
@MainActor
struct DemoView: View {
    let onDone: () -> Void
    var body: some View {
        VStack {
            Button("Run", action: toggleRun)
            ChildView(onStart: startDayOne)
            Button("Close", action: onDone)
            Text("x").onAppear(perform: reload)
        }
    }
    func toggleRun() {}
    func startDayOne() {}
    func reload() {}
}
"""

_CLEAN = """\
@MainActor
struct DemoView: View {
    let onDone: () -> Void
    let onSkip: () -> Void
    var body: some View {
        VStack {
            Button("Run", action: { toggleRun() })
            ChildView(onStart: { startDayOne() })
            Button("Close", action: onDone)      // forwarding a closure prop — fine
            Button("Skip", action: onSkip)
            Text("x").onAppear { reload() }
            Text("y").onAppear(perform: freeFn)  // mainactor-ok
        }
    }
    func toggleRun() {}
    func startDayOne() {}
    func reload() {}
}
"""

# A type WITHOUT @MainActor — bare method refs are not a hazard here, so
# the whole file is skipped.
_NON_MAINACTOR = """\
struct PlainView: View {
    var body: some View {
        Button("Run", action: toggleRun)
        Text("x").onAppear(perform: reload)
    }
    func toggleRun() {}
    func reload() {}
}
"""


def run_selftest() -> int:
    cases = [
        # (name, src, expected_method_count, expected_total_count)
        # violation: toggleRun, startDayOne, reload are method refs (3);
        #   onDone is a closure prop → allowed.
        ("violation flags 3 method refs", _VIOLATION, 3, 3),
        # clean: all wrapped / closure-props / escape-hatched → 0.
        ("clean flags nothing", _CLEAN, 0, 0),
        # non-@MainActor file is skipped entirely → 0.
        ("non-@MainActor file skipped", _NON_MAINACTOR, 0, 0),
    ]
    failures = []
    for name, src, exp_methods, exp_total in cases:
        hits = scan_src(src)
        methods = sum(1 for h in hits if h[3] == "method")
        total = len(hits)
        ok = methods == exp_methods and total == exp_total
        flag = "PASS" if ok else "FAIL"
        print(f"  [{flag}] {name}: expected {exp_methods} method / {exp_total} total, "
              f"got {methods} method / {total} total")
        if not ok:
            failures.append(name)
    print()
    if failures:
        print(f"check_mainactor_closure_refs --selftest: FAIL — {len(failures)} case(s) misclassified.")
        return 1
    print("check_mainactor_closure_refs --selftest: PASS — every fixture classifies correctly.")
    return 0


if __name__ == "__main__":
    if "--selftest" in sys.argv[1:]:
        sys.exit(run_selftest())
    sys.exit(main())
