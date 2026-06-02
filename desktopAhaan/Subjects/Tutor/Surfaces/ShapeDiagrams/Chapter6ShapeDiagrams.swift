import SwiftUI

// MARK: - Chapter 6 shape diagrams  (Physical and Chemical Changes)
//
// Pure-SwiftUI schematic diagrams for the four ch06 `shapeDiagram`
// MediaAssets. Big Sur / legacy-GPU rules honoured.

// MARK: - ch06_physical_vs_chemical

/// The dividing line between the two kinds of change: physical changes are
/// usually reversible and make no new substance; chemical changes make a new
/// substance and are usually hard to reverse.
struct PhysicalVsChemicalDiagram: View {
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            HStack(spacing: 12) {
                column(title: "Physical", tint: Color.compatBlue,
                       note: "no new substance · reversible",
                       items: ["Ice melting", "Tearing paper", "Boiling water"])
                Rectangle().fill(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.25)).frame(width: 1)
                column(title: "Chemical", tint: .red,
                       note: "new substance · hard to reverse",
                       items: ["Burning wood", "Rusting iron", "Cooking food"])
            }
        }
    }

    private func column(title: String, tint: Color, note: String, items: [String]) -> some View {
        VStack(spacing: 6) {
            Text(title).font(.system(size: 12, weight: .bold)).foregroundColor(DesignTokens.BrandColor.canvasText)
            SDLabel(text: note, color: tint)
            ForEach(0..<items.count, id: \.self) { i in
                SDChip(text: items[i], color: tint)
            }
        }
    }
}

// MARK: - ch06_rust_formation

/// Rusting is a chemical change: iron, in the presence of oxygen and water,
/// slowly turns into reddish-brown rust (iron oxide).
struct RustFormationDiagram: View {
    var body: some View {
        SDFigure(tint: Color.compatBrown) {
            VStack(spacing: 14) {
                HStack(spacing: 8) {
                    SDChip(text: "Iron", color: DesignTokens.BrandColor.canvasTextSecondary)
                    SDPlus()
                    SDChip(text: "Oxygen", color: Color.compatBlue)
                    SDPlus()
                    SDChip(text: "Water", color: Color.compatBlue)
                    SDArrow(color: Color.compatBrown)
                    SDChip(text: "Rust", color: Color.compatBrown)
                }
                // A nail with rust patches
                HStack(spacing: 0) {
                    Capsule().fill(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.5))
                        .frame(width: 90, height: 12)
                        .overlay(
                            HStack(spacing: 14) {
                                ForEach(0..<3, id: \.self) { _ in
                                    Circle().fill(Color.compatBrown.opacity(0.7)).frame(width: 9, height: 9)
                                }
                            }
                        )
                    Circle().fill(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.5)).frame(width: 18, height: 18)
                }
                SDLabel(text: "iron + oxygen + water → rust (iron oxide)", color: Color.compatBrown)
            }
        }
    }
}

// MARK: - ch06_crystallization

/// Crystallisation: dissolving a solid in hot water then letting it cool /
/// evaporate leaves regular, pure crystals — a way to purify a substance.
struct CrystallizationDiagram: View {
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            HStack(spacing: 14) {
                beaker(showCrystals: false, caption: "Hot solution")
                Image(systemName: SFSymbolCompat.name("arrow.right"))
                    .font(.system(size: 16, weight: .bold)).foregroundColor(Color.compatBlue)
                beaker(showCrystals: true, caption: "Crystals form")
            }
        }
    }

    private func beaker(showCrystals: Bool, caption: String) -> some View {
        VStack(spacing: 5) {
            ZStack(alignment: .bottom) {
                BeakerShape()
                    .stroke(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.6), lineWidth: 2)
                    .frame(width: 60, height: 70)
                BeakerShape()
                    .fill(Color.compatBlue.opacity(0.18))
                    .frame(width: 60, height: 70)
                if showCrystals {
                    HStack(spacing: 3) {
                        ForEach(0..<4, id: \.self) { _ in
                            DiamondShape().fill(Color.compatBlue.opacity(0.65)).frame(width: 11, height: 11)
                        }
                    }.padding(.bottom, 6)
                } else {
                    HStack(spacing: 6) {
                        ForEach(0..<5, id: \.self) { _ in
                            Circle().fill(Color.compatBlue.opacity(0.4)).frame(width: 4, height: 4)
                        }
                    }.padding(.bottom, 20)
                }
            }
            SDLabel(text: caption, color: Color.compatBlue)
        }
    }
}

/// A simple beaker outline (open top, slight lip).
private struct BeakerShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX + 3, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY + 6))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - 6))
        p.addQuadCurve(to: CGPoint(x: rect.minX + 6, y: rect.maxY),
                       control: CGPoint(x: rect.minX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.maxX - 6, y: rect.maxY))
        p.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY - 6),
                       control: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + 6))
        p.addLine(to: CGPoint(x: rect.maxX - 3, y: rect.minY))
        return p
    }
}

/// A small diamond (crystal) glyph.
private struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        p.closeSubpath()
        return p
    }
}

// MARK: - ch06_balanced_equation

/// A balanced equation has the SAME number of each atom on both sides — none
/// are created or destroyed. Shown for 2H₂ + O₂ → 2H₂O.
struct BalancedEquationDiagram: View {
    var body: some View {
        SDFigure(tint: .green) {
            VStack(spacing: 12) {
                HStack(spacing: 6) {
                    SDChip(text: "2 H₂", color: Color.compatBlue)
                    SDPlus()
                    SDChip(text: "O₂", color: .red)
                    SDArrow(color: .green)
                    SDChip(text: "2 H₂O", color: .green)
                }
                HStack(spacing: 18) {
                    atomTally("H", left: 4, right: 4, color: Color.compatBlue)
                    atomTally("O", left: 2, right: 2, color: .red)
                }
                SDLabel(text: "Same atoms each side → balanced", color: .green)
            }
        }
    }

    private func atomTally(_ symbol: String, left: Int, right: Int, color: Color) -> some View {
        VStack(spacing: 3) {
            Text("\(symbol):  \(left) = \(right)")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            HStack(spacing: 2) {
                ForEach(0..<left, id: \.self) { _ in
                    Circle().fill(color.opacity(0.6)).frame(width: 7, height: 7)
                }
            }
        }
    }
}
