import SwiftUI

// MARK: - DiscoverChapter1View inline scenes (group B)
//
// Lifted out of DiscoverChapter1View+InlineScenes.swift to bring every
// partial under the 600-LOC Big Sur (Swift 5.5) type-checker ceiling.
// Contains: Parasite/VenusFlytrap/SortTheFeeders/SoilLayers scenes. Standalone closure-driven scene structs (already
// internal); the dispatcher references them unchanged.

// MARK: - Inline Scene 13: Parasite, Partner, or Predator? (Topic 2)
struct ParasitePartnerPredatorScene: View {
    let onComplete: (Int) -> Void

    private enum Kind: String, CaseIterable {
        case parasite = "Parasite"
        case partner = "Partner"
        case predator = "Predator"
    }
    // Made `private` to match Kind's access level after the parent
    // struct was de-privatised during the 2026-05-22 split.
    private struct Q: Identifiable {
        let id: String; let emoji: String; let name: String; let detail: String; let correct: Kind
    }
    private let questions: [Q] = [
        Q(id: "q1", emoji: "🌿", name: "Cuscuta", detail: "Wraps around host plants, sucks their sap.",
          correct: .parasite),
        Q(id: "q2", emoji: "🌳", name: "Lichen",
          detail: "Alga + fungus living together; both gain from the deal.",
          correct: .partner),
        Q(id: "q3", emoji: "🍶", name: "Pitcher Plant",
          detail: "Lures insects into a digestive cup.", correct: .predator)
    ]

    @State private var answers: [String: Kind] = [:]
    private var score: Int {
        questions.reduce(0) { $0 + ((answers[$1.id] == $1.correct) ? 1 : 0) }
    }
    private var allAnswered: Bool { answers.count == questions.count }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Parasite, Partner, or Predator?")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("For each plant, pick the right category.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                ForEach(questions) { q in
                    questionCard(q)
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
                        .padding(.horizontal, DesignTokens.Spacing.xl)
                }
                if allAnswered {
                    Text("Score: \(score) / \(questions.count)")
                        .font(.headline)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                        .padding(.top, DesignTokens.Spacing.sm)
                }
                GotItButton(action: { onComplete(score) }).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    @ViewBuilder
    private func questionCard(_ q: Q) -> some View {
        let answer = answers[q.id]
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            HStack(spacing: 10) {
                Text(q.emoji).font(.title)
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                    Text(q.name).font(.headline)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    Text(q.detail).font(.caption)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }
            }
            HStack(spacing: DesignTokens.Spacing.sm) {
                ForEach(Kind.allCases, id: \.self) { k in
                    answerButton(q: q, kind: k, picked: answer)
                }
            }
            if let picked = answer {
                Text(picked == q.correct ? "Correct — \(q.correct.rawValue)." : "Not quite — the answer is \(q.correct.rawValue).")
                    .font(.caption)
                    .foregroundColor(picked == q.correct
                                     ? DesignTokens.BrandColor.primaryAction
                                     : DesignTokens.BrandColor.danger)
            }
        }
        .padding(DesignTokens.Spacing.md)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
    }

    private func answerButton(q: Q, kind: Kind, picked: Kind?) -> some View {
        let isPicked = picked == kind
        let isCorrect = kind == q.correct
        let tint: Color = {
            guard picked != nil else { return Color.compatIndigo }
            if isPicked { return isCorrect ? DesignTokens.BrandColor.primaryAction : DesignTokens.BrandColor.danger }
            return Color.gray
        }()
        return Button {
            if answers[q.id] == nil { answers[q.id] = kind }
        } label: {
            Text(kind.rawValue)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 10).padding(.vertical, 6)
                .background(Capsule().fill(tint.opacity(isPicked ? 0.22 : 0.10)))
                .overlay(Capsule().strokeBorder(tint.opacity(0.5), lineWidth: 1))
                .foregroundColor(tint)
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .disabled(picked != nil)
    }
}

// MARK: - Inline Scene 14: Venus Flytrap Reflex (Topic 2)
//
// Timing mini-game: a "fly" appears on the open trap; the kid has a
// short window to tap "Snap!" before the fly escapes. Caught flies
// count toward score. 5 rounds total.
struct VenusFlytrapReflexScene: View {
    let onComplete: (Int) -> Void

    @State private var round: Int = 0
    @State private var caught: Int = 0
    @State private var flyOnTrap: Bool = false
    @State private var trapClosed: Bool = false
    @State private var roundActive: Bool = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let totalRounds = 5

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Venus Flytrap Reflex")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("A bug lands on the trap — tap Snap! before it escapes. The trap closes when triggered twice within seconds (a real safety check the plant evolved).")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                trapVisual
                    .frame(width: 240, height: 160)
                controlRow
                Text("Caught: \(caught) / \(totalRounds)  ·  Round: \(min(round + 1, totalRounds))")
                    .font(.callout.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                if round >= totalRounds {
                    Text("Done! The real plant catches 1-3 bugs in its life — most rounds are practice.")
                        .font(.caption)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        .padding(.horizontal, DesignTokens.Spacing.xl)
                        .multilineTextAlignment(.center)
                }
                GotItButton(action: { onComplete(caught) }).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    private var trapVisual: some View {
        ZStack {
            // Two clamshell leaves
            HStack(spacing: trapClosed ? 0 : 6) {
                lobe(rotation: trapClosed ? 10 : -25)
                lobe(rotation: trapClosed ? -10 : 25)
            }
            if flyOnTrap && !trapClosed {
                Text("🪰").font(.title)
            }
        }
    }

    private func lobe(rotation: Double) -> some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(LinearGradient(colors: [Color.green, Color.red.opacity(0.55)],
                                  startPoint: .top, endPoint: .bottom))
            .frame(width: 95, height: 110)
            .rotationEffect(.degrees(rotation))
    }

    private var controlRow: some View {
        HStack(spacing: 14) {
            Button { startRound() } label: {
                Text(round >= totalRounds ? "Replay" : "Release a bug")
                    .font(.body.weight(.semibold))
                    .padding(.horizontal, DesignTokens.Spacing.lg).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }
            .buttonStyle(.plain).pointingCursor()
            .disabled(roundActive)

            Button { snap() } label: {
                Text("Snap!")
                    .font(.body.weight(.bold))
                    .padding(.horizontal, DesignTokens.Spacing.lg).padding(.vertical, 9)
                    .background(Capsule().fill(DesignTokens.BrandColor.danger.opacity(0.18)))
                    .overlay(Capsule().strokeBorder(DesignTokens.BrandColor.danger.opacity(0.5), lineWidth: 1))
                    .foregroundColor(DesignTokens.BrandColor.danger)
            }
            .buttonStyle(.plain).pointingCursor()
            .disabled(!flyOnTrap || trapClosed)
        }
    }

    private func startRound() {
        if round >= totalRounds {
            round = 0; caught = 0
        }
        flyOnTrap = false; trapClosed = false; roundActive = true
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 600_000_000)
            withAnimation { flyOnTrap = true }
            // Window: 1500ms before fly escapes
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            if flyOnTrap && !trapClosed {
                // Escaped
                withAnimation { flyOnTrap = false }
                round += 1; roundActive = false
            }
        }
    }

    private func snap() {
        if flyOnTrap && !trapClosed {
            let a = reduceMotion ? Animation.linear(duration: 0.0) : .easeIn(duration: 0.15)
            withAnimationRespectingReduceMotion(a) {
                trapClosed = true; flyOnTrap = false
            }
            caught += 1
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 800_000_000)
                round += 1; roundActive = false
                withAnimation { trapClosed = false }
            }
        }
    }
}

// MARK: - Inline Scene 15: Sort the Feeders (Topic 2 → 3 bridge)
struct SortTheFeedersScene: View {
    let onComplete: () -> Void

    private enum Bucket: String, CaseIterable {
        case autotroph = "Autotroph"
        case parasite = "Parasite"
        case saprotroph = "Saprotroph"
        case insectivore = "Insectivore"
    }
    // Made `private` to match Bucket's access level after the parent
    // struct was de-privatised during the 2026-05-22 split.
    private struct Org: Identifiable {
        let id: String; let emoji: String; let name: String; let correct: Bucket
    }
    private let organisms: [Org] = [
        Org(id: "rice", emoji: "🌾", name: "Rice plant", correct: .autotroph),
        Org(id: "cuscuta", emoji: "🌿", name: "Cuscuta", correct: .parasite),
        Org(id: "mould", emoji: "🍞", name: "Bread mould", correct: .saprotroph),
        Org(id: "pitcher", emoji: "🍶", name: "Pitcher Plant", correct: .insectivore),
        Org(id: "oak", emoji: "🌳", name: "Oak tree", correct: .autotroph),
        Org(id: "mush", emoji: "🍄", name: "Mushroom", correct: .saprotroph)
    ]

    @State private var assignment: [String: Bucket] = [:]
    private var allSorted: Bool { assignment.count == organisms.count }
    private var correctCount: Int {
        organisms.reduce(0) { $0 + ((assignment[$1.id] == $1.correct) ? 1 : 0) }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Sort the Feeders")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Tap an organism, then tap a bucket to file it. Mix-up an answer? Hit Reset to try again.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                organismRow
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                bucketRow
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                if allSorted {
                    Text("Sorted \(correctCount) / \(organisms.count) correctly.")
                        .font(.headline)
                        .foregroundColor(correctCount == organisms.count
                                          ? DesignTokens.BrandColor.primaryAction
                                          : DesignTokens.BrandColor.canvasText)
                }
                HStack(spacing: 14) {
                    Button("Reset") { assignment = [:] }
                        .disabled(assignment.isEmpty)
                    GotItButton(action: onComplete)
                }
                .padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    private var organismRow: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text("Organisms").font(.caption.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            HStack(spacing: 6) {
                ForEach(organisms) { o in
                    organismChip(o)
                }
            }
        }
    }

    private var bucketRow: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text("Buckets — tap to file the selected organism")
                .font(.caption.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            HStack(spacing: 6) {
                ForEach(Bucket.allCases, id: \.self) { b in
                    bucketChip(b)
                }
            }
        }
    }

    @State private var selectedOrg: String? = nil
    private func organismChip(_ o: Org) -> some View {
        let assigned = assignment[o.id]
        let isSelected = selectedOrg == o.id
        let tint: Color = assigned == nil
            ? (isSelected ? Color.compatIndigo : Color.gray)
            : (assigned == o.correct ? DesignTokens.BrandColor.primaryAction : DesignTokens.BrandColor.danger)
        return Button { if assignment[o.id] == nil { selectedOrg = o.id } } label: {
            VStack(spacing: DesignTokens.Spacing.xxs) {
                Text(o.emoji).font(.title3)
                Text(o.name).font(.caption2)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            .padding(DesignTokens.Spacing.sm)
            .background(RoundedRectangle(cornerRadius: 8).fill(tint.opacity(isSelected ? 0.2 : 0.08)))
            .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(tint.opacity(0.45), lineWidth: 1))
        }
        .buttonStyle(.plain).pointingCursor()
    }

    private func bucketChip(_ b: Bucket) -> some View {
        Button {
            if let s = selectedOrg, assignment[s] == nil {
                assignment[s] = b
                selectedOrg = nil
            }
        } label: {
            Text(b.rawValue)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 10).padding(.vertical, 6)
                .background(Capsule().fill(Color.compatIndigo.opacity(0.10)))
                .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.4), lineWidth: 1))
                .foregroundColor(Color.compatIndigo)
        }
        .buttonStyle(.plain).pointingCursor()
        .disabled(selectedOrg == nil)
    }
}

// MARK: - Inline Scene 16: Soil Layers Lab (Topic 3)
struct SoilLayersLabScene: View {
    let onComplete: () -> Void

    struct Layer: Identifiable {
        let id: String; let name: String; let depth: String; let detail: String; let color: Color
    }
    private let layers: [Layer] = [
        Layer(id: "litter", name: "Litter", depth: "0–2 cm",
              detail: "Dead leaves, twigs. Earthworms and fungi feed here.",
              color: Color.compatBrown.opacity(0.4)),
        Layer(id: "topsoil", name: "Topsoil", depth: "2–25 cm",
              detail: "Roots + humus. Nitrogen, phosphorus, potassium — most plant food lives here.",
              color: Color.compatBrown.opacity(0.55)),
        Layer(id: "subsoil", name: "Subsoil", depth: "25–80 cm",
              detail: "Mostly clay + minerals. Deep roots reach for water.",
              color: Color.orange.opacity(0.45)),
        Layer(id: "parent", name: "Parent Rock", depth: "80 cm+",
              detail: "Slowly weathers into soil over thousands of years.",
              color: Color.gray.opacity(0.5))
    ]

    @State private var tapped: Set<String> = []

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Soil Layers Lab")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Tap each layer to see what lives there. Soil isn't one thing — it's a stack of zones.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                VStack(spacing: 0) {
                    ForEach(layers) { layer in
                        layerBand(layer)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)
                if tapped.count == layers.count {
                    Text("Whole profile explored.")
                        .font(.headline)
                        .foregroundColor(DesignTokens.BrandColor.primaryAction)
                }
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    @ViewBuilder
    private func layerBand(_ layer: Layer) -> some View {
        let isOpen = tapped.contains(layer.id)
        Button { tapped.insert(layer.id) } label: {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(layer.name).font(.headline)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    Spacer()
                    Text(layer.depth).font(.caption.monospacedDigit())
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }
                if isOpen {
                    Text(layer.detail).font(.callout)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    Text("Tap to reveal").font(.caption.italic())
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(layer.color)
        }
        .buttonStyle(.plain).pointingCursor()
    }
}

