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

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
