import SwiftUI

// MARK: - InfrastructureSorter
//
// Bespoke interactive for Social Science Ch.19 "Infrastructure: Engine of India's
// Development" (`socialscience_class7` / ssch19). The chapter opens (ssch19_t01_c01)
// by splitting infrastructure into TWO big kinds: PHYSICAL infrastructure — the
// 'hardware' of transport, utilities, energy and communication (roads, railways,
// dams, ports, phone towers) — and SOCIAL infrastructure — the things that help
// people grow and stay well (schools, hospitals, police & fire stations, courts,
// libraries, parks). The exam-and-Olympiad skill is telling the two apart.
//
// This widget shows one real example at a time (every one named in the chapter:
// NH44, the Bhakra Nangal Dam, the Indian Railways, J.C. Bose's wireless towers,
// the Jawaharlal Nehru port — vs a government school, a hospital, a police/fire
// station, a court, a public library) and asks the learner to tap Physical or
// Social. Each card carries a chapter-grounded reason, so a wrong tap teaches.
// A running score and an 'all N sorted' finish reward completing the set. Ten
// cards, five per kind, fixed order (no randomness — banned on the target).
//
// Big Sur compat: self-contained, @SceneStorage (namespaced by chapter) for the
// card index, @State for the per-card pick, Color(red:green:blue:), RM-gated
// motion, SFSymbolCompat (SF Symbols 1/2 only), VoiceOver labels. No macOS 12+
// APIs (no .animation(_:value:)), no force-unwraps.

struct InfrastructureSorter: View {
    let chapterId: String

    @SceneStorage private var index: Int
    @State private var picked: Int? = nil        // kind index tapped for current card
    @State private var solved: Set<Int> = []     // card indices answered correctly
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(chapterId: String) {
        self.chapterId = chapterId
        self._index = SceneStorage(wrappedValue: 0, "ssinteractive.\(chapterId).infraidx")
    }

    private let steel = Color(red: 0.20, green: 0.38, blue: 0.50)

    // MARK: - The two kinds (grounded in ssch19_t01_c01)

    private struct Kind { let name: String; let symbol: String }
    private let kinds: [Kind] = [
        Kind(name: "Physical", symbol: "bolt.fill"),
        Kind(name: "Social",   symbol: "graduationcap.fill")
    ]

    // Each example maps to one kind (index into `kinds`) with a chapter-grounded reason.
    private struct Item { let text: String; let kind: Int; let reason: String }
    private let items: [Item] = [
        Item(text: "NH44 — the highway from Srinagar to Kanyakumari", kind: 0,
             reason: "Roads and highways are physical (transport) infrastructure. NH44 is India's longest, running 4,112 km."),
        Item(text: "The Bhakra Nangal Dam", kind: 0,
             reason: "Dams are energy & utilities infrastructure — Bhakra Nangal gives both electricity and irrigation water."),
        Item(text: "The Indian Railways", kind: 0,
             reason: "Railways are physical transport infrastructure — India's lifeline since 1853, carrying over 20 million passengers a day."),
        Item(text: "Wireless towers, cables and data centres", kind: 0,
             reason: "Communication networks are physical infrastructure. J.C. Bose pioneered wireless transmission in Calcutta in 1895."),
        Item(text: "The Jawaharlal Nehru sea port", kind: 0,
             reason: "Ports are physical transport infrastructure — sea ports handle the bulk of India's overseas trade."),
        Item(text: "A government school", kind: 1,
             reason: "Schools help people learn — that makes them social infrastructure, which supports education and development."),
        Item(text: "A hospital or health centre", kind: 1,
             reason: "Hospitals keep people healthy — social infrastructure supports the community's wellbeing."),
        Item(text: "A police station and fire station", kind: 1,
             reason: "They keep people safe — safety services are part of social infrastructure."),
        Item(text: "A court of law", kind: 1,
             reason: "Courts deliver justice — they are social infrastructure that protects people's rights."),
        Item(text: "A public library and park", kind: 1,
             reason: "Libraries and parks make life richer and bring people together — social infrastructure for community wellbeing.")
    ]

    private var current: Item { items[max(0, min(index, items.count - 1))] }
    private var answered: Bool { picked != nil }
    private var wasCorrect: Bool { picked == current.kind }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            progressRow
            exampleCard
            kindButtons
            if answered { feedbackBanner }
            if answered { nextButton }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                .fill(Color.white.opacity(0.92))
                .overlay(RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                    .strokeBorder(steel.opacity(0.28), lineWidth: 1))
        )
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text("Physical or social?")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Infrastructure comes in two kinds. Tap whether each example is physical 'hardware' or social.")
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var progressRow: some View {
        HStack(spacing: 6) {
            let done = solved.count >= items.count
            Image(systemName: SFSymbolCompat.name(done ? "checkmark.seal.fill" : "list.number"))
                .foregroundColor(done ? .green : DesignTokens.BrandColor.canvasTextSecondary)
                .accessibilityHidden(true)
            Text(done
                 ? "You sorted all \(items.count) examples correctly!"
                 : "Card \(index + 1) of \(items.count) · \(solved.count) sorted")
                .font(.caption.weight(.medium))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
    }

    private var exampleCard: some View {
        Text(current.text)
            .font(.title3.weight(.semibold))
            .foregroundColor(DesignTokens.BrandColor.canvasText)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(DesignTokens.Spacing.lg)
            .background(RoundedRectangle(cornerRadius: 10).fill(steel.opacity(0.08)))
            .accessibilityLabel("Example: \(current.text)")
    }

    private var kindButtons: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            ForEach(kinds.indices, id: \.self) { i in kindButton(i) }
        }
    }

    private func kindButton(_ i: Int) -> some View {
        let kind = kinds[i]
        let isPick = picked == i
        let showAsAnswer = answered && i == current.kind
        let tint: Color = showAsAnswer ? .green : (isPick ? .red : steel)
        return Button { pick(i) } label: {
            VStack(spacing: 6) {
                Image(systemName: SFSymbolCompat.name(kind.symbol))
                    .font(.title3)
                    .accessibilityHidden(true)
                Text("\(kind.name) infrastructure")
                    .font(.caption.weight(.semibold))
                    .multilineTextAlignment(.center)
            }
            .foregroundColor(answered ? (showAsAnswer || isPick ? .white : DesignTokens.BrandColor.canvasText) : .white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignTokens.Spacing.md).padding(.horizontal, 6)
            .background(RoundedRectangle(cornerRadius: 10)
                .fill(answered ? tint.opacity(showAsAnswer || isPick ? 0.9 : 0.12) : steel))
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .disabled(answered)
        .accessibilityLabel("\(kind.name) infrastructure")
        .accessibilityHint("Tap if this is \(kind.name.lowercased()) infrastructure.")
    }

    private var feedbackBanner: some View {
        HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
            Image(systemName: SFSymbolCompat.name(wasCorrect ? "checkmark.circle.fill" : "xmark.circle.fill"))
                .foregroundColor(wasCorrect ? .green : .red)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                Text(wasCorrect ? "Correct — that's \(kinds[current.kind].name.lowercased()) infrastructure." : "Not quite — it's \(kinds[current.kind].name.lowercased()) infrastructure.")
                    .font(.caption.weight(.bold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Text(current.reason)
                    .font(.caption)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8)
            .fill((wasCorrect ? Color.green : Color.red).opacity(0.12)))
        .accessibilityElement(children: .combine)
    }

    private var nextButton: some View {
        Button { advance() } label: {
            Text(index + 1 < items.count ? "Next example →" : "Start over")
                .font(.caption.weight(.semibold))
                .foregroundColor(.white)
                .padding(.horizontal, DesignTokens.Spacing.lg).padding(.vertical, DesignTokens.Spacing.sm)
                .background(Capsule().fill(steel))
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel(index + 1 < items.count ? "Next example" : "Start over")
    }

    // MARK: - Actions

    private func pick(_ i: Int) {
        guard picked == nil else { return }
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
            picked = i
            if i == current.kind { solved.insert(index) }
        }
    }

    private func advance() {
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
            picked = nil
            index = index + 1 < items.count ? index + 1 : 0
        }
    }
}
