import SwiftUI

// MARK: - Chapter 5 shape diagrams  (Acids, Bases and Salts)
//
// Pure-SwiftUI schematic diagrams for the four ch05 `shapeDiagram`
// MediaAssets. Big Sur / legacy-GPU rules honoured.

// MARK: - ch05_ph_scale

/// The pH scale 0–14: strong acid (0) through neutral (7, pure water) to
/// strong base (14), drawn as a colour band with markers.
struct PHScaleDiagram: View {
    var body: some View {
        SDFigure(tint: .green) {
            VStack(spacing: 8) {
                HStack {
                    SDLabel(text: "Acidic", color: .red)
                    Spacer()
                    SDLabel(text: "Neutral", color: .green)
                    Spacer()
                    SDLabel(text: "Basic", color: .purple)
                }
                RoundedRectangle(cornerRadius: 6)
                    .fill(LinearGradient(gradient: Gradient(colors: [.red, .orange, .green, .blue, .purple]),
                                         startPoint: .leading, endPoint: .trailing))
                    .frame(height: 26)
                HStack(spacing: 0) {
                    ForEach(0..<15, id: \.self) { n in
                        Text("\(n)")
                            .font(.system(size: 9, weight: n == 7 ? .bold : .regular))
                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                            .frame(maxWidth: .infinity)
                    }
                }
                HStack(spacing: 10) {
                    SDChip(text: "lemon ≈ 2", color: .red)
                    SDChip(text: "water = 7", color: .green)
                    SDChip(text: "soap ≈ 10", color: .purple)
                }
            }
        }
    }
}

// MARK: - ch05_neutralisation

/// Neutralisation: an acid reacts with a base to give a salt and water,
/// cancelling each other's effect.
struct NeutralisationDiagram: View {
    var body: some View {
        SDFigure(tint: .green) {
            VStack(spacing: 14) {
                HStack(spacing: 8) {
                    SDChip(text: "Acid", color: .red)
                    SDPlus()
                    SDChip(text: "Base", color: .purple)
                    SDArrow(color: .green)
                    SDChip(text: "Salt", color: Color.compatBlue)
                    SDPlus()
                    SDChip(text: "Water", color: Color.compatBlue)
                }
                SDLabel(text: "e.g. HCl + NaOH → NaCl + H₂O", color: .green)
                SDLabel(text: "The mixture is no longer acidic or basic")
            }
        }
    }
}

// MARK: - ch05_indicators

/// How common indicators change colour in acids vs bases — the test that
/// tells acids and bases apart.
struct IndicatorsDiagram: View {
    private let rows: [(String, String, Color, String, Color)] = [
        ("Blue litmus", "→ red", .red, "no change", .blue),
        ("Red litmus", "no change", .red, "→ blue", .blue),
        ("Turmeric", "no change", .yellow, "→ red", .red),
        ("China rose", "→ pink", .pink, "→ green", .green)
    ]
    var body: some View {
        SDFigure(tint: .orange) {
            VStack(spacing: 5) {
                HStack {
                    headerCell("Indicator")
                    headerCell("In acid")
                    headerCell("In base")
                }
                ForEach(0..<rows.count, id: \.self) { i in
                    HStack {
                        cell(rows[i].0, tint: DesignTokens.BrandColor.canvasText)
                        cell(rows[i].1, tint: rows[i].2)
                        cell(rows[i].3, tint: rows[i].4)
                    }
                }
            }
        }
    }

    private func headerCell(_ t: String) -> some View {
        Text(t)
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(DesignTokens.BrandColor.canvasText)
            .frame(maxWidth: .infinity)
    }

    private func cell(_ t: String, tint: Color) -> some View {
        Text(t)
            .font(.system(size: 9, weight: .medium))
            .foregroundColor(tint)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 3)
            .background(RoundedRectangle(cornerRadius: 4).fill(tint.opacity(0.12)))
    }
}

// MARK: - ch05_tooth_decay

/// Tooth decay & its cure: bacteria make acid that attacks the enamel;
/// brushing with a basic toothpaste neutralises the acid.
struct ToothDecayDiagram: View {
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            HStack(spacing: 16) {
                VStack(spacing: 6) {
                    ToothBodyShape()
                        .fill(Color.white.opacity(0.92))
                        .overlay(ToothBodyShape().stroke(Color.compatBlue.opacity(0.55), lineWidth: 1.5))
                        .overlay(
                            HStack(spacing: 3) {
                                ForEach(0..<3, id: \.self) { _ in
                                    Circle().fill(Color.red.opacity(0.6)).frame(width: 6, height: 6)
                                }
                            }.offset(y: -10)
                        )
                        .frame(width: 54, height: 64)
                    SDLabel(text: "Acid from bacteria", color: .red)
                }
                VStack(spacing: 8) {
                    Image(systemName: SFSymbolCompat.name("arrow.right"))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.purple)
                    SDChip(text: "Toothpaste (base)", color: .purple)
                    SDLabel(text: "neutralises the acid", color: .green)
                }
            }
        }
    }
}

/// A simple molar crown for the decay figure.
private struct ToothBodyShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let step = rect.width / 3
        p.move(to: CGPoint(x: rect.minX, y: rect.minY + 8))
        for c in 0..<3 {
            let x0 = rect.minX + CGFloat(c) * step
            p.addQuadCurve(to: CGPoint(x: x0 + step, y: rect.minY + 8),
                           control: CGPoint(x: x0 + step / 2, y: rect.minY - 4))
        }
        p.addLine(to: CGPoint(x: rect.maxX - 4, y: rect.maxY))
        p.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.maxY - 6),
                       control: CGPoint(x: rect.midX + 8, y: rect.maxY))
        p.addQuadCurve(to: CGPoint(x: rect.minX + 4, y: rect.maxY),
                       control: CGPoint(x: rect.midX - 8, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}
