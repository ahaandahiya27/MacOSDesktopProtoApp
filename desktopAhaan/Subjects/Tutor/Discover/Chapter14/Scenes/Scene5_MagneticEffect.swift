import SwiftUI

/// Scene 5 — Magnetic Effect. Toggle current; compass needle swings.
struct Scene5_MagneticEffect: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var currentOn = false

    var body: some View {
        VStack(spacing: 14) {
            Text("Magnetic Effect").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Place a compass near a wire. Turn current on — needle swings.")
                .font(.callout).foregroundColor(.secondary)

            ZStack {
                RoundedRectangle(cornerRadius: 18).fill(Color.gray.opacity(0.08))
                    .frame(width: 320, height: 220)
                Rectangle().fill(currentOn ? Color.compatIndigo : Color.gray)
                    .frame(width: 240, height: 6)
                ZStack {
                    Circle().strokeBorder(Color.compatIndigo, lineWidth: 2).frame(width: 70, height: 70)
                    Image(systemName: "arrow.up")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.red)
                        .rotationEffect(.degrees(currentOn ? 90 : 0))
                        .animation(.easeInOut(duration: 0.5), value: currentOn)
                }
                .offset(y: 50)
            }

            Button(currentOn ? "Switch current OFF" : "Switch current ON") { currentOn.toggle() }
                .accentColor(Color.compatIndigo)

            Text(currentOn ? "✅ Needle deflects — current = magnet" : "Needle points north — no current")
                .font(.headline)
                .foregroundColor(currentOn ? .green : .secondary)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Hans Christian Ørsted, 1820", systemImage: "scope")
                        .font(.title2.bold())
                    Text("Ørsted discovered that an electric current creates a magnetic field around the wire. Every electromagnet, electric motor, doorbell, and MRI machine is built on this single observation.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            // Grouped so the outer VStack stays within Swift 5.5's
            // 10-child ViewBuilder limit (Xcode 13.2.1 / Big Sur target).
            Group {
                TryAtHomeCallout(
                    title: "Compass near a wire",
                    detail: "Place a compass on a flat table. Run a wire from a 1.5 V cell across the compass, switching the cell ON for a couple of seconds. The needle deflects — exactly Ørsted's 1820 observation. Reverse the cell polarity; the needle deflects the OTHER way. This single demonstration changed physics."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                LookingAheadCallout(
                    title: "Class 10 / 12 → JEE",
                    detail: "Class 10 covers the magnetic field of a straight wire (right-hand thumb rule). Class 12 'Magnetic Effects of Current' adds the Biot-Savart law (B = μ₀I / 2πr for a straight wire), Ampère's law, and the force F = BIL on a current-carrying conductor. This whole chain is a JEE Physics gold mine."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                RelatedConceptsCallout(
                    title: "Related: Ch 15 (Light)",
                    detail: "Electric current creates a magnetic field (Ørsted 1820). The reverse is also true — a changing magnetic field creates a current (Faraday). In Class 12 you'll learn light itself is an oscillating combination of these two — that's why Light (Ch 15) and Electricity (Ch 14) eventually merge."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)
            }

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
