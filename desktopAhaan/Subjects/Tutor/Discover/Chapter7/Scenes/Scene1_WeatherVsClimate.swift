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
        GeometryReader { geo in
            ZStack {
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
                            .foregroundColor(.secondary)
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
                .frame(maxHeight: geo.size.height * 0.55)

                VStack(spacing: 14) {
                    Spacer()

                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Weather vs Climate", systemImage: "cloud.sun.fill")
                                .font(.title2.bold())
                            Text(explanationText)
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: 640)

                    GotItButton { onComplete() }
                        .padding(.bottom, 12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)
            }
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
                    .foregroundColor(.secondary)

                HStack(spacing: 16) {
                    ForEach(icons) { icon in
                        VStack(spacing: 4) {
                            Image(systemName: icon.symbol)
                                .font(.title2)
                                .foregroundColor(color)
                                .scaleEffect(pulse.wrappedValue ? 1.15 : 1.0)
                            Text(icon.label)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(selectedSide == side ? color.opacity(0.12) : Color(NSColor.windowBackgroundColor))
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
