import SwiftUI

/// Scene 1 — The Mouth Lab.
///
/// A semi-circular jaw drawn with Path, 32 teeth visible (16 upper + 16 lower)
/// categorized as incisors, canines, premolars, molars. Tap each tooth to
/// highlight and show its name and role. A toggle shows comparative animal teeth
/// (lion's jaw). Pulls text from ch02_t01_c03.
///
/// Big Sur (macOS 11) compatible — both jaw diagrams now use a ZStack of
/// stroked arc Paths + RoundedRectangle tooth shapes instead of a Canvas.
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
                            .foregroundColor(.secondary)
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
                                .foregroundColor(.orange)
                            Text(teethExplanation)
                                .font(.body)
                                .foregroundColor(.primary)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

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

/// Human jaw — 32 teeth arranged around an upper + lower arc. The old
/// Canvas-based version drew everything in a single GraphicsContext;
/// here each tooth is a positioned RoundedRectangle so taps can be wired
/// without recomputing geometry. Geometry mirrors the old code.
struct HumanJawDiagram: View {
    @Binding var selectedTooth: Int?
    private let center = CGPoint(x: 200, y: 100)
    private let radius: CGFloat = 80

    var body: some View {
        ZStack(alignment: .topLeading) {
            JawArc(center: center, radius: radius, upper: true)
                .stroke(Color.gray.opacity(0.5), lineWidth: 3)
            JawArc(center: center, radius: radius, upper: false)
                .stroke(Color.gray.opacity(0.5), lineWidth: 3)

            ForEach(0..<32, id: \.self) { idx in
                let pos = toothPosition(idx)
                ToothShapeView(isSelected: selectedTooth == idx)
                    .frame(width: 12, height: 20)
                    .position(x: pos.x, y: pos.y)
                    .onTapGesture { selectedTooth = idx }
            }
        }
    }

    private func toothPosition(_ index: Int) -> CGPoint {
        let inLowerJaw = index >= 16
        let i = index % 16
        let angleDeg = CGFloat(i) * (180 / 16)
        let radians = angleDeg * .pi / 180
        let x = center.x + radius * cos(radians)
        let y = inLowerJaw
            ? center.y + radius * sin(radians)
            : center.y - radius * sin(radians)
        return CGPoint(x: x, y: y)
    }
}

/// A single tooth rendered as a rounded rect with selection highlight.
private struct ToothShapeView: View {
    let isSelected: Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(isSelected ? Color.yellow : Color.white)
            RoundedRectangle(cornerRadius: 2)
                .stroke(isSelected ? Color.orange : Color.gray,
                        lineWidth: isSelected ? 2 : 1)
        }
    }
}

/// Half-circle arc used for the upper and lower jaw outlines.
struct JawArc: Shape {
    let center: CGPoint
    let radius: CGFloat
    /// `true` = top half (start 180°, end 0° clockwise=false);
    /// `false` = bottom half (start 0°, end 180° clockwise=false).
    let upper: Bool

    func path(in rect: CGRect) -> Path {
        var p = Path()
        if upper {
            p.addArc(center: center, radius: radius,
                     startAngle: .degrees(180), endAngle: .degrees(0),
                     clockwise: false)
        } else {
            p.addArc(center: center, radius: radius,
                     startAngle: .degrees(0), endAngle: .degrees(180),
                     clockwise: false)
        }
        return p
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
                    .foregroundColor(.orange)
                Text(tooth)
                    .font(.body.weight(.semibold))
                    .foregroundColor(.primary)
                Spacer()
            }
        }
        .transition(.scale.combined(with: .opacity))
    }
}

// MARK: - Lion Jaw Diagram

/// Lion jaw — six teeth along the upper arc, with enlarged canines at
/// positions 1 and 4. Rebuilt with Shape views.
struct LionJawDiagram: View {
    private let center = CGPoint(x: 200, y: 100)
    private let radius: CGFloat = 70

    var body: some View {
        ZStack(alignment: .topLeading) {
            JawArc(center: center, radius: radius, upper: true)
                .stroke(Color.red.opacity(0.6), lineWidth: 4)
            JawArc(center: center, radius: radius, upper: false)
                .stroke(Color.red.opacity(0.6), lineWidth: 4)

            ForEach(0..<6, id: \.self) { i in
                let angleDeg = CGFloat(i) * (180 / 6)
                let radians = angleDeg * .pi / 180
                let x = center.x + radius * cos(radians)
                let y = center.y - radius * sin(radians)
                let size: CGFloat = (i == 1 || i == 4) ? 20 : 14
                ZStack {
                    RoundedRectangle(cornerRadius: 2).fill(Color(NSColor.controlBackgroundColor))
                    RoundedRectangle(cornerRadius: 2).stroke(Color.gray, lineWidth: 1)
                }
                .frame(width: 8, height: size)
                .position(x: x, y: y)
            }
        }
    }
}
