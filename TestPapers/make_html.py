#!/usr/bin/env python3
"""Assemble a self-contained, print-ready HTML for a test paper:
question paper -> page break -> solutions. No external assets.

Usage:
    python3 make_html.py <QuestionPaper.md> <Solutions.md> <out.html>
    python3 make_html.py --all      # build both papers in this folder
"""
import html
import os
import re
import sys

CSS = """
@page { size: A4; margin: 18mm 16mm; }
* { box-sizing: border-box; }
body { font-family: Georgia, 'Times New Roman', serif; font-size: 12pt;
       line-height: 1.45; color: #111; max-width: 820px; margin: 0 auto;
       padding: 16px; }
h1 { font-size: 19pt; margin: 0 0 2px; }
h2 { font-size: 15pt; margin: 0 0 10px; color: #333; }
h3 { font-size: 13pt; margin: 18px 0 6px; }
table { border-collapse: collapse; margin: 8px 0 14px; }
th, td { border: 1px solid #999; padding: 3px 9px; text-align: left;
         font-size: 11pt; }
.markbox { border: 2px solid #222; border-radius: 6px; padding: 8px 12px;
           margin: 10px 0 16px; background: #f6f6f6; font-size: 11.5pt; }
.q { margin: 9px 0 2px; }
.opts { margin: 0 0 6px 22px; }
.opts span { display: inline-block; min-width: 46%; vertical-align: top;
             margin: 1px 0; }
.sol { margin: 5px 0; }
.pagebreak { page-break-before: always; }
.note { color: #555; font-style: italic; font-size: 10.5pt; }
hr { border: none; border-top: 1px solid #ccc; margin: 14px 0; }
code { background: #eee; padding: 0 2px; }
"""


def inline(s):
    s = html.escape(s)
    s = re.sub(r"\*\*(.+?)\*\*", r"<strong>\1</strong>", s)
    s = re.sub(r"`(.+?)`", r"<code>\1</code>", s)
    return s


def md_to_html(text):
    """Focused markdown -> HTML good enough for these papers."""
    out = []
    lines = text.splitlines()
    i = 0
    in_table = False
    cur_q_opts = []

    def flush_opts():
        nonlocal cur_q_opts
        if cur_q_opts:
            out.append('<div class="opts">' + "".join(cur_q_opts) + "</div>")
            cur_q_opts = []

    while i < len(lines):
        ln = lines[i]
        stripped = ln.strip()

        # skip HTML comments (coverage matrix block)
        if stripped.startswith("<!--"):
            while i < len(lines) and "-->" not in lines[i]:
                i += 1
            i += 1
            continue

        # tables
        if stripped.startswith("|"):
            flush_opts()
            cells = [c.strip() for c in stripped.strip("|").split("|")]
            is_sep = all(set(c) <= set("-: ") and c for c in cells)
            if is_sep:
                i += 1
                continue
            if not in_table:
                out.append("<table>")
                in_table = True
                tag = "th"
            else:
                tag = "td"
            row = "".join(f"<{tag}>{inline(c)}</{tag}>" for c in cells)
            out.append(f"<tr>{row}</tr>")
            i += 1
            continue
        elif in_table:
            out.append("</table>")
            in_table = False

        m_opt = re.match(r"^\s*\(([ABCD])\)\s+(.+)$", ln)
        m_q = re.match(r"^\s*(\d{1,3})\.\s+(.*)$", ln)

        if m_opt:
            cur_q_opts.append(f"<span>({m_opt.group(1)}) {inline(m_opt.group(2))}</span>")
            i += 1
            continue

        flush_opts()

        if ln.startswith("# "):
            out.append(f"<h1>{inline(ln[2:].strip())}</h1>")
        elif ln.startswith("## "):
            out.append(f"<h2>{inline(ln[3:].strip())}</h2>")
        elif ln.startswith("### "):
            out.append(f"<h3>{inline(ln[4:].strip())}</h3>")
        elif stripped == "---":
            out.append("<hr>")
        elif m_q:
            out.append(f'<div class="q"><strong>{m_q.group(1)}.</strong> {inline(m_q.group(2))}</div>')
        elif stripped.startswith("**") and stripped.endswith("**") and re.match(r"^\*\*\s*\d+\.", stripped):
            out.append(f'<div class="sol">{inline(stripped)}</div>')
        elif stripped.startswith("*") and stripped.endswith("*") and not stripped.startswith("**"):
            out.append(f'<p class="note">{inline(stripped.strip("*"))}</p>')
        elif stripped == "":
            pass
        else:
            out.append(f"<p>{inline(stripped)}</p>")
        i += 1

    flush_opts()
    if in_table:
        out.append("</table>")
    return "\n".join(out)


def build(qp_path, sol_path, out_path):
    with open(qp_path, encoding="utf-8") as f:
        qp = f.read()
    with open(sol_path, encoding="utf-8") as f:
        sol = f.read()
    title = os.path.basename(out_path).replace(".html", "").replace("_", " ")
    doc = f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{html.escape(title)}</title>
<style>{CSS}</style>
</head>
<body>
{md_to_html(qp)}
<div class="pagebreak"></div>
{md_to_html(sol)}
</body>
</html>
"""
    with open(out_path, "w", encoding="utf-8") as f:
        f.write(doc)
    print(f"wrote {out_path} ({len(doc)} bytes)")


def main():
    here = os.path.dirname(os.path.abspath(__file__))
    if len(sys.argv) == 2 and sys.argv[1] == "--all":
        for base in sorted(os.listdir(here)):
            if base.endswith("_QuestionPaper.md"):
                stem = base.replace("_QuestionPaper.md", "")
                build(os.path.join(here, base),
                      os.path.join(here, stem + "_Solutions.md"),
                      os.path.join(here, stem + ".html"))
    elif len(sys.argv) == 4:
        build(sys.argv[1], sys.argv[2], sys.argv[3])
    else:
        print(__doc__)
        return 2
    return 0


if __name__ == "__main__":
    sys.exit(main())
