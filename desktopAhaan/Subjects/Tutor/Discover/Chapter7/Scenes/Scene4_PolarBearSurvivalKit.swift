import SwiftUI

/// Scene 4 — Polar Bear Survival Kit.
/// A polar bear with labeled adaptations. Tap each label for explanation.
@available(macOS 12, *)
struct Scene4_PolarBearSurvivalKit: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var selectedAdaptation: Int? = nil
    @State private var tappedAdaptations: Set<Int> = []
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private struct Adaptation: Identifiable {
        let id: Int
        let name: String
        let symbol: String
        let position: CGPoint  // fraction of canvas
        let detail: String
    }

    private let adaptations: [Adaptation] = [
        Adaptation(id: 0, name: "Thick Fur", symbol: "circle.grid.cross.fill",
                   position: CGPoint(x: 0.5, y: 0.25),
                   detail: "Two layers of thick fur trap air for insulation. The outer layer is oily and water-repellent, keeping the bear dry after swimming in icy water."),
        Adaptation(id: 1, name: "Blubber Layer", symbol: "circle.fill",
                   position: CGPoint(x: 0.3, y: 0.45),
                   detail: "A thick layer of fat (blubber) under the skin — up to 11 cm thick — stores energy and provides insulation against freezing Arctic temperatures."),
        Adaptation(id: 2, name: "White Camouflage", symbol: "eye.fill",
                   position: CGPoint(x: 0.7, y: 0.3),
                   detail: "White fur blends with snow and ice, helping polar bears sneak up on seals. Their fur is actually transparent — it only looks white because it reflects light!"),
        Adaptation(id: 3, name: "Small Ears", symbol: "ear.fill",
                   position: CGPoint(x: 0.6, y: 0.15),
                   detail: "Small ears mean less surface area exposed to the cold. This reduces heat loss. Compare with an elephant's huge ears that radiate heat away!"),
        Adaptation(id: 4, name: "Large Paws", symbol: "pawprint.fill",
                   position: CGPoint(x: 0.35, y: 0.7),
                   detail: "Wide, flat paws act like snowshoes, spreading body weight over thin ice. Fur on the soles provides grip on slippery surfaces and insulation from the cold ground."),
        Adaptation(id: 5, name: "Black Skin", symbol: "circle.inset.filled",
                   position: CGPoint(x: 0.65, y: 0.55),
                   detail: "Under all that white fur, polar bears have jet-black skin. Black absorbs heat from the sun more efficiently, helping them stay warm in the Arctic."),
    ]

    private var allTapped: Bool { tappedAdaptations.count == adaptations.count }

    var body: some View {
        GeometryReader { _ in
            ZStack {
                mainColumn
                bottomOverlay
            }
        }
    }

    @ViewBuilder
    private var mainColumn: some View {
        VStack(spacing: 12) {
            Text("Polar Bear Survival Kit")
                .font(.title2.bold())
                .padding(.top, 14)

            Text("\(tappedAdaptations.count) / \(adaptations.count) adaptations explored")
                .font(.caption.weight(.medium))
                .foregroundColor(.secondary)

            bearDiagram
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
    }

    @ViewBuilder
    private var bearDiagram: some View {
        ZStack {
            bearCanvas
                .frame(maxWidth: 400, maxHeight: 280)

            ForEach(adaptations) { adapt in
                adaptationLabel(adapt)
            }
        }
        .frame(maxWidth: 400, maxHeight: 280)
        .background(bearDiagramBackground)
        .overlay(bearDiagramBorder)
    }

    private var bearCanvas: some View {
        Canvas { ctx, size in
            let bodyRect = CGRect(x: size.width * 0.25, y: size.height * 0.3,
                                  width: size.width * 0.5, height: size.height * 0.45)
            ctx.fill(Path(ellipseIn: bodyRect), with: .color(.white.opacity(0.9)))
            ctx.stroke(Path(ellipseIn: bodyRect), with: .color(.gray.opacity(0.3)), lineWidth: 1.5)

            let headRect = CGRect(x: size.width * 0.38, y: size.height * 0.08,
                                  width: size.width * 0.24, height: size.height * 0.28)
            ctx.fill(Path(ellipseIn: headRect), with: .color(.white.opacity(0.9)))
            ctx.stroke(Path(ellipseIn: headRect), with: .color(.gray.opacity(0.3)), lineWidth: 1.5)

            let eyeSize: CGFloat = 6
            let leftEye = CGRect(x: size.width * 0.44, y: size.height * 0.18, width: eyeSize, height: eyeSize)
            let rightEye = CGRect(x: size.width * 0.52, y: size.height * 0.18, width: eyeSize, height: eyeSize)
            ctx.fill(Path(ellipseIn: leftEye), with: .color(.black))
            ctx.fill(Path(ellipseIn: rightEye), with: .color(.black))

            let nose = CGRect(x: size.width * 0.475, y: size.height * 0.24, width: 10, height: 7)
            ctx.fill(Path(ellipseIn: nose), with: .color(.black))

            let paw1 = CGRect(x: size.width * 0.28, y: size.height * 0.68, width: size.width * 0.12, height: size.height * 0.12)
            let paw2 = CGRect(x: size.width * 0.6, y: size.height * 0.68, width: size.width * 0.12, height: size.height * 0.12)
            ctx.fill(Path(ellipseIn: paw1), with: .color(.white.opacity(0.9)))
            ctx.stroke(Path(ellipseIn: paw1), with: .color(.gray.opacity(0.3)), lineWidth: 1.5)
            ctx.fill(Path(ellipseIn: paw2), with: .color(.white.opacity(0.9)))
            ctx.stroke(Path(ellipseIn: paw2), with: .color(.gray.opacity(0.3)), lineWidth: 1.5)
        }
    }

    private var bearDiagramBackground: some View {
        RoundedRectangle(cornerRadius: 14)
            .fill(LinearGradient(colors: [Color.compatCyan.opacity(0.15), .blue.opacity(0.08)], startPoint: .top, endPoint: .bottom))
    }

    private var bearDiagramBorder: some View {
        RoundedRectangle(cornerRadius: 14)
            .strokeBorder(.gray.opacity(0.2), lineWidth: 1)
    }

    @ViewBuilder
    private func adaptationLabel(_ adapt: Adaptation) -> some View {
        let isTapped = tappedAdaptations.contains(adapt.id)
        let isSelected = selectedAdaptation == adapt.id
        let bgColor: Color = isSelected
            ? Color.compatIndigo
            : (isTapped ? Color.green.opacity(0.8) : Color.blue.opacity(0.7))

        Button {
            withAnimation(reduceMotion ? .none : .spring()) {
                selectedAdaptation = adapt.id
                tappedAdaptations.insert(adapt.id)
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: adapt.symbol)
                    .font(.caption)
                Text(adapt.name)
                    .font(.caption2.weight(.semibold))
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Capsule().fill(bgColor))
            .foregroundColor(.white)
        }
        .buttonStyle(.plain)
        .position(x: adapt.position.x * 400, y: adapt.position.y * 280)
        .accessibilityLabel("\(adapt.name). \(isTapped ? "Already explored" : "Tap to explore")")
    }

    @ViewBuilder
    private var bottomOverlay: some View {
        VStack(spacing: 14) {
            Spacer()
            detailCard
                .frame(maxWidth: 640)

            if allTapped {
                GotItButton { onComplete() }
                    .padding(.bottom, 12)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(.horizontal, 24)
    }

    @ViewBuilder
    private var detailCard: some View {
        SoftShadowCard(padding: 18) {
            VStack(alignment: .leading, spacing: 8) {
                if let idx = selectedAdaptation, let adapt = adaptations.first(where: { $0.id == idx }) {
                    Label(adapt.name, systemImage: adapt.symbol)
                        .font(.title2.bold())
                    Text(adapt.detail)
                        .font(.body)
                        .lineSpacing(4)
                } else {
                    Label("Polar Bear Adaptations", systemImage: "snowflake")
                        .font(.title2.bold())
                    Text("Polar bears are perfectly adapted to survive in the freezing Arctic. Tap each label on the bear to learn how! Fun fact: penguins also huddle together to share warmth.")
                        .font(.body)
                        .lineSpacing(4)
                }
            }
        }
    }
}
