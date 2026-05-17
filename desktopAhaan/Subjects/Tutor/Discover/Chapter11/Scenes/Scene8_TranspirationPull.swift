import SwiftUI

/// Scene 8 — Transpiration Pull. Drop a polythene cover over a leaf cluster;
/// droplets form inside in minutes.
struct Scene8_TranspirationPull: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var covered = false
    @State private var seconds: Int = 0
    @State private var runID: UUID = UUID()

    var body: some View {
        VStack(spacing: 14) {
            Text("Transpiration Pull").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Cover a leafy branch with polythene. Watch water vapour collect.")
                .font(.callout).foregroundColor(.secondary)

            ZStack {
                RoundedRectangle(cornerRadius: 18).fill(Color.green.opacity(0.10))
                    .frame(width: 320, height: 260)
                VStack(spacing: 6) {
                    if covered {
                        Text("💧💧💧").font(.system(size: 36))
                            .opacity(seconds >= 3 ? 1 : 0)
                    }
                    Text("🌿").font(.system(size: 80))
                }
            }
            .overlay(
                covered
                ? RoundedRectangle(cornerRadius: 18)
                    .strokeBorder(Color.blue.opacity(0.6), style: StrokeStyle(lineWidth: 3, dash: [6]))
                    .frame(width: 320, height: 260)
                : nil
            )

            HStack(spacing: 16) {
                Button(covered ? "Remove cover" : "Add polythene cover") {
                    covered.toggle()
                    if covered {
                        let token = UUID()
                        runID = token
                        seconds = 0
                        advance(token: token)
                    } else {
                        runID = UUID()  // invalidate any pending advance
                        seconds = 0
                    }
                }
                .accentColor(Color.compatIndigo)
                if covered { Text("\(seconds)s").font(.headline).foregroundColor(.secondary) }
            }

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Plants sweat — and it pulls water up", systemImage: "drop.degreesign")
                        .font(.title2.bold())
                    Text("Water vapour leaves through stomata in the leaf. This loss creates a suction that drags more water up the xylem all the way from the roots — like sipping through a straw, but powered by evaporation.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onDisappear { runID = UUID() }
    }

    private func advance(token: UUID) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            guard token == runID, covered else { return }
            seconds += 1
            if seconds < 5 { advance(token: token) }
        }
    }
}
