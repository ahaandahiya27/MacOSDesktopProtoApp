import SwiftUI

/// Tap-to-reveal labelled diagram (G11 in the issue taxonomy / M8
/// module type). A SwiftUI shape or system-symbol base sits behind a
/// transparent overlay of numbered hotspots. Tapping a hotspot reveals
/// its label + one-line explanation.
///
/// This is intentionally NOT bitmap-image based — we draw the base
/// using SF Symbols or vector shapes so the same component works on
/// the Big Sur iMac without bundling rendered PNG diagrams (which
/// would also be hard to localise / theme).
///
/// Pattern:
///
///     HotspotDiagram(
///         title: "Parts of a flower",
///         baseSymbol: "leaf.fill",
///         baseColor: .pink,
///         hotspots: [
///             .init(x: 0.50, y: 0.20, label: "Petal",
///                   detail: "Coloured to attract pollinators."),
///             .init(x: 0.50, y: 0.50, label: "Stamen",
///                   detail: "Male part; makes pollen."),
///             .init(x: 0.50, y: 0.70, label: "Pistil",
///                   detail: "Female part; receives pollen.")
///         ]
///     )
///
/// `x` and `y` are unit coordinates (0.0–1.0) inside the diagram's
/// frame so positions scale with the container.
///
/// macOS 11 (Big Sur) compatible — pure SwiftUI + SF Symbols. No
/// `Canvas`, no `Layout`, no macOS 12+ APIs.
struct HotspotDiagram: View {
    let title: String
    /// SF Symbol name for the diagram backdrop. Use one with a clear
    /// silhouette (leaf.fill, drop.fill, lungs.fill, gear, …).
    let baseSymbol: String
    let baseColor: Color
    let hotspots: [Hotspot]
    /// Square diagram size in points. Default fits the standard scene
    /// content card width on the iMac's 5K @1× canvas.
    let size: CGFloat

    @State private var selectedIndex: Int? = nil

    struct Hotspot {
        /// Unit X position (0.0 = left edge, 1.0 = right edge).
        let x: CGFloat
        /// Unit Y position (0.0 = top edge, 1.0 = bottom edge).
        let y: CGFloat
        let label: String
        let detail: String
    }

    init(title: String,
         baseSymbol: String,
         baseColor: Color,
         hotspots: [Hotspot],
         size: CGFloat = 280) {
        self.title = title
        self.baseSymbol = baseSymbol
        self.baseColor = baseColor
        self.hotspots = hotspots
        self.size = size
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            diagram
            if let i = selectedIndex, hotspots.indices.contains(i) {
                detailCard(for: hotspots[i])
            } else {
                emptyState
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(baseColor.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(baseColor.opacity(0.30), lineWidth: 1)
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Interactive diagram: \(title), \(hotspots.count) labelled parts.")
    }

    private var header: some View {
        HStack(spacing: 8) {
            Image(systemName: SFSymbolCompat.name("hand.tap.fill"))
                .font(.title3)
                .foregroundColor(baseColor)
                .accessibilityHidden(true)
            Text(title)
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Spacer(minLength: 0)
            Text("Tap a number")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private var diagram: some View {
        ZStack {
            Image(systemName: SFSymbolCompat.name(baseSymbol))
                .resizable()
                .scaledToFit()
                .foregroundColor(baseColor.opacity(0.30))
                .frame(width: size * 0.75, height: size * 0.75)
                .accessibilityHidden(true)
            ForEach(Array(hotspots.enumerated()), id: \.offset) { (index, spot) in
                hotspotDot(at: index, spot: spot)
            }
        }
        .frame(width: size, height: size)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.05))
        )
    }

    private func hotspotDot(at index: Int, spot: Hotspot) -> some View {
        let isSelected = (selectedIndex == index)
        return Button {
            selectedIndex = (selectedIndex == index) ? nil : index
        } label: {
            ZStack {
                Circle()
                    .fill(isSelected ? baseColor : Color.white)
                    .frame(width: 28, height: 28)
                Circle()
                    .strokeBorder(baseColor, lineWidth: 2)
                    .frame(width: 28, height: 28)
                Text("\(index + 1)")
                    .font(.caption.weight(.bold))
                    .foregroundColor(isSelected ? .white : baseColor)
            }
            .shadow(color: .black.opacity(0.15), radius: 2, y: 1)
        }
        .buttonStyle(PressableButtonStyle())
        .pointingCursor()
        .position(x: spot.x * size, y: spot.y * size)
        .accessibilityLabel("Part \(index + 1): \(spot.label)")
        .accessibilityHint(spot.detail)
        .accessibilityAddTraits(isSelected ? [.isSelected, .isButton] : .isButton)
    }

    private func detailCard(for spot: Hotspot) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(spot.label)
                .font(.subheadline.weight(.bold))
                .foregroundColor(baseColor)
            Text(spot.detail)
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.6))
        )
    }

    private var emptyState: some View {
        HStack(spacing: 6) {
            Image(systemName: "info.circle")
                .foregroundColor(.secondary)
            Text("Tap any numbered dot to learn what that part does.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 6)
    }
}
