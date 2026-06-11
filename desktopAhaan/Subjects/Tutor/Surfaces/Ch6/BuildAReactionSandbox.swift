import SwiftUI
import AppKit

// MARK: - BuildAReactionSandbox
//
// Four-slider live interactive widget for Ch.6 (Physical and Chemical
// Changes). Sliders: Temperature, Concentration, Surface Area, Catalyst.
// Output: relative reaction rate, classified Slow → Steady → Fast →
// Runaway. The model is the collision-theory cartoon used in NCERT
// Class 7: each factor multiplicatively raises the rate, with a soft
// saturation so no single dial can run away unless catalyst is on.
//
// Pedagogical hook: chemistry isn't a fixed clock — every input you can
// change moves the rate predictably. Catalyst doesn't get consumed; the
// kid can feel the asymmetry between the four sliders (temperature is
// exponential-ish, surface area is linear-ish, catalyst is a multiplier).
//
// Big Sur compat:
//   - Slider / @State / @SceneStorage are macOS 10.15+/11+ baseline.
//   - Animations route through .respectReduceMotion.
//   - No Canvas, no .scrollPosition, no @Observable.
//   - All symbols through SFSymbolCompat.name(_:).

struct BuildAReactionSandbox: View {
    let chapterId: String

    @SceneStorage private var temperature: Double
    @SceneStorage private var concentration: Double
    @SceneStorage private var surfaceArea: Double
    @SceneStorage private var catalyst: Double
    @State private var isShowingExplainer: Bool = false

    init(chapterId: String) {
        self.chapterId = chapterId
        self._temperature   = SceneStorage(wrappedValue: 0.5, "sandbox.\(chapterId).temperature")
        self._concentration = SceneStorage(wrappedValue: 0.5, "sandbox.\(chapterId).concentration")
        self._surfaceArea   = SceneStorage(wrappedValue: 0.5, "sandbox.\(chapterId).surface")
        self._catalyst      = SceneStorage(wrappedValue: 0.0, "sandbox.\(chapterId).catalyst")
    }

    // MARK: - Rate model
    //
    // Multiplicative collision-theory cartoon. Temperature curves up
    // (squared) because higher temperature means more energetic AND
    // more frequent collisions. Surface area is roughly linear (more
    // exposed reactants = more contact). Concentration is roughly
    // linear too. Catalyst is a saturating multiplier (0..1 maps to
    // 1x..3x), capping how much benefit the kid gets from "more"
    // catalyst — a real-world honesty constraint.

    private var rate: Double {
        let t = pow(max(0, min(1, temperature)), 0.7) // mild concavity, fast rise then flatten
        let c = max(0.05, min(1, concentration))
        let s = max(0.05, min(1, surfaceArea))
        let cat = 1.0 + 2.0 * max(0, min(1, catalyst))
        let raw = t * c * s * cat
        return max(0, min(1, raw / 3.0)) // normalise so catalyst-on-full sits near 1
    }

    private var rateLabel: String {
        switch rate {
        case ..<0.05:  return "Stopped"
        case ..<0.25:  return "Slow"
        case ..<0.55:  return "Steady"
        case ..<0.85:  return "Fast"
        default:       return "Runaway"
        }
    }

    private var limitingFactorLabel: String {
        let pairs: [(name: String, value: Double)] = [
            ("Temperature",  temperature),
            ("Concentration", concentration),
            ("Surface area",  surfaceArea)
        ]
        if let lowest = pairs.min(by: { $0.value < $1.value }) {
            return lowest.name
        }
        return "—"
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            slidersBlock
            outputBlock
            explainerToggle
            if isShowingExplainer {
                explainerBody
            }
        }
        .padding(DesignTokens.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card, style: .continuous)
                .fill(Color.compatIndigo.opacity(0.10))
        )
        .respectReduceMotion(animation: .easeInOut(duration: 0.22))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Build-a-reaction sandbox")
        .accessibilityHint("Four sliders let you change a chemical reaction's inputs. The output bar shows the resulting reaction rate.")
    }

    private var header: some View {
        HStack(spacing: 10) {
            Image(systemName: SFSymbolCompat.name("flame.fill"))
                .font(.title3)
                .foregroundColor(Color.compatIndigo)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                Text("Build-a-Reaction sandbox")
                    .font(.headline)
                Text("Turn each dial — which one speeds it up fastest?")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
        }
    }

    private var slidersBlock: some View {
        VStack(spacing: 10) {
            ReactionSliderRow(
                label: "Temperature", value: $temperature,
                color: .orange, symbol: "thermometer")
            ReactionSliderRow(
                label: "Concentration", value: $concentration,
                color: Color.compatPurple, symbol: "drop.fill")
            ReactionSliderRow(
                label: "Surface area", value: $surfaceArea,
                color: Color.compatBrown, symbol: "square.grid.3x3.fill")
            ReactionSliderRow(
                label: "Catalyst", value: $catalyst,
                color: Color.compatTeal, symbol: "bolt.fill")
        }
    }

    private var outputBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Reaction rate")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                Spacer()
                Text(rateLabel)
                    .font(.caption.weight(.bold))
                    .foregroundColor(Color.compatIndigo)
            }
            rateBar
            HStack(spacing: DesignTokens.Spacing.xs) {
                Text("Slowest dial:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(limitingFactorLabel)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.primary)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Reaction rate output")
        .accessibilityValue("\(Int(rate * 100)) percent — \(rateLabel). Slowest dial: \(limitingFactorLabel).")
    }

    private var rateBar: some View {
        GeometryReader { geo in
            let fillW: CGFloat = max(4, geo.size.width * rate)
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.secondary.opacity(0.20))
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Color.orange, Color.compatIndigo],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: fillW)
                    .respectReduceMotion(animation: .easeOut(duration: 0.32))
            }
        }
        .frame(height: 14)
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
                Text(isShowingExplainer ? "Hide explanation" : "Why does this happen?")
                    .font(.caption.weight(.semibold))
            }
            .foregroundColor(Color.compatIndigo)
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityHint("Reveals a short explanation of why each dial changes the reaction rate.")
    }

    private var explainerBody: some View {
        Text("A chemical reaction is just lots of tiny collisions. The faster the molecules move (temperature), the more there are bumping (concentration), and the more exposed surface they have (surface area), the more collisions per second — and the faster the reaction. A catalyst is a 'matchmaker' that lets each collision succeed more often without being used up. Turn the catalyst on and the same temperature gets you much further.")
            .font(.callout)
            .foregroundColor(.primary)
            .lineSpacing(3)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, DesignTokens.Spacing.xs)
            .transition(.opacity)
            .accessibilityHint("Plain-language explanation of the collision-theory model behind the four sliders.")
    }
}

// MARK: - ReactionSliderRow

private struct ReactionSliderRow: View {
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
                .accessibilityHint("Drag to change the \(label.lowercased()) from zero to a hundred percent.")
        }
    }
}
