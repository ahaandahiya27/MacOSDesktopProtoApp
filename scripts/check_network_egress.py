#!/usr/bin/env python3
"""check_network_egress.py — locks Bug-Free-Cert categories H.5 + H.6.

This app is offline-first with a single deliberate outbound network path:
the optional `FreeOnlineTranslationProvider`, which the user can disable in
Settings. H.5 ("no outbound network call besides FreeOnlineTranslation-
Provider") and H.6 ("no telemetry / analytics call") were both certified
only by a one-time grep in the audit. This lint turns that grep into a
deterministic commit + push-time gate so a future feature can't quietly
add a second egress path or drop in an analytics SDK.

Two rules, scanned across the app target (`desktopAhaan/**/*.swift`,
excluding the test targets):

  H.5 — networking primitives (`URLSession`, `URLRequest`, `.dataTask`,
        `URLSession.shared.data(`, `NWConnection`, raw BSD `socket(`) may
        appear ONLY in the allowlisted provider file.
  H.6 — no import of a known telemetry / analytics / crash-reporting SDK,
        anywhere.

Usage:
    python3 scripts/check_network_egress.py
    python3 scripts/check_network_egress.py --selftest

Exit 0 = clean, 1 = violation.
"""
import os
import re
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
APP_DIR = os.path.join(REPO, "desktopAhaan")

# The single sanctioned egress site (path relative to the app dir).
ALLOWED_NET_FILES = {
    os.path.join("Services", "Translation", "FreeOnlineTranslationProvider.swift"),
}

NET_PATTERNS = [
    re.compile(r'\bURLSession\b'),
    re.compile(r'\bURLRequest\b'),
    re.compile(r'\.dataTask\b'),
    re.compile(r'\.downloadTask\b'),
    re.compile(r'\.uploadTask\b'),
    re.compile(r'\bNWConnection\b'),
    re.compile(r'\bsocket\s*\('),
]

# Known analytics / telemetry / crash-SDK module names. None should ever be
# imported in an offline, no-telemetry, single-user app.
TELEMETRY_IMPORTS = re.compile(
    r'^\s*import\s+('
    r'Firebase\w*|FIRAnalytics|GoogleAnalytics|Mixpanel|Amplitude|Segment|'
    r'Sentry|Crashlytics|FirebaseCrashlytics|AppCenter\w*|Bugsnag|'
    r'Heap|Datadog|Instabug|Flurry|Adjust|Branch|Kochava|TelemetryClient'
    r')\b',
    re.MULTILINE,
)

# A comment line shouldn't count as a real call site; strip // line comments.
COMMENT_RE = re.compile(r'//.*$', re.MULTILINE)


def swift_files(app_dir):
    for dirpath, _dirs, files in os.walk(app_dir):
        for f in files:
            if f.endswith(".swift"):
                yield os.path.join(dirpath, f)


def audit(app_dir, allowed=ALLOWED_NET_FILES):
    errors = []
    saw_allowed_net = False
    for path in swift_files(app_dir):
        rel = os.path.relpath(path, app_dir)
        with open(path, encoding="utf-8") as fh:
            raw = fh.read()
        code = COMMENT_RE.sub("", raw)
        is_allowed = rel in allowed
        for pat in NET_PATTERNS:
            if pat.search(code):
                if is_allowed:
                    saw_allowed_net = True
                else:
                    errors.append(f"H.5 {rel}: networking primitive "
                                  f"/{pat.pattern}/ outside the allowlisted provider")
                    break
        for m in TELEMETRY_IMPORTS.finditer(code):
            errors.append(f"H.6 {rel}: telemetry/analytics import {m.group(1)!r}")
    # Guard against the allowlist pointing at a renamed/moved file: if the
    # sanctioned site no longer contains networking, the allowlist is stale.
    if allowed and not saw_allowed_net:
        errors.append("H.5: allowlisted provider file has no networking "
                      "primitive — allowlist is stale (file moved/renamed?)")
    return errors


def selftest():
    import tempfile
    ok = True
    with tempfile.TemporaryDirectory() as d:
        prov_dir = os.path.join(d, "Services", "Translation")
        os.makedirs(prov_dir)
        with open(os.path.join(prov_dir, "FreeOnlineTranslationProvider.swift"),
                  "w", encoding="utf-8") as fh:
            fh.write("let s = URLSession.shared\n")
        allowed = {os.path.join("Services", "Translation",
                                "FreeOnlineTranslationProvider.swift")}
        # clean baseline
        if audit(d, allowed):
            print("SELFTEST FAIL: clean baseline flagged:", audit(d, allowed)); ok = False
        # rogue egress elsewhere
        with open(os.path.join(d, "Rogue.swift"), "w", encoding="utf-8") as fh:
            fh.write("let t = URLSession.shared.dataTask(with: r)\n")
        if not any("H.5" in e and "Rogue" in e for e in audit(d, allowed)):
            print("SELFTEST FAIL: rogue egress not caught"); ok = False
        os.remove(os.path.join(d, "Rogue.swift"))
        # commented-out networking must NOT trip
        with open(os.path.join(d, "Commented.swift"), "w", encoding="utf-8") as fh:
            fh.write("// let t = URLSession.shared.dataTask(with: r)\n")
        if audit(d, allowed):
            print("SELFTEST FAIL: commented egress wrongly flagged:",
                  audit(d, allowed)); ok = False
        os.remove(os.path.join(d, "Commented.swift"))
        # telemetry import
        with open(os.path.join(d, "Tele.swift"), "w", encoding="utf-8") as fh:
            fh.write("import Firebase\n")
        if not any("H.6" in e for e in audit(d, allowed)):
            print("SELFTEST FAIL: telemetry import not caught"); ok = False
        os.remove(os.path.join(d, "Tele.swift"))
        # stale allowlist (provider has no networking)
        with open(os.path.join(prov_dir, "FreeOnlineTranslationProvider.swift"),
                  "w", encoding="utf-8") as fh:
            fh.write("let x = 1\n")
        if not any("stale" in e for e in audit(d, allowed)):
            print("SELFTEST FAIL: stale allowlist not caught"); ok = False
    print("SELFTEST PASS" if ok else "SELFTEST FAILED")
    return 0 if ok else 1


def main():
    if "--selftest" in sys.argv:
        return selftest()
    errors = audit(APP_DIR)
    if errors:
        print("check_network_egress: FAIL")
        for e in errors[:50]:
            print("  " + e)
        if len(errors) > 50:
            print(f"  ... and {len(errors) - 50} more")
        return 1
    print("check_network_egress: clean — sole egress is "
          "FreeOnlineTranslationProvider; no telemetry SDK (H.5/H.6)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
