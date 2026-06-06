import SwiftUI

// MARK: - OlympiadHubView
//
// Landing view for the "Olympiad Tests" sidebar entry. Lists every
// bundled paper grouped by subject, each row offering three actions:
//   • Take Quiz       — interactive MCQ flow with score (Approach B)
//   • Read Paper      — print-style HTML of the question paper (Approach A)
//   • View Solutions  — print-style HTML of the solutions (Approach A)
//
// Big Sur safety: pure SwiftUI, NavigationView with NavigationLink for
// the quiz drill-in, .sheet() for the two HTML viewers — all baseline
// macOS 11. ArticleBrowserView reuse means zero new HTML-rendering
// code (and zero WKWebView risk on the AMD R9 M290X — that path uses
// NSTextView).

@MainActor
struct OlympiadHubView: View {
    /// Which paper the user is currently reading the question / solutions
    /// HTML for. nil → no sheet up. Both sheets pivot off the same
    /// optional via two different cases, mirrored in `sheetKind`.
    @State private var presentedSheet: SheetKind?

    enum SheetKind: Identifiable, Hashable {
        case questionPaper(OlympiadPaper)
        case solutions(OlympiadPaper)

        var id: String {
            switch self {
            case .questionPaper(let p): return "Q:\(p.id)"
            case .solutions(let p):     return "S:\(p.id)"
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                ForEach(OlympiadPaperRegistry.papersBySubject(), id: \.subject) { group in
                    subjectSection(name: group.subject, papers: group.papers)
                }
            }
            .padding(24)
            .frame(maxWidth: 820, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .background(Color(NSColor.windowBackgroundColor))
        .navigationTitle("Olympiad Tests")
        .sheet(item: $presentedSheet) { kind in
            switch kind {
            case .questionPaper(let paper):
                ArticleBrowserView(
                    initialFile: paper.questionPaperHTML,
                    chapterFolder: "TestPapers",
                    articleTitle: "Question Paper — \(paper.chapterTitle)"
                )
                .frame(minWidth: 720, minHeight: 540)
            case .solutions(let paper):
                // The .html bundled with the paper is the question
                // paper, not the solutions. The solutions are MD-only
                // today; render them via the plain-text fallback so
                // the kid can still read the answer key + worked
                // solutions in-app while the printed HTML is reserved
                // for the question paper.
                OlympiadSolutionsSheet(paper: paper)
                    .frame(minWidth: 720, minHeight: 540)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 10) {
                Text("🏆").font(.system(size: 36)).accessibilityHidden(true)
                Text("Olympiad Tests")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            Text("Class-7 syllabus, Olympiad difficulty. Each paper is a 60-MCQ rehearsal with the marking scheme +4 / −1 / 0 (max 240). Take it as a timed quiz or open the print-ready paper.")
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
    }

    private func subjectSection(name: String, papers: [OlympiadPaper]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(name)
                .font(.title2.weight(.bold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            ForEach(papers) { paper in
                paperCard(paper)
            }
        }
    }

    private func paperCard(_ paper: OlympiadPaper) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("Ch \(paper.chapterNumber)")
                    .font(.caption.weight(.semibold).monospacedDigit())
                    .foregroundColor(.white)
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(Capsule().fill(DesignTokens.BrandColor.primaryAction))
                Text(paper.chapterTitle)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            HStack(spacing: 16) {
                statChip(icon: "questionmark.circle", text: "\(paper.questionCount) MCQ")
                statChip(icon: "clock", text: "\(paper.suggestedTimeMinutes) min")
                statChip(icon: "star.circle", text: "Max \(paper.maxMarks)")
                statChip(icon: "plus.forwardslash.minus", text: "+\(paper.marksCorrect) / \(paper.marksWrong)")
            }
            HStack(spacing: 10) {
                NavigationLink(destination: OlympiadQuizView(paper: paper)) {
                    actionButtonLabel(icon: "play.circle.fill", text: "Take Quiz", tint: DesignTokens.BrandColor.primaryAction)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Take quiz — \(paper.chapterTitle)")
                .help("Take this Olympiad paper as a 60-question interactive quiz.")

                Button {
                    presentedSheet = .questionPaper(paper)
                } label: {
                    actionButtonLabel(icon: "doc.text.fill", text: "Read Paper", tint: Color.compatTeal)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Read paper — \(paper.chapterTitle)")
                .help("Open the print-ready question paper as HTML.")

                Button {
                    presentedSheet = .solutions(paper)
                } label: {
                    actionButtonLabel(icon: "key.fill", text: "View Solutions", tint: Color.compatBrown)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("View solutions — \(paper.chapterTitle)")
                .help("Open the answer key + worked solutions.")
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusCard)
                .fill(Color.white.opacity(0.55))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusCard)
                .strokeBorder(DesignTokens.BrandColor.primaryAction.opacity(0.18), lineWidth: 1)
        )
    }

    private func statChip(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: SFSymbolCompat.name(icon))
                .font(.caption)
                .foregroundColor(.secondary)
            Text(text)
                .font(.caption.monospacedDigit())
                .foregroundColor(.secondary)
        }
    }

    private func actionButtonLabel(icon: String, text: String, tint: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: SFSymbolCompat.name(icon))
            Text(text)
                .font(.callout.weight(.semibold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .frame(minHeight: 36)
        .background(Capsule().fill(tint))
    }
}

// MARK: - OlympiadSolutionsSheet
//
// MD-only solutions don't have a print-ready HTML companion today, so
// we render them with a lightweight in-app viewer (plain text + scroll).
// Mirrors the `PlainTextArticleFallback` shape so the kid sees a
// consistent look whether they're reading bundled HTML or MD-only
// solutions.
struct OlympiadSolutionsSheet: View {
    let paper: OlympiadPaper
    @Environment(\.presentationMode) private var presentationMode
    @State private var bodyText: String = ""
    @State private var loadError: String? = nil

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: SFSymbolCompat.name("xmark.circle.fill"))
                        .font(.title3)
                }
                .keyboardShortcut("w", modifiers: .command)
                .accessibilityLabel("Close solutions")
                .help("Close solutions")
                Spacer()
                Text("Solutions — \(paper.chapterTitle)")
                    .font(.body.weight(.semibold))
                Spacer()
            }
            .padding(.horizontal, 12).padding(.vertical, 10)
            .background(Color(NSColor.controlBackgroundColor))

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    if let err = loadError {
                        Text(err)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    if bodyText.isEmpty && loadError == nil {
                        Text("Loading…")
                            .foregroundColor(.secondary)
                    } else {
                        Text(bodyText)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(20)
            }
            .background(Color(NSColor.windowBackgroundColor))
        }
        .onAppear { loadSolutions() }
    }

    private func loadSolutions() {
        let bare = (paper.solutionsMD as NSString).deletingPathExtension
        let ext = (paper.solutionsMD as NSString).pathExtension
        guard let url = Bundle.main.url(
            forResource: bare,
            withExtension: ext,
            subdirectory: "TestPapers"
        ) ?? Bundle.main.url(forResource: bare, withExtension: ext) else {
            loadError = "Solutions file not bundled."
            return
        }
        Task.detached(priority: .userInitiated) {
            do {
                let raw = try String(contentsOf: url, encoding: .utf8)
                await MainActor.run {
                    bodyText = raw
                }
            } catch {
                let message = error.localizedDescription
                await MainActor.run {
                    loadError = message
                }
            }
        }
    }
}
