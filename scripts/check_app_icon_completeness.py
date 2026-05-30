#!/usr/bin/env python3
"""check_app_icon_completeness.py — assert the macOS AppIcon set is complete
and non-placeholder, so day-1 releases never ship the generic blank icon.

Verifies `Assets.xcassets/AppIcon.appiconset/Contents.json` lists all 10
required mac entries:

    16x16 @1x/@2x, 32x32 @1x/@2x, 128x128 @1x/@2x,
    256x256 @1x/@2x, 512x512 @1x/@2x

For each declared image it checks that the referenced PNG:
  * exists,
  * has a valid PNG signature,
  * is EXACTLY the declared pixel dimensions (base size x scale), and
  * is not a placeholder — byte-identical to `default-placeholder.png` if such
    a fixture ships in the iconset, else simply non-zero and a real PNG.

PNG dimensions are read straight from the IHDR chunk (no Pillow / third-party
dep) so this runs on Big Sur's stock Python 3.8.

Advisory by default: prints findings and exits 0 so it never blocks a push
(missing/placeholder icons are queued in POLISH_TODOS.md for human attention).
Pass --strict to exit 1 on any problem. --selftest runs built-in fixtures.

Usage:
    python3 scripts/check_app_icon_completeness.py            # advisory
    python3 scripts/check_app_icon_completeness.py --strict   # exit 1 on fault
    python3 scripts/check_app_icon_completeness.py --selftest # self-test
"""
import json
import os
import struct
import sys
import tempfile

PNG_SIG = b"\x89PNG\r\n\x1a\n"

# Required (base_size, scale) combinations for a complete mac app icon set.
REQUIRED = [
    (16, 1), (16, 2),
    (32, 1), (32, 2),
    (128, 1), (128, 2),
    (256, 1), (256, 2),
    (512, 1), (512, 2),
]

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))


def find_iconset():
    """Locate the AppIcon.appiconset dir, preferring the real source tree and
    skipping any agent worktrees under .claude/."""
    candidates = []
    for dirpath, dirnames, _filenames in os.walk(REPO_ROOT):
        # Don't descend into git internals or agent worktrees.
        parts = dirpath.split(os.sep)
        if ".git" in parts or "worktrees" in parts:
            dirnames[:] = []
            continue
        if dirpath.endswith("AppIcon.appiconset"):
            candidates.append(dirpath)
    if not candidates:
        return None
    # Prefer a path under desktopAhaan/Assets.xcassets if present.
    for c in candidates:
        if os.sep + "desktopAhaan" + os.sep in c + os.sep:
            return c
    return sorted(candidates)[0]


def png_dimensions(path):
    """Return (width, height) from a PNG's IHDR, or None if not a valid PNG."""
    try:
        with open(path, "rb") as fh:
            sig = fh.read(8)
            if sig != PNG_SIG:
                return None
            # 4-byte chunk length, 4-byte type ("IHDR"), then 4+4 byte W,H.
            fh.read(4)            # IHDR length
            ctype = fh.read(4)
            if ctype != b"IHDR":
                return None
            w, h = struct.unpack(">II", fh.read(8))
            return (w, h)
    except (OSError, struct.error):
        return None


def check_iconset(iconset_dir):
    """Return (problems, scale_summary). problems is a list of strings."""
    problems = []
    contents_path = os.path.join(iconset_dir, "Contents.json")
    if not os.path.isfile(contents_path):
        return (["Contents.json missing in %s" % iconset_dir], [])

    try:
        with open(contents_path, "r", encoding="utf-8") as fh:
            data = json.load(fh)
    except (OSError, ValueError) as exc:
        return (["Contents.json unreadable/invalid: %s" % exc], [])

    images = data.get("images", [])
    placeholder = os.path.join(iconset_dir, "default-placeholder.png")
    placeholder_bytes = None
    if os.path.isfile(placeholder):
        try:
            with open(placeholder, "rb") as fh:
                placeholder_bytes = fh.read()
        except OSError:
            placeholder_bytes = None

    seen = set()
    summary = []
    for img in images:
        if img.get("idiom") != "mac":
            continue
        size = img.get("size", "")          # e.g. "16x16"
        scale = img.get("scale", "")        # e.g. "2x"
        filename = img.get("filename")
        try:
            base = int(size.split("x")[0])
            scale_n = int(scale.rstrip("x"))
        except (ValueError, AttributeError):
            problems.append("malformed entry size=%r scale=%r" % (size, scale))
            continue
        seen.add((base, scale_n))
        summary.append("%sx%s@%s -> %s" % (base, base, scale, filename))

        if not filename:
            problems.append("%sx%s@%s has no filename" % (base, base, scale))
            continue
        png_path = os.path.join(iconset_dir, filename)
        if not os.path.isfile(png_path):
            problems.append("missing PNG: %s (for %sx%s@%s)" % (filename, base, base, scale))
            continue
        if os.path.getsize(png_path) == 0:
            problems.append("zero-byte PNG: %s" % filename)
            continue
        dims = png_dimensions(png_path)
        if dims is None:
            problems.append("not a valid PNG: %s" % filename)
            continue
        expected = base * scale_n
        if dims != (expected, expected):
            problems.append(
                "wrong dimensions: %s is %dx%d, expected %dx%d (%sx%s@%s)"
                % (filename, dims[0], dims[1], expected, expected, base, base, scale)
            )
        if placeholder_bytes is not None:
            try:
                with open(png_path, "rb") as fh:
                    if fh.read() == placeholder_bytes:
                        problems.append("placeholder icon still in use: %s" % filename)
            except OSError:
                pass

    missing = [combo for combo in REQUIRED if combo not in seen]
    for base, scale_n in missing:
        problems.append("missing required entry: %sx%s@%sx" % (base, base, scale_n))

    return (problems, summary)


def _make_png(path, w, h):
    """Write a minimal valid PNG of dimensions w x h (one IHDR + IDAT + IEND)."""
    import zlib
    def chunk(ctype, payload):
        return (struct.pack(">I", len(payload)) + ctype + payload
                + struct.pack(">I", zlib.crc32(ctype + payload) & 0xFFFFFFFF))
    ihdr = struct.pack(">IIBBBBB", w, h, 8, 2, 0, 0, 0)  # 8-bit RGB
    raw = b"".join(b"\x00" + b"\x00\x00\x00" * w for _ in range(h))
    idat = zlib.compress(raw)
    with open(path, "wb") as fh:
        fh.write(PNG_SIG + chunk(b"IHDR", ihdr) + chunk(b"IDAT", idat) + chunk(b"IEND", b""))


def selftest():
    ok = True
    with tempfile.TemporaryDirectory() as tmp:
        iconset = os.path.join(tmp, "AppIcon.appiconset")
        os.makedirs(iconset)
        # --- Clean fixture: all 10 present at correct dims ---
        images = []
        for base, scale in REQUIRED:
            fn = "icon-%d-%dx.png" % (base, scale)
            _make_png(os.path.join(iconset, fn), base * scale, base * scale)
            images.append({"filename": fn, "idiom": "mac",
                           "scale": "%dx" % scale, "size": "%dx%d" % (base, base)})
        with open(os.path.join(iconset, "Contents.json"), "w", encoding="utf-8") as fh:
            json.dump({"images": images, "info": {"author": "xcode", "version": 1}}, fh)
        problems, _ = check_iconset(iconset)
        if problems:
            ok = False
            print("  selftest FAIL (clean fixture flagged): %s" % problems)
        else:
            print("  selftest PASS: clean 10-entry set accepted")

        # --- Violation A: wrong dimensions ---
        _make_png(os.path.join(iconset, "icon-16-2x.png"), 99, 99)
        problems, _ = check_iconset(iconset)
        if any("wrong dimensions" in p for p in problems):
            print("  selftest PASS: wrong-dimensions detected")
        else:
            ok = False
            print("  selftest FAIL: wrong dimensions not detected")
        _make_png(os.path.join(iconset, "icon-16-2x.png"), 32, 32)  # restore

        # --- Violation B: missing entry ---
        os.remove(os.path.join(iconset, "icon-512-2x.png"))
        problems, _ = check_iconset(iconset)
        if any("missing PNG" in p for p in problems):
            print("  selftest PASS: missing PNG detected")
        else:
            ok = False
            print("  selftest FAIL: missing PNG not detected")

        # --- Violation C: placeholder reuse ---
        ph = os.path.join(iconset, "default-placeholder.png")
        _make_png(ph, 16, 16)
        # make icon-16-1x identical to placeholder
        with open(ph, "rb") as fh:
            pb = fh.read()
        with open(os.path.join(iconset, "icon-16-1x.png"), "wb") as fh:
            fh.write(pb)
        problems, _ = check_iconset(iconset)
        if any("placeholder" in p for p in problems):
            print("  selftest PASS: placeholder reuse detected")
        else:
            ok = False
            print("  selftest FAIL: placeholder reuse not detected")
    return ok


def main():
    argv = sys.argv[1:]
    if "--selftest" in argv:
        print("==> check_app_icon_completeness --selftest")
        sys.exit(0 if selftest() else 1)

    strict = "--strict" in argv

    iconset = find_iconset()
    if iconset is None:
        print("check_app_icon_completeness: no AppIcon.appiconset found.")
        sys.exit(1 if strict else 0)

    rel = os.path.relpath(iconset, REPO_ROOT)
    problems, summary = check_iconset(iconset)

    if not problems:
        print("check_app_icon_completeness: clean — all %d mac icon entries "
              "present at correct dimensions (%s)." % (len(REQUIRED), rel))
        sys.exit(0)

    print("check_app_icon_completeness: %d issue(s) in %s:" % (len(problems), rel))
    for p in problems:
        print("  - %s" % p)
    print("")
    print("Advisory: queue these in POLISH_TODOS.md so a real icon ships on "
          "day 1. Re-run with --strict to make this a hard gate.")
    sys.exit(1 if strict else 0)


if __name__ == "__main__":
    main()
