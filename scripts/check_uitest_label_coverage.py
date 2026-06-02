#!/usr/bin/env python3
"""check_uitest_label_coverage.py — ties each propagated-CTA contract label
to a referencing UI test (taxonomy T2 ratchet).

The propagated Science interactives — the Inside-the-* tour CTAs and the
Build-a-* sandboxes — are reachable from the chapter detail only through an
accessibility label string. Those strings are the *contract* between the
SwiftUI surface and the XCUITest walk that drives it: change the label and
the walk's `app.buttons[<label>]` query silently misses, change the mount and
the walk has nothing to drive. The unit suite can't see either failure, and
the UI walks themselves can't run on a dev Mac / CI (no Accessibility grant
to the runner — they're `--ui` opt-in).

This lint closes that gap deterministically, with NO build and NO AX grant:
it derives every contract label from source and asserts each appears verbatim
somewhere under `desktopAhaanUITests/`. It therefore catches BOTH

  - "added a propagated CTA / sandbox but no walk" (new label, no test), and
  - "drifted a label out from under its walk" (renamed label, stale test),

at commit/push time. Pairs with `check_critical_uitest_presence.py` (which
pins the test *methods* by name); this one pins the *labels* those methods
must reference.

Contract labels come from two source spots:
  1. Tour / concept-map CTA `.accessibilityLabel("…")` declared directly in
     `ChapterDetailView+PropagatedCTAs.swift`.
  2. The `Build-a-… sandbox` container label of every `BuildA*Sandbox(...)`
     mounted from that same file — resolved by finding the sandbox's view
     source under `Subjects/Tutor/Surfaces/` and reading its container label.

Usage:
    python3 scripts/check_uitest_label_coverage.py
    python3 scripts/check_uitest_label_coverage.py --selftest

Exit 0 = clean, 1 = violation. Deterministic, <3s, no build.
"""
import os
import re
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CTA_FILE = os.path.join(
    REPO, "desktopAhaan", "Subjects", "Tutor",
    "ChapterDetailView+PropagatedCTAs.swift")
SURFACES_DIR = os.path.join(
    REPO, "desktopAhaan", "Subjects", "Tutor", "Surfaces")
UITESTS_DIR = os.path.join(REPO, "desktopAhaanUITests")

# `.accessibilityLabel("...")` — the literal-string form. We only care about
# string-literal labels (interpolated `"\(x)"` labels can't be pinned verbatim
# and aren't used for any propagated CTA).
LABEL_RE = re.compile(r'\.accessibilityLabel\("([^"\\]+)"\)')
# A Build-a-* sandbox container label.
SANDBOX_LABEL_RE = re.compile(r'\.accessibilityLabel\("(Build-a-[^"\\]*sandbox)"\)')
# `BuildAFooSandbox(chapterId: ...)` mounts inside the CTA file.
SANDBOX_MOUNT_RE = re.compile(r'\b(BuildA\w*Sandbox)\s*\(\s*chapterId:')


def _read(path):
    with open(path, encoding="utf-8") as fh:
        return fh.read()


def _find_struct_source(struct_name, surfaces_dir):
    """Return the path of the .swift file declaring `struct <struct_name>`
    under surfaces_dir, or None."""
    needle = re.compile(r'\bstruct\s+' + re.escape(struct_name) + r'\b')
    if not os.path.isdir(surfaces_dir):
        return None
    for dirpath, _dirs, files in os.walk(surfaces_dir):
        for f in files:
            if f.endswith(".swift"):
                p = os.path.join(dirpath, f)
                if needle.search(_read(p)):
                    return p
    return None


def contract_labels(cta_file, surfaces_dir):
    """Return (labels, errors).

    `labels` maps each contract label string -> a short source description.
    `errors` lists structural problems (a mounted sandbox whose source or
    container label couldn't be resolved) — those are contract breaks too.
    """
    labels = {}
    errors = []
    if not os.path.isfile(cta_file):
        return labels, ["UITEST-LABEL: CTA source file missing or moved: "
                        + os.path.relpath(cta_file, REPO)]
    text = _read(cta_file)

    # 1. Tour / concept-map CTA labels declared in the CTA file itself.
    for label in LABEL_RE.findall(text):
        labels[label] = "CTA in ChapterDetailView+PropagatedCTAs.swift"

    # 2. Build-a-* sandbox container labels, resolved from each mounted struct.
    for struct in sorted(set(SANDBOX_MOUNT_RE.findall(text))):
        src = _find_struct_source(struct, surfaces_dir)
        if src is None:
            errors.append(
                f"UITEST-LABEL: sandbox {struct!r} is mounted in the CTA file "
                f"but no `struct {struct}` source was found under Surfaces/ "
                f"— can't resolve its container label.")
            continue
        m = SANDBOX_LABEL_RE.search(_read(src))
        if not m:
            errors.append(
                f"UITEST-LABEL: sandbox {struct!r} ({os.path.relpath(src, REPO)}) "
                f"has no `Build-a-… sandbox` container accessibilityLabel "
                f"— nothing for a UI walk to query.")
            continue
        labels[m.group(1)] = f"{struct} container ({os.path.relpath(src, REPO)})"

    return labels, errors


def _uitests_text(uitests_dir):
    chunks = []
    if not os.path.isdir(uitests_dir):
        return ""
    for dirpath, _dirs, files in os.walk(uitests_dir):
        for f in files:
            if f.endswith(".swift"):
                chunks.append(_read(os.path.join(dirpath, f)))
    return "\n".join(chunks)


def audit(cta_file=CTA_FILE, surfaces_dir=SURFACES_DIR, uitests_dir=UITESTS_DIR):
    labels, errors = contract_labels(cta_file, surfaces_dir)
    if not labels and not errors:
        return ["UITEST-LABEL: zero contract labels parsed — CTA file empty, "
                "moved, or its accessibilityLabel format changed"]
    uitext = _uitests_text(uitests_dir)
    for label in sorted(labels):
        if label not in uitext:
            errors.append(
                f"UITEST-LABEL: contract label {label!r} ({labels[label]}) "
                f"has no referencing UI test under desktopAhaanUITests/ "
                f"— add a walk that queries it, or it can drift/break silently.")
    return errors


def selftest():
    import tempfile
    ok = True

    def write(path, body):
        with open(path, "w", encoding="utf-8") as fh:
            fh.write(body)

    with tempfile.TemporaryDirectory() as d:
        cta = os.path.join(d, "CTAs.swift")
        write(cta,
              '.accessibilityLabel("Inside the foo — five-stop tour")\n'
              'BuildAFooSandbox(chapterId: chapter.id)\n')
        surfaces = os.path.join(d, "Surfaces")
        os.makedirs(surfaces)
        write(os.path.join(surfaces, "BuildAFooSandbox.swift"),
              'struct BuildAFooSandbox: View {\n'
              '  var body: some View {\n'
              '    Text("x").accessibilityLabel("Build-a-foo sandbox")\n'
              '  }\n}\n')

        # Pass fixture: a UI test that references BOTH contract labels.
        uipass = os.path.join(d, "uipass")
        os.makedirs(uipass)
        write(os.path.join(uipass, "FooUITests.swift"),
              'app.buttons["Inside the foo — five-stop tour"]\n'
              'app.descendants(matching: .any)["Build-a-foo sandbox"]\n')
        if audit(cta, surfaces, uipass):
            print("SELFTEST FAIL: label-present fixture flagged:",
                  audit(cta, surfaces, uipass)); ok = False

        # Fail fixture: tour label present, sandbox label MISSING.
        uifail = os.path.join(d, "uifail")
        os.makedirs(uifail)
        write(os.path.join(uifail, "FooUITests.swift"),
              'app.buttons["Inside the foo — five-stop tour"]\n')
        errs = audit(cta, surfaces, uifail)
        if not any("Build-a-foo sandbox" in e for e in errs):
            print("SELFTEST FAIL: missing sandbox label not caught:", errs); ok = False

    # A mounted sandbox with no resolvable source must be flagged.
    with tempfile.TemporaryDirectory() as d2:
        cta2 = os.path.join(d2, "CTAs.swift")
        write(cta2, 'BuildAGhostSandbox(chapterId: chapter.id)\n')
        empty_surfaces = os.path.join(d2, "Surfaces")
        os.makedirs(empty_surfaces)
        empty_ui = os.path.join(d2, "ui")
        os.makedirs(empty_ui)
        errs = audit(cta2, empty_surfaces, empty_ui)
        if not any("BuildAGhostSandbox" in e for e in errs):
            print("SELFTEST FAIL: unresolved sandbox mount not caught:", errs); ok = False

    print("SELFTEST PASS" if ok else "SELFTEST FAILED")
    return 0 if ok else 1


def main():
    if "--selftest" in sys.argv:
        return selftest()
    errors = audit()
    if errors:
        print("check_uitest_label_coverage: FAIL")
        for e in errors[:50]:
            print("  " + e)
        return 1
    labels, _ = contract_labels(CTA_FILE, SURFACES_DIR)
    print(f"check_uitest_label_coverage: clean — all {len(labels)} propagated "
          f"contract label(s) referenced by a UI test (T2)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
