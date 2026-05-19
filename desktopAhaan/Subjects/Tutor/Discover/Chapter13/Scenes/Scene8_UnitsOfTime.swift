import SwiftUI

/// Scene 8 — Units of Time. Tap each device to learn its accuracy & era.
struct Scene8_UnitsOfTime: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    enum Device: String, CaseIterable, Identifiable {
        case sundial = "Sundial", waterClock = "Water clock", sand = "Sand clock", pendulum = "Pendulum clock", quartz = "Quartz watch", atomic = "Atomic clock"
        var id: String { rawValue }
        var emoji: String {
            switch self { case .sundial: return "🌞"; case .waterClock: return "💧"; case .sand: return "⏳"; case .pendulum: return "🕰"; case .quartz: return "⌚"; case .atomic: return "⚛️" }
        }
        var era: String {
            switch self {
            case .sundial:    return "~2000 BCE · accurate to ~15 min"
            case .waterClock: return "~1500 BCE · accurate to ~10 min"
            case .sand:       return "~700 CE · short intervals"
            case .pendulum:   return "1656 · accurate to seconds/day"
            case .quartz:     return "1927 · seconds/year"
            case .atomic:     return "1955 · 1 second in 100 million years"
            }
        }
    }

    @State private var device: Device = .sundial

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    LazyVStack(alignment: .center, spacing: 14) {
                Text("Units of Time").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Humans have measured time for thousands of years. Each device was a leap forward.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary).multilineTextAlignment(.center)

                Picker("", selection: $device) {
                    ForEach(Device.allCases) { Text($0.rawValue).tag($0) }
                }.pickerStyle(.menu)

                Text(device.emoji).font(.system(size: 96))

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(device.rawValue).font(.title3.bold())
                        Text(device.era).font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

                LookingAheadCallout(
                    title: "Class 11 Physics → JEE",
                    detail: "Class 11 'Units and Measurements' covers the SI base units: metre, kilogram, second, ampere, kelvin, mole, candela. The second is now defined using the caesium-133 atomic clock (exact). JEE asks unit-system conversion problems."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Inventory of clocks",
                    detail: "List every timekeeping device in your home: phone (atomic-clock-synced), wall clock (quartz), wristwatch, microwave timer, oven timer, kitchen stopwatch, computer system clock. Note which is fastest to read at a glance — that's why each one is shaped the way it is."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                GotItButton { onComplete() }.padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }
}
