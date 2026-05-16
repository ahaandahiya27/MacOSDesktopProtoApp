import SwiftUI

/// Scene 2 — Build Your Thermometer.
/// Draggable mercury level with live °C / °F, plus heat/cool buttons.

struct Scene2_BuildYourThermometer: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var fraction: CGFloat = 0.25 // 0…1 maps to -10…110 °C
    @State private var isDigital = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var tempC: Double { -10.0 + Double(fraction) * 120.0 }
    private var tempF: Double { tempC * 9.0 / 5.0 + 32.0 }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                HStack(spacing: 40) {
                    // Thermometer
                    if isDigital {
                        digitalThermometer
                    } else {
                        analogThermometer(height: min(geo.size.height * 0.55, 340))
                    }

                    // Controls
                    VStack(spacing: 20) {
                        Toggle("Digital mode", isOn: $isDigital)
                            .toggleStyle(.switch)
                            .frame(maxWidth: 180)

                        Button {
                            adjustFraction(by: 0.08)
                        } label: {
                            Label("Heat (Bunsen)", systemImage: "flame.fill")
                                .frame(maxWidth: 180)
                        }
                        
                        .accentColor(.orange)
                        .accessibilityLabel("Heat the thermometer")

                        Button {
                            adjustFraction(by: -0.08)
                        } label: {
                            Label("Cool (Ice)", systemImage: "snowflake")
                                .frame(maxWidth: 180)
                        }
                        
                        .accentColor(Color.compatCyan)
                        .accessibilityLabel("Cool the thermometer")

                        HStack(spacing: 24) {
                            VStack {
                                Text(String(format: "%.0f", tempC))
                                    .font(.largeTitle.bold().monospacedDigit())
                                    .foregroundColor(.red)
                                Text("°C")
                                    .font(.headline)
                            }
                            VStack {
                                Text(String(format: "%.0f", tempF))
                                    .font(.largeTitle.bold().monospacedDigit())
                                    .foregroundColor(.blue)
                                Text("°F")
                                    .font(.headline)
                            }
                        }
                        .accessibilityLabel("\(Int(tempC)) degrees Celsius, \(Int(tempF)) degrees Fahrenheit")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                VStack(spacing: 14) {
                    Spacer()
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Build Your Thermometer", systemImage: SFSymbolCompat.name("thermometer.medium"))
                                .font(.title2.bold())
                            Text("A thermometer measures temperature. The liquid inside expands when heated and shrinks when cooled. Drag the mercury or use the buttons!")
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    GotItButton { onComplete() }
                        .padding(.bottom, 12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)
            }
        }
    }

    // MARK: - Analog thermometer with drag

    private func analogThermometer(height: CGFloat) -> some View {
        let tubeW: CGFloat = 20
        let bulbR: CGFloat = 26
        let tubeH = height - bulbR * 2

        return ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: tubeW / 2)
                        .fill(Color.gray.opacity(0.12))
                        .frame(width: tubeW, height: tubeH)

                    // Scale marks
                    VStack(spacing: 0) {
                        ForEach(0..<7, id: \.self) { i in
                            if i > 0 { Spacer() }
                            HStack(spacing: 4) {
                                Text("\(110 - i * 20)°")
                                    .font(.caption2.monospacedDigit())
                                    .frame(width: 36, alignment: .trailing)
                                Rectangle()
                                    .fill(Color.gray.opacity(0.4))
                                    .frame(width: 8, height: 1)
                            }
                        }
                    }
                    .frame(height: tubeH)
                    .offset(x: -44)
                }

                Circle()
                    .fill(Color.red.opacity(0.85))
                    .frame(width: bulbR * 2, height: bulbR * 2)
            }

            // Mercury
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                RoundedRectangle(cornerRadius: tubeW / 2)
                    .fill(LinearGradient(colors: [.red, .red.opacity(0.6)], startPoint: .bottom, endPoint: .top))
                    .frame(width: tubeW - 4, height: tubeH * fraction)
                    .padding(.bottom, bulbR * 2 - 4)
            }
            .frame(height: height)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { val in
                        let y = val.location.y
                        let newFrac = 1 - (y / tubeH)
                        fraction = min(1, max(0, newFrac))
                    }
            )
            .accessibilityLabel("Draggable mercury level")
        }
        .frame(width: 100, height: height)
    }

    // MARK: - Digital

    private var digitalThermometer: some View {
        VStack(spacing: 8) {
            Image(systemName: SFSymbolCompat.name("thermometer.medium"))
                .font(.system(size: 60))
                .foregroundColor(.red)
            Text(String(format: "%.1f °C", tempC))
                .font(.system(size: 36, weight: .bold, design: .monospaced))
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(NSColor.windowBackgroundColor))
                .shadow(color: .black.opacity(0.1), radius: 10)
        )
        .accessibilityLabel("Digital thermometer reading \(Int(tempC)) degrees")
    }

    private func adjustFraction(by delta: CGFloat) {
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.4)) {
            fraction = min(1, max(0, fraction + delta))
        }
    }
}
