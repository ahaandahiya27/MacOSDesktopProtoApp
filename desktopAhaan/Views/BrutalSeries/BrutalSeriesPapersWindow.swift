import SwiftUI
import AppKit

// MARK: - Model
//
// Brutal Series papers are the third practice-paper surface (alongside
// Boss Challenge and the Olympiad/TestPapers stream). Each paper is a
// dependency-free PDF question paper (~250 KB) + a worked-solutions HTML
// (~30 KB). 64 papers as of 2026-06-23; numbered `B01`..`B64`.
//
// On disk: `desktopAhaan/Resources/BrutalSeries/`
//   • `Paper_B<NN>_<chapter-slugs>_Questions.pdf`
//   • `Paper_B<NN>_<chapter-slugs>_Solutions.html`
//   • `MANIFEST.md`    — human-readable index of paper-# → chapter list
//   • `BRUTAL_INDEX.json` — fingerprint store for the content-generation
//                            loop's dedup pass (not read by the app)
//
// This surface mirrors `BossChallengePapersWindow.swift` exactly: a flat
// list of cards, each with two buttons that hand off to the system
// viewer (`NSWorkspace.shared.open(url)`) — Preview for the PDF, Safari
// for the HTML. Big-Sur-safe by virtue of touching no SwiftUI 12+ API,
// no `.toolbar { }` (the recent crash class), no in-app PDF renderer.

struct BrutalSeriesPaper: Identifiable, Hashable {
    /// `"B01"`..`"B64"`. String, not Int, because it's the stable identity
    /// SwiftUI's ForEach diffs on; the leading `B` also disambiguates from
    /// Boss Challenge's plain numeric ids in any cross-catalog logging.
    let number: String
    /// Raw chapter label string from the manifest, e.g.
    /// `"Heat, Comparing Quantities, Electric Current & its Effects, Simple Equations"`.
    /// Kept as one string (not split into [String]) because chapter names
    /// themselves contain commas — `"Acids, Bases & Salts"`, `"Winds, Storms & Cyclones"`,
    /// `"Weather, Climate & Adaptations"` — and a naive `,` split would
    /// fragment them. Display joins this with no extra processing.
    let chaptersLabel: String
    /// Bundled file name of the questions PDF.
    let questionsPdfFilename: String
    /// Bundled file name of the worked-solutions HTML. Derived by suffix
    /// swap from `questionsPdfFilename` at parse time, so the catalog
    /// only fails if the HTML is genuinely missing (not on a naming drift).
    let solutionsHtmlFilename: String

    var id: String { number }

    var displayTitle: String { "Paper \(number)" }
}

// MARK: - Catalog
//
// Bundle-driven: enumerate `Paper_B*_Questions.pdf`, pair each with its
// matching `_Solutions.html`, and overlay the chapter label from
// `MANIFEST.md` when present. New papers added by the content-generation
// loop become visible on the next launch with no Swift edit.

@MainActor
enum BrutalSeriesPapersCatalog {

    /// Subdirectory hint for the bundle lookup. The pbxproj generator
    /// emits individual `PBXFileReference`s, so Xcode actually copies the
    /// 130 files flat into `<App.app>/Contents/Resources/` rather than
    /// preserving the subdirectory. Lookups try the subdir first and fall
    /// back to flat — the same pattern as `BossChallengePapersCatalog`
    /// and the existing article renderer.
    static let bundleSubdirectory = "BrutalSeries"

    /// All papers found in the bundle, ordered by paper number ascending
    /// (B01 → B64). Empty when no papers are bundled (e.g. a build that
    /// skipped Copy Bundle Resources for this stream).
    static func loadAll(bundle: Bundle = .main) -> [BrutalSeriesPaper] {
        let chapterIndex = parseManifest(bundle: bundle)
        var papers: [BrutalSeriesPaper] = []
        for url in pdfURLs(bundle: bundle) {
            let name = url.lastPathComponent
            // Expected: Paper_B<NN>_<slugs>_Questions.pdf
            guard name.hasPrefix("Paper_B"), name.hasSuffix("_Questions.pdf") else {
                continue
            }
            // Pull "BNN" out: "Paper_".count == 6, then 3 chars "BNN".
            let after = name.dropFirst(6)
            let number = String(after.prefix(3))
            guard number.count == 3, number.first == "B",
                  Int(String(number.dropFirst())) != nil else {
                continue
            }
            let solutionsName = name
                .replacingOccurrences(of: "_Questions.pdf",
                                      with: "_Solutions.html")
            // Skip papers missing their Solutions HTML — the lint would
            // catch this in the content stream, but the catalog being
            // defensive means the kid never opens a card whose second
            // button is dead.
            guard resourceURL(stem: (solutionsName as NSString).deletingPathExtension,
                              ext: "html", bundle: bundle) != nil else {
                continue
            }
            let chapters = chapterIndex[number] ?? "Mixed practice"
            papers.append(BrutalSeriesPaper(
                number: number,
                chaptersLabel: chapters,
                questionsPdfFilename: name,
                solutionsHtmlFilename: solutionsName
            ))
        }
        // Sort by paper number ascending. The `B` prefix is constant so a
        // lexicographic sort matches numeric for our 2-digit suffixes.
        papers.sort { $0.number < $1.number }
        return papers
    }

    /// Resolve a bundled file's on-disk URL by filename. Used by the card
    /// view's "Open" buttons. Returns `nil` when the file isn't bundled.
    static func bundleURL(forFilename name: String,
                          bundle: Bundle = .main) -> URL? {
        let stem = (name as NSString).deletingPathExtension
        let ext = (name as NSString).pathExtension
        return resourceURL(stem: stem, ext: ext, bundle: bundle)
    }

    // MARK: - Bundle resolution (subdir → flat fallback)

    private static func resourceURL(stem: String, ext: String,
                                    bundle: Bundle) -> URL? {
        bundle.url(forResource: stem, withExtension: ext,
                   subdirectory: bundleSubdirectory)
            ?? bundle.url(forResource: stem, withExtension: ext)
    }

    private static func pdfURLs(bundle: Bundle) -> [URL] {
        if let scoped = bundle.urls(forResourcesWithExtension: "pdf",
                                    subdirectory: bundleSubdirectory),
           !scoped.isEmpty {
            return scoped
        }
        return bundle.urls(forResourcesWithExtension: "pdf",
                           subdirectory: nil) ?? []
    }

    // MARK: - Manifest parsing

    /// Parse `MANIFEST.md` for the paper-# → chapter-label map. Returns
    /// `[:]` on a missing/malformed manifest — callers fall back to the
    /// `"Mixed practice"` placeholder string.
    ///
    /// Manifest line shape:
    ///   `- Paper B01: <chapter list with commas> | spread {...} | <filename>`
    ///
    /// The chapter list itself contains commas (`"Acids, Bases & Salts"`),
    /// so we split on ` | ` first (a delimiter that doesn't appear in
    /// chapter names) and then on `": "` to peel the `B<NN>` prefix off.
    private static func parseManifest(bundle: Bundle) -> [String: String] {
        guard let url = resourceURL(stem: "MANIFEST", ext: "md",
                                    bundle: bundle),
              let text = try? String(contentsOf: url, encoding: .utf8) else {
            return [:]
        }
        var out: [String: String] = [:]
        for raw in text.components(separatedBy: "\n") {
            let line = raw.trimmingCharacters(in: .whitespaces)
            guard line.hasPrefix("- Paper B") else { continue }
            // Strip the leading "- " bullet so we can search for ": ".
            let body = String(line.dropFirst(2))
            // Split on " | " — the spread/filename delimiter that the
            // chapter list itself never contains.
            let segments = body.components(separatedBy: " | ")
            guard let header = segments.first else { continue }
            // Header: "Paper B01: Heat, Comparing Quantities, ..."
            guard let colonRange = header.range(of: ": ") else { continue }
            let prefix = header[..<colonRange.lowerBound]
            let chapters = String(header[colonRange.upperBound...])
                .trimmingCharacters(in: .whitespaces)
            // Prefix shape: "Paper B<NN>" — pull the BNN out.
            guard let bRange = prefix.range(of: "B") else { continue }
            let number = String(prefix[bRange.lowerBound...])
                .trimmingCharacters(in: .whitespaces)
            guard number.count == 3, number.first == "B",
                  Int(String(number.dropFirst())) != nil else { continue }
            out[number] = chapters
        }
        return out
    }
}

// MARK: - View

@MainActor
struct BrutalSeriesPapersView: View {
    @State private var papers: [BrutalSeriesPaper] = []
    @State private var didLoad = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
                header
                if papers.isEmpty {
                    emptyState
                } else {
                    ForEach(papers) { paper in
                        BrutalSeriesPaperCard(paper: paper)
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
            Text("Brutal Series Papers")
                .font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("64 mixed-chapter brutal practice papers — opens the "
                 + "PDF in Preview, the worked solutions HTML in Safari.")
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var emptyState: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Text("No Brutal Series papers bundled.")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("This build doesn't include the Brutal Series resources. "
                 + "Try Product → Clean Build Folder and rebuild.")
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
        papers = BrutalSeriesPapersCatalog.loadAll()
    }
}

// MARK: - Card

/// Per-paper row. `fileprivate` so it stays an implementation detail of
/// this surface — there's no other call site.
fileprivate struct BrutalSeriesPaperCard: View {
    let paper: BrutalSeriesPaper

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text(paper.displayTitle)
                .font(.title3.weight(.bold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text(paper.chaptersLabel)
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
            HStack(spacing: DesignTokens.Spacing.sm) {
                openButton(title: "Open Questions",
                           filename: paper.questionsPdfFilename,
                           identifier: "brutal-paper-questions-\(paper.number)")
                openButton(title: "Open Solutions",
                           filename: paper.solutionsHtmlFilename,
                           identifier: "brutal-paper-solutions-\(paper.number)")
            }
        }
        .padding(DesignTokens.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                .fill(Color.gray.opacity(0.08))
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(paper.displayTitle). Chapters: \(paper.chaptersLabel)")
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
        guard let url = BrutalSeriesPapersCatalog.bundleURL(forFilename: filename)
        else { return }
        NSWorkspace.shared.open(url)
    }
}

// MARK: - Window presenter
//
// Opens `BrutalSeriesPapersView` in its own AppKit window from
// Help → "Brutal Series Papers" / ⌘⌥R. Same singleton + window-delegate
// pattern as `BossChallengePapersWindowPresenter` and
// `MockTestWindowPresenter`. Re-triggering the command focuses the
// existing window rather than stacking duplicates; close drops the
// reference so the next open rebuilds the controller and re-reads the
// catalog (picks up any papers added by a content-generation loop).

@MainActor
final class BrutalSeriesPapersWindowPresenter: NSObject, NSWindowDelegate {
    static let shared = BrutalSeriesPapersWindowPresenter()
    private var window: NSWindow?

    func present() {
        if let existing = window {
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        let root = BrutalSeriesPapersView()
            .frame(minWidth: 560, minHeight: 600)
        let hosting = NSHostingController(rootView: root)
        let win = NSWindow(contentViewController: hosting)
        win.title = "Brutal Series Papers"
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
