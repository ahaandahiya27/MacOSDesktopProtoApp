import SwiftUI

/// Scene 2 — Build a Weather Station.
/// 5 instruments appear one by one. Tap each to learn what it measures.

struct Scene2_BuildAWeatherStation: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var revealedCount: Int = 0
    @State private var selectedInstrument: Int? = nil
    @State private var stationComplete = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private struct Instrument: Identifiable {
        let id: Int
        let name: String
        let symbol: String
        let measures: String
        let detail: String
    }

    private let instruments: [Instrument] = [
        Instrument(id: 0, name: "Thermometer", symbol: "thermometer.medium",
                   measures: "Temperature",
                   detail: "A thermometer measures how hot or cold the air is. It uses mercury or alcohol that expands when heated. Temperature is measured in degrees Celsius (C)."),
        Instrument(id: 1, name: "Rain Gauge", symbol: "drop.fill",
                   measures: "Rainfall",
                   detail: "A rain gauge collects rainwater in a graduated cylinder. The amount of rain collected tells us the rainfall in millimetres. India's average annual rainfall is about 1200 mm."),
        Instrument(id: 2, name: "Anemometer", symbol: "wind",
                   measures: "Wind Speed",
                   detail: "An anemometer has spinning cups that catch the wind. The faster they spin, the higher the wind speed. Wind speed is measured in km/h or m/s."),
        Instrument(id: 3, name: "Wind Vane", symbol: "arrow.up.left.and.arrow.down.right",
                   measures: "Wind Direction",
                   detail: "A wind vane (or weather vane) points in the direction the wind is blowing from. If it points north, the wind comes from the north — a 'northerly' wind."),
        Instrument(id: 4, name: "Hygrometer", symbol: "humidity.fill",
                   measures: "Humidity",
                   detail: "A hygrometer measures the moisture in the air. High humidity means the air holds lots of water vapour and rain may be coming. Humidity is given as a percentage."),
    ]

    var body: some View {
        GeometryReader { _ in
            ZStack {
                VStack(spacing: 16) {
                    Text("Build Your Weather Station")
                        .font(.title2.bold())
                        .padding(.top, 14)

                    // Instrument row
                    HStack(spacing: 14) {
                        ForEach(instruments) { inst in
                            let isRevealed = inst.id < revealedCount
                            let isSelected = selectedInstrument == inst.id

                            Button {
                                guard isRevealed else { return }
                                withAnimation(reduceMotion ? .none : .spring()) {
                                    selectedInstrument = inst.id
                                }
                            } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: inst.symbol)
                                        .font(.title)
                                        .foregroundColor(isRevealed ? Color.compatIndigo : .gray.opacity(0.3))
                                    Text(inst.name)
                                        .font(.caption.weight(.medium))
                                        .foregroundColor(isRevealed ? .primary : .secondary)
                                    Text(inst.measures)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                .frame(width: 100, height: 100)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(isSelected ? Color.compatIndigo.opacity(0.12) : Color(NSColor.windowBackgroundColor))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .strokeBorder(isSelected ? Color.compatIndigo : .gray.opacity(0.2), lineWidth: isSelected ? 2 : 1)
                                )
                                .opacity(isRevealed ? 1 : 0.4)
                            }
                            .buttonStyle(.plain)
                            .disabled(!isRevealed)
                            .accessibilityLabel("\(inst.name) measures \(inst.measures). \(isRevealed ? "Tap to learn more" : "Not yet revealed")")
                        }
                    }

                    // Progress bar
                    HStack(spacing: 6) {
                        Text("Station progress:")
                            .font(.caption.weight(.medium))
                            .foregroundColor(.secondary)
                        ProgressView(value: Double(revealedCount), total: 5)
                            .frame(maxWidth: 200)
                        Text("\(revealedCount) / 5")
                            .font(.caption.monospacedDigit())
                            .foregroundColor(Color.compatIndigo)
                    }

                    // Add next instrument button
                    if revealedCount < 5 {
                        Button {
                            withAnimation(reduceMotion ? .none : .spring()) {
                                revealedCount += 1
                                selectedInstrument = revealedCount - 1
                            }
                            if revealedCount == 5 {
                                withAnimation(reduceMotion ? .none : .easeInOut.delay(0.3)) {
                                    stationComplete = true
                                }
                            }
                        } label: {
                            Label("Add next instrument", systemImage: "plus.circle.fill")
                        }
                        
                        .accentColor(Color.compatIndigo)
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)

                VStack(spacing: 14) {
                    Spacer()

                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            if let idx = selectedInstrument, idx < instruments.count {
                                let inst = instruments[idx]
                                Label(inst.name, systemImage: inst.symbol)
                                    .font(.title2.bold())
                                Text(inst.detail)
                                    .font(.body)
                                    .lineSpacing(4)
                            } else {
                                Label("Weather Station", systemImage: "barometer")
                                    .font(.title2.bold())
                                Text("A weather station uses instruments to measure atmospheric conditions. Tap 'Add next instrument' to build yours one step at a time!")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    if stationComplete {
                        GotItButton { onComplete() }
                            .padding(.bottom, 12)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)

                if stationComplete {
                    ParticleEmitter(isActive: true, particleCount: 40, duration: 2.0)
                        .allowsHitTesting(false)
                        .ignoresSafeArea()
                }
            }
        }
    }
}
