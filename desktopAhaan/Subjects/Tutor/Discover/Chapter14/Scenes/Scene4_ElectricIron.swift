import SwiftUI

/// Scene 4 — Inside an Electric Iron. Tap each part of an iron to see its job.
struct Scene4_ElectricIron: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    enum Part: String, CaseIterable, Identifiable {
        case element = "Heating element", thermo = "Thermostat", plate = "Soleplate", flex = "Flex"
        var id: String { rawValue }
        var role: String {
            switch self {
            case .element: return "Coil of nichrome wire. Heats up when current flows."
            case .thermo:  return "A bimetallic strip — bends and breaks the circuit when too hot, switches it back on when cooler."
            case .plate:   return "Flat metal base. Spreads heat evenly onto the cloth."
            case .flex:    return "Insulated wire carrying current safely from the plug."
            }
        }
    }

    @State private var pick: Part = .element
    @State private var currentA: Double = 5    // free-play: current through the heating coil

    var body: some View {
        VStack(spacing: 14) {
            Text("Inside an Electric Iron").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Tap any part to see what it does.").font(.callout).foregroundColor(.secondary)

            ZStack {
                RoundedRectangle(cornerRadius: 18).fill(Color.orange.opacity(0.10))
                    .frame(width: 320, height: 200)
                Text("🪨").font(.system(size: 70))
                Text("🟥").font(.system(size: 80)).opacity(0.4)
            }

            Picker("", selection: $pick) {
                ForEach(Part.allCases) { Text($0.rawValue).tag($0) }
            }.pickerStyle(.segmented).frame(maxWidth: 520).padding(.horizontal, 16)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(pick.rawValue).font(.title3.bold())
                    Text(pick.role).font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 10 → JEE",
                detail: "Class 10 covers thermostat (bimetallic strip) physics in 'Heating Effects of Electric Current'. Class 12 / JEE adds the temperature coefficient of resistance α — why nichrome is used (low α) for stable heating elements."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Cool vs hot iron base",
                detail: "Touch an unplugged iron's bottom plate — cool. After turning it on for 1 minute, hold a hand 10 cm above it (NEVER touch). The heat shimmer is visible — that's the heating element's I²R energy radiating."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            DiscoveryWidget(
                title: "Discovery — Joule's law in your hand",
                subtitle: "P = I²R. Drag the current and watch the heating power for a typical 50 Ω nichrome coil.",
                value: $currentA,
                range: 0...10,
                step: 0.5,
                valueLabel: { v in String(format: "Current: %.1f A", v) },
                output: ironPowerExplanation
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func ironPowerExplanation(_ amps: Double) -> String {
        let R: Double = 50              // nichrome coil resistance (Ω)
        let power = amps * amps * R     // Joule's law: P = I²R, watts
        switch amps {
        case ..<1:
            return String(format: "Power ≈ %.0f W. Barely warm — wouldn't iron a shirt.", power)
        case ..<3:
            return String(format: "Power ≈ %.0f W. A low-temperature delicate setting.", power)
        case ..<6:
            return String(format: "Power ≈ %.0f W. A normal cotton-setting iron.", power)
        default:
            return String(format: "Power ≈ %.0f W. High setting — would scorch a thin fabric if held still.", power)
        }
    }
}
