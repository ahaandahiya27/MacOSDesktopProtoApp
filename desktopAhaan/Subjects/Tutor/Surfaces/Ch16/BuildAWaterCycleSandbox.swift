import SwiftUI
import AppKit

// MARK: - BuildAWaterCycleSandbox
//
// Three-slider sandbox for Ch.16 (Water: A Precious Resource).
// Sliders: rainfall (monthly average), evaporation rate, household
// usage. Output: groundwater level over 12 months (a simple
// difference equation: level(t+1) = level(t) + rain - evap - usage,
// clamped to [0, 1]). The kid can simulate a drought (high evap,
// low rain) or sustainable use (balanced).
//
// Pedagogical hook: shows why summer cities run out of water — the
// rain isn't the only variable; rising temperatures (evap) and
// growing population (usage) shift the balance even if rainfall
// stays the same.

struct BuildAWaterCycleSandbox: View {
    let chapterId: String

    @SceneStorage private var rainfall: Double
    @SceneStorage private var evaporation: Double
    @SceneStorage private var usage: Double
    @State private var isShowingExplainer: Bool = false

    init(chapterId: String) {
        self.chapterId = chapterId
        self._rainfall    = SceneStorage(wrappedValue: 0.55, "sandbox.\(chapterId).rain")
        self._evaporation = SceneStorage(wrappedValue: 0.40, "sandbox.\(chapterId).evap")
        self._usage       = SceneStorage(wrappedValue: 0.30, "sandbox.\(chapterId).usage")
    }

    // MARK: - Model

    private var net: Double {
        rainfall - 0.7 * evaporation - 0.7 * usage
    }

    /// 12 months of groundwater levels, starting at 0.7 (full).
    private var monthlyLevels: [Double] {
        var result: [Double] = []
        var level = 0.7
        for _ in 0..<12 {
            level = max(0, min(1, level + net * 0.15))
            result.append(level)
        }
        return result
    }

    private var finalLevel: Double {
        monthlyLevels.last ?? 0.7
    }

    private var statusLabel: String {
        switch finalLevel {
        case ..<0.10:  return "Drought (dry wells)"
        case ..<0.30:  return "Stressed"
        case ..<0.55:  return "Manageable"
        case ..<0.80:  return "Healthy"
        default:       return "Replenished"
        }
    }

    private var statusColor: Color {
        switch finalLevel {
        case ..<0.10:  return DesignTokens.BrandColor.danger
        case ..<0.30:  return DesignTokens.BrandColor.tryAtHome
        case ..<0.55:  return DesignTokens.BrandColor.mnemonic
        case ..<0.80:  return Color.compatTeal
        default:       return DesignTokens.BrandColor.primaryAction
        }
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            slidersBlock
            timelineChart
            outputBlock
            explainerToggle
            if isShowingExplainer {
                explainerBody
            }
        }
        .padding(DesignTokens.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.compatCyan.opacity(0.10))
        )
        .respectReduceMotion(animation: .easeInOut(duration: 0.22))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Build-a-water-cycle sandbox")
        .accessibilityHint("Three sliders set rainfall, evaporation, and household usage. The chart shows groundwater level over twelve months.")
    }

    private var header: some View {
        HStack(spacing: 10) {
            Image(systemName: SFSymbolCompat.name("drop.fill"))
                .font(.title3)
                .foregroundColor(Color.compatCyan)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                Text("Build-a-Water-Cycle sandbox")
                    .font(.headline)
                Text("Can you keep the well from running dry over a year?")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
        }
    }

    private var slidersBlock: some View {
        VStack(spacing: 10) {
            WaterCycleSliderRow(
                label: "Rainfall (monsoon)", value: $rainfall,
                color: Color.compatBlue, symbol: "cloud.rain.fill")
            WaterCycleSliderRow(
                label: "Evaporation (summer heat)", value: $evaporation,
                color: DesignTokens.BrandColor.tryAtHome, symbol: "thermometer.sun.fill")
            WaterCycleSliderRow(
                label: "Household usage", value: $usage,
                color: Color.compatPurple, symbol: "house.fill")
        }
    }

    /// Mini line chart — 12 bars showing the groundwater level over the year.
    private var timelineChart: some View {
        GeometryReader { geo in
            let levels = monthlyLevels
            let barWidth: CGFloat = (geo.size.width - 44) / 12
            HStack(alignment: .bottom, spacing: DesignTokens.Spacing.xs) {
                ForEach(levels.indices, id: \.self) { idx in
                    let value = levels[idx]
                    let barHeight: CGFloat = max(2, geo.size.height * CGFloat(value))
                    let barAlpha: Double = 0.5 + 0.5 * value
                    Capsule()
                        .fill(statusColor.opacity(barAlpha))
                        .frame(width: barWidth,
                               height: barHeight)
                        .respectReduceMotion(animation: .easeOut(duration: 0.32))
                        .accessibilityLabel("Month \(idx + 1): \(Int(value * 100)) percent.")
                }
            }
        }
        .frame(height: 80)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Twelve-month groundwater level chart.")
    }

    private var outputBlock: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            HStack {
                Text("Year-end level")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(Int(finalLevel * 100))%")
                    .font(.caption.monospacedDigit().weight(.bold))
                    .foregroundColor(.primary)
            }
            HStack {
                Text("Status")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Spacer()
                Text(statusLabel)
                    .font(.caption.weight(.bold))
                    .foregroundColor(statusColor)
            }
            HStack {
                Text("Net monthly change")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Spacer()
                Text(String(format: "%+.2f", net))
                    .font(.caption.monospacedDigit().weight(.bold))
                    .foregroundColor(.primary)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Water-cycle output")
        .accessibilityValue("Year-end groundwater level \(Int(finalLevel * 100)) percent. Status: \(statusLabel).")
    }

    private var explainerToggle: some View {
        Button(action: {
            withAnimationRespectingReduceMotion(.easeOut(duration: 0.18)) {
                isShowingExplainer.toggle()
            }
        }) {
            HStack(spacing: 6) {
                Image(systemName: isShowingExplainer ? "chevron.down" : "chevron.right")
                    .font(.caption.weight(.bold))
                Text(isShowingExplainer ? "Hide explanation" : "Why does the level drop even when it rains?")
                    .font(.caption.weight(.semibold))
            }
            .foregroundColor(DesignTokens.BrandColor.relatedConcepts)
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityHint("Reveals a short explanation of the water-cycle balance.")
    }

    private var explainerBody: some View {
        Text("Groundwater is a balance: water IN (rainfall, river inflow) minus water OUT (evaporation, household, agriculture, industry). If outflow exceeds inflow, the level drops month after month — even if it rains. Indian cities like Bangalore and Chennai now run out of water by April-May not because rainfall stopped but because evaporation rose with heat and usage rose with population. Rainwater harvesting, drip irrigation, and recharging wells are all about tilting the balance back toward inflow.")
            .font(.callout)
            .foregroundColor(.primary)
            .lineSpacing(3)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, DesignTokens.Spacing.xs)
            .transition(.opacity)
            .accessibilityHint("Plain-language explanation of why groundwater levels drop.")
    }
}

// MARK: - WaterCycleSliderRow

private struct WaterCycleSliderRow: View {
    let label: String
    @Binding var value: Double
    let color: Color
    let symbol: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(spacing: 6) {
                Image(systemName: SFSymbolCompat.name(symbol))
                    .font(.caption)
                    .foregroundColor(color)
                    .accessibilityHidden(true)
                Text(label)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.primary)
                Spacer()
                Text("\(Int(value * 100))%")
                    .font(.caption.monospacedDigit())
                    .foregroundColor(.secondary)
            }
            Slider(value: $value, in: 0...1)
                .accentColor(color)
                .accessibilityLabel(label)
                .accessibilityValue("\(Int(value * 100)) percent")
                .accessibilityHint("Drag to change \(label.lowercased()) from zero to a hundred percent.")
        }
    }
}
