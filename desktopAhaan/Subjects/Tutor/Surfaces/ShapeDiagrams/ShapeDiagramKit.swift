import SwiftUI

// MARK: - ShapeDiagramKit
//
// Shared building blocks for the v7 Phase 3 chapter shape diagrams
// (ch02 onward). ch01 keeps its own file-private `DiagramCanvas` /
// `PartLabel`; these are deliberately named `SD*` so the two sets never
// collide at module scope.
//
// Big Sur / legacy-GPU rules honoured: no macOS 12+ APIs, colours via
// Color.compat* / system primaries (never .mint/.teal/.cyan/.indigo/.brown
// raw, never .foregroundColor(.orange/.yellow/.teal)), static geometry only.
// The host MediaAssetView frames each diagram to maxHeight 220, supplies the
// caption + a single VoiceOver label and ignores child a11y, so these are
// decorative figures with small in-figure part labels.

// MARK: - SDFigure (tinted canvas)

/// Soft tinted backdrop + consistent inset shared by every chapter diagram.
struct SDFigure<Content: View>: View {
    let tint: Color
    let content: Content
    init(tint: Color, @ViewBuilder content: () -> Content) {
        self.tint = tint
        self.content = content()
    }
    var body: some View {
        content
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.md).fill(tint.opacity(0.06)))
    }
}

// MARK: - SDLabel (part chip)

/// Small rounded caption chip naming an internal structure.
struct SDLabel: View {
    let text: String
    var color: Color = DesignTokens.BrandColor.canvasText
    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(color)
            .padding(.horizontal, 6).padding(.vertical, DesignTokens.Spacing.xxs)
            .background(RoundedRectangle(cornerRadius: 4).fill(Color.white.opacity(0.82)))
            .fixedSize()
    }
}

// MARK: - SDChip (equation / flow token)

/// A tinted token used in equations and process flows (e.g. "CO₂", "salt").
struct SDChip: View {
    let text: String
    var color: Color = .green
    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(DesignTokens.BrandColor.canvasText)
            .padding(.horizontal, DesignTokens.Spacing.sm).padding(.vertical, 5)
            .background(RoundedRectangle(cornerRadius: 7).fill(color.opacity(0.18)))
            .overlay(RoundedRectangle(cornerRadius: 7).strokeBorder(color.opacity(0.55), lineWidth: 1))
            .fixedSize()
    }
}

// MARK: - SDArrow (directional connector)

/// A bold right-pointing arrow (uses the SF Symbols 2 safe name via compat).
struct SDArrow: View {
    var color: Color = DesignTokens.BrandColor.canvasTextSecondary
    var body: some View {
        Image(systemName: SFSymbolCompat.name("arrow.right"))
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(color)
    }
}

// MARK: - SDPlus

/// A "+" separator for equations / sums.
struct SDPlus: View {
    var body: some View {
        Text("+")
            .font(.headline)
            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
    }
}

// MARK: - Reusable organic shapes

/// A simple pointed leaf / petal blob (two mirrored quad curves).
struct SDLeafShape: InsettableShape {
    var inset: CGFloat = 0
    func inset(by amount: CGFloat) -> SDLeafShape { var s = self; s.inset += amount; return s }
    func path(in rect: CGRect) -> Path {
        let r = rect.insetBy(dx: inset, dy: inset)
        var p = Path()
        p.move(to: CGPoint(x: r.minX, y: r.midY))
        p.addQuadCurve(to: CGPoint(x: r.maxX, y: r.midY), control: CGPoint(x: r.midX, y: r.minY))
        p.addQuadCurve(to: CGPoint(x: r.minX, y: r.midY), control: CGPoint(x: r.midX, y: r.maxY))
        p.closeSubpath()
        return p
    }
}

/// A rounded finger / villus shape: straight sides, domed top, open bottom.
struct SDFingerShape: InsettableShape {
    var inset: CGFloat = 0
    func inset(by amount: CGFloat) -> SDFingerShape { var s = self; s.inset += amount; return s }
    func path(in rect: CGRect) -> Path {
        let r = rect.insetBy(dx: inset, dy: inset)
        var p = Path()
        p.move(to: CGPoint(x: r.minX, y: r.maxY))
        p.addLine(to: CGPoint(x: r.minX, y: r.minY + r.width / 2))
        p.addQuadCurve(to: CGPoint(x: r.maxX, y: r.minY + r.width / 2),
                       control: CGPoint(x: r.midX, y: r.minY - r.width * 0.2))
        p.addLine(to: CGPoint(x: r.maxX, y: r.maxY))
        return p
    }
}
