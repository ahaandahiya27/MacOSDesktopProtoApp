import SwiftUI

// MARK: - ClimateFactorsExplorer
//
// Bespoke interactive for Social Science Ch.3 "Climates of India"
// (`socialscience_class7` / ssch03). Topic ssch03_t02 "Factors Determining the
// Climate" is the heart of the chapter: five forces decide why one Indian place
// is hot and another cool — Latitude (t02_c01), Altitude (t02_c02), Proximity to
// the Sea (t02_c03), Winds (t02_c04) and Topography & Microclimates (t02_c05).
//
// This widget upgrades ssch03 from the generic glossary-match to a chapter-
// specific explorer. Tap a factor to see the rule it follows (its cause -> effect)
// and a side-by-side pair of real Indian places that the chapter itself uses to
// make the contrast visible — Kanniyakumari vs Srinagar for latitude, the plains
// vs Shimla for altitude, coastal Mumbai vs inland Nagpur for the sea's
// moderating "cushion", and so on. Every fact is straight from ssch03_t02.
//
// Big Sur compat: self-contained, @SceneStorage (namespaced by chapter),
// Color(red:green:blue:), SFSymbolCompat (SF Symbols 1 only), RM-gated motion,
// VoiceOver labels. No macOS 12+ APIs (no .animation(_:value:)), no force-unwraps.

struct ClimateFactorsExplorer: View {
    let chapterId: String

    @SceneStorage private var selected: Int
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(chapterId: String) {
        self.chapterId = chapterId
        self._selected = SceneStorage(wrappedValue: 0, "ssinteractive.\(chapterId).climatefactor")
    }

    private let skyTeal = Color(red: 0.13, green: 0.45, blue: 0.55)

    // MARK: - The five climate factors (grounded in ssch03_t02_c01..c05)

    private struct Endpoint {
        let cap: String        // short caption, e.g. "Warmer"
        let symbol: String     // SF Symbols 1 glyph
        let place: String      // the chapter's own real-world example
    }

    private struct Factor {
        let name: String
        let symbol: String
        let rule: String       // the cause -> effect headline
        let left: Endpoint     // one end of the contrast
        let right: Endpoint    // the other end
        let detail: String     // kid-friendly "why", from the chapter
    }

    private let factors: [Factor] = [
        Factor(
            name: "Latitude",
            symbol: "globe",
            rule: "Near the Equator (low latitude) it is hotter; near the poles (high latitude) it is colder.",
            left: Endpoint(cap: "Warmer", symbol: "sun.max.fill",
                           place: "Kanniyakumari & the Nicobar Islands — near the Equator, warm all year."),
            right: Endpoint(cap: "Cooler", symbol: "snowflake",
                            place: "Srinagar — far to the north, so much cooler."),
            detail: "Near the Equator the Sun's rays hit almost straight down, squeezing all their heat onto a small patch. Near the poles the rays slant, spreading their heat over a wide area and passing through more air."),
        Factor(
            name: "Altitude",
            symbol: "triangle.fill",
            rule: "The higher you go, the colder it gets.",
            left: Endpoint(cap: "Lower & warmer", symbol: "sun.max.fill",
                           place: "The plains stay warm."),
            right: Endpoint(cap: "Higher & cooler", symbol: "snowflake",
                            place: "Hill stations — Shimla, Ooty, Darjeeling, Munnar — are cool even in summer; Himalayan peaks stay snow-covered."),
            detail: "High up, the air is thinner and less dense, so it can't hold much heat; and since the Sun mainly heats the ground, the farther you are above it, the less warm the air feels."),
        Factor(
            name: "Proximity to the Sea",
            symbol: "drop.fill",
            rule: "The sea is a temperature 'cushion' — coasts stay mild; inland places get more extreme.",
            left: Endpoint(cap: "Coastal & mild", symbol: "drop.fill",
                           place: "Mumbai — cooler summers, milder winters."),
            right: Endpoint(cap: "Inland & extreme", symbol: "thermometer",
                            place: "Nagpur — hotter summers, colder winters, though at about the same latitude."),
            detail: "The sea heats up and cools down slowly, so places beside it never get too hot or too cold. The farther inland you go, the more extreme the temperatures become."),
        Factor(
            name: "Winds",
            symbol: "wind",
            rule: "Winds carry whole 'parcels' of air — warm or cool, dry or moist — and bring those qualities with them.",
            left: Endpoint(cap: "Dry land winds", symbol: "sun.max.fill",
                           place: "Hot, dry winds from the Arabian & Afghan deserts bring heat waves to Punjab, Haryana, Rajasthan & Madhya Pradesh."),
            right: Endpoint(cap: "Moist sea winds", symbol: "drop.fill",
                            place: "Winds off the sea carry moisture over the land and bring rain — the monsoon is the biggest example."),
            detail: "In winter, cold winds slipping over the Himalayas chill the foothills and cause cold waves. The direction a wind comes from decides whether it warms, cools, dries or waters a region."),
        Factor(
            name: "Topography",
            symbol: "map.fill",
            rule: "The shape of the land blocks or steers winds — and tiny areas can have their own microclimate.",
            left: Endpoint(cap: "Sheltered", symbol: "shield.fill",
                           place: "The Himalayas & Karakoram shield the north, partly blocking Central Asia's cold desert winds."),
            right: Endpoint(cap: "Exposed", symbol: "wind",
                            place: "The flat Thar has nothing to block the hot, dry winds."),
            detail: "Mountains, valleys, slopes and coasts all shape climate. Even a small spot can have its own microclimate — a cool shady forest, an enclosed valley, or a hot 'urban heat island' where concrete traps heat and makes a city warmer than the land around it.")
    ]

    private var current: Factor { factors[max(0, min(selected, factors.count - 1))] }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            chipWrap
            detailPanel
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                .fill(Color.white.opacity(0.92))
                .overlay(RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                    .strokeBorder(skyTeal.opacity(0.28), lineWidth: 1))
        )
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("What shapes a place's climate?")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Five forces decide whether an Indian place is hot or cool, wet or dry. Tap one to see the rule it follows.")
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // Manual wrapping into rows of up to 2 (factor names are long).
    private var chipWrap: some View {
        let rows = stride(from: 0, to: factors.count, by: 2).map { start -> [Int] in
            Array(factors.indices[start..<min(start + 2, factors.count)])
        }
        return VStack(alignment: .leading, spacing: 7) {
            ForEach(rows.indices, id: \.self) { r in
                HStack(spacing: 7) {
                    ForEach(rows[r], id: \.self) { idx in chip(idx) }
                    Spacer(minLength: 0)
                }
            }
        }
    }

    private func chip(_ idx: Int) -> some View {
        let factor = factors[idx]
        let on = selected == idx
        return Button { selectFactor(idx) } label: {
            HStack(spacing: 6) {
                Image(systemName: SFSymbolCompat.name(factor.symbol))
                    .font(.caption)
                    .accessibilityHidden(true)
                Text(factor.name)
                    .font(.caption.weight(.semibold))
            }
            .foregroundColor(on ? .white : DesignTokens.BrandColor.canvasText)
            .padding(.horizontal, 12).padding(.vertical, 7)
            .background(Capsule().fill(on ? skyTeal : skyTeal.opacity(0.10)))
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel("\(factor.name)\(on ? ", selected" : "")")
        .accessibilityHint("Tap to see how \(factor.name.lowercased()) shapes the climate.")
    }

    private var detailPanel: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(current.rule)
                .font(.subheadline.weight(.bold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
            HStack(alignment: .top, spacing: 10) {
                endpointCard(current.left)
                endpointCard(current.right)
            }
            Text(current.detail)
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 8).fill(skyTeal.opacity(0.12)))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(current.name). \(current.rule) \(current.left.cap): \(current.left.place) \(current.right.cap): \(current.right.place) \(current.detail)")
    }

    private func endpointCard(_ end: Endpoint) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 5) {
                Image(systemName: SFSymbolCompat.name(end.symbol))
                    .font(.caption2)
                    .foregroundColor(skyTeal)
                    .accessibilityHidden(true)
                Text(end.cap)
                    .font(.caption2.weight(.bold))
                    .foregroundColor(skyTeal)
            }
            Text(end.place)
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 7).fill(Color.white.opacity(0.7)))
        .accessibilityHidden(true)
    }

    private func selectFactor(_ idx: Int) {
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
            selected = idx
        }
    }
}
