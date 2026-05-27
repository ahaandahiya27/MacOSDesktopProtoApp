import SwiftUI

// MARK: - Notebook card
//
// The "My Notebook" CTA on the chapter detail page. Renders the
// hero card; the actual writing UI lives in `ChapterNotebookSheet`
// further down. Lifted out of `ChapterDetailView.swift` to keep the
// main view under the Big Sur Swift 5.5 type-checker risk threshold
// (~600 LOC). Visible at file-scope (no `private`) so the parent
// view in the sister file can construct it.

struct NotebookCard: View {
    let hasNotes: Bool
    /// When the chapter's note was last edited — drives the recency badge.
    var lastEdited: Date? = nil
    let onTap: () -> Void
    @State private var isHovered = false

    /// "Last edited N days ago" when a note exists with a known timestamp,
    /// else the existing prompt copy. RelativeDateTimeFormatter is macOS
    /// 10.15+ (Big Sur safe).
    private var subtitleText: String {
        if hasNotes, let edited = lastEdited {
            let fmt = RelativeDateTimeFormatter()
            fmt.unitsStyle = .full
            return "Last edited " + fmt.localizedString(for: edited, relativeTo: Date())
        }
        return hasNotes
            ? "Pick up where you left off"
            : "Jot down questions, sketches in words, or aha moments"
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Text("📓")
                    .font(.system(size: 26))
                VStack(alignment: .leading, spacing: 2) {
                    Text("My Notebook")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(subtitleText)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.92))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                Image(systemName: "square.and.pencil")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.95))
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.25, green: 0.50, blue: 0.40),
                                Color(red: 0.40, green: 0.60, blue: 0.30)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(isHovered ? 1.005 : 1.0)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        // Reduce Motion gate — see ChapterDetailView's enrichment cards.
        // The 1.005 scale is small but still a motion cue; clamp it off
        // for accessibility users.
        .onHover { hovering in
            isHovered = hovering && !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
        }
        .accessibilityLabel("My Notebook")
        .accessibilityHint("Opens the chapter notebook for your own notes.")
    }
}

// MARK: - Notebook sheet
//
// A free-form per-chapter writing space. Big Sur compatible: uses
// TextEditor (macOS 11+), not the macOS 12+ .scrollDismissesKeyboard
// or .formStyle modifiers. Persists through DataStore.setChapterNote so
// the save infrastructure is shared with all other user data.

struct ChapterNotebookSheet: View {
    let chapterId: String
    let chapterTitle: String

    @EnvironmentObject private var dataStore: DataStore
    @Environment(\.presentationMode) private var presentationMode
    @State private var draft: String = ""
    @State private var didLoad: Bool = false

    private var wordCount: Int {
        draft.split(whereSeparator: \.isWhitespace).count
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("My Notebook")
                        .font(.title2.bold())
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    Text(chapterTitle)
                        .font(.subheadline)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }
                Spacer()
                Button("Done") {
                    // 2026-05-22 fix: dismiss FIRST, then save in next
                    // runloop tick. Doing both synchronously inside the
                    // button action cascaded two `objectWillChange.send`
                    // notifications (the @Published `chapterNotes` write
                    // and the `presentationMode` binding flip) into the
                    // same render commit, occasionally tripping the
                    // "Entangling fence" warning on the parent
                    // ChapterDetailView's next interaction (e.g. Try
                    // Discover Mode click) → EXC_BAD_ACCESS in objc_release.
                    // The .onChange(of: draft) save below already wrote
                    // the value on every keystroke, so the captured copy
                    // is just defence-in-depth.
                    let captured = draft
                    let cid = chapterId
                    let ds = dataStore
                    presentationMode.wrappedValue.dismiss()
                    DispatchQueue.main.async {
                        ds.setChapterNote(captured, forChapterId: cid)
                    }
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding(20)
            .background(Color.white.opacity(0.5))

            Divider()

            VStack(alignment: .leading, spacing: 10) {
                Text("Anything you noticed, wondered, or want to remember about this chapter goes here. The notebook saves automatically.")
                    .font(.caption)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .padding(.horizontal, 4)

                TextEditor(text: $draft)
                    .font(.body)
                    .frame(minHeight: 320)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(Color.gray.opacity(0.20), lineWidth: 1)
                    )

                HStack {
                    Text("\(wordCount) word\(wordCount == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    Spacer()
                    if !draft.isEmpty {
                        Button {
                            draft = ""
                            dataStore.setChapterNote("", forChapterId: chapterId)
                        } label: {
                            Label("Clear", systemImage: "trash")
                                .font(.caption)
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    }
                }
            }
            .padding(20)
        }
        .frame(minWidth: 640, minHeight: 540)
        .onAppear {
            guard !didLoad else { return }
            draft = dataStore.chapterNotes[chapterId] ?? ""
            didLoad = true
        }
        .onChange(of: draft) { newValue in
            // Persist on every keystroke. saveCoalesced inside
            // setChapterNote debounces actual disk writes to 250ms.
            dataStore.setChapterNote(newValue, forChapterId: chapterId)
        }
    }
}
