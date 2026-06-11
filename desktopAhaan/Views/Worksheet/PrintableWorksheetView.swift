import SwiftUI
import AppKit

/// The "print a paper worksheet" sheet. The kid (or parent) picks a subject +
/// chapter, how many MCQs (5/10/15/20), and whether to print an answer key,
/// then taps Print — `WorksheetPrintRenderer` lays the questions out and runs
/// `NSPrintOperation`. Opened from Help → "Printable Worksheet…" / ⌘⇧P via
/// `PrintableWorksheetWindowPresenter` (its own AppKit window, mirroring
/// Daily Plan / Weekly Progress — ContentView's sheet dispatcher is owned by
/// another surface).
///
/// `@MainActor` — reads `SubjectRegistry` on the main thread and drives an
/// AppKit print operation.
@MainActor
struct PrintableWorksheetView: View {
    @EnvironmentObject private var subjectRegistry: SubjectRegistry

    /// Closes the hosting window after a print is dispatched.
    var onClose: (() -> Void)?

    @State private var selectedPackId: String = ""
    @State private var selectedChapterId: String = ""
    @State private var count: Int = WorksheetStorage.defaultCount()
    @State private var includeAnswerKey: Bool = WorksheetStorage.includeAnswerKey()
    @State private var lastResultMessage: String?

    private var packs: [SubjectPack] { subjectRegistry.packs }

    private var selectedPack: SubjectPack? {
        subjectRegistry.pack(withId: selectedPackId) ?? packs.first
    }

    private var chapters: [Chapter] { selectedPack?.chapters ?? [] }

    private var selectedChapter: Chapter? {
        chapters.first(where: { $0.id == selectedChapterId }) ?? chapters.first
    }

    /// Eligible MCQ count in the current chapter — gates the Print button and
    /// drives the "only N available" note.
    private var availableCount: Int {
        selectedChapter.map { WorksheetSampler.eligibleMCQs(in: $0).count } ?? 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Printable Worksheet")
                .font(.largeTitle.weight(.bold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)

            Group {
                subjectPicker
                chapterPicker
                countControl
                answerKeyToggle
            }

            availabilityNote
            Spacer(minLength: DesignTokens.Spacing.xs)
            footer
        }
        .padding(DesignTokens.Spacing.xl)
        .frame(minWidth: 460, minHeight: 420)
        .onAppear { primeSelection() }
    }

    // MARK: - Controls

    private var subjectPicker: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text("Subject").font(.headline)
            Picker("Subject", selection: $selectedPackId) {
                ForEach(packs) { pack in
                    Text("\(pack.coverEmoji)  \(pack.title)").tag(pack.id)
                }
            }
            .labelsHidden()
            .onChange(of: selectedPackId) { _ in
                // Reset the chapter to the new subject's first chapter.
                selectedChapterId = selectedPack?.chapters.first?.id ?? ""
            }
        }
    }

    private var chapterPicker: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text("Chapter").font(.headline)
            Picker("Chapter", selection: $selectedChapterId) {
                ForEach(chapters) { chapter in
                    Text("\(chapter.number). \(chapter.title)").tag(chapter.id)
                }
            }
            .labelsHidden()
        }
    }

    private var countControl: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text("Number of questions: \(count)").font(.headline)
            Picker("Number of questions", selection: $count) {
                ForEach(WorksheetSampler.countChoices, id: \.self) { n in
                    Text("\(n)").tag(n)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
        }
    }

    private var answerKeyToggle: some View {
        Toggle(isOn: $includeAnswerKey) {
            Text("Include answer key on the last page").font(.headline)
        }
        .toggleStyle(.switch)
    }

    @ViewBuilder
    private var availabilityNote: some View {
        if availableCount == 0 {
            Text("This chapter has no multiple-choice questions to print yet.")
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.warning)
        } else if availableCount < count {
            Text("Only \(availableCount) multiple-choice questions are available — the worksheet will print \(availableCount).")
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
    }

    @ViewBuilder
    private var footer: some View {
        if let message = lastResultMessage {
            Text(message)
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        HStack {
            Spacer()
            Button("Close") { onClose?() }
            Button("Print…") { printWorksheet() }
                .keyboardShortcut(.defaultAction)
                .disabled(availableCount == 0)
        }
    }

    // MARK: - Actions

    private func primeSelection() {
        if selectedPackId.isEmpty { selectedPackId = packs.first?.id ?? "" }
        if selectedChapterId.isEmpty {
            selectedChapterId = selectedPack?.chapters.first?.id ?? ""
        }
    }

    private func printWorksheet() {
        guard let pack = selectedPack, let chapter = selectedChapter else { return }
        // Persist the chosen defaults for next time.
        WorksheetStorage.setDefaultCount(count)
        WorksheetStorage.setIncludeAnswerKey(includeAnswerKey)

        let eligible = WorksheetSampler.eligibleMCQs(in: chapter)
        let seed = WorksheetSampler.seed(from: Date().description)
        let picked = WorksheetSampler.sample(eligible, count: count, seed: seed)
        guard !picked.isEmpty else {
            lastResultMessage = "No questions available to print."
            return
        }
        let doc = WorksheetDocument(
            chapterTitle: "Ch. \(chapter.number): \(chapter.title)",
            subjectTitle: pack.title,
            dateText: Self.dateFormatter.string(from: Date()),
            questions: picked,
            includeAnswerKey: includeAnswerKey)
        let ok = WorksheetPrintRenderer.printWorksheet(doc)
        lastResultMessage = ok
            ? "Printed \(picked.count) question\(picked.count == 1 ? "" : "s")."
            : "Print cancelled."
    }

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none
        return f
    }()
}

// MARK: - Window presenter

/// Opens `PrintableWorksheetView` in its own AppKit window from ⌘⇧P / Help →
/// "Printable Worksheet…". Singleton so re-triggering focuses the existing
/// window. Mirrors `DailyPlanWindowPresenter`.
@MainActor
final class PrintableWorksheetWindowPresenter: NSObject, NSWindowDelegate {
    static let shared = PrintableWorksheetWindowPresenter()
    private var window: NSWindow?

    func present(registry: SubjectRegistry) {
        if let existing = window {
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        let root = PrintableWorksheetView(onClose: { [weak self] in self?.close() })
            .environmentObject(registry)
            .frame(minWidth: 460, minHeight: 420)
        let hosting = NSHostingController(rootView: root)
        let win = NSWindow(contentViewController: hosting)
        win.title = "Printable Worksheet"
        win.setContentSize(NSSize(width: 520, height: 520))
        win.styleMask = [.titled, .closable, .resizable, .miniaturizable]
        win.isReleasedWhenClosed = false
        win.center()
        win.delegate = self
        window = win
        win.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func close() {
        window?.orderOut(nil)
        window = nil
    }

    nonisolated func windowWillClose(_ notification: Notification) {
        Task { @MainActor in self.window = nil }
    }
}
