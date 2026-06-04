import SwiftUI
import AppKit

// MARK: - BuildAPlantSandbox
//
// Four-slider live interactive widget for the Ch.1 pilot. Each
// slider controls a photosynthesis input variable (Sunlight, Air,
// Water, Chlorophyll). The output bar shows the resulting rate via
// Liebig's law of the minimum: the rate equals the SMALLEST of the
// four inputs, raised to the 0.7 power so the bar moves smoothly
// instead of stair-stepping.
//
// Pedagogical hook: when a kid sets one slider to zero, the rate
// drops to zero no matter what the others say. That's the limiting
// factor lesson — the slowest step controls the whole pathway.
//
// Slider positions persist per session via @SceneStorage scoped to
// chapter id so a kid can return to the sandbox mid-experiment.
//
// Big Sur compat:
//   - Slider, @State, @SceneStorage: all macOS 10.15+ / 11+.
//   - All animations route through .respectReduceMotion(animation:).
//   - Plant viz is a small ZStack of SwiftUI Shapes — no Canvas,
//     no Image asset, no third-party deps.

struct BuildAPlantSandbox: View {
    /// Chapter id used to namespace the @SceneStorage keys so future
    /// per-chapter sandboxes don't clobber each other's slider state.
    let chapterId: String

    @SceneStorage private var lightIntensity: Double
    @SceneStorage private var co2Concentration: Double
    @SceneStorage private var waterAvailability: Double
    @SceneStorage private var chlorophyllAmount: Double
    @State private var isShowingExplainer: Bool = false

    init(chapterId: String) {
        self.chapterId = chapterId
        // @SceneStorage requires a String literal key at the property
        // wrapper layer. We can use an init-side initialization with
        // a parametrized key by re-creating the storage wrapper.
        self._lightIntensity     = SceneStorage(wrappedValue: 0.7, "sandbox.\(chapterId).light")
        self._co2Concentration   = SceneStorage(wrappedValue: 0.7, "sandbox.\(chapterId).co2")
        self._waterAvailability  = SceneStorage(wrappedValue: 0.7, "sandbox.\(chapterId).water")
        self._chlorophyllAmount  = SceneStorage(wrappedValue: 0.7, "sandbox.\(chapterId).chlorophyll")
    }

    // MARK: - Rate model (Liebig's law of the minimum)

    /// `pow(min(...), 0.7)` — the 0.7 exponent makes the bar move
    /// smoothly rather than in step-changes as the limiting factor
    /// hands off between sliders. Values stay in [0, 1].
    private var photosynthesisRate: Double {
        let m = min(lightIntensity, co2Concentration, waterAvailability, chlorophyllAmount)
        return pow(max(0, min(1, m)), 0.7)
    }

    private var rateLabel: String {
        switch photosynthesisRate {
        case ..<0.01:  return "Stopped"
        case ..<0.25:  return "Slow"
        case ..<0.55:  return "Steady"
        case ..<0.85:  return "Fast"
        default:       return "Maxed"
        }
    }

    private var limitingFactorLabel: String {
        let pairs: [(name: String, value: Double)] = [
            ("Sunlight",      lightIntensity),
            ("Air (CO₂)",     co2Concentration),
            ("Water",         waterAvailability),
            ("Chlorophyll",   chlorophyllAmount)
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
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.compatTeal.opacity(0.10))
        )
        .respectReduceMotion(animation: .easeInOut(duration: 0.22))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Build-a-plant sandbox")
        .accessibilityHint("Four sliders let you change a plant's inputs. The output bar shows how fast it makes food.")
    }

    private var header: some View {
        HStack(spacing: 10) {
            Image(systemName: SFSymbolCompat.name("leaf.fill"))
                .font(.title3)
                .foregroundColor(Color.compatTeal)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text("Build-a-Plant sandbox")
                    .font(.headline)
                Text("Try setting one slider to zero — what happens?")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
        }
    }

    /// 4 sliders stacked vertically. Each is one accessibilityElement so
    /// VoiceOver navigates them as 4 distinct controls. The "value" is
    /// announced as a percentage so a screen-reader user can dial it in.
    private var slidersBlock: some View {
        VStack(spacing: 10) {
            SandboxSliderRow(
                label: "Sunlight", value: $lightIntensity,
                color: .yellow, symbol: "sun.max.fill")
            SandboxSliderRow(
                label: "Air (CO₂)", value: $co2Concentration,
                color: .gray, symbol: "wind")
            SandboxSliderRow(
                label: "Water", value: $waterAvailability,
                color: .blue, symbol: "drop.fill")
            SandboxSliderRow(
                label: "Chlorophyll", value: $chlorophyllAmount,
                color: Color.compatTeal, symbol: "leaf.fill")
        }
    }

    private var outputBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Photosynthesis rate")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                Spacer()
                Text(rateLabel)
                    .font(.caption.weight(.bold))
                    .foregroundColor(Color.compatTeal)
            }
            rateBar
            HStack(spacing: 4) {
                Text("Slowest input:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(limitingFactorLabel)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.primary)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Photosynthesis rate output")
        .accessibilityValue("\(Int(photosynthesisRate * 100)) percent — \(rateLabel). Slowest input: \(limitingFactorLabel).")
    }

    /// The animated rate bar. A GeometryReader-based width animation,
    /// gated by .respectReduceMotion so the bar snaps to its target
    /// width without animating when Reduce Motion is on.
    private var rateBar: some View {
        GeometryReader { geo in
            let fillW: CGFloat = max(4, geo.size.width * photosynthesisRate)
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.secondary.opacity(0.20))
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Color.compatTeal, Color.compatCyan],
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
            .foregroundColor(Color.compatTeal)
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityHint("Reveals a short explanation of why the slowest input controls the whole rate.")
    }

    private var explainerBody: some View {
        Text("A plant's food-making is a chain: each link needs the four inputs together. The slowest one decides the whole chain's speed — even one bottleneck stops everything else from helping. Real plants live this every day: a leaf with plenty of sunlight and water still slows down if there's not enough air, or if its green pigment is damaged.")
            .font(.callout)
            .foregroundColor(.primary)
            .lineSpacing(3)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, 4)
            .transition(.opacity)
            .accessibilityHint("Plain-language explanation of the limiting-factor idea.")
    }
}

// MARK: - SandboxSliderRow

private struct SandboxSliderRow: View {
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
                .accessibilityHint("Drag to change the \(label.lowercased()) input from zero to a hundred percent.")
        }
    }
}
