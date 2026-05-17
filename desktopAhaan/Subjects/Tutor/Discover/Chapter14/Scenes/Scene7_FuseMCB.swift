import SwiftUI

/// Scene 7 — Fuse & MCB. Push current up; once past 15A, the fuse blows.
struct Scene7_FuseMCB: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var current: Double = 5
    private var blown: Bool { current > 15 }

    var body: some View {
        VStack(spacing: 14) {
            Text("Fuse & MCB").font(.largeTitle.bold()).padding(.top, 18)
            Text("Push the current up. The fuse melts (or the MCB trips) past its rating.")
                .font(.callout).foregroundColor(.secondary).multilineTextAlignment(.center)

            ZStack {
                RoundedRectangle(cornerRadius: 18).fill(Color.gray.opacity(0.08))
                    .frame(width: 320, height: 200)
                VStack {
                    Text(blown ? "💥" : "🔌").font(.system(size: 60))
                    Text(blown ? "Fuse BLOWN — circuit broken" : "Safe").font(.headline)
                        .foregroundColor(blown ? .red : .green)
                }
            }

            Text("Current: \(String(format: "%.1f", current)) A   (limit 15 A)")
                .font(.title3.bold())
                .foregroundColor(blown ? .red : Color.compatIndigo)

            Slider(value: $current, in: 0...25, step: 0.1).frame(maxWidth: 460).padding(.horizontal, 24)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Safety first", systemImage: "shield.lefthalf.filled")
                        .font(.title2.bold())
                    Text("A fuse contains a thin wire that melts if too much current flows — breaking the circuit before things catch fire. A miniature circuit breaker (MCB) does the same job but you can reset it instead of replacing a wire.")
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
