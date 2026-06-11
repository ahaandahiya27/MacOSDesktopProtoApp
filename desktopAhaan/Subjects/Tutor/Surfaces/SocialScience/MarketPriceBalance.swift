import SwiftUI

// MARK: - MarketPriceBalance
//
// Bespoke interactive for Social Science Ch.12 "Understanding Markets"
// (`socialscience_class7` / ssch12). The chapter's heart (topic ssch12_t02) is
// how a price is found: t02_c02 "Demand and Supply" — when many buyers want
// something but little is available the price rises, and when sellers bring far
// more than buyers want the price falls — and t02_c01 "Negotiation and the
// 'Just Right' Price", built on the book's guava example (₹80 too high, ₹20 too
// low, ₹40 just right).
//
// This widget lets a learner DRIVE that mechanism: two sliders set how many
// buyers want guavas (demand) and how many guavas reach the market (supply), and
// the price moves live toward the balance point. When demand and supply meet, the
// price settles at the chapter's ₹40 "just right" level; push them apart and the
// price climbs or falls, with a one-line explanation of why — and a note when the
// price gets so high buyers walk away or so low the seller barely earns (the
// negotiation idea from t02_c01).
//
// Big Sur compat: self-contained, @SceneStorage (namespaced by chapter), Slider
// (macOS 10.15+), GeometryReader gauge, Color.compat* + Color(red:green:blue:),
// RM-gated motion, SFSymbolCompat, VoiceOver labels. No macOS 12+ APIs, no
// randomness, no force-unwraps.

struct MarketPriceBalance: View {
    let chapterId: String

    @SceneStorage private var demand: Double
    @SceneStorage private var supply: Double

    init(chapterId: String) {
        self.chapterId = chapterId
        self._demand = SceneStorage(wrappedValue: 5, "ssinteractive.\(chapterId).demand")
        self._supply = SceneStorage(wrappedValue: 5, "ssinteractive.\(chapterId).supply")
    }

    // MARK: - Price model (grounded in the book's guava example)

    private let justRight = 40.0     // ₹40 "just right" when demand == supply
    private let priceLow = 12.0      // floor (near the book's "too low" ₹20)
    private let priceHigh = 84.0     // ceiling (near the book's "too high" ₹80)

    /// Price climbs when demand outweighs supply, falls when supply outweighs
    /// demand, clamped to the book's sensible band.
    private var price: Double {
        let raw = justRight + (demand - supply) * 4.4
        return min(priceHigh, max(priceLow, raw))
    }

    private var rupees: Int { Int(price.rounded()) }
    private var gap: Double { demand - supply }
    private var balanced: Bool { abs(gap) <= 1 }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            priceReadout
            gauge
            sliderRow(label: "Buyers wanting guavas (demand)", value: $demand,
                      lowWord: "few", highWord: "many", a11y: "Demand")
            sliderRow(label: "Guavas brought to market (supply)", value: $supply,
                      lowWord: "few", highWord: "lots", a11y: "Supply")
            statusBanner
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                .fill(Color.white.opacity(0.92))
                .overlay(RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                    .strokeBorder(Color.compatTeal.opacity(0.30), lineWidth: 1))
        )
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text("Find the 'just right' price")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Slide demand and supply, and watch the guava price move to where buyers and sellers agree.")
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var priceReadout: some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Text("🍐")
                .font(.title2)
                .accessibilityHidden(true)
            Text("₹\(rupees)")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundColor(Color.compatTeal)
            Text("per kg")
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            Spacer(minLength: 0)
            if balanced {
                Text("just right")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10).padding(.vertical, DesignTokens.Spacing.xs)
                    .background(Capsule().fill(Color.green.opacity(0.85)))
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Guava price: \(rupees) rupees per kilogram\(balanced ? ", the just right price" : "").")
    }

    // Horizontal price gauge: low (left) → high (right), marker at the price.
    private var gauge: some View {
        let fraction = (price - priceLow) / (priceHigh - priceLow)
        return VStack(spacing: 3) {
            GeometryReader { geo in
                let markerSize: CGFloat = 18
                let x = CGFloat(fraction) * max(0, geo.size.width - markerSize)
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [
                                Color.green.opacity(0.45),
                                Color.compatTeal.opacity(0.45),
                                Color.orange.opacity(0.55)
                            ]),
                            startPoint: .leading, endPoint: .trailing))
                        .frame(height: 8)
                    Circle()
                        .fill(Color.compatTeal)
                        .overlay(Circle().strokeBorder(Color.white, lineWidth: 2))
                        .frame(width: markerSize, height: markerSize)
                        .offset(x: x)
                }
                .frame(maxHeight: .infinity, alignment: .center)
            }
            .frame(height: 18)
            HStack {
                Text("₹\(Int(priceLow)) too low")
                Spacer(minLength: 0)
                Text("₹\(Int(priceHigh)) too high")
            }
            .font(.caption2)
            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .accessibilityHidden(true)
    }

    private func sliderRow(label: String, value: Binding<Double>,
                           lowWord: String, highWord: String, a11y: String) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
            Text(label)
                .font(.caption.weight(.medium))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            HStack(spacing: DesignTokens.Spacing.sm) {
                Text(lowWord)
                    .font(.caption2)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                Slider(value: value, in: 0...10, step: 1)
                    .accessibilityLabel(a11y)
                    .accessibilityValue("\(Int(value.wrappedValue)) out of 10")
                Text(highWord)
                    .font(.caption2)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
        }
    }

    private var statusBanner: some View {
        HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
            Image(systemName: SFSymbolCompat.name(statusSymbol))
                .foregroundColor(statusTint)
                .accessibilityHidden(true)
            Text(statusText)
                .font(.caption.weight(.medium))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.sm).fill(statusTint.opacity(0.12)))
        .accessibilityElement(children: .combine)
    }

    // MARK: - Status copy (grounded in t02_c01 / t02_c02)

    private var statusText: String {
        if balanced {
            return "Supply meets demand, so the price settles at the 'just right' level — high enough for the seller, low enough for the buyer."
        }
        if gap > 1 {
            let extra = rupees >= 70 ? " It's now so high that many buyers walk away." : ""
            return "More buyers than guavas — when demand outweighs supply, the price climbs.\(extra)"
        }
        let extra = rupees <= 22 ? " It's now so low that the seller barely earns a profit." : ""
        return "More guavas than buyers — when supply outweighs demand, the price falls.\(extra)"
    }

    private var statusSymbol: String {
        if balanced { return "checkmark.seal.fill" }
        return gap > 1 ? "arrow.up.circle.fill" : "arrow.down.circle.fill"
    }

    private var statusTint: Color {
        if balanced { return .green }
        return gap > 1 ? .orange : Color.compatTeal
    }
}
