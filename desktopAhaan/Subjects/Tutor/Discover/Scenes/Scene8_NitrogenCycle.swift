import SwiftUI

/// Scene 8 — The Nitrogen Cycle. Four nodes with arrows between them. Tap an
/// arrow to read what happens along that step. When all four arrows have been
/// tapped, a final question slides in.

struct Scene8_NitrogenCycle: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var visited: Set<NCArrow> = []
    @State private var selected: NCArrow? = nil
    @State private var answerRevealed = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var allTapped: Bool { visited.count == NCArrow.allCases.count }

    enum NCArrow: String, CaseIterable, Identifiable {
        case airSoil = "air_soil"
        case soilPlant = "soil_plant"
        case plantAnimal = "plant_animal"
        case animalSoil = "animal_soil"
        var id: String { rawValue }
        var label: String {
            switch self {
            case .airSoil:    return "⚡ Air → Soil"
            case .soilPlant:  return "🌱 Soil → Plant"
            case .plantAnimal:return "🍽️ Plant → Animal"
            case .animalSoil: return "🍂 Animal → Soil"
            }
        }
        var explanation: String {
            switch self {
            case .airSoil:
                return "Lightning and Rhizobium bacteria fix nitrogen from the air into the soil as nitrate."
            case .soilPlant:
                return "Plants absorb nitrogen from the soil through their roots, mostly as nitrate."
            case .plantAnimal:
                return "When animals eat plants, the nitrogen moves into animal proteins."
            case .animalSoil:
                return "Decomposers break down dung and dead bodies, returning nitrogen to the soil."
            }
        }
    }

    private var question: String {
        pack.questionIndex["ch01_t02_q04"]?.prompt
            ?? "Write three methods by which nitrogen in the soil can be replenished."
    }
    private var answer: String {
        pack.questionIndex["ch01_t02_q04"]?.answer
            ?? "1) Lightning fixes atmospheric N₂ into nitrate. 2) Rhizobium in legume root nodules fixes N₂ biologically. 3) Decomposition of organic matter (manure, dead bodies) returns nitrogen to the soil."
    }

    var body: some View {
        VStack(spacing: 14) {
            Text("The Nitrogen Cycle")
                .font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .padding(.top, 18)
            Text("Tap each arrow to see what happens. Finish all four to unlock the question.")
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

            // The diagram
            ZStack {
                GeometryReader { geo in
                    let w = geo.size.width
                    let h = geo.size.height
                    let air = CGPoint(x: w * 0.5,  y: h * 0.12)
                    let plant = CGPoint(x: w * 0.85, y: h * 0.5)
                    let animal = CGPoint(x: w * 0.5,  y: h * 0.88)
                    let soil = CGPoint(x: w * 0.15, y: h * 0.5)

                    // Arrows
                    arrow(.airSoil,     from: air,    to: soil,   curve: .leftBend)
                    arrow(.soilPlant,   from: soil,   to: plant,  curve: .topBend)
                    arrow(.plantAnimal, from: plant,  to: animal, curve: .rightBend)
                    arrow(.animalSoil,  from: animal, to: soil,   curve: .bottomBend)

                    // Nodes
                    node(at: air,    emoji: "☁️", label: "Air (N₂)")
                    node(at: plant,  emoji: "🌱", label: "Plant")
                    node(at: animal, emoji: "🐄", label: "Animal")
                    node(at: soil,   emoji: "🌍", label: "Soil")
                }
            }
            .frame(maxWidth: 560, maxHeight: 320)

            // Selected explanation
            SoftShadowCard(padding: 14) {
                if let sel = selected {
                    HStack(alignment: .top, spacing: 12) {
                        Text(sel.label).font(.title3.bold()).foregroundColor(Color.compatIndigo)
                        Spacer(minLength: 0)
                    }
                    Text(sel.explanation).font(.callout).padding(.top, 4)
                } else {
                    Label("Tap any arrow on the diagram.", systemImage: SFSymbolCompat.name("hand.tap.fill"))
                        .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }
            }
            .frame(maxWidth: 560)

            if allTapped {
                SoftShadowCard(padding: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Quick check", systemImage: "questionmark.circle.fill")
                            .font(.headline).foregroundColor(.green)
                        Text(question).font(.body)
                        if answerRevealed {
                            Divider().padding(.vertical, 4)
                            Text(answer)
                                .font(.callout)
                                .foregroundColor(DesignTokens.BrandColor.canvasText)
                                .padding(.top, 2)
                        }
                        HStack {
                            Button(answerRevealed ? "Hide answer" : "Show answer") {
                                withAnimation { answerRevealed.toggle() }
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
                .frame(maxWidth: 560)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            LookingAheadCallout(
                title: "Class 12 Chemistry + Biology → JEE / NEET",
                detail: "The natural N-cycle you just walked through is one half. The other half humans built: the Haber-Bosch process — combining N₂ from the air with H₂ at 400°C and 200 atmospheres to make ammonia. JEE Chemistry asks the thermodynamics. NEET Biology asks how the resulting fertiliser, applied to soil, can over-feed algae in rivers downstream (eutrophication) and choke the water of oxygen."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Read a fertiliser bag",
                detail: "Any kitchen-garden fertiliser bag has three numbers, e.g. 10-26-26. Those are %N, %P₂O₅, %K₂O — the NPK ratio. High first number = leafy growth (nitrogen). High second = root + flower (phosphorus). High third = fruit + sturdiness (potassium). Match the numbers to what your plant needs and you're farming chemistry."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            VStack(spacing: 4) {
                GotItButton(action: onComplete)
                    .disabled(!allTapped)
                    .opacity(allTapped ? 1 : 0.55)
                if !allTapped {
                    Text("Tap all steps to continue")
                        .font(.caption2)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }
            }
            .padding(.bottom, 12)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Helpers

    private enum CurveStyle { case leftBend, topBend, rightBend, bottomBend }

    @ViewBuilder
    private func arrow(_ kind: NCArrow, from: CGPoint, to: CGPoint, curve: CurveStyle) -> some View {
        let visited = visited.contains(kind)
        let isSelected = selected == kind
        let progress: CGFloat = (visited || isSelected) ? 1 : 0.65
        let mid = controlPoint(from: from, to: to, curve: curve)

        ZStack {
            Path { p in
                p.move(to: from)
                p.addQuadCurve(to: to, control: mid)
            }
            .trim(from: 0, to: progress)
            .stroke(
                visited ? Color.green : (isSelected ? Color.compatIndigo : Color.gray.opacity(0.5)),
                style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: visited ? [] : [6, 4])
            )

            // Tappable label sits at the mid-point
            Button {
                withAnimation(reduceMotion ? .none : .easeInOut) {
                    selected = kind
                    self.visited.insert(kind)
                }
            } label: {
                Text(kind.label)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(visited ? Color.green.opacity(0.18) : Color.compatIndigo.opacity(0.12))
                    )
                    .foregroundColor(visited ? .green : Color.compatIndigo)
            }
            .buttonStyle(.plain)
            .position(mid)
            .accessibilityLabel("Show information about \(kind.label)")
        }
    }

    private func controlPoint(from: CGPoint, to: CGPoint, curve: CurveStyle) -> CGPoint {
        let mx = (from.x + to.x) / 2
        let my = (from.y + to.y) / 2
        switch curve {
        case .leftBend:    return CGPoint(x: mx - 60, y: my)
        case .topBend:     return CGPoint(x: mx,      y: my - 50)
        case .rightBend:   return CGPoint(x: mx + 60, y: my)
        case .bottomBend:  return CGPoint(x: mx,      y: my + 50)
        }
    }

    @ViewBuilder
    private func node(at p: CGPoint, emoji: String, label: String) -> some View {
        VStack(spacing: 2) {
            Circle()
                .fill(Color(NSColor.windowBackgroundColor))
                .frame(width: 64, height: 64)
                .overlay(Text(emoji).font(.system(size: 32)))
                .overlay(Circle().strokeBorder(Color.compatIndigo.opacity(0.4), lineWidth: 2))
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
        }
        .position(p)
    }
}
