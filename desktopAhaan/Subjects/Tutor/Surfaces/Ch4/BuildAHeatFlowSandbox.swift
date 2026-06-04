import SwiftUI
import AppKit

// MARK: - BuildAHeatFlowSandbox
//
// Three-slider live interactive widget for Ch.4 (Heat). The student
// adjusts material conductivity (k), wall thickness (L), and temperature
// difference (ΔT) — and reads off the heat flow per second.
//
// The model is Fourier's law in cartoon form: Q/t ∝ k * ΔT / L. The
// sandbox makes vivid why a hot tea cup loses heat faster in winter
// (large ΔT) and why insulators are thick low-k materials.
//
// Big Sur compat: same constraints as BuildAPlantSandbox.

struct BuildAHeatFlowSandbox: View {
    let chapterId: String

    @SceneStorage private var conductivity: Double      // 0..1 → wool..copper
    @SceneStorage private var thickness: Double         // 0..1 → thin..thick
    @SceneStorage private var temperatureDiff: Double   // 0..1 → 0K..100K-ish
    @State private var isShowingExplainer: Bool = false

    init(chapterId: String) {
        self.chapterId = chapterId
        self._conductivity     = SceneStorage(wrappedValue: 0.4, "sandbox.\(chapterId).conductivity")
        self._thickness        = SceneStorage(wrappedValue: 0.5, "sandbox.\(chapterId).thickness")
        self._temperatureDiff  = SceneStorage(wrappedValue: 0.6, "sandbox.\(chapterId).deltaT")
    }

    // MARK: - Model
    //
    // Q/t ∝ k * ΔT / L. We protect against /0 with a small floor on
    // thickness. The raw value is normalised to 0..1 by the worst-case
    // combination (k=1, ΔT=1, L=0.05).

    private var flow: Double {
        let k = max(0.01, conductivity)
        let dT = max(0, temperatureDiff)
        let L = max(0.05, thickness)
        let raw = k * dT / L
        return max(0, min(1, raw / 20.0))
    }

    private var flowLabel: String {
        switch flow {
        case ..<0.05:  return "Sealed"
        case ..<0.25:  return "Slow drip"
        case ..<0.55:  return "Steady"
        case ..<0.85:  return "Fast"
        default:       return "Gushing"
        }
    }

    private var materialName: String {
        switch conductivity {
        case ..<0.15:  return "Wool / air pocket"
        case ..<0.35:  return "Wood"
        case ..<0.55:  return "Brick / concrete"
        case ..<0.80:  return "Glass / iron"
        default:       return "Copper / silver"
        }
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
                .fill(Color.orange.opacity(0.10))
        )
        .respectReduceMotion(animation: .easeInOut(duration: 0.22))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Build-a-heat-flow sandbox")
        .accessibilityHint("Three sliders let you change material, wall thickness, and temperature difference. The output bar shows heat flow per second.")
    }

    private var header: some View {
        HStack(spacing: 10) {
            Image(systemName: SFSymbolCompat.name("thermometer.sun.fill"))
                .font(.title3)
                .foregroundColor(.orange)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text("Build-a-Heat-Flow sandbox")
                    .font(.headline)
                Text("Which dial cools a tea cup fastest in winter?")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
        }
    }

    private var slidersBlock: some View {
        VStack(spacing: 10) {
            HeatSliderRow(
                label: "Material conductivity", value: $conductivity,
                color: Color.compatPurple, symbol: "square.layers.3d.fill")
            HeatSliderRow(
                label: "Wall thickness", value: $thickness,
                color: Color.compatBrown, symbol: "ruler")
            HeatSliderRow(
                label: "Temperature difference", value: $temperatureDiff,
                color: .orange, symbol: "thermometer")
        }
    }

    private var outputBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Heat flow per second")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                Spacer()
                Text(flowLabel)
                    .font(.caption.weight(.bold))
                    .foregroundColor(DesignTokens.BrandColor.tryAtHome)
            }
            flowBar
            HStack(spacing: 4) {
                Text("Material:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(materialName)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.primary)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Heat-flow output")
        .accessibilityValue("\(Int(flow * 100)) percent — \(flowLabel). Material: \(materialName).")
    }

    private var flowBar: some View {
        GeometryReader { geo in
            let fillW: CGFloat = max(4, geo.size.width * flow)
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.secondary.opacity(0.20))
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [.yellow, .orange, .red],
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
            .foregroundColor(DesignTokens.BrandColor.tryAtHome)
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityHint("Reveals a short explanation of Fourier's law in plain language.")
    }

    private var explainerBody: some View {
        Text("Heat is a flow, like water in a pipe. The bigger the temperature difference at the two ends, the harder the flow. A material that conducts well (metal) is a fat pipe — wool is a thin one. And a thicker wall is a longer pipe with more resistance. Real-world insulators (wool, double-glazed glass with trapped air, foam) all combine the same trick: low conductivity AND extra thickness.")
            .font(.callout)
            .foregroundColor(.primary)
            .lineSpacing(3)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, 4)
            .transition(.opacity)
            .accessibilityHint("Plain-language explanation of why heat flows faster when ΔT is big or the wall is thin.")
    }
}

// MARK: - HeatSliderRow

private struct HeatSliderRow: View {
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
