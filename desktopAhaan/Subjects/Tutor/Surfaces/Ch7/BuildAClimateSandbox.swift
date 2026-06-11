import SwiftUI
import AppKit

// MARK: - BuildAClimateSandbox
//
// Four-slider live interactive widget for Ch.7 (Weather, Climate and
// Adaptations). Sliders: Latitude (0 = equator, 1 = pole), Altitude
// (0 = sea level, 1 = mountain top), Season (0 = winter, 1 = summer),
// Humidity (0 = bone-dry, 1 = saturated). The widget classifies the
// result into one of the six Köppen-style climate types a Class 7
// student would recognise: Tropical, Desert, Temperate, Polar,
// Highland, or Tundra. It is a cartoon classifier — not a real
// Köppen-Geiger calculator — but it gives the kid a feel for how
// climate emerges from a few first-principles inputs.
//
// Big Sur compat: same constraints as the rest of the pilot surfaces.

struct BuildAClimateSandbox: View {
    let chapterId: String

    @SceneStorage private var latitude: Double
    @SceneStorage private var altitude: Double
    @SceneStorage private var season: Double
    @SceneStorage private var humidity: Double
    @State private var isShowingExplainer: Bool = false

    init(chapterId: String) {
        self.chapterId = chapterId
        self._latitude = SceneStorage(wrappedValue: 0.5, "sandbox.\(chapterId).latitude")
        self._altitude = SceneStorage(wrappedValue: 0.2, "sandbox.\(chapterId).altitude")
        self._season   = SceneStorage(wrappedValue: 0.5, "sandbox.\(chapterId).season")
        self._humidity = SceneStorage(wrappedValue: 0.5, "sandbox.\(chapterId).humidity")
    }

    // MARK: - Climate model
    //
    // Temperature proxy = (1 - latitude) - 0.7 * altitude + 0.5 * (season - 0.5)
    // Humidity is its own axis. Climate type emerges from this 2D space.

    private var temperatureProxy: Double {
        let t = (1 - latitude) - 0.7 * altitude + 0.5 * (season - 0.5)
        return max(0, min(1, (t + 0.5) / 1.5))
    }

    private var climateLabel: String {
        let t = temperatureProxy
        let h = humidity
        if altitude > 0.75 { return t < 0.3 ? "Tundra" : "Highland" }
        if t < 0.20 { return "Polar" }
        if t < 0.45 { return h > 0.55 ? "Temperate" : "Cold steppe" }
        if t < 0.70 { return h > 0.55 ? "Temperate" : "Mediterranean" }
        return h > 0.55 ? "Tropical" : "Desert"
    }

    private var climateColor: Color {
        switch climateLabel {
        case "Tundra":        return Color.compatCyan
        case "Highland":      return .gray
        case "Polar":         return Color.compatCyan
        case "Temperate":     return Color.compatTeal
        case "Cold steppe":   return Color.compatBrown
        case "Mediterranean": return .yellow
        case "Tropical":      return .green
        case "Desert":        return .orange
        default:              return .secondary
        }
    }

    private var climateHint: String {
        switch climateLabel {
        case "Tundra":        return "Treeless cold plains. Mosses and lichens only."
        case "Highland":      return "Thin air, snow above. Different climate every 1000 m."
        case "Polar":         return "Ice caps. Penguins, polar bears, no farming."
        case "Temperate":     return "Four seasons, deciduous forests. Like Delhi NCR or Tokyo."
        case "Cold steppe":   return "Dry grasslands. Cold winters, brief summers."
        case "Mediterranean": return "Warm dry summers, mild wet winters. Olive trees."
        case "Tropical":      return "Hot and humid year-round. Rainforests."
        case "Desert":        return "Hot and dry. Cacti, camels, deep wells."
        default:              return "—"
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
        .padding(DesignTokens.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card, style: .continuous)
                .fill(climateColor.opacity(0.10))
        )
        .respectReduceMotion(animation: .easeInOut(duration: 0.22))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Build-a-climate sandbox")
        .accessibilityHint("Four sliders let you change latitude, altitude, season, and humidity. The output shows what climate emerges.")
    }

    private var header: some View {
        HStack(spacing: 10) {
            Image(systemName: SFSymbolCompat.name("globe.asia.australia.fill"))
                .font(.title3)
                .foregroundColor(climateColor)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                Text("Build-a-Climate sandbox")
                    .font(.headline)
                Text("Where in the world would you create this combination?")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
        }
    }

    private var slidersBlock: some View {
        VStack(spacing: 10) {
            ClimateSliderRow(
                label: "Latitude (equator → pole)", value: $latitude,
                color: Color.compatCyan, symbol: "location.north.line")
            ClimateSliderRow(
                label: "Altitude (sea → mountain)", value: $altitude,
                color: .gray, symbol: "mountain.2.fill")
            ClimateSliderRow(
                label: "Season (winter → summer)", value: $season,
                color: .yellow, symbol: "sun.max.fill")
            ClimateSliderRow(
                label: "Humidity (dry → wet)", value: $humidity,
                color: .blue, symbol: "drop.fill")
        }
    }

    private var outputBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Climate type")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                Spacer()
                Text(climateLabel)
                    .font(.caption.weight(.bold))
                    .foregroundColor(climateColor)
            }
            temperatureBar
            Text(climateHint)
                .font(.caption)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Climate output")
        .accessibilityValue("Climate type: \(climateLabel). \(climateHint)")
    }

    private var temperatureBar: some View {
        GeometryReader { geo in
            let fillW: CGFloat = max(4, geo.size.width * temperatureProxy)
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.secondary.opacity(0.20))
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Color.compatCyan, .green, .yellow, .orange, .red],
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
                Text(isShowingExplainer ? "Hide explanation" : "Why these four factors?")
                    .font(.caption.weight(.semibold))
            }
            .foregroundColor(climateColor)
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityHint("Reveals a short explanation of how latitude, altitude, season, and humidity combine to shape climate.")
    }

    private var explainerBody: some View {
        Text("Latitude sets how directly the sun strikes the ground — that's the primary thermometer. Altitude adds an air-thinning correction: every 1000 m up, you lose about 6 °C. Season is the planet's tilt translated into local time-of-year. Humidity is the wildcard that decides whether the heat feels like a rainforest or a desert. Real climate classifiers (Köppen-Geiger) use much more — soil, vegetation, ocean currents — but these four explain about 80 percent of what we feel.")
            .font(.callout)
            .foregroundColor(.primary)
            .lineSpacing(3)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, DesignTokens.Spacing.xs)
            .transition(.opacity)
            .accessibilityHint("Plain-language summary of how the four sliders shape climate type.")
    }
}

// MARK: - ClimateSliderRow

private struct ClimateSliderRow: View {
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
