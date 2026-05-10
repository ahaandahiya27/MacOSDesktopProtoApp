import SwiftUI

/// Scene 1 — The Mouth Lab.
///
/// A semi-circular jaw drawn with Path, 32 teeth visible (16 upper + 16 lower)
/// categorized as incisors, canines, premolars, molars. Tap each tooth to
/// highlight and show its name and role. A toggle shows comparative animal teeth
/// (lion's jaw). Pulls text from ch02_t01_c03.
struct Scene1_TheMouthLab: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var selectedTooth: Int? = nil
    @State private var showAnimalTeeth = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var teethExplanation: String {
        pack.conceptIndex["ch02_t01_c03"]?.explanation(at: .kidFriendly)
            ?? "Different teeth have different jobs. Incisors cut, canines tear, and molars grind your food."
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 16) {
                    HStack {
                        Toggle("Show animal teeth (Lion)", isOn: $showAnimalTeeth)
                            .font(.body)
                    }
                    .padding(.horizontal, 24)

                    if showAnimalTeeth {
                        LionJawDiagram()
                            .frame(height: 200)
                            .padding(.horizontal, 24)
                        Text("A lion's teeth are sharp for tearing meat!")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        HumanJawDiagram(selectedTooth: $selectedTooth)
                            .frame(height: 200)
                            .padding(.horizontal, 24)

                        if let index = selectedTooth {
                            ToothCallout(tooth: teethByType(from: index))
                                .padding(.horizontal, 24)
                        }
                    }

                    Spacer()

                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("The Mouth Lab", systemImage: "mouth.fill")
                                .font(.title2.bold())
                                .foregroundStyle(.orange)
                            Text(teethExplanation)
                                .font(.body)
                                .foregroundStyle(.primary)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: 640)

                    GotItButton { onComplete() }
                        .padding(.bottom, 12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    private func teethByType(from index: Int) -> String {
        let position = index % 8
        switch position {
        case 0...1: return "Incisor — cuts food"
        case 2: return "Canine — tears food"
        case 3...4: return "Premolar — crushes food"
        default: return "Molar — grinds food"
        }
    }
}

// MARK: - Human Jaw Diagram

struct HumanJawDiagram: View {
    @Binding var selectedTooth: Int?

    var body: some View {
        Canvas { context, _ in
            let center = CGPoint(x: 200, y: 100)
            let radius: CGFloat = 80

            // Upper jaw (semi-circular arc)
            var upperPath = Path()
            upperPath.addArc(center: center, radius: radius, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
            context.stroke(
                upperPath,
                with: .color(.gray.opacity(0.5)),
                lineWidth: 3
            )

            // Lower jaw (semi-circular arc)
            var lowerPath = Path()
            lowerPath.addArc(center: center, radius: radius, startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
            context.stroke(
                lowerPath,
                with: .color(.gray.opacity(0.5)),
                lineWidth: 3
            )

            // Draw 32 teeth: 16 upper + 16 lower
            for i in 0..<16 {
                let angle = CGFloat(i) * (180 / 16)
                let radians = angle * .pi / 180
                let x = center.x + radius * cos(radians)
                let y = center.y - radius * sin(radians)
                drawTooth(at: CGPoint(x: x, y: y), index: i, in: &context, isSelected: selectedTooth == i)
            }

            for i in 0..<16 {
                let angle = CGFloat(i) * (180 / 16)
                let radians = angle * .pi / 180
                let x = center.x + radius * cos(radians)
                let y = center.y + radius * sin(radians)
                drawTooth(at: CGPoint(x: x, y: y), index: i + 16, in: &context, isSelected: selectedTooth == (i + 16))
            }
        }
    }

    private func drawTooth(at point: CGPoint, index: Int, in context: inout GraphicsContext, isSelected: Bool) {
        let toothRect = CGRect(x: point.x - 6, y: point.y - 10, width: 12, height: 20)
        let path = Path(roundedRect: toothRect, cornerRadius: 2)
        context.fill(
            path,
            with: .color(isSelected ? .yellow : .white)
        )
        context.stroke(
            path,
            with: .color(isSelected ? .orange : .gray),
            lineWidth: isSelected ? 2 : 1
        )
    }
}

// MARK: - Tooth Callout

struct ToothCallout: View {
    let tooth: String

    var body: some View {
        SoftShadowCard(padding: 14) {
            HStack(spacing: 12) {
                Image(systemName: "arrowshape.left.fill")
                    .font(.title2)
                    .foregroundStyle(.orange)
                Text(tooth)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.primary)
                Spacer()
            }
        }
        .transition(.scale.combined(with: .opacity))
    }
}

// MARK: - Lion Jaw Diagram

struct LionJawDiagram: View {
    var body: some View {
        Canvas { context, _ in
            let center = CGPoint(x: 200, y: 100)
            let radius: CGFloat = 70

            // Upper jaw
            var upperPath = Path()
            upperPath.addArc(center: center, radius: radius, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
            context.stroke(
                upperPath,
                with: .color(.red.opacity(0.6)),
                lineWidth: 4
            )

            // Lower jaw
            var lowerPath = Path()
            lowerPath.addArc(center: center, radius: radius, startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
            context.stroke(
                lowerPath,
                with: .color(.red.opacity(0.6)),
                lineWidth: 4
            )

            // Lion's larger canines and teeth
            for i in 0..<6 {
                let angle = CGFloat(i) * (180 / 6)
                let radians = angle * .pi / 180
                let x = center.x + radius * cos(radians)
                let y = center.y - radius * sin(radians)
                let size: CGFloat = (i == 1 || i == 4) ? 20 : 14 // Larger canines
                let toothRect = CGRect(x: x - 4, y: y - size / 2, width: 8, height: size)
                let path = Path(roundedRect: toothRect, cornerRadius: 2)
                context.fill(path, with: .color(.white))
                context.stroke(path, with: .color(.gray), lineWidth: 1)
            }
        }
    }
}
