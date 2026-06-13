import SwiftUI

/// Scene 6 — Physical or Chemical Sorting.
/// Drag-and-drop game. 12 changes shown as cards. Two zones: Physical / Chemical.
/// Score out of 12. Uses DragGesture with zone rect tracking.

struct Scene6_PhysicalOrChemicalSorting: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    private struct ChangeItem: Identifiable {
        let id = UUID()
        let label: String
        let emoji: String
        let isChemical: Bool
    }

    private static let allItems: [ChangeItem] = [
        ChangeItem(label: "Melting ice",       emoji: "🧊", isChemical: false),
        ChangeItem(label: "Burning wood",      emoji: "🪵", isChemical: true),
        ChangeItem(label: "Dissolving sugar",  emoji: "🍬", isChemical: false),
        ChangeItem(label: "Rusting iron",      emoji: "🔩", isChemical: true),
        ChangeItem(label: "Breaking glass",    emoji: "🪟", isChemical: false),
        ChangeItem(label: "Cooking egg",       emoji: "🍳", isChemical: true),
        ChangeItem(label: "Evaporation",       emoji: "☀️", isChemical: false),
        ChangeItem(label: "Digestion",         emoji: "🫃", isChemical: true),
        ChangeItem(label: "Cutting cloth",     emoji: "✂️", isChemical: false),
        ChangeItem(label: "Curdling milk",     emoji: "🥛", isChemical: true),
        ChangeItem(label: "Making dough",      emoji: "🍞", isChemical: false),
        ChangeItem(label: "Photosynthesis",    emoji: "🌿", isChemical: true),
    ]

    @State private var remaining: [ChangeItem] = Scene6_PhysicalOrChemicalSorting.allItems.shuffled()
    @State private var physicalBin: [ChangeItem] = []
    @State private var chemicalBin: [ChangeItem] = []
    @State private var score: Int = 0
    @State private var dragOffsets: [UUID: CGSize] = [:]
    @State private var draggingId: UUID? = nil
    @State private var shakeId: UUID? = nil
    @State private var showConfetti = false
    @State private var physicalRect: CGRect = .zero
    @State private var chemicalRect: CGRect = .zero
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var isDone: Bool { remaining.isEmpty }

    var body: some View {
        // ScrollView + LazyVStack: GeometryReader-collapse bug fixed by
        // removing the unused outer GeometryReader; drag chips + drop
        // zones now lay out at their natural height. The dropZone
        // helper's own GeometryReader still tracks each zone's global
        // frame for hit testing.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                VStack(spacing: DesignTokens.Spacing.md) {
                    // Score
                    HStack {
                        Text("Physical or Chemical?")
                            .font(.title2.bold())
                        Spacer()
                        Text("Score: \(score) / 12")
                            .font(.headline.monospacedDigit())
                            .foregroundColor(Color.compatIndigo)
                            .padding(.trailing, DesignTokens.Spacing.xl)
                            .padding(.top, DesignTokens.Spacing.sm)
                    }
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                    .padding(.top, DesignTokens.Spacing.md)

                    // Items to drag
                    if !isDone {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 95), spacing: 8)], spacing: DesignTokens.Spacing.sm) {
                            ForEach(remaining) { item in
                                itemChip(item)
                            }
                        }
                        .padding(.horizontal, DesignTokens.Spacing.xl)
                        .frame(maxHeight: 180)
                    } else {
                        Text("All sorted!")
                            .font(.title2.bold())
                            .foregroundColor(.green)
                            .padding(.top, 20)
                    }

                    // Drop zones
                    HStack(spacing: 20) {
                        dropZone(title: "Physical Change", color: .blue, items: physicalBin, isChemical: false)
                        dropZone(title: "Chemical Change", color: .orange, items: chemicalBin, isChemical: true)
                    }
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                    .frame(maxHeight: 200)
                }

                Group {
                    if isDone {
                        SoftShadowCard(padding: 18) {
                            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                                Label("Great sorting!", systemImage: "star.fill")
                                    .font(.title2.bold())
                                    .foregroundColor(.orange)
                                Text("Physical changes keep the same substance — melting, dissolving, cutting. Chemical changes form new substances — burning, rusting, cooking, digestion.")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: DesignTokens.contentMaxWidth)

                        LookingAheadCallout(
                            title: "Class 11 Chemistry → JEE (Energy + Mass Conservation)",
                            detail: "JEE tests: does mass change in physical vs chemical changes? Answer: NO in both — conservation of mass holds. The difference is *bond energy*: physical change rearranges molecules, chemical change rearranges atoms within molecules. Energy diagrams (activation energy hill, ΔH of formation) become how you tell the two apart on a calorimeter trace."
                        )
                        .frame(maxWidth: DesignTokens.contentMaxWidth)

                        TryAtHomeCallout(
                            title: "Mass-balance experiment",
                            detail: "Weigh an empty kitchen scale. Add an effervescent vitamin tablet to a glass of water on the scale. Note the mass. Drop the tablet in. After fizzing stops, weigh again. Mass DECREASES because CO₂ left the system as gas. Repeat in a closed bottle — mass stays the same (gas trapped). This is Conservation of Mass + the difference between open vs closed system."
                        )
                        .frame(maxWidth: DesignTokens.contentMaxWidth)

                        GotItButton { onComplete(score) }
                            .padding(.bottom, DesignTokens.Spacing.md)
                    } else {
                        SoftShadowCard(padding: 18) {
                            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                                Label("Drag each card", systemImage: SFSymbolCompat.name("hand.draw.fill"))
                                    .font(.title2.bold())
                                Text("Drag each change into the correct bin: Physical Change or Chemical Change.")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
                        .padding(.bottom, DesignTokens.Spacing.md)
                    }
                

                }

                .padding(.horizontal, DesignTokens.Spacing.xl)


            }

            .frame(maxWidth: .infinity)

            .padding(.bottom, DesignTokens.Spacing.md)

        }
        .overlay(
            Group {
                if showConfetti {
                    ParticleEmitter(isActive: true, particleCount: min(40, HardwareTier.particleBudget), duration: 1.5)
                        .allowsHitTesting(false)
                        .ignoresSafeArea()
                }
            }
        )
    }

    // MARK: - Item chip with DragGesture

    private func itemChip(_ item: ChangeItem) -> some View {
        let offset = dragOffsets[item.id] ?? .zero
        let isShaking = shakeId == item.id

        return VStack(spacing: DesignTokens.Spacing.xxs) {
            Text(item.emoji)
                .font(.title2)
            Text(item.label)
                .font(.caption2.weight(.medium))
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(width: 92, height: 68)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.md, style: .continuous)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.md, style: .continuous)
                .strokeBorder(.gray.opacity(0.25), lineWidth: 1)
        )
        .shadow(color: .black.opacity(draggingId == item.id ? 0.25 : 0), radius: 12, x: 0, y: 6)
        .scaleEffect(draggingId == item.id ? 1.08 : 1.0)
        .offset(offset)
        .offset(x: isShaking ? -6 : 0)
        .zIndex(draggingId == item.id ? 100 : 0)
        .gesture(
            DragGesture(coordinateSpace: .global)
                .onChanged { val in
                    draggingId = item.id
                    dragOffsets[item.id] = val.translation
                }
                .onEnded { val in
                    let dropPt = val.location
                    handleDrop(item, at: dropPt)
                    dragOffsets[item.id] = .zero
                    draggingId = nil
                }
        )
        .accessibilityLabel("\(item.label). Drag to Physical or Chemical zone.")
        .accessibilityAction(named: "Place in Physical") { handleDrop(item, inChemical: false) }
        .accessibilityAction(named: "Place in Chemical") { handleDrop(item, inChemical: true) }
    }

    // MARK: - Drop zone

    private func dropZone(title: String, color: Color, items: [ChangeItem], isChemical: Bool) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundColor(color)

            let cols = [GridItem(.adaptive(minimum: 60), spacing: 4)]
            LazyVGrid(columns: cols, spacing: DesignTokens.Spacing.xs) {
                ForEach(items) { m in
                    Text("\(m.emoji) \(m.label)")
                        .font(.caption2)
                        .padding(DesignTokens.Spacing.xs)
                        .background(color.opacity(0.1))
                        .cornerRadius(6)
                }
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card, style: .continuous)
                .fill(color.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card, style: .continuous)
                .strokeBorder(color.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
        )
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        let frame = geo.frame(in: .global)
                        if isChemical { chemicalRect = frame }
                        else { physicalRect = frame }
                    }
                    .onChange(of: geo.size) { _ in
                        let frame = geo.frame(in: .global)
                        if isChemical { chemicalRect = frame }
                        else { physicalRect = frame }
                    }
            }
        )
        .accessibilityLabel("\(title) zone with \(items.count) items")
    }

    // MARK: - Drop logic

    private func handleDrop(_ item: ChangeItem, at point: CGPoint) {
        let inPhysical = physicalRect.contains(point)
        let inChemical = chemicalRect.contains(point)
        guard inPhysical || inChemical else { return }
        handleDrop(item, inChemical: inChemical)
    }

    private func handleDrop(_ item: ChangeItem, inChemical: Bool) {
        let correct = (inChemical && item.isChemical) || (!inChemical && !item.isChemical)

        if correct {
            score += 1
            withAnimationRespectingReduceMotion(.easeInOut(duration: 0.25)) {
                remaining.removeAll { $0.id == item.id }
                if item.isChemical { chemicalBin.append(item) }
                else { physicalBin.append(item) }
            }
            showConfetti = true
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 1_500_000_000)
                showConfetti = false
            }
        } else {
            shakeId = item.id
            if !reduceMotion {
                withAnimationRespectingReduceMotion(.spring(response: 0.15, dampingFraction: 0.3)) {
                    shakeId = item.id
                }
            }
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: DiscoverTiming.settleDelayNs)
                shakeId = nil
            }
        }
    }
}
