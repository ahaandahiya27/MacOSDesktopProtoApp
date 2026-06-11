import SwiftUI

// MARK: - IndiaPhysiographicExplorer
//
// Bespoke interactive for Social Science Ch.1 "Geographical Diversity of India"
// (`socialscience_class7` / ssch01). The chapter's spine is the FIVE
// physiographic regions (concept ssch01_t01_c02). This widget draws them as a
// north→south relief stack: tap a band to select it and read a faithful,
// NCERT-sourced fact — elevation falls as you move down the stack, mirroring a
// real cross-section from the Himalayas to the islands.
//
// Pedagogical hook: the bands are sized + tinted by elevation, so a learner
// *sees* that the country steps down from the world's highest mountains,
// across the flat alluvial plains, onto the ancient plateau, to the coasts and
// out to the island arcs — geography you can feel with a fingertip.
//
// Big Sur compat:
//   - Self-contained inline widget (mounted like BuildAPlantSandbox); no
//     coordinator sheet, no macOS 12+ APIs.
//   - Pure SwiftUI Shapes + Color(red:green:blue:) — no Canvas, no MapKit, no
//     asset, no raw `.mint/.teal/.brown`.
//   - Selection persists per session via @SceneStorage namespaced by chapter.
//   - Motion guarded by `accessibilityReduceMotion`; full VoiceOver labels.

struct IndiaPhysiographicExplorer: View {
    let chapterId: String

    @SceneStorage private var selectedIndex: Int
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(chapterId: String) {
        self.chapterId = chapterId
        self._selectedIndex = SceneStorage(wrappedValue: 0, "ssinteractive.\(chapterId).region")
    }

    // MARK: - Region model (faithful to NCERT ssch01)

    private struct Region {
        let name: String
        let glyph: String
        let subtitle: String
        let fact: String
        /// 0 (sea level) … 1 (highest) — drives band height + tint.
        let elevation: Double
    }

    private let regions: [Region] = [
        Region(
            name: "The Himalayas",
            glyph: "🏔️",
            subtitle: "Young fold mountains · the Water Tower of Asia",
            fact: "The world's highest range, raised when the Indian plate collided with Asia. Its three parallel ranges — Himadri (snow-capped, with Mt. Everest and Kanchenjunga), Himachal, and the Shivalik foothills — feed the great perennial rivers Ganga, Yamuna and Brahmaputra.",
            elevation: 1.0
        ),
        Region(
            name: "The Northern Plains",
            glyph: "🌾",
            subtitle: "Flat, fertile alluvium built by three rivers",
            fact: "Made of fine alluvial soil dropped over millions of years by the Indus, Ganga and Brahmaputra systems. Almost perfectly flat and intensely farmed, these plains have fed and sheltered the densest populations in India for thousands of years.",
            elevation: 0.45
        ),
        Region(
            name: "The Peninsular Plateau",
            glyph: "🪨",
            subtitle: "One of Earth's oldest landmasses",
            fact: "An ancient block of hard rock, tilted gently east, bordered by the Western and Eastern Ghats. It is rich in minerals and black volcanic soil (the Deccan Trap), and its rivers — Godavari, Krishna, Kaveri — flow east into the Bay of Bengal.",
            elevation: 0.6
        ),
        Region(
            name: "The Coastal Plains",
            glyph: "🏖️",
            subtitle: "Narrow lowlands either side of the plateau",
            fact: "Thin strips between the Ghats and the sea. The wider eastern coast carries large river deltas (Mahanadi, Godavari, Krishna, Kaveri); the narrow western coast holds lagoons and busy ports. Coastal plains support fishing, rice and bustling trade.",
            elevation: 0.2
        ),
        Region(
            name: "The Islands",
            glyph: "🏝️",
            subtitle: "Two very different island groups",
            fact: "The Andaman & Nicobar Islands in the Bay of Bengal are the tops of undersea mountains, covered in dense forest; the Lakshadweep Islands in the Arabian Sea are low coral atolls. Both are rich in marine life and biodiversity.",
            elevation: 0.05
        )
    ]

    private var selected: Region {
        let i = max(0, min(selectedIndex, regions.count - 1))
        return regions[i]
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            reliefStack
            detailPanel
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                .fill(Color.white.opacity(0.92))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                        .strokeBorder(Color.compatIndigo.opacity(0.25), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text("Explore India's five physiographic regions")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Tap a band — they step down from the world's highest mountains to coral islands.")
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var reliefStack: some View {
        VStack(spacing: DesignTokens.Spacing.xs) {
            ForEach(regions.indices, id: \.self) { i in
                regionBand(i)
            }
        }
    }

    private func regionBand(_ i: Int) -> some View {
        let region = regions[i]
        let isSelected = i == selectedIndex
        return Button {
            withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.25)) {
                selectedIndex = i
            }
        } label: {
            HStack(spacing: 10) {
                Text(region.glyph)
                    .font(.system(size: 22))
                    .accessibilityHidden(true)
                Text(region.name)
                    .font(.subheadline.weight(isSelected ? .bold : .medium))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.35), radius: 1, x: 0, y: 1)
                Spacer(minLength: 0)
                if isSelected {
                    Image(systemName: SFSymbolCompat.name("chevron.right.circle.fill"))
                        .foregroundColor(.white)
                        .accessibilityHidden(true)
                }
            }
            .padding(.horizontal, 14)
            .frame(height: bandHeight(region.elevation))
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(bandGradient(region.elevation))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.white.opacity(isSelected ? 0.9 : 0.0), lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel("\(region.name), \(region.subtitle)")
        .accessibilityHint(isSelected ? "Selected. Showing details below." : "Tap to read about this region.")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    /// Higher land draws a taller band so the stack reads as a relief profile.
    private func bandHeight(_ elevation: Double) -> CGFloat {
        44 + CGFloat(elevation) * 30
    }

    /// Cool whites/greys high up (snow + bare rock) warming to greens and
    /// blue-greens lower down (plains, coasts, sea) — an elevation gradient.
    private func bandGradient(_ elevation: Double) -> LinearGradient {
        let top: Color
        let bottom: Color
        if elevation > 0.8 {
            top = Color(red: 0.55, green: 0.60, blue: 0.72)
            bottom = Color(red: 0.32, green: 0.38, blue: 0.52)
        } else if elevation > 0.5 {
            top = Color(red: 0.45, green: 0.42, blue: 0.34)
            bottom = Color(red: 0.30, green: 0.27, blue: 0.20)
        } else if elevation > 0.35 {
            top = Color(red: 0.36, green: 0.56, blue: 0.34)
            bottom = Color(red: 0.22, green: 0.42, blue: 0.22)
        } else if elevation > 0.1 {
            top = Color(red: 0.30, green: 0.55, blue: 0.55)
            bottom = Color(red: 0.18, green: 0.40, blue: 0.44)
        } else {
            top = Color(red: 0.20, green: 0.45, blue: 0.62)
            bottom = Color(red: 0.10, green: 0.30, blue: 0.48)
        }
        return LinearGradient(gradient: Gradient(colors: [top, bottom]),
                              startPoint: .top, endPoint: .bottom)
    }

    private var detailPanel: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                Text(selected.glyph).font(.title2).accessibilityHidden(true)
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                    Text(selected.name)
                        .font(.headline)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    Text(selected.subtitle)
                        .font(.caption)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }
            }
            Text(selected.fact)
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.compatIndigo.opacity(0.06))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(selected.name). \(selected.fact)")
    }
}
