import SwiftUI
import AppKit

// MARK: - Printable worksheet: sampling + AppKit print renderer
//
// `WorksheetSampler` is the PURE, testable core: it picks a deterministic
// seeded sample of MCQ questions from a chapter and derives the answer key.
// `WorksheetPrintRenderer` wraps the SwiftUI page layout in an `NSHostingView`
// and drives `NSPrintOperation` (a real `NSView` is required for printing).
//
// Big Sur compatible: `NSPrintInfo` / `NSPrintOperation.run()` are 10.13+;
// the block/selector sheet variant (deprecated on 11.0) is intentionally
// avoided per the don't-regress catalog. `shuffled(using:)` is Swift 5.5.
// No macOS 12+ APIs.

// MARK: - Deterministic PRNG

/// SplitMix64 — a tiny, stable, seedable generator. Stable across runs and
/// machines (unlike `Hasher`), so a given seed always yields the same sample.
struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) {
        // Avoid the all-zero fixed point.
        state = seed == 0 ? 0x9E3779B97F4A7C15 : seed
    }
    mutating func next() -> UInt64 {
        state = state &+ 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}

// MARK: - Sampler (pure)

enum WorksheetSampler {

    /// The worksheet question-count choices the slider offers.
    static let countChoices = [5, 10, 15, 20]
    static let defaultCount = 10

    /// MCQ questions in `chapter` eligible for a paper worksheet: multiple
    /// choice with at least two options (we render a/b/c/d).
    static func eligibleMCQs(in chapter: Chapter) -> [Question] {
        var result: [Question] = []
        for topic in chapter.topics {
            for question in topic.questions {
                let optionCount = question.options?.count ?? 0
                if question.questionType == .mcq && optionCount >= 2 {
                    result.append(question)
                }
            }
        }
        return result
    }

    /// A deterministic seeded sample of up to `count` questions. Same seed →
    /// same questions; different seeds → (almost always) a different sample.
    static func sample(_ questions: [Question], count: Int, seed: UInt64) -> [Question] {
        guard count > 0, !questions.isEmpty else { return [] }
        var gen = SeededGenerator(seed: seed)
        return Array(questions.shuffled(using: &gen).prefix(count))
    }

    /// Stable UInt64 seed from a string (FNV-1a) — used to turn
    /// `Date().description` into a reproducible-yet-varying seed per print.
    static func seed(from string: String) -> UInt64 {
        var hash: UInt64 = 0xcbf29ce484222325
        for byte in string.utf8 {
            hash = (hash ^ UInt64(byte)) &* 0x100000001b3
        }
        return hash
    }

    /// Option letter (a, b, c, …) for a zero-based index.
    static func optionLetter(_ index: Int) -> String {
        guard index >= 0, index < 26 else { return "?" }
        return String(UnicodeScalar(UInt8(97 + index)))
    }

    /// The correct-answer letter for an MCQ, or nil when the answer text
    /// isn't among the options (defensive — never happens in shipped packs).
    static func answerLetter(for question: Question) -> String? {
        guard let options = question.options,
              let idx = options.firstIndex(of: question.answer) else { return nil }
        return optionLetter(idx)
    }

    /// Answer-key lines for the selected questions, 1-indexed:
    /// `["1. b", "2. d", …]`.
    static func answerKey(for questions: [Question]) -> [String] {
        questions.enumerated().map { i, q in
            "\(i + 1). \(answerLetter(for: q) ?? "?")"
        }
    }
}

// MARK: - Storage

/// Feature-local `UserDefaults` keys for the worksheet sheet (kept out of the
/// shared `AppStorageKeys`, per the `DailyPlanStorage` precedent).
enum WorksheetStorage {
    static let defaultCountKey = "worksheetDefaultCount"
    static let includeAnswerKeyKey = "worksheetIncludeAnswerKey"

    static func defaultCount(_ defaults: UserDefaults = .standard) -> Int {
        let stored = defaults.integer(forKey: defaultCountKey)
        return WorksheetSampler.countChoices.contains(stored) ? stored : WorksheetSampler.defaultCount
    }
    static func setDefaultCount(_ n: Int, _ defaults: UserDefaults = .standard) {
        defaults.set(n, forKey: defaultCountKey)
    }
    static func includeAnswerKey(_ defaults: UserDefaults = .standard) -> Bool {
        if defaults.object(forKey: includeAnswerKeyKey) == nil { return true }
        return defaults.bool(forKey: includeAnswerKeyKey)
    }
    static func setIncludeAnswerKey(_ on: Bool, _ defaults: UserDefaults = .standard) {
        defaults.set(on, forKey: includeAnswerKeyKey)
    }
}

// MARK: - Print document

/// Everything the printed page needs — resolved off the chapter so the
/// renderer never reaches back into the registry.
struct WorksheetDocument {
    let chapterTitle: String
    let subjectTitle: String
    let dateText: String
    let questions: [Question]
    let includeAnswerKey: Bool
}

// MARK: - Renderer

@MainActor
enum WorksheetPrintRenderer {

    /// Build the print info: US Letter, 0.75" margins, automatic pagination
    /// so a long question list (and the optional answer-key section) flows to
    /// additional pages.
    static func makePrintInfo() -> NSPrintInfo {
        let info = NSPrintInfo()
        info.topMargin = 54
        info.bottomMargin = 54
        info.leftMargin = 54
        info.rightMargin = 54
        info.horizontalPagination = .fit
        info.verticalPagination = .automatic
        info.isHorizontallyCentered = false
        info.isVerticallyCentered = false
        return info
    }

    /// Lay the worksheet out in an `NSHostingView` sized to the printable
    /// width and run the print operation modally. Returns the operation's
    /// success flag (false if the user cancels the panel).
    @discardableResult
    static func printWorksheet(_ document: WorksheetDocument) -> Bool {
        let info = makePrintInfo()
        let printableWidth = info.paperSize.width - info.leftMargin - info.rightMargin
        let page = WorksheetPrintableView(document: document)
            .frame(width: printableWidth, alignment: .topLeading)
        let host = NSHostingView(rootView: page)
        let height = max(host.fittingSize.height, info.paperSize.height - info.topMargin - info.bottomMargin)
        host.frame = NSRect(x: 0, y: 0, width: printableWidth, height: height)

        let op = NSPrintOperation(view: host, printInfo: info)
        op.showsPrintPanel = true
        op.showsProgressPanel = true
        op.jobTitle = "\(document.subjectTitle) — \(document.chapterTitle) Worksheet"
        // Synchronous modal run — block-based; NOT the deprecated
        // runModal(for:delegate:didRun:contextInfo:) selector form.
        return op.run()
    }
}

// MARK: - Printable page (SwiftUI, hosted in NSHostingView)

/// The on-paper layout. Authored in SwiftUI and hosted for printing. Uses
/// black/secondary system text (prints crisply) and generous spacing so the
/// kid has room to circle answers.
private struct WorksheetPrintableView: View {
    let document: WorksheetDocument

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            header
            ForEach(document.questions.indices, id: \.self) { idx in
                questionBlock(number: idx + 1, question: document.questions[idx])
            }
            if document.includeAnswerKey {
                answerKeySection
            }
        }
        .padding(20)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("\(document.subjectTitle) · \(document.chapterTitle)")
                .font(.system(size: 20, weight: .bold))
            HStack {
                Text("Name: ____________________________")
                Spacer()
                Text(document.dateText)
            }
            .font(.system(size: 13))
            .foregroundColor(.secondary)
            Divider()
        }
    }

    private func questionBlock(number: Int, question: Question) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(number). \(question.prompt)")
                .font(.system(size: 14, weight: .semibold))
                .fixedSize(horizontal: false, vertical: true)
            let options = question.options ?? []
            ForEach(options.indices, id: \.self) { oi in
                Text("(\(WorksheetSampler.optionLetter(oi)))  \(options[oi])")
                    .font(.system(size: 13))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.bottom, 6)
    }

    private var answerKeySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Push the key toward its own page so it doesn't sit under the
            // last question (a true forced break is printer-dependent).
            Spacer(minLength: 80)
            Divider()
            Text("Answer Key")
                .font(.system(size: 16, weight: .bold))
            Text(WorksheetSampler.answerKey(for: document.questions).joined(separator: "   "))
                .font(.system(size: 13))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
