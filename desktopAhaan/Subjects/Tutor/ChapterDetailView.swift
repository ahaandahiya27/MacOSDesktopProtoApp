import SwiftUI
import AppKit

struct ChapterDetailView: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var nav: TutorNavigationState
    @EnvironmentObject private var dataStore: DataStore
    @State private var presentedSheet: SheetKind?

    /// Single source of truth for which enrichment sheet is on screen.
    /// SwiftUI on macOS Big Sur (11) silently drops all-but-the-last
    /// `.sheet(isPresented:)` modifier on a given view, so we route
    /// every sheet through one `.sheet(item:)`. Identifiable conformance
    /// is required so the .sheet(item:) modifier can key the
    /// re-presentation.
    private enum SheetKind: String, Identifiable {
        case homeExperiments
        case notebook
        var id: String { rawValue }
    }

    /// Returns the chapter's "Beyond the Book" article entry ONLY when
    /// the HTML file is actually findable in Bundle.main. Catches the
    /// failure mode where someone (me!) adds a new HTML to disk but
    /// forgets to add it to the Xcode project — without this gate, the
    /// card opens an empty "Article not found" sheet on click.
    private var beyondTheBookEntry: ArticleEntry? {
        guard let entry = ArticleIndex.entries["\(chapter.id)_beyond"] else {
            return nil
        }
        let name = entry.filename.replacingOccurrences(of: ".html", with: "")
        let resolved = Bundle.main.url(forResource: name, withExtension: "html",
                                        subdirectory: entry.chapterFolder)
            ?? Bundle.main.url(forResource: name, withExtension: "html")
        return resolved != nil ? entry : nil
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(chapter.summary)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)

                if DiscoverMode.hasExperience(for: pack, chapter: chapter) {
                    Button {
                        // CRITICAL (2026-05-22 07:35 fix): defer the
                        // navigation push to the next runloop tick.
                        // Rohan reported the crash pattern: open Try at
                        // Home / Beyond the Book / My Notebook, dismiss,
                        // THEN click Try Discover Mode → EXC_BAD_ACCESS
                        // in objc_release. Cause: the sheet's dismiss
                        // and the nav.push trigger overlapping re-renders
                        // of ChapterDetailView in the same runloop tick.
                        // SwiftUI's "Entangling fence requested after
                        // pre-commit" warning fires when one render
                        // commit hasn't finished before the next one
                        // starts. DispatchQueue.main.async pushes the
                        // navigation to the next tick so the sheet-
                        // dismiss commit completes first. Same effect
                        // when navigating directly (no prior sheet) —
                        // the one-tick delay is imperceptible.
                        let packId = pack.id
                        let chapterId = chapter.id
                        DispatchQueue.main.async {
                            nav.push(.discover(packId: packId, chapterId: chapterId))
                        }
                    } label: {
                        DiscoverEntryBanner(
                            sceneCount: DataStore.discoverSceneCounts[chapter.number] ?? 9
                        )
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }

                // Enrichment surfaces: "Beyond the Book" article (long-form
                // reading), "Try at Home" sheet (hands-on experiments), and
                // "Notebook" sheet (free-form per-chapter writing).
                // Beyond/Home are content-gated; Notebook is always shown.
                VStack(spacing: 12) {
                    if beyondTheBookEntry != nil || HomeExperimentLibrary.hasExperiments(for: chapter.id) {
                        HStack(spacing: 12) {
                            if let entry = beyondTheBookEntry {
                                BeyondTheBookCard(entry: entry)
                            }
                            if HomeExperimentLibrary.hasExperiments(for: chapter.id) {
                                // Defer the sheet-present to the next runloop tick.
                                // Same C2 cascade fix as the Try Discover Mode nav.push
                                // — setting presentedSheet inside the Button action
                                // can collide with the Button-press render commit on
                                // ChapterDetailView, sometimes tripping "Entangling
                                // fence requested after pre-commit" → EXC_BAD_ACCESS.
                                TryAtHomeCard {
                                    DispatchQueue.main.async { presentedSheet = .homeExperiments }
                                }
                            }
                        }
                    }
                    NotebookCard(
                        hasNotes: !(dataStore.chapterNotes[chapter.id]?.isEmpty ?? true)
                    ) {
                        DispatchQueue.main.async { presentedSheet = .notebook }
                    }
                }

                ForEach(chapter.topics) { topic in
                    Button {
                        nav.push(.topic(packId: pack.id, topicId: topic.id))
                    } label: {
                        TopicCard(topic: topic)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .pointingCursor()
                    .contextMenu {
                        Button("Open") { nav.push(.topic(packId: pack.id, topicId: topic.id)) }
                        Button("Copy title") {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(topic.title, forType: .string)
                        }
                    }
                }
            }
            .padding(20)
            // Center the bounded-width column inside the full-width
            // detail pane. Same pattern as ConceptDetailView / QuestionDetailView.
            .frame(maxWidth: DesignTokens.contentMaxWidthWide, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .background(Color(NSColor.windowBackgroundColor))
        .navigationTitle("Ch. \(chapter.number) — \(chapter.title)")
        .sheet(item: $presentedSheet) { kind in
            switch kind {
            case .homeExperiments:
                HomeExperimentsSheet(
                    chapterId: chapter.id,
                    chapterTitle: "Ch. \(chapter.number) — \(chapter.title)"
                )
            case .notebook:
                ChapterNotebookSheet(
                    chapterId: chapter.id,
                    chapterTitle: "Ch. \(chapter.number) — \(chapter.title)"
                )
                .environmentObject(dataStore)
            }
        }
    }

}

// MARK: - Notebook card

private struct NotebookCard: View {
    let hasNotes: Bool
    let onTap: () -> Void
    @State private var isHovered = false

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Text("📓")
                    .font(.system(size: 26))
                VStack(alignment: .leading, spacing: 2) {
                    Text("My Notebook")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(hasNotes ? "Pick up where you left off" : "Jot down questions, sketches in words, or aha moments")
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
        .onHover { isHovered = $0 }
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

// MARK: - Beyond the Book card

private struct BeyondTheBookCard: View {
    let entry: ArticleEntry
    @State private var isHovered = false

    var body: some View {
        Button {
            // Defer NSWindow creation to the next runloop tick. Same
            // C2 cascade fix — synchronously creating an NSWindow +
            // NSHostingView + @StateObject WebViewCoordinator inside
            // the Button action collides with the Button-press render
            // commit on ChapterDetailView. The deferral lets the
            // current commit fully resolve before AppKit starts a new
            // window's full lifecycle (which itself triggers AppKit
            // notifications and SwiftUI re-renders on the main window).
            let f = entry.filename
            let cf = entry.chapterFolder
            DispatchQueue.main.async {
                ArticleWindowManager.shared.openArticle(filename: f, chapterFolder: cf)
            }
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text("📖")
                        .font(.system(size: 26))
                    Text("Beyond the Book")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                Text(entry.title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.92))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Text("≈ \(entry.estimatedMinutes) min read")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.45, green: 0.30, blue: 0.65),
                                Color(red: 0.25, green: 0.40, blue: 0.70)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(isHovered ? 1.01 : 1.0)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .accessibilityLabel("Beyond the Book")
        .accessibilityHint("Opens a long-form enrichment article for this chapter.")
    }
}

// MARK: - Try at Home card

private struct TryAtHomeCard: View {
    let onTap: () -> Void
    @State private var isHovered = false

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text("🧪")
                        .font(.system(size: 26))
                    Text("Try at Home")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                Text("Hands-on experiments you can do this weekend.")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.92))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Text("5 experiments")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.85, green: 0.45, blue: 0.25),
                                Color(red: 0.65, green: 0.30, blue: 0.50)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(isHovered ? 1.01 : 1.0)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .accessibilityLabel("Try at Home")
        .accessibilityHint("Opens hands-on home experiments for this chapter.")
    }
}

// MARK: - Home Experiments sheet
//
// A dedicated UI surface for hands-on experiments tied to a chapter.
// Separate from Discover (interactive in-app) and Articles (long-form
// reading) — these are real-world activities the kid can run with kitchen
// or garden supplies. Big Sur compatible: no .foregroundStyle, no
// .symbolEffect, no Color.brown.

struct HomeExperiment: Identifiable {
    let id: String
    let emoji: String
    let title: String
    let needs: [String]
    let steps: [String]
    let whyItWorks: String
    let estimatedMinutes: Int
}

enum HomeExperimentLibrary {
    static let experiments: [String: [HomeExperiment]] = [
        "ch01": [
            HomeExperiment(
                id: "ch01_exp_starch_map",
                emoji: "🌿",
                title: "Iodine starch map of a leaf",
                needs: [
                    "One healthy potted plant (mint, money plant or hibiscus all work)",
                    "A small piece of black paper or cardboard",
                    "Iodine solution from the chemist (or povidone-iodine in a pinch)",
                    "Boiling water and warm alcohol (ask a grown-up)",
                    "A white plate"
                ],
                steps: [
                    "Cover a corner of one leaf (on the plant) with black paper. Tape it down so no light gets in.",
                    "Leave the plant in bright sunlight for a full day.",
                    "Pluck the leaf. Boil it for 1 minute in water to kill it.",
                    "Move it to warm alcohol — the leaf turns pale as chlorophyll washes out.",
                    "Rinse it. Drop iodine onto the leaf for 30 seconds, then rinse again.",
                    "Look closely. The covered part stays pale; the rest turns blue-black."
                ],
                whyItWorks: "Iodine turns blue-black wherever starch is hiding. Sunlit parts of the leaf made starch by photosynthesis; the covered corner could not. You just photographed photosynthesis.",
                estimatedMinutes: 60
            ),
            HomeExperiment(
                id: "ch01_exp_celery_xylem",
                emoji: "💧",
                title: "Coloured-water celery — xylem in action",
                needs: [
                    "One stalk of fresh celery with leaves",
                    "A glass of water",
                    "A small bottle of red or blue food colour",
                    "A sharp knife (use it with an adult)"
                ],
                steps: [
                    "Trim 2 cm off the bottom of the celery stalk so the cut is fresh.",
                    "Pour water into the glass and add 10 drops of food colour. Stir.",
                    "Stand the celery in the coloured water with the cut end down.",
                    "Wait 3–4 hours. Check the leaves and the stalk.",
                    "Slice the stalk crossways. Count the coloured dots."
                ],
                whyItWorks: "The dots are the xylem — tiny straws that pull water up from roots to leaves using a force called capillary action plus the suction from leaves losing water. You can literally see the plant's plumbing.",
                estimatedMinutes: 240
            ),
            HomeExperiment(
                id: "ch01_exp_mimosa_clock",
                emoji: "🤚",
                title: "Mimosa pudica reaction time",
                needs: [
                    "A touch-me-not (Mimosa pudica) plant in a pot or in a garden",
                    "A stopwatch or phone timer",
                    "A pencil to gently poke"
                ],
                steps: [
                    "Sit with the plant in a quiet spot in mid-morning.",
                    "Start the timer and gently touch one leaflet with the pencil tip.",
                    "Stop the timer the moment the whole leaf has folded.",
                    "Wait 5 minutes for it to reopen, then repeat with a different leaf.",
                    "Try at 9 a.m., noon, and 4 p.m. and compare times."
                ],
                whyItWorks: "Mimosa cells at the base of each leaflet lose water in a flash when poked. The leaf collapses, hiding it from imaginary herbivores. J. C. Bose's crescograph in Calcutta a hundred years ago first recorded responses like this and proved plants can react in seconds, not days.",
                estimatedMinutes: 30
            ),
            HomeExperiment(
                id: "ch01_exp_pondscope",
                emoji: "🔬",
                title: "Spirogyra oxygen bubbles",
                needs: [
                    "A pinch of bright-green pond scum (Spirogyra) from any clean pond or fish tank",
                    "A small glass jar with water",
                    "Sunlight from a window",
                    "A magnifying glass (optional)"
                ],
                steps: [
                    "Place the green algae in the jar of water.",
                    "Stand the jar in bright direct sunlight.",
                    "Watch closely for 15 minutes — tiny silver bubbles will start to rise from the algae.",
                    "After an hour, gently push the green strands aside. The bubbles will keep coming."
                ],
                whyItWorks: "Each bubble is pure oxygen made by photosynthesis. The same gas you are breathing right now was made — over hundreds of millions of years — by green cells just like these. You are watching the air being born.",
                estimatedMinutes: 60
            ),
            HomeExperiment(
                id: "ch01_exp_root_nodules",
                emoji: "🌱",
                title: "Chickpea root nodules in a jar",
                needs: [
                    "A handful of dry kala chana or whole black gram (uncooked)",
                    "A jar with garden soil",
                    "Water",
                    "Patience for 2–3 weeks"
                ],
                steps: [
                    "Soak the chana in water overnight.",
                    "Push 4 soaked seeds into the soil about 2 cm deep, water lightly.",
                    "Keep the jar near a window. Water every 2 days.",
                    "After 2–3 weeks, gently lift out one seedling with all its roots.",
                    "Rinse the roots in a bowl. Look for tiny round bumps."
                ],
                whyItWorks: "Those bumps are root nodules. Inside each one lives a colony of Rhizobium bacteria pulling nitrogen straight out of the air and trading it to the plant for sugar. Farmers have used this trade for thousands of years — that's why crops are rotated with legumes.",
                estimatedMinutes: 60
            )
        ],
        "ch02": [
            HomeExperiment(
                id: "ch02_exp_saliva_starch",
                emoji: "🍞",
                title: "Saliva digesting starch — taste it happen",
                needs: [
                    "A small bite of plain bread (no jam, no butter)",
                    "A glass of water to rinse afterwards",
                    "A working tongue and a quiet 5 minutes"
                ],
                steps: [
                    "Take a small bite of plain bread. Don't swallow.",
                    "Chew slowly for 1 full minute.",
                    "Pay attention to the taste at 1 minute, 2 minutes, 3 minutes.",
                    "By the 3rd minute the bread tastes noticeably sweeter."
                ],
                whyItWorks: "Saliva contains an enzyme called amylase that breaks starch into maltose, a sweet sugar. You are watching the very first step of digestion happen on your own tongue.",
                estimatedMinutes: 5
            ),
            HomeExperiment(
                id: "ch02_exp_eggshell_acid",
                emoji: "🥚",
                title: "Eggshell vs vinegar (stomach acid simulator)",
                needs: [
                    "A clean raw eggshell — wash it well",
                    "A small bowl of white vinegar",
                    "24 hours of patience"
                ],
                steps: [
                    "Drop the eggshell into the bowl of vinegar.",
                    "Watch — bubbles will start rising immediately.",
                    "Leave it for 24 hours.",
                    "Lift the shell out. It will be soft, bendy, or partly gone."
                ],
                whyItWorks: "Vinegar (acetic acid) is far weaker than stomach acid (hydrochloric acid), but it still dissolves the calcium carbonate in eggshell. Your stomach makes acid 1,000 times stronger — that's why a layer of fresh mucus matters.",
                estimatedMinutes: 1440
            ),
            HomeExperiment(
                id: "ch02_exp_tongue_map_myth",
                emoji: "👅",
                title: "Bust the tongue-map myth",
                needs: [
                    "Three small cups: salt water, sugar water, lemon juice",
                    "Three cotton buds / earbuds",
                    "A mirror or a curious partner"
                ],
                steps: [
                    "Dab one bud in sugar water and touch it to the BACK of your tongue.",
                    "Notice — you taste sweet, even though textbooks say the tip handles sweet.",
                    "Repeat with salt water on the back and centre.",
                    "Try lemon juice on the tip — you'll still taste sour."
                ],
                whyItWorks: "The old tongue map (sweet-tip / sour-sides / bitter-back) is a translation error from a 1901 paper. Every taste bud detects every taste. Science updates itself when better evidence shows up.",
                estimatedMinutes: 10
            ),
            HomeExperiment(
                id: "ch02_exp_curd_making",
                emoji: "🥛",
                title: "Make curd at home — see lactic acid in action",
                needs: [
                    "1 cup of warm milk (just-warm to the wrist, not hot)",
                    "1 teaspoon of existing curd (the starter)",
                    "A bowl with a lid",
                    "A warm spot in the kitchen, overnight"
                ],
                steps: [
                    "Pour the warm milk into the bowl.",
                    "Add the spoonful of curd. Stir gently for 10 seconds.",
                    "Cover the bowl. Leave it on the kitchen counter overnight.",
                    "In the morning — solid curd."
                ],
                whyItWorks: "The bit of curd you added contained Lactobacillus bacteria. Overnight, those bacteria converted the sugar in milk (lactose) into lactic acid. Acid makes milk proteins clump — that's the solid curd you eat.",
                estimatedMinutes: 720
            ),
            HomeExperiment(
                id: "ch02_exp_stomach_rumble",
                emoji: "🥁",
                title: "Listen to your stomach's 90-minute clock",
                needs: [
                    "A quiet room, an empty stomach (2+ hours since last meal)",
                    "Optional: an ear pressed to a clean drinking glass against your belly",
                    "A notebook and a clock"
                ],
                steps: [
                    "Sit quietly for 5 minutes after at least 2 hours of not eating.",
                    "Listen for low gurgles or rumbles from your stomach.",
                    "Note the time when you hear them.",
                    "Wait. Listen again at 30 minutes, 60, and 90 minutes."
                ],
                whyItWorks: "When your stomach is empty, it contracts in waves about every 90 minutes — the Migrating Motor Complex. The waves sweep crumbs and bacteria through to the small intestine. Your gut has its own clock, all by itself.",
                estimatedMinutes: 120
            )
        ]
    ]

    static func hasExperiments(for chapterId: String) -> Bool {
        guard let list = experiments[chapterId] else { return false }
        return !list.isEmpty
    }
}

struct HomeExperimentsSheet: View {
    let chapterId: String
    let chapterTitle: String

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Try at Home")
                        .font(.title2.bold())
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    Text(chapterTitle)
                        .font(.subheadline)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }
                Spacer()
                Button("Close") { presentationMode.wrappedValue.dismiss() }
                    .keyboardShortcut(.cancelAction)
            }
            .padding(20)
            .background(Color.white.opacity(0.5))

            Divider()

            ScrollView {
                LazyVStack(spacing: 14) {
                    if let list = HomeExperimentLibrary.experiments[chapterId] {
                        ForEach(list) { exp in
                            HomeExperimentCard(experiment: exp)
                        }
                    } else {
                        VStack(spacing: 10) {
                            Text("🧪").font(.system(size: 56))
                            Text("No home experiments yet")
                                .font(.title3.bold())
                                .foregroundColor(DesignTokens.BrandColor.canvasText)
                            Text("We are adding hands-on activities chapter by chapter. Check back soon.")
                                .font(.callout)
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(40)
                    }
                }
                .padding(20)
                .frame(maxWidth: 720)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .frame(minWidth: 640, minHeight: 540)
    }
}

private struct HomeExperimentCard: View {
    let experiment: HomeExperiment
    @State private var expanded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { expanded.toggle() }
            } label: {
                HStack(spacing: 12) {
                    Text(experiment.emoji).font(.system(size: 28))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(experiment.title)
                            .font(.headline)
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                            .multilineTextAlignment(.leading)
                        Text("\u{2248} \(experiment.estimatedMinutes) min")
                            .font(.caption)
                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    }
                    Spacer()
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .font(.callout)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }
                .padding(14)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if expanded {
                VStack(alignment: .leading, spacing: 14) {
                    Divider()

                    Group {
                        Text("What you'll need")
                            .font(.subheadline.bold())
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                        ForEach(experiment.needs.indices, id: \.self) { idx in let item = experiment.needs[idx];
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                Text(item).multilineTextAlignment(.leading)
                            }
                            .font(.callout)
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                        }
                    }

                    Group {
                        Text("What you'll do")
                            .font(.subheadline.bold())
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                        ForEach(experiment.steps.indices, id: \.self) { idx in let step = experiment.steps[idx];
                            HStack(alignment: .top, spacing: 8) {
                                Text("\(idx + 1).")
                                    .frame(width: 22, alignment: .trailing)
                                Text(step).multilineTextAlignment(.leading)
                            }
                            .font(.callout)
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                        }
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Why it works")
                            .font(.subheadline.bold())
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                        Text(experiment.whyItWorks)
                            .font(.callout)
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.compatIndigo.opacity(0.10))
                    )
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 14)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(Color.gray.opacity(0.15), lineWidth: 1)
        )
    }
}

private struct DiscoverEntryBanner: View {
    /// Live scene count for THIS chapter — was hard-coded "9 interactive
    /// scenes" pre-2026-05-21, which lied to the kid once we expanded
    /// every chapter to 20+. Reads through DataStore.discoverSceneCounts
    /// keyed by chapter.number; defaults to 9 if not in the table (e.g.
    /// content packs that never grew beyond the original 9).
    let sceneCount: Int

    @State private var isHovered = false

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            Text("✨")
                .font(.system(size: 38))
            VStack(alignment: .leading, spacing: 4) {
                Text("Try Discover Mode")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                Text("\(sceneCount) interactive scenes — animations, mini-games, and a final boss quiz.")
                    .font(.callout)
                    .foregroundColor(.white.opacity(0.92))
            }
            Spacer()
            Image(systemName: "arrow.right.circle.fill")
                .font(.title)
                .foregroundColor(.white.opacity(0.95))
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.30, green: 0.65, blue: 0.45),
                            Color(red: 0.20, green: 0.45, blue: 0.75)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 6)
        )
        .scaleEffect(isHovered ? 1.01 : 1.0)
        .onHover { hovering in isHovered = hovering }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Opens an illustrated, interactive learning experience for this chapter.")
    }
}

private struct TopicCard: View {
    let topic: Topic
    @State private var isHovered = false

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(topic.title)
                    .font(.title3.bold())
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                Text(topic.summary)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .lineSpacing(3)
                HStack(spacing: 12) {
                    Label("\(topic.concepts.count) concepts", systemImage: "lightbulb")
                    Label("\(topic.questions.count) questions", systemImage: "questionmark.circle")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 4)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isHovered ? Color.gray.opacity(0.18) : Color.gray.opacity(0.1))
        )
        .onHover { hovering in isHovered = hovering }
    }
}
