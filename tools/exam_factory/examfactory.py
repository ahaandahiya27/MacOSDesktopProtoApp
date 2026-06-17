# -*- coding: utf-8 -*-
# Reusable exam-paper engine with BALANCED answer keys (~25% A/B/C/D).
# Items are content-keyed: (chapter, stem, correct_text, main_html, [(distractor_text, why_html) x3])
import os, html, random
from collections import Counter
# reportlab is OPTIONAL. The dev Mac no longer ships it, so the question-paper
# PDF is produced by a tiny dependency-free writer (see _write_pdf below) and
# the question paper is ALSO emitted as pure HTML. When reportlab *is* present
# (older toolchains) the richer Platypus PDF path is still used.
try:
    from reportlab.lib.pagesizes import A4
    from reportlab.lib.units import mm
    from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
    from reportlab.lib.enums import TA_CENTER
    from reportlab.lib import colors
    from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, HRFlowable, KeepTogether
    _HAVE_REPORTLAB = True
except Exception:
    _HAVE_REPORTLAB = False

# ---- small helpers shared by all papers ----
def C(t): return f'<p><span class="lbl">The idea</span> {t}</p>'
def steps(*xs): return '<div class="steps">'+''.join(f'<div class="st">{x}</div>' for x in xs)+'</div>'
def U(t): return f'<p class="uc"><span class="lbl gr">Where you meet it in real life</span> {t}</p>'

# ---- diagrams ----
PEND='<svg viewBox="0 0 160 90" class="dgm" style="max-width:160px"><line x1="20" y1="10" x2="140" y2="10" stroke="#888" stroke-width="3"/><line x1="80" y1="10" x2="120" y2="70" stroke="#666"/><circle cx="120" cy="74" r="9" fill="#c83"/><path d="M80 10 L40 70" stroke="#bbb" stroke-dasharray="3 3"/><circle cx="40" cy="74" r="9" fill="#ddd" stroke="#bbb"/><text x="30" y="88" font-size="8" fill="#666">one to-and-fro = 1 oscillation</text></svg>'
DTG='<svg viewBox="0 0 160 100" class="dgm" style="max-width:170px"><line x1="25" y1="12" x2="25" y2="85" stroke="#888"/><line x1="25" y1="85" x2="150" y2="85" stroke="#888"/><line x1="25" y1="85" x2="135" y2="25" stroke="#2a7" stroke-width="3"/><text x="55" y="40" font-size="8" fill="#2a7">straight slope = uniform speed</text><text x="30" y="98" font-size="8" fill="#666">distance vs time</text><text x="6" y="50" font-size="8" fill="#888">dist</text></svg>'
LUNGS='<svg viewBox="0 0 150 95" class="dgm" style="max-width:150px"><line x1="75" y1="8" x2="75" y2="35" stroke="#888" stroke-width="3"/><text x="80" y="20" font-size="8">windpipe</text><ellipse cx="55" cy="55" rx="18" ry="26" fill="#f3c7c7" stroke="#c88"/><ellipse cx="95" cy="55" rx="18" ry="26" fill="#f3c7c7" stroke="#c88"/><path d="M30 85 Q75 95 120 85" fill="none" stroke="#69b" stroke-width="3"/><text x="40" y="92" font-size="8" fill="#69b">diaphragm</text></svg>'
LIME='<svg viewBox="0 0 150 80" class="dgm" style="max-width:150px"><rect x="40" y="20" width="50" height="50" rx="4" fill="#eef" stroke="#88a"/><rect x="42" y="45" width="46" height="23" fill="#f4f4f4"/><text x="46" y="60" font-size="8">lime water</text><text x="20" y="16" font-size="8" fill="#666">exhale CO₂ → turns milky</text></svg>'.replace('₂','<tspan baseline-shift="sub" font-size="6">2</tspan>')
def balance(left,right):
    return f'<svg viewBox="0 0 220 70" class="dgm"><line x1="20" y1="40" x2="200" y2="40" stroke="#888" stroke-width="3"/><polygon points="110,40 100,62 120,62" fill="#aaa"/><text x="55" y="30" font-size="11" text-anchor="middle">{left}</text><text x="165" y="30" font-size="11" text-anchor="middle">{right}</text><text x="40" y="68" font-size="8" fill="#666">an equation = a balance: do the same to both sides</text></svg>'
def speedtri():
    return '<svg viewBox="0 0 120 90" class="dgm" style="max-width:120px"><polygon points="60,8 18,80 102,80" fill="#eef6ff" stroke="#9bd"/><text x="60" y="34" font-size="12" text-anchor="middle">d</text><text x="42" y="72" font-size="12">s</text><text x="80" y="72" font-size="12">t</text><text x="6" y="88" font-size="7" fill="#666">d=s×t · s=d/t · t=d/s</text></svg>'

# ===================================================================
# Dependency-free question-paper renderers (NO reportlab required).
# Helvetica AFM advance widths (units/1000) for ASCII 32..126 — used for
# accurate word-wrap + centring in the hand-built PDF.
# ===================================================================
_HELV_W = [278,278,355,556,556,889,667,191,333,333,389,584,278,333,278,278,556,556,556,556,556,556,556,556,556,556,278,278,584,584,584,556,1015,667,667,722,722,667,611,778,722,278,500,667,556,833,722,778,667,778,722,667,611,722,667,944,667,667,611,278,278,278,469,556,333,556,556,500,556,556,278,556,556,222,222,500,222,833,556,556,556,556,333,500,278,556,500,722,500,500,500,334,260,334,584]
_HELVB_W=[278,333,474,556,556,889,722,238,333,333,389,584,278,333,278,278,556,556,556,556,556,556,556,556,556,556,333,333,584,584,584,611,975,722,722,722,722,667,611,778,722,278,556,722,611,833,722,778,667,778,722,667,611,722,667,944,667,667,611,333,278,333,584,556,333,556,611,556,611,556,333,611,611,278,278,556,278,889,611,611,611,611,389,556,333,611,556,778,556,556,500,389,280,389,584]
def _cw(ch, bold):
    o = ord(ch)
    if 32 <= o <= 126:
        return (_HELVB_W if bold else _HELV_W)[o-32]
    return 556
def _twidth(s, size, bold):
    return sum(_cw(c, bold) for c in s)/1000.0*size
def _wrap(text, size, bold, maxw):
    out, cur = [], ""
    for w in str(text).split():
        trial = w if not cur else cur+" "+w
        if not cur or _twidth(trial, size, bold) <= maxw:
            cur = trial
        else:
            out.append(cur); cur = w
    if cur: out.append(cur)
    return out or [""]
def _pdf_san(s):
    s = str(s)
    for k, v in (("−","-"),("–","-"),("—","-"),("→","->"),("×","x"),("÷","/"),
                 ("·","-"),("°"," deg"),("²","^2"),("³","^3"),("≥",">="),("≤","<="),
                 ("≈","~"),("√","root "),("±","+/-"),("∠","angle "),("△","triangle "),
                 ("Ω","ohm"),("₀","0"),("₁","1"),("₂","2"),("₃","3"),("₄","4"),
                 ("’","'"),("‘","'"),("“",'"'),("”",'"'),("…","...")):
        s = s.replace(k, v)
    return "".join(c if 32 <= ord(c) < 127 else "?" for c in s)
def _pdf_esc(s):
    return s.replace("\\","\\\\").replace("(","\\(").replace(")","\\)")
def _write_pdf(path, title, subtitle_lines, blocks):
    """blocks: list of (num:int, stem:str, [optA,optB,optC,optD]). A4, Helvetica."""
    PW, PH = 595.28, 841.89
    ML, MR, MT, MB = 50, 50, 58, 52
    usable = PW-ML-MR
    SZQ, SZO, LHQ, LHO = 10.6, 10.2, 14.0, 13.4
    pages, cur, y = [], [], 0.0
    def start():
        nonlocal cur, y
        cur = []; y = PH-MT; pages.append(cur)
    start()
    tw = _twidth(title, 16, True); cur.append(((PW-tw)/2, y, title, 16, True)); y -= 24
    for sl in subtitle_lines:
        for ln in _wrap(sl, 9, False, usable):
            cur.append(((PW-_twidth(ln,9,False))/2, y, ln, 9, False)); y -= 12
    y -= 12
    for num, stem, opts in blocks:
        lines = []
        for t in _wrap(f"{num}.  {_pdf_san(stem)}", SZQ, False, usable):
            lines.append((ML, t, SZQ, False))
        for i, L in enumerate("ABCD"):
            for t in _wrap(f"({L})  {_pdf_san(opts[i])}", SZO, False, usable-18):
                lines.append((ML+18, t, SZO, False))
        h = sum((LHQ if sz >= SZQ else LHO) for _,_,sz,_ in lines)+8
        if y-h < MB and y < PH-MT-1:
            start()
        for x, t, sz, b in lines:
            lh = LHQ if sz >= SZQ else LHO
            if y-lh < MB:
                start()
            cur.append((x, y, t, sz, b)); y -= lh
        y -= 8
    # ---- serialise ----
    n = len(pages); freg, fbold = 3, 4
    pid, cid, k = [], [], 5
    for _ in range(n):
        pid.append(k); cid.append(k+1); k += 2
    total = k-1
    buf = bytearray(b"%PDF-1.4\n%\xe2\xe3\xcf\xd3\n")
    off = {}
    def put(num, body):
        off[num] = len(buf)
        buf.extend(f"{num} 0 obj\n".encode("latin-1"))
        buf.extend(body if isinstance(body, bytes) else body.encode("latin-1"))
        buf.extend(b"\nendobj\n")
    put(1, "<< /Type /Catalog /Pages 2 0 R >>")
    put(2, "<< /Type /Pages /Kids ["+" ".join(f"{p} 0 R" for p in pid)+f"] /Count {n} >>")
    put(freg,  "<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>")
    put(fbold, "<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>")
    for j, page in enumerate(pages):
        parts = ["BT"]
        for (x, yy, text, size, bold) in page:
            parts.append(f"/{'F2' if bold else 'F1'} {size:.2f} Tf")
            parts.append(f"1 0 0 1 {x:.2f} {yy:.2f} Tm")
            parts.append(f"({_pdf_esc(text)}) Tj")
        parts.append("ET")
        stream = "\n".join(parts).encode("latin-1")
        put(cid[j], b"<< /Length "+str(len(stream)).encode()+b" >>\nstream\n"+stream+b"\nendstream")
        put(pid[j], f"<< /Type /Page /Parent 2 0 R /MediaBox [0 0 {PW:.2f} {PH:.2f}] "
                    f"/Resources << /Font << /F1 {freg} 0 R /F2 {fbold} 0 R >> >> "
                    f"/Contents {cid[j]} 0 R >>")
    xo = len(buf)
    buf.extend(f"xref\n0 {total+1}\n".encode("latin-1"))
    buf.extend(b"0000000000 65535 f \n")
    for num in range(1, total+1):
        buf.extend(f"{off.get(num,0):010d} 00000 n \n".encode("latin-1"))
    buf.extend(f"trailer\n<< /Size {total+1} /Root 1 0 R >>\nstartxref\n{xo}\n%%EOF".encode("latin-1"))
    with open(path, "wb") as fh:
        fh.write(bytes(buf))
def _write_question_html(path, PNUM, title_chapters, rows):
    """Dependency-free question paper as pure HTML (questions + 4 options, NO answers)."""
    CSS=('*{box-sizing:border-box}body{font-family:-apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif;'
         'color:#1f2430;margin:0;background:#f4f6fb;line-height:1.5}.wrap{max-width:820px;margin:0 auto;padding:26px 20px 70px}'
         'h1{color:#15366b;margin:0 0 4px;font-size:23px}.lead{color:#566;margin:0 0 4px;font-size:14px}'
         '.mark{font-size:13px;color:#445;background:#eef2fb;border:1px solid #d6e0f5;border-radius:10px;padding:8px 13px;margin:10px 0 22px}'
         '.q{background:#fff;border:1px solid #e3e8f2;border-radius:12px;padding:13px 17px;margin:0 0 13px;box-shadow:0 1px 3px rgba(20,40,80,.04)}'
         '.qn{display:inline-block;background:#15366b;color:#fff;font-weight:700;font-size:12px;border-radius:6px;padding:1px 8px;margin-right:7px}'
         '.stem{font-weight:600;font-size:15px}.opts{margin:9px 0 0;padding:0;list-style:none}'
         '.opts li{font-size:14px;padding:3px 0}.ol{font-weight:700;color:#556;margin-right:5px}'
         '@media print{body{background:#fff}.q{break-inside:avoid;box-shadow:none}}')
    def esc(s): return html.escape(str(s))
    qs=[]
    for i,(ch,stem,opt,ans,exp) in enumerate(rows,1):
        ol="".join(f'<li><span class="ol">({L})</span> {esc(opt[L])}</li>' for L in "ABCD")
        qs.append(f'<div class="q"><div><span class="qn">Q{i}</span><span class="stem">{esc(stem)}</span></div>'
                  f'<ul class="opts">{ol}</ul></div>')
    doc=(f'<!DOCTYPE html><html lang="en"><head><meta charset="utf-8">'
         f'<meta name="viewport" content="width=device-width,initial-scale=1">'
         f'<title>Boss Paper {PNUM} — Question Paper</title><style>{CSS}</style></head><body><div class="wrap">'
         f'<h1>🏆 Boss Challenge — Paper {PNUM}: Question Paper</h1>'
         f'<p class="lead">Class 7 · {esc(title_chapters)}</p>'
         f'<div class="mark">100 single-correct MCQs · one correct option each · Marking: <b>+4</b> correct, '
         f'<b>−1</b> wrong, <b>0</b> blank. Write your A/B/C/D answers on a separate sheet; '
         f'check them against the Solutions file.</div>'
         f'{"".join(qs)}</div></body></html>')
    open(path,"w",encoding="utf-8").write(doc)

def build_paper(PNUM, title_chapters, SHORT, chip_labels, items, seed=None, append_manifest=True):
    DIR=f"Paper_{PNUM}_{SHORT}"; os.makedirs(DIR, exist_ok=True)
    n=len(items); assert n==100, n
    rng=random.Random(seed if seed is not None else int(PNUM)*101+7)
    # exactly balanced target letters
    targets=(["A","B","C","D"]*((n//4)+1))[:n]; rng.shuffle(targets)
    rows=[]   # each: chapter, stem, {A..D:text}, ans_letter, explanation_html
    for it,tgt in zip(items,targets):
        ch,stem,correct,main,dist=it
        assert len(dist)==3, stem
        order=["A","B","C","D"]; others=[L for L in order if L!=tgt]
        rng.shuffle(others)  # randomise where distractors land too
        mp={tgt:(correct,None)}
        for L,(dt,why) in zip(others,dist): mp[L]=(dt,why)
        # why-wrong block sorted by letter
        wl="".join(f'<li><b>{L}:</b> {mp[L][1]}</li>' for L in order if L!=tgt)
        exp=main+'<div class="wrong"><span class="lbl rd">Why the other options miss</span><ul>'+wl+'</ul></div>'
        rows.append((ch,stem,{L:mp[L][0] for L in order},tgt,exp))

    # ---- Questions.md ----
    md=[f"# Boss Challenge Paper {PNUM} — 100 MCQs (Class 7)","",f"**Chapters (mixed):** {title_chapters}","",
        "**Marking:** +4 correct, −1 wrong, 0 blank. One correct option each. Answers in the Solutions file.","","---",""]
    for i,(ch,stem,opt,ans,exp) in enumerate(rows,1):
        md.append(f"{i}. {stem}"); md+=[f"   (A) {opt['A']}",f"   (B) {opt['B']}",f"   (C) {opt['C']}",f"   (D) {opt['D']}",""]
    open(os.path.join(DIR,"Questions.md"),"w",encoding="utf-8").write("\n".join(md))

    # ---- Question paper: pure HTML (always) ----
    _write_question_html(os.path.join(DIR,"QuestionPaper.html"), PNUM, title_chapters, rows)

    # ---- Question paper: PDF (dependency-free writer; reportlab path kept for older toolchains) ----
    subtitle=[title_chapters.replace('·','|'),
              "One correct option each. Marking: +4 correct, -1 wrong, 0 blank. Write A/B/C/D on a separate sheet."]
    if _HAVE_REPORTLAB:
        def san(s):
            s=str(s).replace("−","-").replace("–","-").replace("—"," - ").replace("→","->").replace("×","x").replace("÷","/").replace("·"," - ").replace("°","&deg;")
            s=s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("&amp;deg;","&deg;").replace("&amp;lt;","&lt;").replace("&amp;gt;","&gt;")
            return s
        doc=SimpleDocTemplate(os.path.join(DIR,"QuestionPaper.pdf"),pagesize=A4,topMargin=15*mm,bottomMargin=15*mm,leftMargin=18*mm,rightMargin=18*mm,title=f"Boss Paper {PNUM}")
        ss=getSampleStyleSheet()
        T=ParagraphStyle('t',parent=ss['Title'],fontSize=17,textColor=colors.HexColor('#15366b'),spaceAfter=3)
        S=ParagraphStyle('s',parent=ss['Normal'],fontSize=9.5,alignment=TA_CENTER,textColor=colors.HexColor('#555'),spaceAfter=2,leading=13)
        QST=ParagraphStyle('q',parent=ss['Normal'],fontSize=10.8,leading=15,spaceBefore=9,spaceAfter=3)
        OS=ParagraphStyle('o',parent=ss['Normal'],fontSize=10.3,leading=14.5,leftIndent=14,spaceAfter=1.5)
        story=[Paragraph(f"Boss Challenge — Paper {PNUM} (Class 7)",T),
               Paragraph(san(title_chapters.replace('·','|')),S),
               Paragraph("One correct option each. Marking: +4 correct, -1 wrong, 0 blank. Write A/B/C/D on a separate sheet.",S),
               Spacer(1,4),HRFlowable(width="100%",thickness=1,color=colors.HexColor('#15366b')),Spacer(1,2)]
        for i,(ch,stem,opt,ans,exp) in enumerate(rows,1):
            blk=[Paragraph(f"<b>{i}.</b>&nbsp;&nbsp;{san(stem)}",QST)]
            for L in "ABCD": blk.append(Paragraph(f"<b>({L})</b>&nbsp;&nbsp;{san(opt[L])}",OS))
            blk.append(Spacer(1,3)); story.append(KeepTogether(blk))
        doc.build(story)
    else:
        blocks=[(i,stem,[opt['A'],opt['B'],opt['C'],opt['D']]) for i,(ch,stem,opt,ans,exp) in enumerate(rows,1)]
        _write_pdf(os.path.join(DIR,"QuestionPaper.pdf"),
                   f"Boss Challenge - Paper {PNUM} (Class 7)", subtitle, blocks)

    # ---- Solutions HTML ----
    CSS='''*{box-sizing:border-box}body{font-family:-apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif;color:#1f2430;margin:0;background:#f4f6fb;line-height:1.55}
.wrap{max-width:880px;margin:0 auto;padding:26px 20px 70px}h1{color:#15366b;margin:0 0 4px;font-size:25px}.lead{color:#566;margin:0 0 12px;font-size:14px}
.legend{font-size:13px;color:#445;background:#eef2fb;border:1px solid #d6e0f5;border-radius:10px;padding:10px 14px;margin:0 0 22px}
.card{background:#fff;border:1px solid #e3e8f2;border-radius:14px;padding:18px 20px;margin:0 0 18px;box-shadow:0 1px 4px rgba(20,40,80,.05)}
.qh{font-size:16px;margin-bottom:10px}.qn{display:inline-block;background:#15366b;color:#fff;font-weight:700;font-size:12px;border-radius:6px;padding:2px 9px;margin-right:6px}
.chip{display:inline-block;font-size:10.5px;border-radius:5px;padding:1px 7px;margin-left:4px;background:#eef2fb;color:#456}.qt{font-weight:600}
.opt{padding:6px 11px;border:1px solid #e6e9f0;border-radius:8px;margin:5px 0;font-size:14px;background:#fbfcfe}.opt .ol{font-weight:700;color:#556}
.opt.correct{background:#e8f7ec;border-color:#7fd29a}.opt.correct .ol{color:#1c7a3e}.tick{color:#1c7a3e;font-weight:700}
.ansbar{font-size:13.5px;color:#1c7a3e;font-weight:700;margin:2px 0 10px}
.exp{font-size:14.5px;background:#fffdf6;border:1px solid #f0e4b8;border-left:4px solid #f0c000;border-radius:8px;padding:12px 16px}.exp p{margin:8px 0}
.lbl{display:inline-block;font-weight:800;font-size:11px;letter-spacing:.3px;text-transform:uppercase;color:#8a6d00;background:#fdf3cf;border-radius:5px;padding:1px 7px;margin-right:6px}
.lbl.rd{color:#9a3030;background:#fbe1e1}.lbl.gr{color:#1c6a3e;background:#def3e5}
.steps{margin:8px 0;border-left:3px solid #9db8e6;padding-left:12px;background:#f7faff;border-radius:0 8px 8px 0;padding-top:4px;padding-bottom:4px}.st{font-size:13.5px;font-family:ui-monospace,Menlo,Consolas,monospace;color:#234;padding:2px 0}
.wrong{background:#fcf4f4;border:1px solid #f0d8d8;border-radius:8px;padding:6px 12px;margin:8px 0}.wrong ul{margin:6px 0 4px;padding-left:18px}.wrong li{font-size:13.5px;margin:3px 0}
.uc{background:#f1f8f3;border:1px solid #cfe9d8;border-radius:8px;padding:8px 12px;margin:8px 0 2px;font-size:14px}
.dgm{display:block;max-width:340px;margin:10px 0;background:#fff;border:1px dashed #cdd6ea;border-radius:8px;padding:4px}
@media print{body{background:#fff}.card{break-inside:avoid;box-shadow:none}.wrap{max-width:100%}}'''
    def esc(s): return html.escape(str(s))
    cards=[]
    for i,(ch,stem,opt,ans,exp) in enumerate(rows,1):
        oh=""
        for L in "ABCD":
            cls="opt correct" if L==ans else "opt"; tick=" ✓" if L==ans else ""
            oh+=f'<div class="{cls}"><span class="ol">({L})</span> {esc(opt[L])}<span class="tick">{tick}</span></div>'
        cards.append(f'<div class="card"><div class="qh"><span class="qn">Q{i}</span><span class="chip">{chip_labels[ch]}</span> <span class="qt">{esc(stem)}</span></div>{oh}<div class="ansbar">Correct answer: <b>{ans}</b></div><div class="exp">{exp}</div></div>')
    keydist=Counter(r[3] for r in rows)
    HTMLDOC=f'''<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Boss Paper {PNUM} — Detailed Solutions</title><style>{CSS}</style></head><body><div class="wrap">
<h1>🏆 Boss Challenge — Paper {PNUM}: Detailed Solutions</h1><p class="lead">Class 7 · {title_chapters}</p>
<div class="legend">Every question: <b>The idea</b>, <b>step-by-step reasoning</b>, a <b>diagram</b> where it helps, <b style="color:#9a3030">why the other options miss</b>, and a <b style="color:#1c6a3e">real-life use-case</b>. Green = correct option. <b>Answer key is balanced</b> — correct option spread A:{keydist['A']} B:{keydist['B']} C:{keydist['C']} D:{keydist['D']}.</div>
{''.join(cards)}<p style="text-align:center;color:#889;font-size:12px;margin-top:30px">Paper {PNUM} · 100 questions · answer spread A:{keydist['A']} B:{keydist['B']} C:{keydist['C']} D:{keydist['D']} 🎯</p></div></body></html>'''
    open(os.path.join(DIR,"Solutions.html"),"w",encoding="utf-8").write(HTMLDOC)

    # manifest (optional — callers that own a curated manifest pass append_manifest=False)
    if append_manifest:
        mani="PAPERS_MANIFEST.md"
        if not os.path.exists(mani):
            open(mani,"w").write("# Exam Papers Manifest\n\n| # | Date | Chapters | Answer spread (A/B/C/D) | Self-check |\n|---|---|---|---|---|\n")
        open(mani,"a").write(f"| {PNUM} | 2026-06-17 | {title_chapters} | {keydist['A']}/{keydist['B']}/{keydist['C']}/{keydist['D']} | ✓ |\n")
    print(f"Paper {PNUM} built. answer spread A/B/C/D = {dict(keydist)} | dir {DIR} | files {os.listdir(DIR)}")
    return keydist
