import SwiftUI

/// Scene 6 — Adaptation Match Game.
/// Drag-and-drop: 6 animals matched to 6 adaptations. Score out of 12 (2 per correct match).
/// Uses DragGesture with zone rect tracking.

struct Scene6_AdaptationMatchGame: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    private struct MatchPair: Identifiable {
        let id: Int
        let animal: String
        let adaptation: String
    }

    private static let pairs: [MatchPair] = [
        MatchPair(id: 0, animal: "Polar Bear", adaptation: "Thick blubber"),
        MatchPair(id: 1, animal: "Camel", adaptation: "Hump stores fat"),
        MatchPair(id: 2, animal: "Toucan", adaptation: "Large beak for cooling"),
        MatchPair(id: 3, animal: "Penguin", adaptation: "Huddling behaviour"),
        MatchPair(id: 4, animal: "Elephant", adaptation: "Large ears for cooling"),
        MatchPair(id: 5, animal: "Arctic Fox", adaptation: "White winter coat"),
    ]

    @State private var animalOrder: [MatchPair]
    @State private var adaptationOrder: [MatchPair]
    @State private var dragOffsets: [Int: CGSize] = [:]
    @State private var adaptationRects: [Int: CGRect] = [:]
    @State private var matched: Set<Int> = []
    @State private var score: Int = 0
    @State private var shakeId: Int? = nil
    @State private var showConfetti = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(pack: SubjectPack, chapter: Chapter, onComplete: @escaping (Int) -> Void) {
        self.pack = pack
        self.chapter = chapter
        self.onComplete = onComplete
        _animalOrder = State(initialValue: Self.pairs.shuffled())
        _adaptationOrder = State(initialValue: Self.pairs.shuffled())
    }

    private var isDone: Bool { matched.count == Self.pairs.count }

    var body: some View {
        // Refactored ZStack-overlap pattern to ScrollView+VStack.
        // Drag-and-drop preserves global-coordinate hit testing.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                VStack(spacing: 14) {
                    HStack {
                        Spacer()
                        Text("Score: \(score) / 12")
                            .font(.headline.monospacedDigit())
                            .foregroundColor(Color.compatIndigo)
                            .padding(.trailing, DesignTokens.Spacing.xl)
                            .padding(.top, DesignTokens.Spacing.sm)
                    }

                    if !isDone {
                        HStack(alignment: .top, spacing: 40) {
                            // Animals (draggable)
                            VStack(spacing: 10) {
                                Text("Animals")
                                    .font(.headline)
                                    .foregroundColor(DesignTokens.BrandColor.tryAtHome)
                                ForEach(animalOrder) { pair in
                                    if matched.contains(pair.id) {
                                        matchedChip(pair.animal, color: .green)
                                    } else {
                                        draggableAnimalChip(pair)
                                    }
                                }
                            }

                            // Adaptations (drop targets)
                            VStack(spacing: 10) {
                                Text("Adaptations")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                ForEach(adaptationOrder) { pair in
                                    if matched.contains(pair.id) {
                                        matchedChip(pair.adaptation, color: .green)
                                    } else {
                                        adaptationTarget(pair)
                                    }
                                }
                            }
                        }
                    } else {
                        Text("All matched!")
                            .font(.title2.bold())
                            .foregroundColor(.green)
                            .padding(.top, 20)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                Group {
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            Label(isDone ? "Great matching!" : "Match Animals to Adaptations",
                                  systemImage: isDone ? "star.fill" : "arrow.left.arrow.right")
                                .font(.title2.bold())
                                .foregroundColor(isDone ? .orange : .primary)
                            Text(isDone
                                 ? "Every animal has unique adaptations that help it survive in its climate. You matched all 6 correctly!"
                                 : "Drag each animal on the left to its matching adaptation on the right. Each correct match earns 2 points.")
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    LookingAheadCallout(
                        title: "Class 12 Biology → NEET (Natural Selection)",
                        detail: "Each match you just made is a *natural-selection success story*: random variation in ancestors → some variants survived their habitat → those variants reproduced more → species drifted in that direction. NEET asks 'is adaptation goal-directed?' — NO, it's the residue of survival. Darwin's *On the Origin of Species* explains the mechanism Class 12 dissects formally."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    TryAtHomeCallout(
                        title: "Spot adaptations near your home",
                        detail: "Walk through a local park. Make a list: a city pigeon (eats anything → urban), a cactus (waxy + thorny → drought), a stray dog (matted ear hair → mosquito repellent), a banyan tree (aerial roots → support its massive canopy). Every organism in plain sight is an adaptation portfolio. Class-12 ecologists publish papers on what you see in 20 minutes."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    if isDone {
                        GotItButton { onComplete(score) }
                            .padding(.bottom, DesignTokens.Spacing.md)
                    }
                

                }

                .padding(.horizontal, DesignTokens.Spacing.xl)

                if showConfetti {
                    ParticleEmitter(isActive: true, particleCount: min(40, HardwareTier.particleBudget), duration: 1.5)
                        .allowsHitTesting(false)
                        .ignoresSafeArea()
                }
            

            }

            .frame(maxWidth: .infinity)

            .padding(.bottom, DesignTokens.Spacing.md)

        }
    }

    // MARK: - Draggable animal chip

    private func draggableAnimalChip(_ pair: MatchPair) -> some View {
        let offset = dragOffsets[pair.id] ?? .zero
        let isShaking = shakeId == pair.id

        return Text(pair.animal)
            .font(.body.weight(.medium))
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .frame(minWidth: 140)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(.orange.opacity(0.4), lineWidth: 1.5)
            )
            .shadow(color: .black.opacity(offset != .zero ? 0.25 : 0), radius: 12, x: 0, y: 6)
            .scaleEffect(offset != .zero ? 1.08 : 1.0)
            .offset(offset)
            .offset(x: isShaking ? -6 : 0)
            .zIndex(offset == .zero ? 0 : 10)
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged { val in
                        dragOffsets[pair.id] = val.translation
                    }
                    .onEnded { val in
                        handleDrop(pair, at: val.location)
                        dragOffsets[pair.id] = .zero
                    }
            )
            .accessibilityLabel("\(pair.animal). Drag to matching adaptation.")
    }

    // MARK: - Adaptation target

    private func adaptationTarget(_ pair: MatchPair) -> some View {
        Text(pair.adaptation)
            .font(.body.weight(.medium))
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .frame(minWidth: 180)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(.blue.opacity(0.3), style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
            )
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear { adaptationRects[pair.id] = geo.frame(in: .global) }
                        .onChange(of: geo.size) { _ in adaptationRects[pair.id] = geo.frame(in: .global) }
                }
            )
            .accessibilityLabel("\(pair.adaptation) drop target")
    }

    // MARK: - Matched chip

    private func matchedChip(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.body.weight(.medium))
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .frame(minWidth: 140)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(color.opacity(0.12))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(color.opacity(0.4), lineWidth: 1.5)
            )
    }

    // MARK: - Drop logic

    private func handleDrop(_ animalPair: MatchPair, at point: CGPoint) {
        // Find which adaptation zone the drop landed in
        for (adaptId, rect) in adaptationRects {
            guard rect.contains(point) else { continue }
            guard !matched.contains(adaptId) else { continue }

            if adaptId == animalPair.id {
                // Correct match
                score += 2
                _ = withAnimationRespectingReduceMotion(.easeInOut(duration: 0.25)) {
                    matched.insert(animalPair.id)
                }
                showConfetti = true
                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 1_500_000_000)
                    showConfetti = false
                }
            } else {
                // Wrong match — shake
                shakeId = animalPair.id
                if !reduceMotion {
                    withAnimationRespectingReduceMotion(.spring(response: 0.15, dampingFraction: 0.3)) {
                        shakeId = animalPair.id
                    }
                }
                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 400_000_000)
                    shakeId = nil
                }
            }
            return
        }
    }
}
