import SwiftUI

// MARK: - Chapter 3 shape diagrams  (Fibre to Fabric — wool & silk)
//
// Pure-SwiftUI schematic diagrams for the four ch03 `shapeDiagram`
// MediaAssets. Big Sur / legacy-GPU rules honoured (compat colours, no
// macOS 12+ APIs, static art).

// MARK: - ch03_wool_process

/// Wool from sheep to yarn as a four-step process flow: shearing → scouring
/// (washing) → sorting → spinning into yarn.
struct WoolProcessDiagram: View {
    private let steps = ["Shearing", "Scouring", "Sorting", "Spinning"]
    var body: some View {
        SDFigure(tint: Color.compatBrown) {
            VStack(spacing: 10) {
                SDLabel(text: "Fleece → yarn", color: Color.compatBrown)
                HStack(spacing: 4) {
                    ForEach(0..<steps.count, id: \.self) { i in
                        stepNode(steps[i], last: i == steps.count - 1)
                    }
                }
                SDLabel(text: "Then weaving / knitting makes fabric")
            }
        }
    }

    private func stepNode(_ title: String, last: Bool) -> some View {
        HStack(spacing: 4) {
            VStack(spacing: 4) {
                Circle()
                    .fill(Color.compatBrown.opacity(0.22))
                    .overlay(Circle().stroke(Color.compatBrown.opacity(0.6), lineWidth: 1.5))
                    .frame(width: 34, height: 34)
                Text(title)
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .fixedSize()
            }
            if !last { SDArrow() }
        }
    }
}

// MARK: - ch03_silkworm_lifecycle

/// The silk moth's life cycle as a ring: egg → larva (caterpillar) → cocoon
/// (pupa) → moth → back to egg. Silk is reeled from the cocoon stage.
struct SilkwormLifecycleDiagram: View {
    private let stages = ["Egg", "Larva", "Cocoon", "Moth"]
    var body: some View {
        SDFigure(tint: .green) {
            GeometryReader { geo in
                let w = geo.size.width, h = geo.size.height
                let cx = w / 2, cy = h / 2
                let r = min(w, h) * 0.34
                ZStack {
                    Circle()
                        .stroke(Color.green.opacity(0.4),
                                style: StrokeStyle(lineWidth: 2, dash: [4, 3]))
                        .frame(width: r * 2, height: r * 2)
                        .position(x: cx, y: cy)
                    SDLabel(text: "Life cycle", color: .green).position(x: cx, y: cy)
                    Group {
                        stageNode(stages[0], x: cx, y: cy - r)
                        stageNode(stages[1], x: cx + r, y: cy)
                        stageNode(stages[2], x: cx, y: cy + r)
                        stageNode(stages[3], x: cx - r, y: cy)
                    }
                }
            }
        }
    }

    private func stageNode(_ title: String, x: CGFloat, y: CGFloat) -> some View {
        VStack(spacing: 2) {
            Circle()
                .fill(Color.green.opacity(0.25))
                .overlay(Circle().stroke(Color.green.opacity(0.6), lineWidth: 1.5))
                .frame(width: 26, height: 26)
            SDLabel(text: title, color: .green)
        }
        .position(x: x, y: y)
    }
}

// MARK: - ch03_polymer_chain

/// A synthetic fibre is a polymer: many small identical units (monomers)
/// joined into a long repeating chain — shown as linked beads.
struct PolymerChainDiagram: View {
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            VStack(spacing: 12) {
                SDLabel(text: "Monomer", color: Color.compatBlue)
                Circle()
                    .fill(Color.compatBlue.opacity(0.3))
                    .overlay(Circle().stroke(Color.compatBlue.opacity(0.65), lineWidth: 1.5))
                    .frame(width: 26, height: 26)
                Image(systemName: SFSymbolCompat.name("arrow.down"))
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color.compatBlue)
                SDLabel(text: "join many → polymer chain", color: Color.compatBlue)
                HStack(spacing: 0) {
                    ForEach(0..<8, id: \.self) { i in
                        bead(showLink: i < 7)
                    }
                }
            }
        }
    }

    private func bead(showLink: Bool) -> some View {
        HStack(spacing: 0) {
            Circle()
                .fill(Color.compatBlue.opacity(0.3))
                .overlay(Circle().stroke(Color.compatBlue.opacity(0.65), lineWidth: 1.5))
                .frame(width: 20, height: 20)
            if showLink {
                Rectangle().fill(Color.compatBlue.opacity(0.5)).frame(width: 8, height: 2.5)
            }
        }
    }
}

// MARK: - ch03_fibre_compare

/// Natural vs synthetic fibres side by side, with everyday examples of each.
struct FibreCompareDiagram: View {
    var body: some View {
        SDFigure(tint: .green) {
            HStack(spacing: 12) {
                column(title: "Natural", tint: .green,
                       items: ["Wool", "Silk", "Cotton", "Jute"])
                Rectangle().fill(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.25)).frame(width: 1)
                column(title: "Synthetic", tint: Color.compatBlue,
                       items: ["Nylon", "Polyester", "Acrylic", "Rayon"])
            }
        }
    }

    private func column(title: String, tint: Color, items: [String]) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            ForEach(0..<items.count, id: \.self) { i in
                SDChip(text: items[i], color: tint)
            }
        }
    }
}
