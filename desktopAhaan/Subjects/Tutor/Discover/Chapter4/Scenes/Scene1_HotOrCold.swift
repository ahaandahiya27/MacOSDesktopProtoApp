import SwiftUI

/// Scene 1 — Hot or Cold? The Touch Test.
/// Tap 6 objects and watch a thermometer animate to each temperature.

struct Scene1_HotOrCold: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var selectedIndex: Int? = nil
    @State private var mercuryHeight: CGFloat = 0.15
    @State private var displayTemp: Int = 20
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private struct ThermalObject: Identifiable {
        let id = UUID()
        let emoji: String
        let label: String
        let tempC: Int
        let fraction: CGFloat // 0…1 mapped onto thermometer
    }

    private let objects: [ThermalObject] = [
        ThermalObject(emoji: "🧊", label: "Ice cube", tempC: 0, fraction: 0.0),
        ThermalObject(emoji: "🥤", label: "Glass of water", tempC: 25, fraction: 0.25),
        ThermalObject(emoji: "🪵", label: "Wooden block", tempC: 27, fraction: 0.27),
        ThermalObject(emoji: "🥄", label: "Metal spoon", tempC: 28, fraction: 0.28),
        ThermalObject(emoji: "☕", label: "Hot tea cup", tempC: 70, fraction: 0.70),
        ThermalObject(emoji: "☀️", label: "Sun surface", tempC: 100, fraction: 1.0),
    ]

    var body: some View {
        // Refactored ZStack-overlap pattern to ScrollView+VStack.

        // Inner GeometryReader is preserved for size-relative

        // interactive content; cards now sit as siblings below it.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                GeometryReader { geo in
                    let thermoH: CGFloat = min(geo.size.height * 0.55, 340)
                    ZStack {
                HStack(spacing: 30) {
                    // Thermometer on the left
                    thermometerView
                        .frame(width: 80, height: thermoH)
                        .accessibilityLabel("Thermometer showing \(displayTemp) degrees Celsius")

                    // Object grid
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 16)], spacing: 16) {
                        ForEach(objects.indices, id: \.self) { idx in let obj = objects[idx];
                            Button {
                                selectObject(idx)
                            } label: {
                                VStack(spacing: 6) {
                                    Text(obj.emoji)
                                        .font(.system(size: 44))
                                    Text(obj.label)
                                        .font(.caption.weight(.medium))
                                    if selectedIndex == idx {
                                        Text("\(obj.tempC)°C")
                                            .font(.caption2.bold())
                                            .foregroundColor(DesignTokens.BrandColor.tryAtHome)
                                    }
                                }
                                .frame(width: 110, height: 100)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(selectedIndex == idx
                                              ? Color.orange.opacity(0.15)
                                              : Color.white)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .strokeBorder(selectedIndex == idx ? .orange : .clear, lineWidth: 2)
                                )
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("\(obj.label), \(obj.tempC) degrees Celsius")
                        }
                    }
                    .frame(maxWidth: 400)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, DesignTokens.Spacing.xxl)

                // Caption + button
                

                    }

                }

                .frame(height: 320)

                Group {
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            Label("Hot or Cold?", systemImage: SFSymbolCompat.name("hand.raised.fingers.spread"))
                                .font(.title2.bold())
                            Text("Different objects feel hot or cold because they are at different temperatures. Tap each object to see its temperature on the thermometer!")
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    LookingAheadCallout(
                        title: "Class 11 Physics → JEE (Thermodynamics)",
                        detail: "Hot vs cold is your nerves measuring heat FLOW into or out of skin, not absolute temperature. JEE asks: 'Why does metal at room temperature feel colder than wood at room temperature?' Same temperature, but metal conducts heat away from your skin 1000× faster — your nerves register the rapid heat-loss as 'cold'. Thermometers measure temperature; skin measures thermal conductivity."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    TryAtHomeCallout(
                        title: "Metal vs wood thermometer test",
                        detail: "Put a metal spoon and a wooden pencil side-by-side on your desk for 10 minutes. They're now both at room temperature. Touch each — the metal feels distinctly colder. Now check with a thermometer (kitchen or any digital) — same number for both. Your skin lied; the thermometer told the truth. This is JEE Q5 in disguise."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    GotItButton { onComplete() }
                        .padding(.bottom, DesignTokens.Spacing.md)
                

                }

                .padding(.horizontal, DesignTokens.Spacing.xl)
            

            }

            .frame(maxWidth: .infinity)

            .padding(.bottom, DesignTokens.Spacing.md)

        }
    }

    // MARK: - Thermometer

    private var thermometerView: some View {
        GeometryReader { geo in
            let bulbR: CGFloat = 24
            let tubeW: CGFloat = 16
            let tubeH: CGFloat = geo.size.height - bulbR * 2 - 10
            let bulbSize: CGFloat = bulbR * 2
            let mercuryW: CGFloat = tubeW - 4
            let mercuryH: CGFloat = tubeH * mercuryHeight
            let bulbPad: CGFloat = bulbR * 2 - 4
            let labelY: CGFloat = -tubeH * mercuryHeight - bulbR
            let tubeCornerRadius: CGFloat = tubeW / 2

            ZStack(alignment: .bottom) {
                // Tube background
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: tubeCornerRadius)
                        .fill(Color.gray.opacity(0.15))
                        .frame(width: tubeW, height: tubeH)
                    Circle()
                        .fill(Color.red.opacity(0.8))
                        .frame(width: bulbSize, height: bulbSize)
                }

                // Mercury fill
                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    RoundedRectangle(cornerRadius: tubeCornerRadius)
                        .fill(LinearGradient(colors: [.red, .red.opacity(0.7)], startPoint: .bottom, endPoint: .top))
                        .frame(width: mercuryW, height: mercuryH)
                        .padding(.bottom, bulbPad)
                    Spacer().frame(height: 0)
                }
                .frame(height: geo.size.height)

                // Temperature label
                Text("\(displayTemp)°C")
                    .font(.title3.bold().monospacedDigit())
                    .foregroundColor(.red)
                    .offset(x: 50, y: labelY)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }

    private func selectObject(_ idx: Int) {
        selectedIndex = idx
        let obj = objects[idx]
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.6)) {
            mercuryHeight = max(0.02, obj.fraction)
        }
        displayTemp = obj.tempC
    }
}
