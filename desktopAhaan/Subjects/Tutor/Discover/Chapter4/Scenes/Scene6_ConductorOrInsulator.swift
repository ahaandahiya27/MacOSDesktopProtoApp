import SwiftUI

/// Scene 6 — Conductor or Insulator? Drag Game.
/// 12 materials, drag into Good Conductor or Bad Conductor zones.

struct Scene6_ConductorOrInsulator: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    private struct Material: Identifiable {
        let id = UUID()
        let name: String
        let emoji: String
        let isConductor: Bool
    }

    private static let allMaterials: [Material] = [
        Material(name: "Copper", emoji: "🟤", isConductor: true),
        Material(name: "Silver", emoji: "⬜", isConductor: true),
        Material(name: "Steel", emoji: "🔩", isConductor: true),
        Material(name: "Stone", emoji: "🪨", isConductor: true),
        Material(name: "Wood", emoji: "🪵", isConductor: false),
        Material(name: "Bread", emoji: "🍞", isConductor: false),
        Material(name: "Brick", emoji: "🧱", isConductor: false),
        Material(name: "Ice", emoji: "🧊", isConductor: false),
        Material(name: "Water", emoji: "💧", isConductor: false),
        Material(name: "Glass", emoji: "🪟", isConductor: false),
        Material(name: "Wool", emoji: "🧶", isConductor: false),
        Material(name: "Air", emoji: "💨", isConductor: false),
    ]

    @State private var remaining: [Material] = Scene6_ConductorOrInsulator.allMaterials.shuffled()
    @State private var conductorBin: [Material] = []
    @State private var insulatorBin: [Material] = []
    @State private var score: Int = 0
    @State private var dragOffsets: [UUID: CGSize] = [:]
    @State private var shakeId: UUID? = nil
    @State private var showConfetti = false
    @State private var conductorRect: CGRect = .zero
    @State private var insulatorRect: CGRect = .zero
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var isDone: Bool { remaining.isEmpty }

    var body: some View {
        // Refactored ZStack-overlap pattern to ScrollView+VStack.

        // Inner GeometryReader is preserved for size-relative

        // interactive content; cards now sit as siblings below it.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                GeometryReader { geo in

                    ZStack {
                VStack(spacing: DesignTokens.Spacing.md) {
                    // Score
                    HStack {
                        Spacer()
                        Text("Score: \(score) / 12")
                            .font(.headline.monospacedDigit())
                            .foregroundColor(Color.compatIndigo)
                            .padding(.trailing, DesignTokens.Spacing.xl)
                            .padding(.top, DesignTokens.Spacing.sm)
                    }

                    // Materials to drag
                    if !isDone {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 10)], spacing: 10) {
                            ForEach(remaining) { mat in
                                materialChip(mat)
                            }
                        }
                        .padding(.horizontal, DesignTokens.Spacing.xl)
                        .frame(maxHeight: 160)
                    } else {
                        Text("All sorted!")
                            .font(.title2.bold())
                            .foregroundColor(.green)
                            .padding(.top, 20)
                    }

                    // Drop zones
                    HStack(spacing: 20) {
                        dropZone(title: "Good Conductor", color: .orange, items: conductorBin, isConductor: true)
                        dropZone(title: "Bad Conductor", color: .blue, items: insulatorBin, isConductor: false)
                    }
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                    .frame(maxHeight: 200)

                    Spacer()
                }

                

                    }

                }

                .frame(height: 320)

                Group {
                    if isDone {
                        SoftShadowCard(padding: 18) {
                            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                                Label("Great sorting!", systemImage: "star.fill")
                                    .font(.title2.bold())
                                    .foregroundColor(.orange)
                                Text("Metals like copper and silver let heat pass easily — they are conductors. Wood, wool, and air trap heat — they are insulators.")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: DesignTokens.contentMaxWidth)

                        LookingAheadCallout(
                            title: "Class 11 / 12 Physics → JEE",
                            detail: "Conductor vs insulator carries over from heat to electricity in Class 11. The same metals (Cu, Ag) conduct both well, because free electrons carry both energy and charge. JEE asks a classic: graphene and diamond are both pure carbon, so why does graphene conduct and diamond not? The answer is lattice shape. Graphene's flat sheets let electrons move; diamond's rigid cage does not."
                        )
                        .frame(maxWidth: DesignTokens.contentMaxWidth)

                        TryAtHomeCallout(
                            title: "Build a thermos with newspaper",
                            detail: "Wrap an ice cube in dry newspaper (5+ layers). Put a second cube on the table uncovered. Set a 10-minute timer. The newspaper-wrapped cube survives almost intact; the bare one halves. Trapped air between paper fibres = insulation. Same principle as a thermos's vacuum, your sweater's wool, polar-bear fur, double-glazed windows."
                        )
                        .frame(maxWidth: DesignTokens.contentMaxWidth)

                        GotItButton { onComplete(score) }
                            .padding(.bottom, DesignTokens.Spacing.md)
                    } else {
                        SoftShadowCard(padding: 18) {
                            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                                Label("Conductor or Insulator?", systemImage: "arrow.left.arrow.right")
                                    .font(.title2.bold())
                                Text("Drag each material into the correct bin. Good conductors let heat flow easily; bad conductors (insulators) block heat.")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
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

    // MARK: - Material chip with DragGesture

    private func materialChip(_ mat: Material) -> some View {
        let offset = dragOffsets[mat.id] ?? .zero
        let isShaking = shakeId == mat.id

        return VStack(spacing: DesignTokens.Spacing.xxs) {
            Text(mat.emoji)
                .font(.title2)
            Text(mat.name)
                .font(.caption.weight(.medium))
        }
        .frame(width: 86, height: 64)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(.gray.opacity(0.25), lineWidth: 1)
        )
        .shadow(color: .black.opacity(offset != .zero ? 0.25 : 0), radius: 12, x: 0, y: 6)
        .scaleEffect(offset != .zero ? 1.08 : 1.0)
        .offset(offset)
        .offset(x: isShaking ? -6 : 0)
        .zIndex(offset == .zero ? 0 : 10)
        .gesture(
            DragGesture(coordinateSpace: .global)
                .onChanged { val in
                    dragOffsets[mat.id] = val.translation
                }
                .onEnded { val in
                    let dropPt = val.location
                    handleDrop(mat, at: dropPt)
                    dragOffsets[mat.id] = .zero
                }
        )
        .accessibilityLabel("\(mat.name). Drag to conductor or insulator zone.")
    }

    // MARK: - Drop zone

    private func dropZone(title: String, color: Color, items: [Material], isConductor: Bool) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundColor(color)

            let cols = [GridItem(.adaptive(minimum: 60), spacing: 4)]
            LazyVGrid(columns: cols, spacing: 4) {
                ForEach(items) { m in
                    Text("\(m.emoji) \(m.name)")
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
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(color.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(color.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
        )
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        let frame = geo.frame(in: .global)
                        if isConductor { conductorRect = frame }
                        else { insulatorRect = frame }
                    }
                    .onChange(of: geo.size) { _ in
                        let frame = geo.frame(in: .global)
                        if isConductor { conductorRect = frame }
                        else { insulatorRect = frame }
                    }
            }
        )
        .accessibilityLabel("\(title) zone with \(items.count) items")
    }

    // MARK: - Drop logic

    private func handleDrop(_ mat: Material, at point: CGPoint) {
        let droppedInConductor = conductorRect.contains(point)
        let droppedInInsulator = insulatorRect.contains(point)

        guard droppedInConductor || droppedInInsulator else { return }

        let correct = (droppedInConductor && mat.isConductor) || (droppedInInsulator && !mat.isConductor)

        if correct {
            score += 1
            withAnimationRespectingReduceMotion(.easeInOut(duration: 0.25)) {
                remaining.removeAll { $0.id == mat.id }
                if mat.isConductor { conductorBin.append(mat) }
                else { insulatorBin.append(mat) }
            }
            showConfetti = true
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 1_500_000_000)
                showConfetti = false
            }
        } else {
            // Wrong — shake
            shakeId = mat.id
            if !reduceMotion {
                withAnimationRespectingReduceMotion(.spring(response: 0.15, dampingFraction: 0.3)) {
                    shakeId = mat.id
                }
            }
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 400_000_000)
                shakeId = nil
            }
        }
    }
}
