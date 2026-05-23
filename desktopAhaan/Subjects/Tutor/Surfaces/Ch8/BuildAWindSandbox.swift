import SwiftUI
import AppKit

// MARK: - BuildAWindSandbox
//
// Three-slider live interactive for Ch.8 (Winds, Storms, Cyclones).
// The student sets pressure difference (Δp), surface friction, and
// Coriolis strength (latitude proxy 0 = equator, 1 = pole). The
// output shows wind speed + apparent direction relative to the
// pressure gradient — illustrating why winds curve.
//
// Model is a cartoon of the geostrophic-wind balance: at the equator
// (Coriolis=0) winds blow STRAIGHT from high to low pressure. At the
// pole (Coriolis=max) the wind curves to flow ALONG isobars at right
// angles to the gradient. Friction slows everything down and brings
// the wind partly back toward the low.

struct BuildAWindSandbox: View {
    let chapterId: String

    @SceneStorage private var pressureGradient: Double
    @SceneStorage private var friction: Double
    @SceneStorage private var coriolisStrength: Double
    @State private var isShowingExplainer: Bool = false

    init(chapterId: String) {
        self.chapterId = chapterId
        self._pressureGradient = SceneStorage(wrappedValue: 0.6, "sandbox.\(chapterId).gradient")
        self._friction         = SceneStorage(wrappedValue: 0.3, "sandbox.\(chapterId).friction")
        self._coriolisStrength = SceneStorage(wrappedValue: 0.5, "sandbox.\(chapterId).coriolis")
    }

    // MARK: - Model

    private var windSpeed: Double {
        let raw = pressureGradient * (1.0 - 0.7 * friction)
        return max(0, min(1, raw))
    }

    /// 0 = wind blows directly from H to L (straight). 1 = wind blows
    /// perpendicular to gradient (along isobars). Coriolis pushes toward
    /// perpendicular; friction pulls back toward straight.
    private var deflectionFraction: Double {
        let c = max(0, min(1, coriolisStrength))
        let f = max(0, min(1, friction))
        return max(0, min(1, c * (1.0 - 0.5 * f)))
    }

    private var deflectionDegrees: Double {
        90.0 * deflectionFraction
    }

    private var speedLabel: String {
        switch windSpeed {
        case ..<0.05:  return "Calm"
        case ..<0.25:  return "Breeze"
        case ..<0.55:  return "Wind"
        case ..<0.85:  return "Gale"
        default:       return "Storm"
        }
    }

    private var directionLabel: String {
        if deflectionFraction < 0.10 { return "Straight to low" }
        if deflectionFraction < 0.45 { return "Diagonal" }
        if deflectionFraction < 0.80 { return "Mostly along isobars" }
        return "Along isobars"
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            slidersBlock
            windCompass
            outputBlock
            explainerToggle
            if isShowingExplainer {
                explainerBody
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.compatBlue.opacity(0.10))
        )
        .respectReduceMotion(animation: .easeInOut(duration: 0.22))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Build-a-wind sandbox")
        .accessibilityHint("Three sliders let you change pressure gradient, surface friction, and Coriolis strength. The compass shows the wind direction relative to the pressure gradient.")
    }

    private var header: some View {
        HStack(spacing: 10) {
            Image(systemName: SFSymbolCompat.name("wind"))
                .font(.title3)
                .foregroundColor(Color.compatBlue)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text("Build-a-Wind sandbox")
                    .font(.headline)
                Text("At the equator, winds blow straight. At the pole, they curve. Why?")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
        }
    }

    private var slidersBlock: some View {
        VStack(spacing: 10) {
            WindSliderRow(
                label: "Pressure gradient (Δp)", value: $pressureGradient,
                color: Color.compatBlue, symbol: "arrow.right.arrow.left")
            WindSliderRow(
                label: "Surface friction", value: $friction,
                color: Color.compatBrown, symbol: "square.grid.3x3.fill")
            WindSliderRow(
                label: "Coriolis (latitude)", value: $coriolisStrength,
                color: Color.compatPurple, symbol: "globe.asia.australia.fill")
        }
    }

    /// A simple compass: H (high) on left, L (low) on right, with an
    /// arrow rotating from "straight to L" (0°) toward "perpendicular"
    /// (90°) as Coriolis grows.
    private var windCompass: some View {
        HStack(spacing: 14) {
            Text("H")
                .font(.title2.bold())
                .foregroundColor(.red)
                .accessibilityHidden(true)
            ZStack {
                Circle()
                    .stroke(Color.secondary.opacity(0.35), lineWidth: 1)
                    .frame(width: 90, height: 90)
                Image(systemName: SFSymbolCompat.name("arrow.right"))
                    .font(.title.bold())
                    .foregroundColor(Color.compatBlue)
                    .rotationEffect(.degrees(deflectionDegrees))
                    .respectReduceMotion(animation: .easeInOut(duration: 0.35))
                    .accessibilityHidden(true)
            }
            Text("L")
                .font(.title2.bold())
                .foregroundColor(.blue)
                .accessibilityHidden(true)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Wind compass — arrow rotated \(Int(deflectionDegrees)) degrees off the H-to-L axis.")
    }

    private var outputBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Wind speed")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                Spacer()
                Text(speedLabel)
                    .font(.caption.weight(.bold))
                    .foregroundColor(DesignTokens.BrandColor.relatedConcepts)
            }
            speedBar
            HStack(spacing: 4) {
                Text("Direction:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(directionLabel)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.primary)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Wind output")
        .accessibilityValue("Speed \(Int(windSpeed * 100)) percent — \(speedLabel). Direction: \(directionLabel) at \(Int(deflectionDegrees)) degrees from the gradient.")
    }

    private var speedBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.secondary.opacity(0.20))
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Color.compatCyan, Color.compatBlue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(4, geo.size.width * windSpeed))
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
                Text(isShowingExplainer ? "Hide explanation" : "Why does the wind curve?")
                    .font(.caption.weight(.semibold))
            }
            .foregroundColor(DesignTokens.BrandColor.relatedConcepts)
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityHint("Reveals a short explanation of why higher latitudes deflect winds toward isobars.")
    }

    private var explainerBody: some View {
        Text("Air wants to flow from high pressure to low — that's the gradient force. But Earth rotates underneath. As air moves, it 'overshoots' the slower-spinning ground beneath it. In the Northern Hemisphere, this overshoot looks like a right-turn (Coriolis). At high latitudes, the rotation effect is strong enough that wind ends up flowing nearly along the isobars instead of straight across them. Friction near the ground partly cancels Coriolis, which is why surface wind always blows somewhat across the isobars — never purely along them.")
            .font(.callout)
            .foregroundColor(.primary)
            .lineSpacing(3)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, 4)
            .transition(.opacity)
            .accessibilityHint("Plain-language explanation of how pressure gradient, Coriolis, and friction combine.")
    }
}

// MARK: - WindSliderRow

private struct WindSliderRow: View {
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
