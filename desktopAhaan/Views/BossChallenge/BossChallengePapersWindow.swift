import SwiftUI
import AppKit

// MARK: - Model
//
// Boss Challenge Papers are mixed-chapter, 100-MCQ practice papers that ship
// pre-rendered as PDFs (questions) + self-contained HTML (worked solutions)
// + plain-text Markdown (the same questions, copy-pasteable). They live
// under `desktopAhaan/Resources/BossChallengePapers/` and are bundled by
// the existing pbxproj generator (which walks the target source tree).
//
// This surface is intentionally light: it does NOT re-render the papers
// in-app or wire them into the SRS. It just lists what's bundled and hands
// off to the system viewer (Preview for the PDF, Safari for the HTML) via
// `NSWorkspace.shared.open(url)`. Big-Sur-safe because we don't reach for
// any modern SwiftUI list / toolbar / accessibility API, and we don't
// touch the article renderer.

struct BossChallengePaper: Identifiable, Hashable {
    /// Two-digit string ("00", "01", … "07"). Drives the display title and
    /// the bundle-filename lookup. String, not Int, because it's also the
    /// stable identity used by SwiftUI's ForEach.
    let number: String
    /// Human-readable chapter labels, one per chapter, in the order they
    /// appear in the paper. e.g., `["Heat", "Nutrition in Plants", "Integers"]`.
    let chapters: [String]
    /// Bundled file name of the question paper (PDF for the numbered papers;
    /// `Boss_Paper_00_MCQ_Questions.pdf` for the 3-chapter boss paper).
    let questionPaperFilename: String
    /// Bundled file name of the detailed solutions HTML. Always present —
    /// the catalog drops any paper that doesn't have one.
    let solutionsFilename: String
    /// Bundled file name of the Markdown copy of the questions. Optional —
    /// the boss paper has it, the numbered papers all do too, but the UI
    /// degrades gracefully if it's missing.
    let questionsMdFilename: String?

    var id: String { number }

    var displayTitle: String {
        number == "00" ? "Boss Paper (Mixed)" : "Paper \(number)"
    }
}

// MARK: - Catalog
//
// Discovery is bundle-driven, not hard-coded: the catalog enumerates
// `BossChallengePapers/` inside the app bundle, groups files by paper
// number, and (when available) overlays the chapter labels from the
// human-curated PAPERS_MANIFEST.md table. New papers added by the
// content-generation loop become visible on the next launch — no Swift
// edit required.

@MainActor
enum BossChallengePapersCatalog {

    /// Subdirectory hint for `Bundle.main.url(forResource:withExtension:subdirectory:)`.
    /// Matches the disk layout under `desktopAhaan/Resources/`. We *try* this
    /// subdirectory first, then fall back to a flat lookup — the pbxproj
    /// generator emits individual `PBXFileReference`s rather than a folder
    /// reference, so Xcode actually copies the 26 paper files flat into the
    /// app's `Contents/Resources/`. Matches the pattern used by the article
    /// renderer (e.g. `ChapterDetailView+ExtraReadingRow.swift`).
    static let bundleSubdirectory = "BossChallengePapers"

    /// Resolve a single bundled file by stem + extension, trying the
    /// subdirectory first and falling back to flat lookup. Returns `nil`
    /// when the file isn't bundled at all.
    private static func resourceURL(stem: String, ext: String,
                                    bundle: Bundle) -> URL? {
        bundle.url(forResource: stem, withExtension: ext,
                   subdirectory: bundleSubdirectory)
            ?? bundle.url(forResource: stem, withExtension: ext)
    }

    /// Enumerate every bundled file with `ext`, trying the subdirectory
    /// first and falling back to flat enumeration. Callers filter by name
    /// prefix/suffix to pick out the Paper_* / Boss_Paper_00_* files they
    /// want — the bundle also contains article HTML and other PDFs.
    private static func resourceURLs(ext: String, bundle: Bundle) -> [URL] {
        if let scoped = bundle.urls(forResourcesWithExtension: ext,
                                    subdirectory: bundleSubdirectory),
           !scoped.isEmpty {
            return scoped
        }
        return bundle.urls(forResourcesWithExtension: ext,
                           subdirectory: nil) ?? []
    }

    /// All papers found in the bundle, ordered by paper number. Boss Paper
    /// 00 (the 3-chapter mixed boss paper) always sorts first when present.
    static func loadAll(bundle: Bundle = .main) -> [BossChallengePaper] {
        let chapterIndex = parseManifest(bundle: bundle)

        var papers: [BossChallengePaper] = []

        if let boss = loadBossPaper(bundle: bundle) {
            papers.append(boss)
        }

        // Numbered papers — derive set of numbers from any of the three
        // bundled file kinds. Solutions HTML is required; the PDF and MD
        // are optional but virtually always present.
        let numbers = discoverNumberedPaperIds(bundle: bundle)
        for number in numbers.sorted() {
            guard let solutions = filename(forNumber: number, suffix: "Solutions",
                                           ext: "html", bundle: bundle) else {
                continue
            }
            guard let qp = filename(forNumber: number, suffix: "QuestionPaper",
                                    ext: "pdf", bundle: bundle) else {
                continue
            }
            let qmd = filename(forNumber: number, suffix: "Questions",
                               ext: "md", bundle: bundle)
            let chapters = chapterIndex[number] ?? chaptersFromFilename(solutions)
            papers.append(BossChallengePaper(
                number: number,
                chapters: chapters,
                questionPaperFilename: qp,
                solutionsFilename: solutions,
                questionsMdFilename: qmd
            ))
        }
        return papers
    }

    /// Resolve a bundled paper file to its on-disk URL. `nil` if the file
    /// isn't in the bundle (e.g. on a build where the resource wasn't yet
    /// added to Copy Bundle Resources).
    static func bundleURL(forFilename name: String,
                          bundle: Bundle = .main) -> URL? {
        let stem = (name as NSString).deletingPathExtension
        let ext = (name as NSString).pathExtension
        return resourceURL(stem: stem, ext: ext, bundle: bundle)
    }

    // MARK: - Manifest parsing

    /// Parse `PAPERS_MANIFEST.md` (a small Markdown table) into a map from
    /// paper number ("01", "02"…) to an ordered list of chapter labels.
    /// Returns `[:]` when the file is missing or malformed — callers fall
    /// back to filename-derived chapters in that case.
    private static func parseManifest(bundle: Bundle) -> [String: [String]] {
        guard let url = resourceURL(stem: "PAPERS_MANIFEST", ext: "md",
                                    bundle: bundle),
              let text = try? String(contentsOf: url, encoding: .utf8) else {
            return [:]
        }
        var out: [String: [String]] = [:]
        for rawLine in text.components(separatedBy: "\n") {
            let line = rawLine.trimmingCharacters(in: .whitespaces)
            guard line.hasPrefix("|") else { continue }
            let cells = line
                .split(separator: "|", omittingEmptySubsequences: false)
                .map { $0.trimmingCharacters(in: .whitespaces) }
            // Expected data row: ["", "01", "2026-06-17", "Heat / … / Integers", …, ""]
            guard cells.count >= 4 else { continue }
            let number = cells[1]
            // Skip header rows (where cells[1] == "#") and the separator
            // (where cells[1] is "---" or similar). Numbered rows are
            // exactly two digits.
            guard number.count == 2, Int(number) != nil else { continue }
            let chaptersCell = cells[3]
            out[number] = splitChaptersCell(chaptersCell)
        }
        return out
    }

    /// Split the manifest's Chapters cell on either '·' (the middot used in
    /// the later papers) or '/' (the slash used in the earlier ones). One
    /// of the two is always the separator; we try both.
    private static func splitChaptersCell(_ cell: String) -> [String] {
        let parts: [String]
        if cell.contains("·") {
            parts = cell.components(separatedBy: "·")
        } else {
            parts = cell.components(separatedBy: "/")
        }
        return parts
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    // MARK: - Bundle discovery

    /// Enumerate Solutions.html files for the numbered papers (excluding the
    /// boss paper) and return the set of paper numbers found. Solutions is
    /// the required file: if it's missing, the paper can't be shown
    /// usefully even if a PDF exists.
    private static func discoverNumberedPaperIds(bundle: Bundle) -> Set<String> {
        let urls = resourceURLs(ext: "html", bundle: bundle)
        var ids: Set<String> = []
        for url in urls {
            let name = url.lastPathComponent
            // Expected form: Paper_NN_<chapters>_Solutions.html
            guard name.hasPrefix("Paper_") else { continue }
            guard name.hasSuffix("_Solutions.html") else { continue }
            // "Paper_".count == 6
            let afterPrefix = name.dropFirst(6)
            let number = String(afterPrefix.prefix(2))
            guard number.count == 2, Int(number) != nil else { continue }
            ids.insert(number)
        }
        return ids
    }

    /// Look up a numbered paper's filename by suffix (`"QuestionPaper"`,
    /// `"Solutions"`, `"Questions"`) and extension. Returns `nil` when no
    /// matching file is bundled.
    private static func filename(forNumber number: String,
                                 suffix: String,
                                 ext: String,
                                 bundle: Bundle) -> String? {
        let urls = resourceURLs(ext: ext, bundle: bundle)
        let prefix = "Paper_\(number)_"
        let needle = "_\(suffix).\(ext)"
        for url in urls {
            let n = url.lastPathComponent
            if n.hasPrefix(prefix) && n.hasSuffix(needle) {
                return n
            }
        }
        return nil
    }

    /// Boss Paper 00 follows a slightly different naming convention
    /// (`Boss_Paper_00_MCQ_Questions.pdf` instead of `..._QuestionPaper.pdf`)
    /// so it gets a dedicated lookup.
    private static func loadBossPaper(bundle: Bundle) -> BossChallengePaper? {
        guard resourceURL(stem: "Boss_Paper_00_Solutions", ext: "html",
                          bundle: bundle) != nil else {
            return nil
        }
        guard resourceURL(stem: "Boss_Paper_00_MCQ_Questions", ext: "pdf",
                          bundle: bundle) != nil else {
            return nil
        }
        let mdName: String? = resourceURL(
            stem: "Boss_Paper_00_Questions", ext: "md",
            bundle: bundle) != nil
            ? "Boss_Paper_00_Questions.md" : nil
        return BossChallengePaper(
            number: "00",
            chapters: ["Mixed across all chapters"],
            questionPaperFilename: "Boss_Paper_00_MCQ_Questions.pdf",
            solutionsFilename: "Boss_Paper_00_Solutions.html",
            questionsMdFilename: mdName
        )
    }

    /// Last-resort chapter labelling: derive from the file name when the
    /// manifest is missing/malformed. The filename schema bakes the
    /// chapters in as `Heat_NutritionPlants_Integers`; we just space the
    /// CamelCased tokens out so the result is readable.
    private static func chaptersFromFilename(_ name: String) -> [String] {
        // Strip "Paper_NN_" prefix and "_Solutions.html" / "_QuestionPaper.pdf"
        // / "_Questions.md" suffix.
        var stem = (name as NSString).deletingPathExtension
        if stem.hasPrefix("Paper_") {
            stem = String(stem.dropFirst(6))
        }
        if let underscore = stem.firstIndex(of: "_") {
            stem = String(stem[stem.index(after: underscore)...])
        }
        for suffix in ["_Solutions", "_QuestionPaper", "_Questions"] {
            if stem.hasSuffix(suffix) {
                stem = String(stem.dropLast(suffix.count))
            }
        }
        // Wrap the function reference in a closure so Swift 5.5 / Big Sur
        // doesn't try to convert a `@MainActor (String) -> String` to a
        // non-isolated `(String) throws -> String` map argument — that
        // conversion is rejected by the deploy compiler ("loses global
        // actor 'MainActor'"). The closure form keeps the call inside
        // the enclosing @MainActor context.
        return stem.components(separatedBy: "_").map { spaceCamelCase($0) }
    }

    /// Insert spaces before runs of upper-case letters so
    /// `NutritionPlants` reads as `Nutrition Plants`. ASCII-only — that's
    /// what the filenames are.
    private static func spaceCamelCase(_ s: String) -> String {
        var out = ""
        for (i, ch) in s.enumerated() {
            if i > 0, ch.isUppercase {
                out.append(" ")
            }
            out.append(ch)
        }
        return out
    }
}

// MARK: - View

@MainActor
struct BossChallengePapersView: View {
    @State private var papers: [BossChallengePaper] = []
    @State private var didLoad = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
                header
                if papers.isEmpty {
                    emptyState
                } else {
                    ForEach(papers) { paper in
                        BossChallengePaperCard(paper: paper)
                    }
                }
            }
            .padding(DesignTokens.Spacing.xl)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minWidth: 560, minHeight: 600)
        .onAppear { loadIfNeeded() }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text("Boss Challenge Papers")
                .font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Mixed-chapter exam papers — 100 single-correct MCQs each. "
                 + "Marking: +4 correct, −1 wrong, 0 blank. Tap a paper to "
                 + "open it in Preview; tap Open Solutions for the worked answer key.")
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var emptyState: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Text("No Boss Challenge Papers bundled.")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("This build doesn't include the paper resources. Try "
                 + "Product → Clean Build Folder and rebuild.")
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DesignTokens.Spacing.lg)
    }

    private func loadIfNeeded() {
        guard !didLoad else { return }
        didLoad = true
        papers = BossChallengePapersCatalog.loadAll()
    }
}

// MARK: - Card

/// Per-paper row. `fileprivate` so the view stays an implementation detail
/// of this surface — there's no other call-site.
///
/// `@MainActor` annotation is REQUIRED for Big-Sur Swift 5.5 compilation:
/// SwiftUI Views are NOT automatically `@MainActor` on Swift 5.5 (that's a
/// 5.7+ change). Without this, the `openFile` method's call to
/// `BossChallengePapersCatalog.bundleURL(...)` (which IS `@MainActor`-isolated)
/// fails to compile on the deploy iMac with "Calls to static method
/// 'bundleURL(...)' from outside of its actor context are implicitly
/// asynchronous" — the exact iMac compile error that surfaced 2026-06-24
/// in the post-push verification.
@MainActor
fileprivate struct BossChallengePaperCard: View {
    let paper: BossChallengePaper

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text(paper.displayTitle)
                .font(.title3.weight(.bold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text(paper.chapters.joined(separator: " · "))
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
            HStack(spacing: DesignTokens.Spacing.sm) {
                openButton(title: "Open Question Paper",
                           filename: paper.questionPaperFilename,
                           identifier: "boss-paper-question-\(paper.number)")
                openButton(title: "Open Solutions",
                           filename: paper.solutionsFilename,
                           identifier: "boss-paper-solutions-\(paper.number)")
            }
        }
        .padding(DesignTokens.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                .fill(Color.gray.opacity(0.08))
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(paper.displayTitle). Chapters: \(paper.chapters.joined(separator: ", "))")
    }

    private func openButton(title: String,
                            filename: String,
                            identifier: String) -> some View {
        Button(action: { openFile(filename) }) {
            Text(title)
                .font(.callout.weight(.semibold))
                .foregroundColor(.white)
                .padding(.horizontal, DesignTokens.Spacing.md)
                .padding(.vertical, DesignTokens.Spacing.sm)
                .frame(minHeight: 32)
                .background(
                    Capsule().fill(DesignTokens.BrandColor.primaryAction)
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityIdentifier(identifier)
    }

    private func openFile(_ filename: String) {
        guard let url = BossChallengePapersCatalog.bundleURL(forFilename: filename)
        else { return }
        NSWorkspace.shared.open(url)
    }
}

// MARK: - Window presenter
//
// Opens `BossChallengePapersView` in its own AppKit window from Help →
// "Boss Challenge Papers" / ⌘⌥B. Same standalone-window pattern as
// `WeeklyProgressWindowPresenter` / `MockTestWindowPresenter`: macOS 13+
// multi-window scene APIs aren't available on Big Sur, so an
// `NSHostingController`-backed window keeps the feature self-contained.
//
// Singleton — re-triggering the command focuses the existing window. On
// close the reference is dropped so the next open rebuilds the controller
// and re-runs the catalog load (picking up any papers added since).

@MainActor
final class BossChallengePapersWindowPresenter: NSObject, NSWindowDelegate {
    static let shared = BossChallengePapersWindowPresenter()
    private var window: NSWindow?

    func present() {
        if let existing = window {
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        let root = BossChallengePapersView()
            .frame(minWidth: 560, minHeight: 600)
        let hosting = NSHostingController(rootView: root)
        let win = NSWindow(contentViewController: hosting)
        win.title = "Boss Challenge Papers"
        win.setContentSize(NSSize(width: 720, height: 720))
        win.styleMask = [.titled, .closable, .resizable, .miniaturizable]
        win.isReleasedWhenClosed = false
        win.center()
        win.delegate = self
        window = win
        win.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    nonisolated func windowWillClose(_ notification: Notification) {
        Task { @MainActor in self.window = nil }
    }
}
