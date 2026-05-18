import SwiftUI

/// Scene 5 — Kidney Filter. Tap to send "dirty blood" through the kidney
/// → clean blood + urine.
struct Scene5_KidneyFilter: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var filtered = false
    @State private var waterIntakeML: Double = 500     // free-play slider: water you drink

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    VStack(spacing: 14) {
                Text("Kidney Filter").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Tap the button to push blood through the kidney.").font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                HStack(spacing: 24) {
                    VStack {
                        Text(filtered ? "❤️" : "🟤").font(.system(size: 56))
                        Text(filtered ? "Clean blood" : "Dirty blood").font(.caption)
                    }
                    Text("→").font(.title.bold()).foregroundColor(Color.compatIndigo)
                    Text("🫘").font(.system(size: 80))
                        .accessibilityLabel("Kidney filtering blood")
                    Text("→").font(.title.bold()).foregroundColor(Color.compatIndigo)
                    VStack {
                        Text(filtered ? "💧" : "—").font(.system(size: 56))
                        Text(filtered ? "Urine" : "(waste)").font(.caption)
                    }
                }

                Button(filtered ? "Reset" : "Filter blood now") { filtered.toggle() }
                    .accentColor(Color.compatIndigo)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Two bean-shaped life-savers", systemImage: "drop.fill")
                            .font(.title2.bold())
                        Text("Your kidneys filter about 180 litres of blood every day. They remove urea (a waste from protein breakdown) and extra water, sending them to the bladder as urine. Useful nutrients are kept and returned to the blood.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

                // Grouped to stay within Swift 5.5's 10-child ViewBuilder limit
                // (Big Sur / Xcode 13.2.1 target).
                Group {
                    LookingAheadCallout(
                        title: "Class 11 Bio → NEET",
                        detail: "Class 11 'Excretory Products and their Elimination' covers nephron anatomy in detail, glomerular filtration rate (~125 mL/min), the loop of Henle counter-current multiplier, ADH and aldosterone hormones, and dialysis. The nephron diagram is one of the most-tested NEET visuals year after year."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)

                    TryAtHomeCallout(
                        title: "Water in, water out",
                        detail: "Drink 500 mL of water all at once. Note the time. Within 30-60 minutes you'll feel the need to urinate — that's your kidneys filtering the extra water out of your blood."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)
                }

                DiscoveryWidget(
                    title: "Discovery — how fast do kidneys respond?",
                    subtitle: "Imagine you drink this much water now. Drag to see roughly when you'll need to pee.",
                    value: $waterIntakeML,
                    range: 100...1500,
                    step: 50,
                    valueLabel: { v in String(format: "Drank: %.0f mL", v) },
                    output: kidneyResponseExplanation
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                GotItButton { onComplete() }.padding(.bottom, 12)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func kidneyResponseExplanation(_ ml: Double) -> String {
        // Rough model: kidneys filter ~125 mL/min (GFR). Bladder triggers
        // urge around 200-300 mL of additional urine produced.
        let triggerML: Double = 250
        let minsToUrge = (ml / 1500.0) * 60.0 + 15  // 100mL ≈ 19 min, 1500mL ≈ 75 min
        let label: String
        switch ml {
        case ..<200:
            label = "A sip. Kidneys absorb without much fuss — urge in about \(Int(minsToUrge)) minutes."
        case ..<600:
            label = "A normal glass. Urge in roughly \(Int(minsToUrge)) min — kidneys filter steadily at ~125 mL/min."
        case ..<1100:
            label = "Half a litre or more. \(Int(minsToUrge)) min to bladder full — your body sweats less to save the water."
        default:
            label = "Big chug! \(Int(minsToUrge)) min until you NEED a toilet. Anti-diuretic hormone (ADH) drops sharply."
        }
        _ = triggerML
        return label
    }
}
