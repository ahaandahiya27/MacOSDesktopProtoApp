import Foundation

// MARK: - OlympiadPaperParser
//
// Parses the bundled QuestionPaper.md + Solutions.md into a structured
// [OlympiadQuestion]. The MD format is fixed by the authoring pipeline
// (`TestPapers/validate_paper.py`):
//
//   QuestionPaper.md
//     N. <stem>                          (stems may span multiple lines)
//        (A) <option>
//        (B) <option>
//        (C) <option>
//        (D) <option>
//
//   Solutions.md
//     **N. (X)** <explanation…>          (X = A/B/C/D; explanation
//                                          may span multiple lines)
//
// Question numbers are 1…60 contiguous; the validator pins this.
// If the bundle resource is missing, decode failures fall back to an
// empty array and the caller surfaces a non-fatal placeholder.
//
// Big Sur safety: only `NSRegularExpression`, `String.components`,
// `Bundle.main.url(forResource:withExtension:subdirectory:)` — all
// baseline 10.6+.

enum OlympiadPaperParser {

    /// Read both bundled resources from the `TestPapers/` subdirectory
    /// and merge them into the structured form the quiz UI consumes.
    /// Returns an empty array (logged via CrashReporter.logDataIssue)
    /// if either resource fails to load — the UI then renders the
    /// "couldn't load this paper" placeholder rather than crashing.
    static func parse(
        paperId: String,
        questionPaperResource: String,
        solutionsResource: String
    ) -> [OlympiadQuestion] {
        guard let questionPaperText = readResource(questionPaperResource) else {
            CrashReporter.shared.logDataIssue(
                "OlympiadPaperParser: missing QuestionPaper resource '\(questionPaperResource)' for paper '\(paperId)'"
            )
            return []
        }
        guard let solutionsText = readResource(solutionsResource) else {
            CrashReporter.shared.logDataIssue(
                "OlympiadPaperParser: missing Solutions resource '\(solutionsResource)' for paper '\(paperId)'"
            )
            return []
        }

        let answerKey = parseSolutions(solutionsText)
        let bones = parseQuestionPaper(questionPaperText)

        var out: [OlympiadQuestion] = []
        for bone in bones {
            guard let answer = answerKey[bone.number]?.letter else { continue }
            let explanation = answerKey[bone.number]?.explanation
            out.append(
                OlympiadQuestion(
                    id: "\(paperId)_q\(String(format: "%02d", bone.number))",
                    number: bone.number,
                    stem: bone.stem,
                    options: bone.options,
                    correctAnswer: answer,
                    explanation: explanation
                )
            )
        }
        return out
    }

    /// Resource lookup. Bundled under `TestPapers/` subdirectory.
    private static func readResource(_ name: String) -> String? {
        let bare = (name as NSString).deletingPathExtension
        let ext = (name as NSString).pathExtension
        guard let url = Bundle.main.url(
            forResource: bare,
            withExtension: ext,
            subdirectory: "TestPapers"
        ) ?? Bundle.main.url(forResource: bare, withExtension: ext) else {
            return nil
        }
        return try? String(contentsOf: url, encoding: .utf8)
    }

    // MARK: - QuestionPaper.md parsing

    /// Skeleton struct used between the two parser stages.
    private struct QuestionBone {
        let number: Int
        let stem: String
        let options: [String]
    }

    /// Parse the question paper text into per-question bones. The MD
    /// format is forgiving — stems may span multiple lines, options
    /// must start with `(A) `…`(D) `. Implementation: scan line by
    /// line, accumulate into the current question, flush on the next
    /// `N.` head.
    private static func parseQuestionPaper(_ text: String) -> [QuestionBone] {
        var out: [QuestionBone] = []
        var currentNumber: Int? = nil
        var currentStem: [String] = []
        var currentOptions: [String: String] = [:]    // letter → text

        let lines = text.components(separatedBy: "\n")
        let questionHead = try? NSRegularExpression(
            pattern: #"^(\d+)\.\s+(.*)$"#,
            options: []
        )
        let optionHead = try? NSRegularExpression(
            pattern: #"^\s*\(([A-D])\)\s+(.*)$"#,
            options: []
        )

        func flush() {
            guard let num = currentNumber, currentOptions.count == 4 else { return }
            let stem = currentStem.joined(separator: " ")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            let opts = ["A", "B", "C", "D"].map { currentOptions[$0] ?? "" }
            out.append(QuestionBone(number: num, stem: stem, options: opts))
        }

        for rawLine in lines {
            let line = rawLine as NSString
            let range = NSRange(location: 0, length: line.length)

            if let m = questionHead?.firstMatch(in: rawLine, options: [], range: range),
               m.numberOfRanges >= 3 {
                // New question — flush the previous one.
                flush()
                currentNumber = Int(line.substring(with: m.range(at: 1))) ?? 0
                currentStem = [line.substring(with: m.range(at: 2))]
                currentOptions.removeAll(keepingCapacity: true)
                continue
            }
            if let m = optionHead?.firstMatch(in: rawLine, options: [], range: range),
               m.numberOfRanges >= 3,
               currentNumber != nil {
                let letter = line.substring(with: m.range(at: 1))
                let text = line.substring(with: m.range(at: 2))
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                currentOptions[letter] = text
                continue
            }
            // Continuation of the current question's stem (multi-line
            // stems do exist for word-problem questions).
            if currentNumber != nil && currentOptions.isEmpty {
                let trimmed = rawLine.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty && !trimmed.hasPrefix("---") {
                    currentStem.append(trimmed)
                }
            }
        }
        flush()
        return out
    }

    // MARK: - Solutions.md parsing

    /// One entry in the parsed answer key: the correct letter plus the
    /// worked-solution prose.
    private struct AnswerEntry {
        let letter: String
        let explanation: String
    }

    /// Parse the solutions text. The MD format is:
    ///   `**N. (X)** explanation…`
    /// Explanations may span multiple lines until the next `**N. (Y)**`
    /// line OR end of file.
    private static func parseSolutions(_ text: String) -> [Int: AnswerEntry] {
        var out: [Int: AnswerEntry] = [:]
        let lines = text.components(separatedBy: "\n")
        let head = try? NSRegularExpression(
            pattern: #"^\*\*(\d+)\.\s+\(([A-D])\)\*\*\s*(.*)$"#,
            options: []
        )

        var currentNumber: Int? = nil
        var currentLetter: String? = nil
        var currentExplanation: [String] = []

        func flush() {
            if let num = currentNumber, let letter = currentLetter {
                let prose = currentExplanation.joined(separator: " ")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                out[num] = AnswerEntry(letter: letter, explanation: prose)
            }
        }

        for rawLine in lines {
            let nsLine = rawLine as NSString
            let range = NSRange(location: 0, length: nsLine.length)
            if let m = head?.firstMatch(in: rawLine, options: [], range: range),
               m.numberOfRanges >= 4 {
                // New answer entry.
                flush()
                currentNumber = Int(nsLine.substring(with: m.range(at: 1))) ?? 0
                currentLetter = nsLine.substring(with: m.range(at: 2))
                currentExplanation = [nsLine.substring(with: m.range(at: 3))]
            } else if currentNumber != nil {
                let trimmed = rawLine.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty
                    && !trimmed.hasPrefix("#")
                    && !trimmed.hasPrefix("<!--")
                    && !trimmed.hasPrefix("-->") {
                    currentExplanation.append(trimmed)
                }
            }
        }
        flush()
        return out
    }
}
