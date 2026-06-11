import SwiftUI

// MARK: - CompoundingGrowth
//
// Bespoke interactive for Social Science Ch.20 "Banks and the Magic of Finance"
// (`socialscience_class7` / ssch20). The chapter's concept ssch20_t01_c03,
// 'Interest and the Magic of Compounding', and its deepDive 'The snowball that is
// compound interest' teach that you earn interest not just on your money but on
// the interest it has already earned — so savings grow faster and faster — and
// give the Rule of 72 (72 ÷ rate ≈ years to double) and the lesson that money
// saved young grows far larger than the same amount saved later.
//
// This widget lets a learner DRIVE that: sliders set how much you save, the
// yearly interest rate and the number of years, and it shows the compounded
// balance, what plain (simple) interest would have given, and the extra the
// 'snowball' earns — plus the Rule-of-72 doubling time. A split bar shows how the
// interest slice grows relative to the money you put in.
//
// Big Sur compat: self-contained, @SceneStorage (namespaced by chapter), Slider +
// GeometryReader (macOS 10.15+), pow() from Foundation, Color(red:green:blue:),
// SFSymbolCompat (SF Symbols 1 only), VoiceOver labels. No macOS 12+ APIs (no
// .animation(_:value:)), no force-unwraps.

struct CompoundingGrowth: View {
    let chapterId: String

    @SceneStorage private var principal: Double   // rupees you save
    @SceneStorage private var rate: Double         // % per year
    @SceneStorage private var years: Double

    init(chapterId: String) {
        self.chapterId = chapterId
        self._principal = SceneStorage(wrappedValue: 100, "ssinteractive.\(chapterId).principal")
        self._rate = SceneStorage(wrappedValue: 8, "ssinteractive.\(chapterId).rate")
        self._years = SceneStorage(wrappedValue: 10, "ssinteractive.\(chapterId).years")
    }

    private let moneyGreen = Color(red: 0.13, green: 0.52, blue: 0.38)

    // MARK: - The maths (grounded in t01_c03 + the compounding deepDive)

    private var compoundTotal: Double { principal * pow(1 + rate / 100, years) }
    private var simpleTotal: Double { principal * (1 + (rate / 100) * years) }
    private var compoundExtra: Double { max(0, compoundTotal - simpleTotal) }
    private var doublingYears: Double { rate > 0 ? 72 / rate : 0 }

    private func rupees(_ v: Double) -> String { "₹\(Int(v.rounded()))" }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            balanceReadout
            growthBar
            sliders
            insightBanner
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                .fill(Color.white.opacity(0.92))
                .overlay(RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                    .strokeBorder(moneyGreen.opacity(0.30), lineWidth: 1))
        )
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text("The snowball of compounding")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Save some money, pick a rate and a number of years, and watch interest earn its own interest.")
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var balanceReadout: some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Text(rupees(compoundTotal))
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(moneyGreen)
            Text("after \(Int(years)) year\(Int(years) == 1 ? "" : "s")")
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Compounded balance: \(rupees(compoundTotal)) after \(Int(years)) years.")
    }

    // Split bar: the money you put in (solid) + the interest earned (lighter).
    private var growthBar: some View {
        let total = max(compoundTotal, 1)
        let principalFrac = principal / total
        return VStack(spacing: 3) {
            GeometryReader { geo in
                let w: CGFloat = geo.size.width
                let principalW: CGFloat = max(2, CGFloat(principalFrac) * w)
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(moneyGreen)
                        .frame(width: principalW)
                    Rectangle()
                        .fill(moneyGreen.opacity(0.40))
                        .frame(maxWidth: .infinity)
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .frame(height: 18)
            HStack {
                Text("you saved \(rupees(principal))")
                Spacer(minLength: 0)
                Text("interest \(rupees(compoundTotal - principal))")
            }
            .font(.caption2)
            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .accessibilityHidden(true)
    }

    private var sliders: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            sliderRow(label: "Money you save", value: $principal, range: 100...2000, step: 100,
                      display: rupees(principal), a11y: "Amount saved")
            sliderRow(label: "Interest rate per year", value: $rate, range: 2...12, step: 1,
                      display: "\(Int(rate))%", a11y: "Yearly interest rate")
            sliderRow(label: "Number of years", value: $years, range: 1...30, step: 1,
                      display: "\(Int(years)) yr", a11y: "Number of years")
        }
    }

    private func sliderRow(label: String, value: Binding<Double>,
                           range: ClosedRange<Double>, step: Double,
                           display: String, a11y: String) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
            HStack {
                Text(label)
                    .font(.caption.weight(.medium))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Spacer(minLength: 0)
                Text(display)
                    .font(.caption.weight(.bold))
                    .foregroundColor(moneyGreen)
            }
            Slider(value: value, in: range, step: step)
                .accessibilityLabel(a11y)
                .accessibilityValue(display)
        }
    }

    private var insightBanner: some View {
        HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
            Image(systemName: SFSymbolCompat.name("sparkles"))
                .foregroundColor(moneyGreen)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                Text("Compounding earns \(rupees(compoundExtra)) more than plain interest (which would give \(rupees(simpleTotal))).")
                    .font(.caption.weight(.medium))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .fixedSize(horizontal: false, vertical: true)
                Text("Rule of 72: at \(Int(rate))% your money doubles in about \(Int(doublingYears.rounded())) years — and the longer you wait, the faster the snowball rolls.")
                    .font(.caption)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.sm).fill(moneyGreen.opacity(0.12)))
        .accessibilityElement(children: .combine)
    }
}
