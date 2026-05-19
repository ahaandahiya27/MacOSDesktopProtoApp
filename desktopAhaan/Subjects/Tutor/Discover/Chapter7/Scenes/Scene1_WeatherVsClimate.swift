import SwiftUI

/// Scene 1 — Weather vs Climate.
/// Split comparison with animated icons. Tap each side for explanation.

struct Scene1_WeatherVsClimate: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var selectedSide: Side? = nil
    @State private var weatherPulse = false
    @State private var climatePulse = false
    @State private var yearsAveraged: Double = 0       // free-play slider: 0 days → 30 years
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private enum Side: String { case weather, climate }

    private struct WeatherIcon: Identifiable {
        let id = UUID()
        let symbol: String
        let label: String
    }

    private let weatherIcons: [WeatherIcon] = [
        WeatherIcon(symbol: "sun.max.fill", label: "Sunny"),
        WeatherIcon(symbol: "cloud.rain.fill", label: "Rainy"),
        WeatherIcon(symbol: "cloud.fill", label: "Cloudy"),
        WeatherIcon(symbol: "wind", label: "Windy"),
    ]

    private let climateIcons: [WeatherIcon] = [
        WeatherIcon(symbol: "thermometer.snowflake", label: "Polar"),
        WeatherIcon(symbol: "sun.haze.fill", label: "Tropical"),
        WeatherIcon(symbol: "leaf.fill", label: "Temperate"),
    ]

    var body: some View {
        // Refactored ZStack-overlap pattern to ScrollView+VStack so the
        // comparison panels are not covered by the explanation card.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                HStack(spacing: 20) {
                    // Weather side
                    sideCard(
                        title: "Weather",
                        subtitle: "Changes daily",
                        color: Color.compatCyan,
                        icons: weatherIcons,
                        side: .weather,
                        pulse: $weatherPulse
                    )

                    // Divider
                    VStack {
                        Text("vs")
                            .font(.title.bold())
                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    }
                    .frame(width: 40)

                    // Climate side
                    sideCard(
                        title: "Climate",
                        subtitle: "Average over years",
                        color: .orange,
                        icons: climateIcons,
                        side: .climate,
                        pulse: $climatePulse
                    )
                }
                .padding(.horizontal, 32)
                .padding(.top, 20)
                .frame(height: 280)

                Group {
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Weather vs Climate", systemImage: "cloud.sun.fill")
                                .font(.title2.bold())
                            Text(explanationText)
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    DiscoveryWidget(
                        title: "Discovery — how much time = climate?",
                        subtitle: "Slide the years you average over. See exactly where weather ends and climate begins.",
                        value: $yearsAveraged,
                        range: 0...30,
                        step: 1,
                        valueLabel: { v in averagingLabel(v) },
                        output: averagingExplanation
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    MnemonicCallout(
                        hook: "TPHWP",
                        meaning: "The five variables every weather report measures.",
                        expansion: [
                            ("T", "Temperature — how hot or cold the air is"),
                            ("P", "Pressure — heavy or light air (millibars)"),
                            ("H", "Humidity — how much moisture the air carries"),
                            ("W", "Wind — direction and speed of the moving air"),
                            ("P", "Precipitation — rain, snow, hail, sleet")
                        ]
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    LookingAheadCallout(
                        title: "Class 11 Geography + Statistics → JEE / NEET / UPSC",
                        detail: "Weather = today's measurement; Climate = 30-year average. JEE Stats asks the same question as standard deviation. NEET Ecology asks 'why does monsoon arrive in June every year?' (climate). UPSC asks 'why is climate change different from weather change?' Same data, three frames: instantaneous → trend → long-term mean."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    TryAtHomeCallout(
                        title: "Be the family meteorologist for 30 days",
                        detail: "Make a daily weather chart: date, temperature (kitchen thermometer outside window), 'sunny/cloudy/rain', wind direction (lick a finger and feel which side cools — that's the wind source). After 30 days you have your first climate dataset. Compare with the IMD historical average for your city — you'll see what 'climate' actually means."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    GotItButton { onComplete() }
                        .padding(.bottom, 12)
                }
                .padding(.horizontal, 24)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    private var explanationText: String {
        switch selectedSide {
        case .weather:
            return "Weather describes the short-term conditions of the atmosphere — temperature, humidity, rain, wind — at a specific place and time. It can change hour by hour!"
        case .climate:
            return "Climate is the average weather pattern of a place measured over 25 years or more. It tells us what to generally expect — tropical regions are warm year-round, polar regions stay cold."
        case nil:
            return "Weather is what you wear today; climate is what's in your wardrobe. Tap each side to learn more!"
        }
    }

    private func averagingLabel(_ years: Double) -> String {
        if years < 1 { return "Today only" }
        if years < 2 { return "1 year" }
        return "\(Int(years)) years"
    }

    private func averagingExplanation(_ years: Double) -> String {
        switch years {
        case ..<1:
            return "That's pure weather — what's happening right NOW: sunny, raining, hot, cold."
        case ..<2:
            return "One year covers all four seasons but only ONE of each. Still mostly weather."
        case ..<5:
            return "A few years smooth out odd seasons, but a single hot summer can still skew the average."
        case ..<15:
            return "Now patterns emerge — average monsoon onset, average winter temperature. Edging towards climate."
        case ..<25:
            return "Almost climate. The official definition uses 30 years to define a region's climate."
        default:
            return "That's full climate: a 30-year (or longer) average. This is what tells us 'India is tropical, Antarctica is polar'."
        }
    }

    private func sideCard(
        title: String,
        subtitle: String,
        color: Color,
        icons: [WeatherIcon],
        side: Side,
        pulse: Binding<Bool>
    ) -> some View {
        Button {
            withAnimation(reduceMotion ? .none : .spring()) {
                selectedSide = side
            }
            if !reduceMotion {
                pulse.wrappedValue = true
                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 500_000_000)
                    pulse.wrappedValue = false
                }
            }
        } label: {
            VStack(spacing: 14) {
                Text(title)
                    .font(.title.bold())
                    .foregroundColor(color)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                HStack(spacing: 16) {
                    ForEach(icons) { icon in
                        VStack(spacing: 4) {
                            Image(systemName: icon.symbol)
                                .font(.title2)
                                .foregroundColor(color)
                                .scaleEffect(pulse.wrappedValue ? 1.15 : 1.0)
                            Text(icon.label)
                                .font(.caption2)
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        }
                    }
                }
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(selectedSide == side ? color.opacity(0.12) : Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(selectedSide == side ? color : .gray.opacity(0.25), lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(title): \(subtitle). Tap to learn more.")
    }
}
