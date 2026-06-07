import Foundation

// MARK: - OlympiadScoreReportRenderer
//
// Generates a self-contained HTML score report from one quiz
// submission — the kid's per-question answer vs. the correct answer,
// with the worked solution surfaced for every question they missed.
//
// Output is a single .html file the parent can open in Safari /
// Preview and print to PDF if they want a paper artifact. We don't
// generate PDF directly because (a) PDFKit-based page layout is
// fiddly on Big Sur and (b) WKWebView's `createPDF` path is risky on
// the AMD R9 M290X (the same GPU-driver bug class that pushed us to
// the native SwiftUI paper reader). HTML → Preview/Safari → ⌘P → Save
// as PDF is the proven flow.
//
// Reuses the design vocabulary of the Solved Guide HTMLs (Fraunces +
// Lexend, teal hero, per-question card with the correct answer
// highlighted) so the score report reads as a sibling, not a knockoff.

enum OlympiadScoreReportRenderer {

    /// Build the HTML doc. Pure — no I/O, no Bundle lookup. Caller
    /// (`OlympiadQuizResultView`) is responsible for `Data(...).write(to:)`.
    static func render(paper: OlympiadPaper,
                       questions: [OlympiadQuestion],
                       selectedByQuestionId: [String: String],
                       finishedAt: Date = Date()) -> String {
        let tally = computeTally(paper: paper,
                                 questions: questions,
                                 selectedByQuestionId: selectedByQuestionId)
        let dateFmt = DateFormatter()
        dateFmt.dateStyle = .long
        dateFmt.timeStyle = .short
        let dateStr = dateFmt.string(from: finishedAt)

        var pieces: [String] = []
        pieces.append(headBlock(title: "Score Report — \(paper.chapterTitle)"))
        pieces.append("<body><div class=\"wrap\">")
        pieces.append(hero(paper: paper, tally: tally, dateStr: dateStr))
        pieces.append("<section class=\"summary\">")
        pieces.append(summaryRow(tally: tally, paper: paper))
        pieces.append("</section>")
        pieces.append("<section class=\"qa\">")
        pieces.append("<h2>Question by question</h2>")
        for q in questions {
            pieces.append(questionCard(q,
                                       chosen: selectedByQuestionId[q.id],
                                       showExplanationAlways: false))
        }
        pieces.append("</section>")
        pieces.append("<footer><p>desktopAhaan · Class 7 Olympiad practice</p></footer>")
        pieces.append("</div></body></html>")
        return pieces.joined(separator: "\n")
    }

    // MARK: - Tally

    struct Tally {
        let correct: Int
        let wrong: Int
        let skipped: Int
        let scoreOutOfMax: Int
        let percentage: Int
    }

    static func computeTally(paper: OlympiadPaper,
                             questions: [OlympiadQuestion],
                             selectedByQuestionId: [String: String]) -> Tally {
        var correct = 0, wrong = 0, skipped = 0
        for q in questions {
            guard let chosen = selectedByQuestionId[q.id] else { skipped += 1; continue }
            if chosen.uppercased() == q.correctAnswer.uppercased() {
                correct += 1
            } else {
                wrong += 1
            }
        }
        let score = correct * paper.marksCorrect
                  + wrong * paper.marksWrong
                  + skipped * paper.marksSkipped
        let pct: Int
        if paper.maxMarks > 0 {
            let safeScore = max(0, score)
            pct = Int(Double(safeScore) / Double(paper.maxMarks) * 100.0)
        } else {
            pct = 0
        }
        return Tally(correct: correct, wrong: wrong, skipped: skipped,
                     scoreOutOfMax: score, percentage: pct)
    }

    // MARK: - HTML pieces

    private static func esc(_ s: String) -> String {
        s.replacingOccurrences(of: "&", with: "&amp;")
         .replacingOccurrences(of: "<", with: "&lt;")
         .replacingOccurrences(of: ">", with: "&gt;")
         .replacingOccurrences(of: "\"", with: "&quot;")
    }

    private static func hero(paper: OlympiadPaper, tally: Tally, dateStr: String) -> String {
        """
        <header class="hero">
          <div class="eyebrow">\(esc(paper.subjectName)) · Olympiad · Class 7</div>
          <h1>\(esc(paper.chapterTitle))</h1>
          <p class="date">Attempted \(esc(dateStr))</p>
          <div class="scoreband">
            <div class="pill big"><b>\(tally.scoreOutOfMax)</b><span>/ \(paper.maxMarks) marks</span></div>
            <div class="pill big"><b>\(tally.percentage)%</b><span>overall</span></div>
            <div class="pill"><b>\(tally.correct)</b><span>correct</span></div>
            <div class="pill"><b>\(tally.wrong)</b><span>wrong</span></div>
            <div class="pill"><b>\(tally.skipped)</b><span>skipped</span></div>
          </div>
        </header>
        """
    }

    private static func summaryRow(tally: Tally, paper: OlympiadPaper) -> String {
        """
        <p class="scheme">Marking: +\(paper.marksCorrect) correct · \(paper.marksWrong) wrong · \(paper.marksSkipped) skipped. Maximum \(paper.maxMarks).</p>
        """
    }

    private static func questionCard(_ q: OlympiadQuestion,
                                     chosen: String?,
                                     showExplanationAlways: Bool) -> String {
        let isSkipped = chosen == nil
        let chosenUpper = chosen?.uppercased()
        let correctUpper = q.correctAnswer.uppercased()
        let isCorrect = chosenUpper != nil && chosenUpper == correctUpper
        let statusLabel: String = isSkipped ? "Skipped" : (isCorrect ? "Correct" : "Wrong")
        let statusClass: String = isSkipped ? "skipped" : (isCorrect ? "correct" : "wrong")
        var html: [String] = []
        html.append("<div class=\"q \(statusClass)\">")
        html.append("  <div class=\"qhead\">")
        html.append("    <span class=\"qtag\">Q\(q.number)</span>")
        html.append("    <span class=\"status\">\(statusLabel)</span>")
        html.append("  </div>")
        html.append("  <p class=\"qtext\">\(esc(q.stem))</p>")
        html.append("  <ul class=\"opts\">")
        let letters = ["A", "B", "C", "D"]
        for idx in q.options.indices {
            let letter = idx < letters.count ? letters[idx] : "?"
            var cls = ""
            var trailing = ""
            if letter == correctUpper {
                cls = "correct"
                trailing = " <span class=\"mk\">correct</span>"
            }
            if let ch = chosenUpper, ch == letter, !isCorrect {
                cls = "kid-wrong"
                trailing = " <span class=\"mk\">your answer</span>"
            } else if let ch = chosenUpper, ch == letter, isCorrect {
                trailing = " <span class=\"mk\">your answer</span>"
            }
            html.append("    <li class=\"\(cls)\"><span class=\"lab\">\(letter)</span><span>\(esc(q.options[idx]))</span>\(trailing)</li>")
        }
        html.append("  </ul>")
        if (!isCorrect || showExplanationAlways), let expl = q.explanation, !expl.isEmpty {
            html.append("  <div class=\"solve\"><h4>Working</h4><p>\(esc(expl))</p></div>")
        }
        html.append("</div>")
        return html.joined(separator: "\n")
    }

    private static func headBlock(title: String) -> String {
        // Style block is intentionally inline + self-contained — the
        // file should print cleanly with no asset dependencies. Same
        // vocab as the Solved Guides but tuned for a score report:
        // every Q shows status tint (correct=green, wrong=red,
        // skipped=gray); the kid's chosen-wrong option gets a red
        // outline so they can SEE the miss at a glance.
        """
        <!DOCTYPE html>
        <html lang="en"><head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>\(esc(title))</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,600;9..144,700&family=Lexend:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
          :root{--cream:#fbf7ee;--paper:#fff;--ink:#23302f;--soft:#55635f;--teal:#0f8a7e;--teal-deep:#0a5f57;--green:#3a9d5d;--green-wash:#e6f4ea;--red:#c54a3b;--red-wash:#fbe6e3;--gold:#e0a528;--gold-wash:#fbf2d9;--gray:#8b948f;--gray-wash:#eceeec;--line:#e7e0d2;}
          *{box-sizing:border-box;}
          body{margin:0;background:var(--cream);color:var(--ink);font-family:'Lexend',sans-serif;line-height:1.55;}
          .wrap{max-width:820px;margin:0 auto;padding:32px 22px 60px;}
          .hero{background:linear-gradient(135deg,var(--teal) 0%,var(--teal-deep) 100%);color:#fff;border-radius:22px;padding:32px 30px;box-shadow:0 14px 36px -18px rgba(15,90,82,.4);}
          .hero .eyebrow{font-size:.78rem;letter-spacing:.16em;text-transform:uppercase;opacity:.85;font-weight:600;}
          .hero h1{font-family:'Fraunces',serif;font-weight:600;font-size:2.0rem;line-height:1.1;margin:.35em 0 .15em;}
          .hero .date{margin:0 0 14px;opacity:.85;font-size:.95rem;font-weight:300;}
          .scoreband{display:flex;gap:10px;flex-wrap:wrap;}
          .pill{background:rgba(255,255,255,.14);border:1px solid rgba(255,255,255,.25);border-radius:12px;padding:9px 14px;}
          .pill b{font-family:'Fraunces',serif;font-size:1.2rem;display:block;line-height:1;}
          .pill.big b{font-size:1.7rem;}
          .pill span{font-size:.72rem;opacity:.85;}
          .summary{margin:22px 0 4px;}
          .scheme{color:var(--soft);font-size:.88rem;}
          .qa h2{font-family:'Fraunces',serif;color:var(--teal-deep);font-size:1.35rem;margin:30px 0 14px;}
          .q{background:var(--paper);border:1px solid var(--line);border-left-width:6px;border-radius:14px;padding:18px 22px;margin-bottom:14px;}
          .q.correct{border-left-color:var(--green);}
          .q.wrong{border-left-color:var(--red);}
          .q.skipped{border-left-color:var(--gray);}
          .qhead{display:flex;gap:10px;align-items:center;margin-bottom:8px;}
          .qtag{display:inline-block;background:var(--ink);color:#fff;font-size:.7rem;font-weight:600;letter-spacing:.05em;padding:3px 10px;border-radius:6px;}
          .status{font-size:.75rem;font-weight:600;letter-spacing:.05em;text-transform:uppercase;}
          .q.correct .status{color:var(--green);}
          .q.wrong .status{color:var(--red);}
          .q.skipped .status{color:var(--gray);}
          .qtext{font-size:1.0rem;font-weight:500;margin:0 0 12px;}
          .opts{list-style:none;padding:0;margin:0 0 10px;display:grid;gap:6px;}
          .opts li{padding:7px 12px;border-radius:9px;border:1.5px solid var(--line);font-size:.92rem;display:flex;align-items:center;gap:10px;}
          .opts li .lab{font-weight:700;width:1.3em;}
          .opts li.correct{background:var(--green-wash);border-color:#a9dab9;color:#1f6d3a;font-weight:600;}
          .opts li.kid-wrong{background:var(--red-wash);border-color:#e0a59b;color:var(--red);font-weight:600;}
          .opts li .mk{margin-left:auto;font-size:.72rem;font-weight:700;text-transform:uppercase;}
          .solve{background:#f8faf9;border-radius:10px;padding:6px 14px 12px;margin-top:8px;}
          .solve h4{font-family:'Fraunces',serif;color:var(--teal-deep);font-size:.9rem;margin:10px 0 4px;}
          .solve p{margin:0;font-size:.9rem;}
          footer{text-align:center;color:var(--soft);font-size:.78rem;margin-top:30px;}
          @media print{body{background:#fff;}.hero{box-shadow:none;}.q{page-break-inside:avoid;}}
          @media (max-width:540px){.hero h1{font-size:1.55rem;}.wrap{padding:20px 14px 50px;}}
        </style>
        </head>
        """
    }
}
