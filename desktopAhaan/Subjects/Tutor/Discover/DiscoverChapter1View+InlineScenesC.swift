import SwiftUI

// MARK: - DiscoverChapter1View inline scenes (group C)
//
// Lifted out of DiscoverChapter1View+InlineScenes.swift to bring every
// partial under the 600-LOC Big Sur (Swift 5.5) type-checker ceiling.
// Contains: Rhizobium/FoodChain/CompostTimeline/VanHelmontWillow scenes. Standalone closure-driven scene structs (already
// internal); the dispatcher references them unchanged.

// MARK: - Inline Scene 17: Rhizobium Nitrogen Factory (Topic 3)
struct RhizobiumNitrogenScene: View {
    let onComplete: () -> Void
    @State private var noduleOpen: Bool = false

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Rhizobium: The Nitrogen Factory")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Bean and pea roots have pink-white bumps called nodules. Inside each one, Rhizobium bacteria pull nitrogen straight out of the air.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                rootDiagram.frame(width: 220, height: 200)
                Button {
                    withAnimationRespectingReduceMotion(.easeInOut(duration: 0.25)) { noduleOpen.toggle() }
                } label: {
                    Text(noduleOpen ? "Hide the bacteria" : "Magnify a nodule")
                        .font(.body.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                        .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                        .foregroundColor(Color.compatIndigo)
                }
                .buttonStyle(.plain).pointingCursor()
                if noduleOpen { magnifiedCard }
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    private var rootDiagram: some View {
        ZStack {
            Rectangle().fill(Color.compatBrown.opacity(0.6)).frame(width: 10, height: 180)
            ForEach(0..<5, id: \.self) { i in
                let noduleX: CGFloat = i.isMultiple(of: 2) ? -18 : 18
                let noduleY: CGFloat = -70 + CGFloat(i * 30)
                Circle().fill(Color.pink.opacity(0.6))
                    .frame(width: 22, height: 22)
                    .offset(x: noduleX, y: noduleY)
            }
        }
    }

    private var magnifiedCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Inside the nodule").font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Rhizobium bacteria take N₂ gas from the air pockets in soil and turn it into NH₃ (ammonia) — a form roots can absorb. The plant gives them shelter + sugar in exchange. This is why farmers rotate beans into a wheat field: the bacteria leave behind 'free' nitrogen the next crop can use.")
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(maxWidth: DesignTokens.contentMaxWidth)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.2), lineWidth: 1))
        .padding(.horizontal, 24)
    }
}

// MARK: - Inline Scene 18: Food Chain Builder (Topic 3)
struct FoodChainBuilderScene: View {
    let onComplete: () -> Void

    struct Org: Identifiable {
        let id: String; let emoji: String; let name: String; let position: Int
    }
    private let target: [Org] = [
        Org(id: "grass", emoji: "🌾", name: "Grass", position: 0),
        Org(id: "hopper", emoji: "🦗", name: "Grasshopper", position: 1),
        Org(id: "frog", emoji: "🐸", name: "Frog", position: 2),
        Org(id: "snake", emoji: "🐍", name: "Snake", position: 3),
        Org(id: "hawk", emoji: "🦅", name: "Hawk", position: 4)
    ]
    @State private var built: [Org] = []
    @State private var available: [Org] = []
    @State private var feedback: String = ""

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Food Chain Builder")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Tap organisms in order from producer (eats sunlight) to top predator (eaten by no one).")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                chainView
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)
                availableView
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)
                if !feedback.isEmpty {
                    Text(feedback).font(.callout.weight(.semibold))
                        .foregroundColor(feedback.hasPrefix("Perfect")
                                         ? DesignTokens.BrandColor.primaryAction
                                         : DesignTokens.BrandColor.danger)
                }
                HStack(spacing: 14) {
                    Button("Reset") { reset() }
                    GotItButton(action: onComplete)
                }
                .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
            .onAppear { reset() }
        }
    }

    private var chainView: some View {
        HStack(spacing: 6) {
            ForEach(0..<5, id: \.self) { i in
                if i < built.count {
                    orgCard(built[i], filled: true)
                    if i < 4 {
                        Image(systemName: "arrow.right")
                            .foregroundColor(DesignTokens.BrandColor.mnemonicAccent)
                    }
                } else {
                    placeholderCard
                    if i < 4 {
                        Image(systemName: "arrow.right")
                            .foregroundColor(Color.gray.opacity(0.3))
                    }
                }
            }
        }
    }

    private var availableView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Tap to add").font(.caption.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            HStack(spacing: 6) {
                ForEach(available) { o in
                    Button { append(o) } label: { orgCard(o, filled: false) }
                        .buttonStyle(.plain).pointingCursor()
                }
            }
        }
    }

    private func orgCard(_ o: Org, filled: Bool) -> some View {
        VStack(spacing: 2) {
            Text(o.emoji).font(.title3)
            Text(o.name).font(.caption2)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 8)
                    .fill(filled
                          ? DesignTokens.BrandColor.primaryAction.opacity(0.15)
                          : Color.gray.opacity(0.08)))
        .overlay(RoundedRectangle(cornerRadius: 8)
                 .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1))
    }

    private var placeholderCard: some View {
        RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.05))
            .frame(width: 64, height: 64)
            .overlay(RoundedRectangle(cornerRadius: 8)
                     .strokeBorder(Color.gray.opacity(0.2),
                                   style: StrokeStyle(lineWidth: 1, dash: [4])))
    }

    private func reset() {
        built = []
        available = target.shuffled()
        feedback = ""
    }

    private func append(_ o: Org) {
        let expectedPos = built.count
        if o.position == expectedPos {
            built.append(o)
            available.removeAll { $0.id == o.id }
            if built.count == target.count {
                feedback = "Perfect! Energy flows from grass to hawk."
            }
        } else {
            feedback = "Not yet — \(o.name) doesn't fit at position \(expectedPos + 1)."
        }
    }
}

// MARK: - Inline Scene 19: Compost Pit Timeline (Topic 3)
struct CompostTimelineScene: View {
    let onComplete: () -> Void
    @State private var day: Double = 0

    private var stage: Int {
        if day < 8 { return 0 }
        if day < 18 { return 1 }
        return 2
    }
    private var stageLabel: String {
        ["Fresh waste — bacteria start eating sugars.",
         "Mushy — fungi join, breaking down tougher cellulose.",
         "Humus — black, crumbly soil. Plant food."][stage]
    }
    private var stageEmoji: String {
        ["🍌", "🥬", "🟫"][stage]
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Compost Pit Timeline")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Drag the slider across 30 days to watch bacteria and fungi turn kitchen waste into rich soil.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                Text(stageEmoji).font(.system(size: 80))
                Text("Day \(Int(day))")
                    .font(.headline.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Slider(value: $day, in: 0...30)
                    .frame(maxWidth: 340)
                    .padding(.horizontal, 24)
                Text(stageLabel)
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }
}

// MARK: - Van Helmont's Willow (inline Scene 20)
//
// Goes beyond NCERT to plant the central "where does a tree's mass come
// from?" question in the kid's mind. Belgian scientist Jan Baptista van
// Helmont in the 1640s grew a willow from 2 kg to 76 kg over 5 years
// using only rainwater — and the soil weight barely changed. Where did
// the extra 74 kg come from? The answer (mostly CO₂ from air) blows
// minds because it inverts intuition: a tree is, mostly, captured sky.
//
// Interaction: the kid moves a slider 0 → 5 years. Tree weight rises
// non-linearly while soil weight stays nearly flat. A "Where did the
// mass come from?" guessing step with three options reveals the
// CO₂-from-air answer with a short explanation card.
//
// Big Sur compatible: no .symbolEffect, no .foregroundStyle, no
// macOS 12+ APIs; body text routes through DesignTokens.BrandColor.
struct VanHelmontWillowScene: View {
    let onComplete: () -> Void

    @State private var years: Double = 0
    @State private var guessRevealed = false
    @State private var pickedOption: String? = nil

    /// Named option type so SwiftUI gets a stable Identifiable view of
    /// the choices. Originally this was a tuple-array with
    /// `ForEach(options, id: \.label)` — keypath-into-labeled-tuple is
    /// fragile on Swift 5.5 (the Big Sur deploy compiler) and produced
    /// "Entangling fence requested after pre-commit" SwiftUI warnings
    /// plus an EXC_BAD_ACCESS during the transition into this scene.
    struct GuessOption: Identifiable {
        let id: String       // also serves as the label
        let isCorrect: Bool
        let explanation: String
    }

    // Tree mass grew roughly: 2.3 kg start → 76 kg at 5 years. Smooth a
    // curve through that. Soil drops by ~60 g over 5 years (barely
    // moves on the kid-facing dial — we round to one decimal kg).
    private var treeKg: Double {
        // Polynomial fit close to 2.3 + (76 - 2.3) * (t/5)^1.5 — slow
        // start, faster middle, levelling near end.
        let t = max(0, min(5, years))
        let frac = pow(t / 5.0, 1.5)
        return 2.3 + (76.0 - 2.3) * frac
    }
    private var soilKg: Double {
        // Started at 90.7 kg, ended ~90.64 kg. Treat as constant in
        // display; show one decimal so the kid sees it doesn't move.
        let t = max(0, min(5, years))
        return 90.7 - 0.012 * t
    }

    private let options: [GuessOption] = [
        GuessOption(id: "From the soil",
                    isCorrect: false,
                    explanation: "The soil weighed almost the same at the end — only ~60 g less. The tree did not eat the soil."),
        GuessOption(id: "From the rainwater",
                    isCorrect: false,
                    explanation: "Water gave the tree hydrogen and oxygen, but not most of the mass. Trees are mostly carbon."),
        GuessOption(id: "From CO₂ in the air",
                    isCorrect: true,
                    explanation: "Photosynthesis pulls CO₂ out of the air and locks the carbon into wood, leaves and bark. A tree is, mostly, captured sky.")
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                Text("Van Helmont's Willow")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)

                Text("In the 1640s, Belgian scientist Jan Baptista van Helmont planted a 2 kg willow in 90 kg of dry soil. For 5 years he watered it with rainwater only. Move the slider and watch what happens.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: 600)

                // Visualisation
                HStack(alignment: .bottom, spacing: 28) {
                    VStack(spacing: 6) {
                        // No .animation(_:value:) — that's a macOS 12+
                        // modifier (CLAUDE.md forbids macOS 12 APIs on
                        // our Big Sur deploy target). Wrap the slider
                        // change in withAnimation in the binding instead.
                        let treeFontSize: CGFloat = 18 + CGFloat(treeKg * 0.55)
                        Text("🌳")
                            .font(.system(size: treeFontSize))
                        Text("Tree: \(String(format: "%.1f", treeKg)) kg")
                            .font(.subheadline.bold())
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                    }
                    .frame(width: 160)

                    VStack(spacing: 6) {
                        Text("🟫")
                            .font(.system(size: 56))
                        Text("Soil: \(String(format: "%.2f", soilKg)) kg")
                            .font(.subheadline.bold())
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                    }
                    .frame(width: 160)
                }
                .frame(maxWidth: 600)
                .padding(.vertical, 8)

                SoftShadowCard(padding: 14) {
                    VStack(spacing: 8) {
                        Text("Time: \(Int(years.rounded())) year\(Int(years.rounded()) == 1 ? "" : "s")")
                            .font(.subheadline)
                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        Slider(value: $years, in: 0...5, step: 1)
                            .frame(maxWidth: 340)
                    }
                }
                .frame(maxWidth: 600)

                if years >= 5 && !guessRevealed {
                    VStack(spacing: 10) {
                        Text("Where did the extra 74 kg come from?")
                            .font(.title3.bold())
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                            .multilineTextAlignment(.center)
                        VStack(spacing: 8) {
                            ForEach(options) { opt in
                                Button {
                                    pickedOption = opt.id
                                    guessRevealed = true
                                } label: {
                                    HStack {
                                        Text(opt.id)
                                            .font(.body)
                                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(Color.white)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .strokeBorder(Color.gray.opacity(0.25), lineWidth: 1.2)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .frame(maxWidth: 520)
                    }
                    .padding(.top, 8)
                }

                if guessRevealed, let picked = pickedOption,
                   let chosen = options.first(where: { $0.id == picked }) {
                    SoftShadowCard(padding: 14) {
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: chosen.isCorrect ? "checkmark.circle.fill" : "info.circle.fill")
                                .foregroundColor(chosen.isCorrect ? .green : Color.compatIndigo)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(chosen.isCorrect ? "Right!" : "Good guess, but not quite.")
                                    .font(.headline)
                                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                                Text(chosen.explanation)
                                    .font(.callout)
                                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                                    .multilineTextAlignment(.leading)
                                if !chosen.isCorrect {
                                    Text("The real answer: " + (options.first(where: { $0.isCorrect })?.explanation ?? ""))
                                        .font(.callout)
                                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                                        .padding(.top, 4)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: 600)

                    GotItButton { onComplete() }
                        .padding(.bottom, 12)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }
}
