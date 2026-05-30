#!/usr/bin/env python3
"""analyze_crashlogs.py — summarize desktopAhaan crash reports for a parent.

The Late-2014 iMac (Big Sur 11.7.11) writes OS-level crash reports to
``~/Library/Logs/DiagnosticReports/``. Two formats live there:

  * ``.ips``   — the JSON format used on macOS 12+ (and, on later Big Sur
                 point releases, increasingly for app crashes). The file is
                 TWO concatenated JSON objects: a one-line header, then a
                 multi-line body.
  * ``.crash`` — the legacy plain-text format used on Big Sur and earlier.

This tool reads every ``desktopAhaan*`` report of either kind and produces:

  * ``~/Library/Application Support/desktopAhaan/Diagnostics/
       crashlog_summary_YYYY-MM-DD.json``  (machine-readable, for the in-app
       CrashLogSummaryView to render without re-parsing).
  * stdout — a human-readable table of the last 10 crashes, newest first,
       with a one-line plain-English summary per crash.

It is intentionally read-only on the source reports and writes only into the
app's own Application Support container (the same place CrashReporter writes).

Design constraints (Big Sur ships /usr/bin/python3 == 3.8):
  * Python 3.8 syntax only — no ``match`` (3.10+), no ``X | Y`` unions
    (3.10+). ``:=`` is fine (3.8+).
  * stdlib only — no third-party packages.

Usage:
    python3 scripts/analyze_crashlogs.py
    python3 scripts/analyze_crashlogs.py --reports-dir /path/to/reports
    python3 scripts/analyze_crashlogs.py --out-dir /path/to/diagnostics
    python3 scripts/analyze_crashlogs.py --json        # machine-readable to stdout
    python3 scripts/analyze_crashlogs.py --selftest    # run built-in fixtures

Exit code is 0 on success (including "no crashes found"), 1 only on an
internal error or a failing --selftest.
"""
import argparse
import datetime
import glob
import json
import os
import re
import sys
from typing import Dict, List, Optional, Tuple

# App identity — the report filenames begin with the process name and the
# app's Application Support container uses the unsuffixed product name.
APP_PREFIX = "desktopAhaan"
DEFAULT_REPORTS_DIR = os.path.expanduser("~/Library/Logs/DiagnosticReports")
DEFAULT_OUT_DIR = os.path.expanduser(
    "~/Library/Application Support/desktopAhaan/Diagnostics"
)

# How many frames to keep in the "top frames" preview (deduplicated by binary).
TOP_FRAMES = 5
# How many crashes the human-readable table shows.
TABLE_LIMIT = 10


# ── Report discovery ─────────────────────────────────────────────────────────

def find_reports(reports_dir: str) -> List[str]:
    """Every desktopAhaan* .ips / .crash report in *reports_dir*, sorted."""
    out = []
    for ext in ("ips", "crash"):
        out.extend(glob.glob(os.path.join(reports_dir, APP_PREFIX + "*." + ext)))
    # Stable order; we re-sort by parsed date later. De-dup defensively.
    return sorted(set(out))


# ── .ips (JSON) parsing ──────────────────────────────────────────────────────

def _split_ips(raw: str) -> Tuple[dict, dict]:
    """An .ips file is a one-line header JSON followed by a body JSON.

    Returns (header, body). Either may be empty {} if absent/malformed; the
    body is the larger object that carries threads + usedImages.
    """
    raw = raw.strip()
    if not raw:
        return {}, {}
    newline = raw.find("\n")
    if newline == -1:
        # Single JSON object (some tools emit a merged form).
        try:
            obj = json.loads(raw)
        except ValueError:
            return {}, {}
        return obj, obj
    header_str = raw[:newline].strip()
    body_str = raw[newline + 1:].strip()
    try:
        header = json.loads(header_str)
    except ValueError:
        header = {}
    try:
        body = json.loads(body_str)
    except ValueError:
        body = {}
    return header, body


def _ips_frames(body: dict) -> List[str]:
    """Top frames of the faulting thread, labelled 'binary symbol+off'."""
    threads = body.get("threads") or []
    images = body.get("usedImages") or []

    def image_name(idx) -> str:
        if isinstance(idx, int) and 0 <= idx < len(images):
            img = images[idx] or {}
            return img.get("name") or img.get("CFBundleIdentifier") or "?"
        return "?"

    # Pick the crashed/triggered thread; fall back to the first thread.
    faulting = None
    for i, t in enumerate(threads):
        if t.get("triggered") or t.get("crashed"):
            faulting = t
            break
    if faulting is None:
        faulting = body.get("faultingThread")
        if isinstance(faulting, int) and 0 <= faulting < len(threads):
            faulting = threads[faulting]
        else:
            faulting = threads[0] if threads else {}

    out = []
    for fr in (faulting.get("frames") or []):
        binary = image_name(fr.get("imageIndex"))
        symbol = fr.get("symbol")
        if symbol:
            off = fr.get("symbolLocation")
            label = "{} {}+{}".format(binary, symbol, off) if off is not None \
                else "{} {}".format(binary, symbol)
        else:
            off = fr.get("imageOffset")
            label = "{} +{}".format(binary, off) if off is not None else binary
        out.append(label)
    return out


def parse_ips(raw: str, filename: str) -> Optional[dict]:
    header, body = _split_ips(raw)
    if not header and not body:
        return None
    exc = body.get("exception") or {}
    signal = exc.get("signal") or ""
    exc_type = exc.get("type") or ""
    termination = body.get("termination") or {}
    if not signal:
        signal = termination.get("signal") or ""
    frames = _ips_frames(body)
    return {
        "file": os.path.basename(filename),
        "format": "ips",
        "app_version": header.get("app_version")
        or header.get("bundleShortVersionString")
        or body.get("app_version") or "",
        "build": header.get("build_version") or header.get("bundleVersion") or "",
        "os_version": header.get("os_version") or body.get("osVersion", {}).get("train", ""),
        "date": header.get("timestamp") or body.get("captureTime") or "",
        "signal": signal,
        "exception_type": exc_type,
        "top_frames": _dedup_frames(frames)[:TOP_FRAMES],
        "all_frames": frames,
    }


# ── .crash (legacy text) parsing ─────────────────────────────────────────────

_CRASH_FIELD = re.compile(r"^([A-Za-z][A-Za-z /]+):\s+(.*)$")
# A backtrace row:  "2   desktopAhaan   0x000... symbol + 123"
_CRASH_FRAME = re.compile(
    r"^\s*\d+\s+(\S+)\s+0x[0-9a-fA-F]+\s+(.*?)\s*$"
)
_THREAD_CRASHED = re.compile(r"^Thread\s+\d+\s+Crashed", re.MULTILINE)


def parse_crash(raw: str, filename: str) -> Optional[dict]:
    if "Process:" not in raw and "Incident Identifier:" not in raw:
        return None
    fields = {}
    for line in raw.splitlines():
        m = _CRASH_FIELD.match(line)
        if m:
            key = m.group(1).strip()
            if key not in fields:  # keep first occurrence (header block)
                fields[key] = m.group(2).strip()

    # Version line is "1.0 (1)" → version "1.0", build "1".
    version_raw = fields.get("Version", "")
    vm = re.match(r"(\S+)\s*\((.*?)\)", version_raw)
    app_version = vm.group(1) if vm else version_raw
    build = vm.group(2) if vm else ""

    exc_type = fields.get("Exception Type", "")
    signal = ""
    sm = re.search(r"\((SIG[A-Z]+)\)", exc_type)
    if sm:
        signal = sm.group(1)

    frames = _crash_frames(raw)
    return {
        "file": os.path.basename(filename),
        "format": "crash",
        "app_version": app_version,
        "build": build,
        "os_version": fields.get("OS Version", ""),
        "date": fields.get("Date/Time", ""),
        "signal": signal,
        "exception_type": exc_type,
        "top_frames": _dedup_frames(frames)[:TOP_FRAMES],
        "all_frames": frames,
    }


def _crash_frames(raw: str) -> List[str]:
    """Frames of the 'Thread N Crashed:' backtrace; fall back to first thread."""
    lines = raw.splitlines()
    # Find the crashed-thread header, else the first "Thread N:" backtrace.
    start = None
    for i, line in enumerate(lines):
        if _THREAD_CRASHED.match(line):
            start = i + 1
            break
    if start is None:
        for i, line in enumerate(lines):
            if re.match(r"^Thread\s+\d+:", line):
                start = i + 1
                break
    if start is None:
        return []
    frames = []
    for line in lines[start:]:
        if not line.strip():
            break  # blank line ends the backtrace block
        m = _CRASH_FRAME.match(line)
        if m:
            binary = m.group(1)
            sym = m.group(2).strip()
            frames.append("{} {}".format(binary, sym) if sym else binary)
        elif re.match(r"^Thread\s+\d+", line):
            break
    return frames


# ── Shared helpers ───────────────────────────────────────────────────────────

def _dedup_frames(frames: List[str]) -> List[str]:
    """Collapse consecutive frames from the same binary to the first seen.

    Keeps the signal of "where it crashed" while trimming long runs inside one
    library (e.g. 30 frames of libsystem). Order preserved.
    """
    out = []
    last_binary = None
    for f in frames:
        binary = f.split(" ", 1)[0]
        if binary == last_binary:
            continue
        out.append(f)
        last_binary = binary
    return out


def human_summary(crash: dict) -> str:
    """A one-line, parent-readable description of a crash."""
    sig = crash.get("signal") or crash.get("exception_type") or "unknown fault"
    # Find the first app frame (most informative) for the "where".
    where = None
    for f in crash.get("top_frames", []):
        if f.startswith(APP_PREFIX):
            # Drop the binary prefix; keep the symbol.
            parts = f.split(" ", 1)
            where = parts[1] if len(parts) > 1 else None
            break
    if where:
        feature = _feature_hint(where)
        if feature:
            return "Crash in {} ({}) — {}".format(_short_symbol(where), sig, feature)
        return "Crash in {} ({})".format(_short_symbol(where), sig)
    # No app frame — crashed in a system library.
    top = crash.get("top_frames", [])
    if top:
        return "Crash in {} ({}) — system frame, no app code on stack".format(
            top[0].split(" ", 1)[0], sig)
    return "Crash recorded ({}) — no usable backtrace".format(sig)


def _short_symbol(sym: str) -> str:
    """Trim a Swift/ObjC symbol to something readable: drop '+offset', mangling."""
    sym = re.sub(r"\s*\+\s*\d+\s*$", "", sym).strip()
    # Swift demangled symbols can be very long; keep the first 60 chars.
    return sym if len(sym) <= 60 else sym[:57] + "..."


# Map an app symbol substring to a parent-readable feature area. Best-effort;
# absence just means we omit the hint.
_FEATURE_HINTS = [
    ("Discover", "likely a Discover Mode interactive scene"),
    ("Article", "likely an article / reading load"),
    ("BossQuiz", "likely a Boss Quiz"),
    ("Quiz", "likely a quiz / quick-check"),
    ("Translat", "likely the Sanskrit translator"),
    ("OCR", "likely the scan / OCR translator"),
    ("Speech", "likely Read-Aloud / speech"),
    ("DataStore", "likely a save / load of progress"),
    ("Pack", "likely content-pack loading"),
    ("Mastery", "likely the progress dashboard"),
    ("Daily", "likely the Daily Plan / Practice"),
    ("Achievement", "likely the achievements gallery"),
]


def _feature_hint(symbol: str) -> Optional[str]:
    for needle, hint in _FEATURE_HINTS:
        if needle.lower() in symbol.lower():
            return hint
    return None


# ── Date sorting ─────────────────────────────────────────────────────────────

def _date_key(crash: dict):
    """Best-effort sortable key from the heterogeneous date strings."""
    raw = (crash.get("date") or "").strip()
    # ips ISO-ish: "2026-05-30 09:14:22.00 +0530" or "2026-05-30T09:14:22Z"
    # crash:        "2026-05-30 09:14:22.123 +0530"
    m = re.search(r"(\d{4})-(\d{2})-(\d{2})[ T](\d{2}):(\d{2}):(\d{2})", raw)
    if m:
        return tuple(int(g) for g in m.groups())
    return (0, 0, 0, 0, 0, 0)


# ── Orchestration ────────────────────────────────────────────────────────────

def analyze(reports_dir: str) -> List[dict]:
    crashes = []
    for path in find_reports(reports_dir):
        try:
            with open(path, encoding="utf-8", errors="replace") as fh:
                raw = fh.read()
        except OSError:
            continue
        crash = None
        if path.endswith(".ips"):
            crash = parse_ips(raw, path)
        elif path.endswith(".crash"):
            crash = parse_crash(raw, path)
        if crash:
            crash["summary"] = human_summary(crash)
            crashes.append(crash)
    crashes.sort(key=_date_key, reverse=True)  # newest first
    return crashes


def build_report(crashes: List[dict], reports_dir: str) -> dict:
    return {
        "schema": 1,
        "generated": datetime.datetime.now().isoformat(timespec="seconds"),
        "reports_dir": reports_dir,
        "crash_count": len(crashes),
        "crashes": crashes,
    }


def write_summary(report: dict, out_dir: str) -> str:
    os.makedirs(out_dir, exist_ok=True)
    day = datetime.date.today().isoformat()
    out_path = os.path.join(out_dir, "crashlog_summary_{}.json".format(day))
    # Atomic-ish write (temp + replace) to mirror the app's .atomic policy.
    tmp = out_path + ".tmp"
    with open(tmp, "w", encoding="utf-8") as fh:
        json.dump(report, fh, ensure_ascii=False, indent=2)
        fh.write("\n")
    os.replace(tmp, out_path)
    return out_path


def print_table(crashes: List[dict]) -> None:
    if not crashes:
        print("No crashes recorded — perfect! 🎉")
        print("(No desktopAhaan reports found in the DiagnosticReports folder.)")
        return
    print("Recent desktopAhaan crashes (newest first, up to {}):".format(TABLE_LIMIT))
    print()
    for c in crashes[:TABLE_LIMIT]:
        date = c.get("date") or "?"
        ver = c.get("app_version") or "?"
        if c.get("build"):
            ver = "{} ({})".format(ver, c["build"])
        print("  • {}".format(c.get("summary", "Crash")))
        print("      when: {}   version: {}   os: {}".format(
            date, ver, c.get("os_version") or "?"))
        if c.get("top_frames"):
            print("      top:  {}".format(c["top_frames"][0]))
    if len(crashes) > TABLE_LIMIT:
        print()
        print("  … and {} older crash(es) — see the JSON summary.".format(
            len(crashes) - TABLE_LIMIT))


# ── Self-test (fixtures) ─────────────────────────────────────────────────────

_FIXTURE_IPS = (
    '{"app_name":"desktopAhaan","timestamp":"2026-05-30 09:14:22.00 +0530",'
    '"app_version":"1.0","build_version":"3","os_version":"macOS 11.7.11 (20G1427)",'
    '"bug_type":"309","incident_id":"ABC-123"}\n'
    '{"exception":{"type":"EXC_BAD_ACCESS","signal":"SIGSEGV"},'
    '"faultingThread":0,'
    '"usedImages":[{"name":"desktopAhaan"},{"name":"SwiftUI"},{"name":"libsystem_kernel.dylib"}],'
    '"threads":[{"triggered":true,"frames":['
    '{"imageIndex":0,"symbol":"ArticleIndex.lookup(id:)","symbolLocation":48},'
    '{"imageIndex":1,"symbol":"closure #1","symbolLocation":12},'
    '{"imageIndex":2,"symbol":"closure #2","symbolLocation":8},'
    '{"imageIndex":2,"imageOffset":1024}'
    ']}]}'
)

_FIXTURE_CRASH = (
    "Process:               desktopAhaan [4242]\n"
    "Path:                  /Applications/desktopAhaan.app/Contents/MacOS/desktopAhaan\n"
    "Identifier:            com.emoha.desktopAhaan\n"
    "Version:               1.0 (3)\n"
    "OS Version:            macOS 11.7.11 (20G1427)\n"
    "Date/Time:             2026-05-29 18:02:10.500 +0530\n"
    "\n"
    "Exception Type:        EXC_BAD_INSTRUCTION (SIGILL)\n"
    "Crashed Thread:        0  Dispatch queue: com.apple.main-thread\n"
    "\n"
    "Thread 0 Crashed:\n"
    "0   desktopAhaan                  0x000000010a 0x10a000 + 100   DiscoverChapter8View.body.getter\n"
    "1   desktopAhaan                  0x000000010b 0x10a000 + 200   closure #1\n"
    "2   SwiftUI                       0x000000020c 0x200000 + 300   _ViewDebug\n"
    "3   libdyld.dylib                 0x000000030d 0x300000 + 400   start\n"
    "\n"
    "Thread 1:\n"
    "0   libsystem_kernel.dylib        0x000000040e 0x400000 + 500\n"
)

# A second .crash with no app frames (crashed deep in a system library).
_FIXTURE_CRASH_SYS = (
    "Process:               desktopAhaan [99]\n"
    "Version:               1.0 (3)\n"
    "OS Version:            macOS 11.7.11 (20G1427)\n"
    "Date/Time:             2026-05-28 08:00:00.000 +0530\n"
    "Exception Type:        EXC_CRASH (SIGABRT)\n"
    "Crashed Thread:        0\n"
    "\n"
    "Thread 0 Crashed:\n"
    "0   libsystem_kernel.dylib        0x1 0x0 + 1   __pthread_kill\n"
    "1   libsystem_pthread.dylib       0x2 0x0 + 2   pthread_kill\n"
)


def selftest() -> int:
    import tempfile
    ok = True

    def check(cond, msg):
        nonlocal ok
        if not cond:
            print("SELFTEST FAIL:", msg)
            ok = False

    # .ips parse
    ips = parse_ips(_FIXTURE_IPS, "desktopAhaan-2026-05-30-091422.ips")
    check(ips is not None, ".ips returned None")
    if ips:
        check(ips["signal"] == "SIGSEGV", "ips signal: %r" % ips["signal"])
        check(ips["app_version"] == "1.0", "ips version: %r" % ips["app_version"])
        check(ips["os_version"].startswith("macOS 11"), "ips os: %r" % ips["os_version"])
        check(any("ArticleIndex" in f for f in ips["top_frames"]),
              "ips top frame missing ArticleIndex: %r" % ips["top_frames"])
        # consecutive same-binary frames (the two libsystem) collapse to one
        check(ips["top_frames"].count(
            [f for f in ips["top_frames"] if f.startswith("libsystem")][0]
            if any(f.startswith("libsystem") for f in ips["top_frames"]) else "x") <= 1,
            "ips dedup failed: %r" % ips["top_frames"])
        s = human_summary(ips)
        check("article" in s.lower(), "ips summary missing article hint: %r" % s)

    # .crash parse
    cr = parse_crash(_FIXTURE_CRASH, "desktopAhaan_2026-05-29.crash")
    check(cr is not None, ".crash returned None")
    if cr:
        check(cr["signal"] == "SIGILL", "crash signal: %r" % cr["signal"])
        check(cr["app_version"] == "1.0", "crash version: %r" % cr["app_version"])
        check(cr["build"] == "3", "crash build: %r" % cr["build"])
        check(any("DiscoverChapter8View" in f for f in cr["top_frames"]),
              "crash top frame missing Discover: %r" % cr["top_frames"])
        s = human_summary(cr)
        check("discover" in s.lower(), "crash summary missing discover hint: %r" % s)

    # system-only crash → no app frame branch
    crsys = parse_crash(_FIXTURE_CRASH_SYS, "desktopAhaan_sys.crash")
    check(crsys is not None, "sys .crash returned None")
    if crsys:
        s = human_summary(crsys)
        check("system frame" in s.lower(), "sys summary wrong: %r" % s)

    # garbage → None (not a desktopAhaan report)
    check(parse_ips("not json at all", "x.ips") is None, "garbage ips not None")
    check(parse_crash("hello world", "x.crash") is None, "garbage crash not None")

    # end-to-end against a temp reports dir, including date sort + JSON write
    with tempfile.TemporaryDirectory() as rd, tempfile.TemporaryDirectory() as od:
        with open(os.path.join(rd, "desktopAhaan-a.ips"), "w", encoding="utf-8") as fh:
            fh.write(_FIXTURE_IPS)
        with open(os.path.join(rd, "desktopAhaan-b.crash"), "w", encoding="utf-8") as fh:
            fh.write(_FIXTURE_CRASH)
        with open(os.path.join(rd, "desktopAhaan-c.crash"), "w", encoding="utf-8") as fh:
            fh.write(_FIXTURE_CRASH_SYS)
        # an unrelated app's report must be ignored
        with open(os.path.join(rd, "Safari-x.crash"), "w", encoding="utf-8") as fh:
            fh.write("Process: Safari [1]\nException Type: EXC_CRASH (SIGABRT)\n")
        crashes = analyze(rd)
        check(len(crashes) == 3, "expected 3 crashes, got %d" % len(crashes))
        # newest first → the .ips at 2026-05-30 leads
        check(crashes and crashes[0]["date"].startswith("2026-05-30"),
              "sort order wrong: %r" % [c.get("date") for c in crashes])
        report = build_report(crashes, rd)
        out = write_summary(report, od)
        check(os.path.exists(out), "summary json not written")
        with open(out, encoding="utf-8") as fh:
            loaded = json.load(fh)
        check(loaded["crash_count"] == 3, "json crash_count wrong")

    # empty dir → no crashes, clean
    with tempfile.TemporaryDirectory() as rd:
        check(analyze(rd) == [], "empty dir should yield no crashes")

    print("SELFTEST PASS" if ok else "SELFTEST FAILED")
    return 0 if ok else 1


# ── CLI ──────────────────────────────────────────────────────────────────────

def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--reports-dir", default=DEFAULT_REPORTS_DIR,
                        help="DiagnosticReports folder (default: %(default)s)")
    parser.add_argument("--out-dir", default=DEFAULT_OUT_DIR,
                        help="where to write the JSON summary")
    parser.add_argument("--json", action="store_true",
                        help="print the machine-readable JSON to stdout instead of a table")
    parser.add_argument("--no-write", action="store_true",
                        help="don't write the JSON summary file")
    parser.add_argument("--selftest", action="store_true", help="run built-in fixtures")
    args = parser.parse_args(argv)

    if args.selftest:
        return selftest()

    if not os.path.isdir(args.reports_dir):
        # Not an error — a Mac that never crashed may not have the folder.
        if args.json:
            print(json.dumps(build_report([], args.reports_dir), ensure_ascii=False, indent=2))
        else:
            print("No crashes recorded — perfect! 🎉")
            print("(DiagnosticReports folder not present: {})".format(args.reports_dir))
        return 0

    crashes = analyze(args.reports_dir)
    report = build_report(crashes, args.reports_dir)

    if not args.no_write:
        try:
            out = write_summary(report, args.out_dir)
            if not args.json:
                print("Summary written: {}".format(out))
                print()
        except OSError as exc:
            # Don't fail the whole run if the container isn't writable.
            print("(could not write JSON summary: {})".format(exc), file=sys.stderr)

    if args.json:
        print(json.dumps(report, ensure_ascii=False, indent=2))
    else:
        print_table(crashes)
    return 0


if __name__ == "__main__":
    sys.exit(main())
