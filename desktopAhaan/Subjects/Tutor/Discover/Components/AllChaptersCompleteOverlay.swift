import SwiftUI

/// One-time celebration overlay shown when the student finishes every
/// Discover scene across all 19 science chapters (171 scenes). Closes
/// DM7 + EM4 from the visual-sweep taxonomy: until this overlay shipped,
/// there was no whole-Discover-Mode completion moment — per-scene
/// scale-pop celebrations (MO3) and per-chapter ring-fills existed, but
/// no "you finished everything" experience.
///
/// Triggering logic lives in `DataStore.allDiscoverChaptersComplete`.
/// A `@AppStorage` flag suppresses the overlay after first dismissal so
/// it doesn't reappear on every launch — Ahaan sees it once, ever.
///
/// macOS 11 / Swift 5.5 compatible: pure SwiftUI primitives, no
/// `.foregroundStyle`, no `.symbolEffect`, no macOS 12+ APIs.
struct AllChaptersCompleteOverlay: View {
    @Binding var isVisible: Bool

    /// Score-summary stats passed from the DataStore consumer. Optional
    /// because the overlay should still work even if the consumer hasn't
    /// wired summary stats yet — only the headline message is essential.
    let totalScenes: Int
    let totalBossQuizScore: Int?
    let totalBossQuizMax: Int?

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var celebrate = false

    var body: some View {
        ZStack {
            // Dim background to focus attention.
            Color.black.opacity(0.55)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            VStack(spacing: 18) {
                Text("🎉")
                    .font(.system(size: 96))
                    .scaleEffect(celebrate ? 1.0 : 0.5)
                    .opacity(celebrate ? 1.0 : 0.0)

                Text("You finished Discover Mode!")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text("All 19 chapters · \(totalScenes) scenes explored")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)

                if let score = totalBossQuizScore, let maxScore = totalBossQuizMax, maxScore > 0 {
                    Text("Boss Quiz total: \(score) / \(maxScore)")
                        .font(.title3.monospacedDigit())
                        .foregroundColor(.yellow)
                        .padding(.top, 4)
                }

                Text("From plants and digestion to light and the Moon — you've explored every chapter of Class 7 Science. Class 8 has more waiting.")
                    .font(.callout)
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.horizontal, 24)
                    .padding(.top, 4)

                Button(action: dismiss) {
                    Text("Continue")
                        .font(.body.weight(.semibold))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 10)
                        .background(Capsule().fill(Color.white))
                        .foregroundColor(.black)
                }
                .buttonStyle(.plain)
                .padding(.top, 12)
                .accessibilityLabel("Dismiss celebration")
            }
            .frame(maxWidth: 520)
            .padding(36)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(
                        colors: [Color.compatIndigo, Color.purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 8)

            // Confetti layer, only after a short delay so it doesn't
            // collide with the scale-in animation.
            if celebrate {
                ParticleEmitter(isActive: true, particleCount: 80, duration: 4.0)
                    .allowsHitTesting(false)
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            if reduceMotion {
                celebrate = true
            } else {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                    celebrate = true
                }
            }
        }
    }

    private func dismiss() {
        if reduceMotion {
            isVisible = false
        } else {
            withAnimation(.easeOut(duration: 0.25)) {
                isVisible = false
            }
        }
    }
}
