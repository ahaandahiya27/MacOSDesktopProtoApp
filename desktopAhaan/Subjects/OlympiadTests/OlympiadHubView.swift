import SwiftUI
import AppKit

// MARK: - OlympiadHubView
//
// Landing view for the "Olympiad Tests" sidebar entry. One card per
// bundled paper with three actions:
//
//   • Take Quiz   — interactive MCQ flow with score (Approach B)
//   • Open Paper  — print-style HTML viewer (includes both questions
//                   AND solutions — the make_html.py tool ships them
//                   as a single document, matching the parent's
//                   intended print workflow)
//   • Save PDF    — drops the print-ready .pdf onto a destination
//                   the parent picks (NSSavePanel; defaults to
//                   ~/Downloads). The PDF version is what the parent
//                   physically prints; the HTML viewer is for on-
//                   screen reading without leaving the app.
//
// 2026-06-06 UX iteration: the earlier "View Solutions" CTA was
// dropped because the Open Paper HTML viewer already includes the
// solutions section. Three CTAs is the clean shape — one to QUIZ,
// one to READ, one to SAVE-FOR-PRINTING.
//
// Big Sur safety: pure SwiftUI + AppKit NSSavePanel. No WebKit, no
// macOS 12+ APIs. Animations gated via withAnimationRespectingReduceMotion.

@MainActor
struct OlympiadHubView: View {
    /// The print-ready HTML sheet (the Read Paper CTA target). nil →
    /// no sheet up.
    @State private var presentedPaperSheet: OlympiadPaper?
    /// The hand-authored / generator-built Solved Guide HTML sheet
    /// (topic-clustered cards with correct answer highlighted +
    /// worked solution per question). Only papers whose
    /// `solvedGuideHTML` is non-nil have this CTA — Science Ch13 +
    /// Maths Ch15 today.
    @State private var presentedGuideSheet: OlympiadPaper?
    /// Banner shown briefly after a successful Save PDF — gives the
    /// parent a confirmation that the file landed where they asked.
    @State private var savedToURL: URL?
    /// Auto-dismiss timer for the saved banner.
    @State private var bannerDismissTask: Task<Void, Never>?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                if let url = savedToURL {
                    savedBanner(url: url)
                }
                ForEach(OlympiadPaperRegistry.papersBySubject(), id: \.subject) { group in
                    subjectSection(name: group.subject, papers: group.papers)
                }
            }
            .padding(24)
            .frame(maxWidth: 880, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .background(Color(NSColor.windowBackgroundColor))
        .navigationTitle("Olympiad Tests")
        .onDisappear { bannerDismissTask?.cancel() }
        .sheet(item: $presentedPaperSheet) { paper in
            ArticleBrowserView(
                initialFile: paper.questionPaperHTML,
                chapterFolder: "TestPapers",
                articleTitle: "Question Paper + Solutions — \(paper.chapterTitle)"
            )
            .frame(minWidth: 760, minHeight: 560)
        }
        .sheet(item: $presentedGuideSheet) { paper in
            // The Solved Guide is a bundled SwiftUI-rendered HTML —
            // topic-clustered question cards with correct answers
            // highlighted + worked solution per question. Reuses
            // ArticleBrowserView so the rendering path is the proven
            // NSTextView one (no WKWebView risk on Big Sur AMD GPU).
            ArticleBrowserView(
                initialFile: paper.solvedGuideHTML ?? "",
                chapterFolder: "TestPapers",
                articleTitle: "Solved Guide — \(paper.chapterTitle)"
            )
            .frame(minWidth: 760, minHeight: 600)
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Text("🏆").font(.system(size: 40)).accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Olympiad Tests")
                        .font(.largeTitle.bold())
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    Text("Class 7 syllabus · Olympiad difficulty")
                        .font(.subheadline)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }
            }
            // Big Sur (macOS 11) does NOT parse markdown inside
            // `Text("…")` — the `**bold**` syntax was added to SwiftUI
            // in macOS 12. On Big Sur the literal asterisks render
            // verbatim. Use plain prose; the action button row below
            // is the visual hierarchy.
            Text("Each paper is a 60-MCQ rehearsal at competitive standard. Take Quiz to attempt it interactively (instant scoring with worked solutions per question). Open Paper to read the full print-style document (questions plus answer key plus worked solutions). Save PDF to drop a print-ready file onto disk.")
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 4)
            HStack(spacing: 14) {
                schemeChip(icon: "plus", text: "+4 correct", tint: .green)
                schemeChip(icon: "minus", text: "−1 wrong", tint: .red)
                schemeChip(icon: "circle", text: "0 skipped", tint: .gray)
                schemeChip(icon: "star.circle", text: "Max 240", tint: DesignTokens.BrandColor.primaryAction)
            }
            .padding(.top, 4)
        }
        .accessibilityElement(children: .combine)
    }

    private func schemeChip(icon: String, text: String, tint: Color) -> some View {
        HStack(spacing: 5) {
            Image(systemName: SFSymbolCompat.name(icon))
                .font(.caption2.weight(.semibold))
            Text(text)
                .font(.caption.monospacedDigit())
        }
        .foregroundColor(tint)
        .padding(.horizontal, 8).padding(.vertical, 3)
        .background(
            Capsule().fill(tint.opacity(0.12))
        )
    }

    // MARK: - Saved banner

    private func savedBanner(url: URL) -> some View {
        HStack(spacing: 10) {
            Image(systemName: SFSymbolCompat.name("checkmark.circle.fill"))
                .font(.title3)
                .foregroundColor(.green)
            VStack(alignment: .leading, spacing: 2) {
                Text("Saved PDF")
                    .font(.callout.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Text(url.path)
                    .font(.caption.monospacedDigit())
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            Spacer()
            Button("Reveal in Finder") {
                NSWorkspace.shared.activateFileViewerSelecting([url])
            }
            .controlSize(.small)
            Button("Dismiss") {
                savedToURL = nil
                bannerDismissTask?.cancel()
            }
            .controlSize(.small)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.green.opacity(0.10))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color.green.opacity(0.30), lineWidth: 1)
        )
    }

    // MARK: - Subject section

    private func subjectSection(name: String, papers: [OlympiadPaper]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Text(name)
                    .font(.title2.weight(.bold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Text("\(papers.count) paper\(papers.count == 1 ? "" : "s")")
                    .font(.caption.monospacedDigit())
                    .foregroundColor(.secondary)
            }
            ForEach(papers) { paper in
                paperCard(paper)
            }
        }
    }

    // MARK: - Paper card

    private func paperCard(_ paper: OlympiadPaper) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text("Ch \(paper.chapterNumber)")
                    .font(.caption.weight(.semibold).monospacedDigit())
                    .foregroundColor(.white)
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(Capsule().fill(DesignTokens.BrandColor.primaryAction))
                Text(paper.chapterTitle)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Spacer()
            }
            HStack(spacing: 14) {
                statChip(icon: "questionmark.circle", text: "\(paper.questionCount) MCQ")
                statChip(icon: "clock", text: "\(paper.suggestedTimeMinutes) min")
                statChip(icon: "star.circle", text: "\(paper.maxMarks) max")
            }
            HStack(spacing: 12) {
                NavigationLink(destination: OlympiadQuizView(paper: paper)) {
                    actionLabel(icon: "play.circle.fill",
                                text: "Take Quiz",
                                tint: DesignTokens.BrandColor.primaryAction,
                                filled: true)
                }
                .buttonStyle(.plain)
                .help("Take this Olympiad paper as a 60-question interactive quiz.")
                .accessibilityLabel("Take quiz — \(paper.chapterTitle)")

                Button {
                    presentedPaperSheet = paper
                } label: {
                    actionLabel(icon: "doc.text.fill",
                                text: "Open Paper",
                                tint: Color.compatTeal,
                                filled: false)
                }
                .buttonStyle(.plain)
                .help("Open the print-style HTML — questions, answer key and worked solutions.")
                .accessibilityLabel("Open paper — \(paper.chapterTitle)")

                // Conditional Solved Guide CTA — only appears when the
                // paper carries a `solvedGuideHTML` (Science Ch13 + Maths
                // Ch15 today). The Solved Guide is a topic-clustered
                // worked-solutions document with the correct answer
                // highlighted on every question — designed for revision
                // rather than first-attempt rehearsal.
                if paper.solvedGuideHTML != nil {
                    Button {
                        presentedGuideSheet = paper
                    } label: {
                        actionLabel(icon: "book.fill",
                                    text: "Solved Guide",
                                    tint: DesignTokens.BrandColor.primaryAction,
                                    filled: false)
                    }
                    .buttonStyle(.plain)
                    .help("Open the topic-clustered solved guide with worked solutions for all 60 questions.")
                    .accessibilityLabel("Solved guide — \(paper.chapterTitle)")
                }

                Button {
                    savePDF(for: paper)
                } label: {
                    actionLabel(icon: "arrow.down.doc.fill",
                                text: "Save PDF",
                                tint: DesignTokens.BrandColor.mnemonicAccent,
                                filled: false)
                }
                .buttonStyle(.plain)
                .help("Save the print-ready PDF to a folder you choose.")
                .accessibilityLabel("Save PDF — \(paper.chapterTitle)")

                Spacer(minLength: 0)
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusCard)
                .fill(Color.white.opacity(0.65))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusCard)
                .strokeBorder(DesignTokens.BrandColor.primaryAction.opacity(0.18), lineWidth: 1)
        )
    }

    private func statChip(icon: String, text: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: SFSymbolCompat.name(icon))
                .font(.caption.weight(.medium))
                .foregroundColor(.secondary)
            Text(text)
                .font(.caption.monospacedDigit())
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8).padding(.vertical, 3)
        .background(
            Capsule().fill(Color.gray.opacity(0.10))
        )
    }

    /// Single-line action button label. `fixedSize` ensures the text
    /// never wraps mid-button (the earlier UI iteration broke "Take
    /// Quiz" onto two lines because the buttons were too narrow).
    /// The `filled` variant uses tint as the background; the unfilled
    /// variant uses a tint border + white fill so the visual hierarchy
    /// reads "Take Quiz is primary, Open / Save are secondary".
    private func actionLabel(icon: String, text: String, tint: Color, filled: Bool) -> some View {
        HStack(spacing: 6) {
            Image(systemName: SFSymbolCompat.name(icon))
                .font(.subheadline.weight(.semibold))
            Text(text)
                .font(.subheadline.weight(.semibold))
        }
        .foregroundColor(filled ? .white : tint)
        .fixedSize()
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .frame(minHeight: 36)
        .background(
            Group {
                if filled {
                    Capsule().fill(tint)
                } else {
                    Capsule().fill(Color.white)
                }
            }
        )
        .overlay(
            Group {
                if !filled {
                    Capsule().strokeBorder(tint.opacity(0.55), lineWidth: 1.5)
                }
            }
        )
    }

    // MARK: - Save PDF

    /// Open an `NSSavePanel` so the parent can pick where to drop the
    /// print-ready PDF. Defaults to `~/Downloads` with the paper's
    /// pretty filename. On success, surfaces the destination URL in
    /// the "Saved PDF" banner (auto-dismisses in ~6 seconds) + the
    /// "Reveal in Finder" CTA.
    private func savePDF(for paper: OlympiadPaper) {
        let bare = (paper.questionPaperPDF as NSString).deletingPathExtension
        let ext = (paper.questionPaperPDF as NSString).pathExtension
        guard let bundledURL = Bundle.main.url(
            forResource: bare,
            withExtension: ext,
            subdirectory: "TestPapers"
        ) ?? Bundle.main.url(forResource: bare, withExtension: ext) else {
            CrashReporter.shared.logDataIssue(
                "OlympiadHub: PDF resource '\(paper.questionPaperPDF)' is not bundled"
            )
            return
        }
        let panel = NSSavePanel()
        panel.title = "Save Olympiad Paper"
        panel.nameFieldStringValue = paper.questionPaperPDF
        panel.directoryURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first
        panel.canCreateDirectories = true
        panel.isExtensionHidden = false
        // NOTE: NOT setting `panel.allowedContentTypes` here. That
        // property is `[UTType]` (macOS 11+) which requires `import
        // UniformTypeIdentifiers` to typecheck even when assigning an
        // empty array literal on Swift 5.5. The default value (no
        // restriction) is what we want anyway.

        panel.begin { response in
            guard response == .OK, let dest = panel.url else { return }
            do {
                // If the user picked an existing file's location, the
                // panel already prompted for overwrite confirmation;
                // remove the stale copy before our copyItem call so we
                // don't throw NSFileWriteFileExistsError.
                if FileManager.default.fileExists(atPath: dest.path) {
                    try FileManager.default.removeItem(at: dest)
                }
                try FileManager.default.copyItem(at: bundledURL, to: dest)
                // panel.begin's completion is already on the main
                // thread, but the outer `savePDF(for:)` is `@MainActor`-
                // isolated, so we hop explicitly. Use DispatchQueue
                // instead of `Task { @MainActor in ... }` because Swift
                // 5.5's actor-isolation rules around nested Tasks inside
                // an unisolated completion handler are stricter than
                // Swift 6's; the dispatch hop is portable.
                let destination = dest
                DispatchQueue.main.async {
                    savedToURL = destination
                    bannerDismissTask?.cancel()
                    bannerDismissTask = Task { @MainActor [destination] in
                        try? await Task.sleep(nanoseconds: 6_000_000_000)
                        if Task.isCancelled { return }
                        if savedToURL == destination {
                            savedToURL = nil
                        }
                    }
                }
            } catch {
                CrashReporter.shared.logDataIssue(
                    "OlympiadHub: copy PDF '\(paper.questionPaperPDF)' to '\(dest.path)' failed: \(error.localizedDescription)"
                )
            }
        }
    }
}
