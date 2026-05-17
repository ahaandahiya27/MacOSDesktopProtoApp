import SwiftUI

/// Scene 6 — Build an Electromagnet. More turns = stronger pickup.
struct Scene6_BuildElectromagnet: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var turns: Double = 20

    private var clipsHeld: Int { Int(turns / 4) }

    var body: some View {
        VStack(spacing: 14) {
            Text("Build an Electromagnet").font(.largeTitle.bold()).padding(.top, 18)
            Text("Wrap more turns of wire around the iron nail. Watch it grab more clips.")
                .font(.callout).foregroundColor(.secondary).multilineTextAlignment(.center)

            ZStack {
                RoundedRectangle(cornerRadius: 18).fill(Color.gray.opacity(0.08))
                    .frame(width: 320, height: 220)
                VStack(spacing: 6) {
                    Text("🔩").font(.system(size: 60))
                    HStack(spacing: 2) {
                        ForEach(0..<clipsHeld, id: \.self) { _ in
                            Text("📎").font(.system(size: 24))
                        }
                    }
                }
            }

            Text("Turns: \(Int(turns)) → Clips held: \(clipsHeld)")
                .font(.headline)
                .foregroundColor(Color.compatIndigo)

            Slider(value: $turns, in: 5...80, step: 1).frame(maxWidth: 460).padding(.horizontal, 24)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Switchable magnet", systemImage: "powerplug")
                        .font(.title2.bold())
                    Text("Wrap insulated wire around an iron nail and connect a battery. The nail becomes a magnet — but only while the current flows. More turns, stronger field. Used in cranes to pick up cars.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Iron-nail electromagnet",
                detail: "Wrap about 30 turns of insulated wire around a long iron nail. Connect the two ends to a 1.5 V cell. Hold the nail near steel paper clips — it picks them up. Disconnect the cell and the magnet switches off."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
