import SwiftUI

/// Scene 2 — Air Pressure Drop. Hold to "blow" between two paper strips and
/// watch them come together — fast air = low pressure (Bernoulli, made simple).
struct Scene2_AirPressureDrop: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var blowing = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 14) {
            Text("Air Pressure Drop").font(.largeTitle.bold()).padding(.top, 18)
            Text("Press & hold the button. Watch the two paper strips swing together.")
                .font(.callout).foregroundColor(.secondary)

            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.compatCyan.opacity(0.08))
                    .frame(width: 360, height: 260)

                HStack(spacing: blowing ? 30 : 130) {
                    paper
                    paper
                }
                .animation(reduceMotion ? .none : .easeInOut(duration: 0.5), value: blowing)
            }

            Button { } label: {
                Text(blowing ? "Blowing…" : "Press & hold to blow")
                    .font(.headline)
                    .padding(.horizontal, 18).padding(.vertical, 10)
            }
            .accentColor(Color.compatIndigo)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in if !blowing { blowing = true } }
                    .onEnded { _ in blowing = false }
            )

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Fast-moving air has lower pressure", systemImage: "wind")
                        .font(.title2.bold())
                    Text("Blowing between the strips makes the air there move quickly. Quick-moving air pushes less sideways, so the slower air outside pushes the strips together. Cyclones, hurricanes, even airplane wings use this idea.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var paper: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color.white)
            .frame(width: 28, height: 160)
            .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Color.gray.opacity(0.4)))
            .shadow(radius: 2)
    }
}
