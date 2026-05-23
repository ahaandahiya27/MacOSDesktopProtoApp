import SwiftUI
import AppKit

// MARK: - BuildAPHSandbox
//
// Three-slider live interactive for Ch.5 (Acids, Bases and Salts).
// Sliders: acid volume, base volume, acid strength (selects between
// weak / medium / strong). Output: pH on a 0..14 bar, with a colour
// strip and indicator label.
//
// Model is a stoichiometric cartoon: pH = 7 + log(base / acid_eq) for
// excess base, mirrored for excess acid. The kid can equalise the
// two volumes to hit pH 7 and watch neutralisation in real time.

struct BuildAPHSandbox: View {
    let chapterId: String

    @SceneStorage private var acidVolume: Double
    @SceneStorage private var baseVolume: Double
    @SceneStorage private var acidStrength: Double  // 0..1 — weak..strong
    @State private var isShowingExplainer: Bool = false

    init(chapterId: String) {
        self.chapterId = chapterId
        self._acidVolume   = SceneStorage(wrappedValue: 0.5, "sandbox.\(chapterId).acid")
        self._baseVolume   = SceneStorage(wrappedValue: 0.5, "sandbox.\(chapterId).base")
        self._acidStrength = SceneStorage(wrappedValue: 0.5, "sandbox.\(chapterId).strength")
    }

    // MARK: - Model

    /// Effective acid amount = volume × strength. Base is assumed
    /// strong (NaOH-like). The "effective" pH is derived from the
    /// imbalance between the two — symmetric around 7.
    private var pH: Double {
        let acidEq = max(0.001, acidVolume * (0.2 + 1.6 * acidStrength))
        let baseEq = max(0.001, baseVolume)
        let ratio = baseEq / acidEq
        let logTerm = log10(ratio)
        let raw = 7.0 + logTerm * 1.6
        return max(0, min(14, raw))
    }

    private var indicatorColor: Color {
        switch pH {
        case ..<2:    return Color.red.opacity(0.85)
        case ..<4:    return DesignTokens.BrandColor.tryAtHome
        case ..<6:    return DesignTokens.BrandColor.mnemonic
        case ..<8:    return Color.compatTeal
        case ..<10:   return Color.compatCyan
        case ..<12:   return Color.compatBlue
        default:      return Color.compatPurple
        }
    }

    private var pHLabel: String {
        switch pH {
        case ..<3:    return "Strongly acidic"
        case ..<6:    return "Acidic"
        case ..<8:    return "Neutral"
        case ..<11:   return "Basic"
        default:      return "Strongly basic"
        }
    }

    private var litmusLabel: String {
        if pH < 6 { return "Litmus → red" }
        if pH > 8 { return "Litmus → blue" }
        return "Litmus → purple"
    }

    private var strengthLabel: String {
        switch acidStrength {
        case ..<0.33:  return "Citric / acetic"
        case ..<0.66:  return "Carbonic / phosphoric"
        default:        return "HCl / H₂SO₄"
        }
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            slidersBlock
            pHBar
            outputBlock
            explainerToggle
            if isShowingExplainer {
                explainerBody
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(indicatorColor.opacity(0.12))
        )
        .respectReduceMotion(animation: .easeInOut(duration: 0.22))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Build-a-pH sandbox")
        .accessibilityHint("Three sliders let you mix acid and base of variable strength. The pH bar shows the result.")
    }

    private var header: some View {
        HStack(spacing: 10) {
            Image(systemName: SFSymbolCompat.name("testtube.2"))
                .font(.title3)
                .foregroundColor(indicatorColor)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text("Build-a-pH sandbox")
                    .font(.headline)
                Text("Equalise the two volumes — what pH do you get?")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
        }
    }

    private var slidersBlock: some View {
        VStack(spacing: 10) {
            PHSliderRow(
                label: "Acid volume", value: $acidVolume,
                color: Color.red, symbol: "drop.fill")
            PHSliderRow(
                label: "Base volume", value: $baseVolume,
                color: Color.compatBlue, symbol: "drop.fill")
            PHSliderRow(
                label: "Acid strength", value: $acidStrength,
                color: DesignTokens.BrandColor.tryAtHome, symbol: "bolt.fill")
        }
    }

    /// Horizontal 0..14 pH bar with the indicator dot at the current value.
    private var pHBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.red, DesignTokens.BrandColor.tryAtHome,
                                DesignTokens.BrandColor.mnemonic,
                                Color.compatTeal, Color.compatCyan,
                                Color.compatBlue, Color.compatPurple
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 12)
                Circle()
                    .fill(Color.white)
                    .frame(width: 18, height: 18)
                    .overlay(
                        Circle().stroke(Color.black.opacity(0.45), lineWidth: 2)
                    )
                    .offset(x: max(0, geo.size.width - 18) * CGFloat(pH / 14.0))
                    .respectReduceMotion(animation: .easeOut(duration: 0.32))
            }
        }
        .frame(height: 22)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("pH bar")
        .accessibilityValue("pH \(String(format: "%.1f", pH)) — \(pHLabel)")
    }

    private var outputBlock: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("pH")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Spacer()
                Text(String(format: "%.1f", pH))
                    .font(.caption.monospacedDigit().weight(.bold))
                    .foregroundColor(.primary)
            }
            HStack {
                Text("Reading")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Spacer()
                Text(pHLabel)
                    .font(.caption.weight(.bold))
                    .foregroundColor(indicatorColor)
            }
            HStack {
                Text("Indicator")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Spacer()
                Text(litmusLabel)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.primary)
            }
            HStack {
                Text("Acid example")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Spacer()
                Text(strengthLabel)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.primary)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("pH output")
        .accessibilityValue("pH \(String(format: "%.1f", pH)). Reading: \(pHLabel). Indicator: \(litmusLabel). Acid example: \(strengthLabel).")
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
                Text(isShowingExplainer ? "Hide explanation" : "What is pH actually measuring?")
                    .font(.caption.weight(.semibold))
            }
            .foregroundColor(DesignTokens.BrandColor.relatedConcepts)
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityHint("Reveals a short explanation of pH and neutralisation.")
    }

    private var explainerBody: some View {
        Text("pH is the negative log of hydrogen-ion (H⁺) concentration. Pure water has pH 7. Acids release H⁺ ions — more H⁺ means lower pH (further left on the bar). Bases release OH⁻ ions which mop up H⁺ — fewer H⁺ means higher pH. When you mix equal amounts of strong acid and strong base, the H⁺ and OH⁻ combine to form water — pH lands at 7. Weak acids release fewer H⁺ per molecule, so even a 'lot' of vinegar is much less acidic than a tiny bit of HCl.")
            .font(.callout)
            .foregroundColor(.primary)
            .lineSpacing(3)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, 4)
            .transition(.opacity)
            .accessibilityHint("Plain-language explanation of pH and neutralisation.")
    }
}

// MARK: - PHSliderRow

private struct PHSliderRow: View {
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
