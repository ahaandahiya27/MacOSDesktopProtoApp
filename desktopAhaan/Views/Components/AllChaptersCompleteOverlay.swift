import SwiftUI

// Extracted from ContentView.swift 2026-05-22 (E1 split). The all-
// chapters-complete celebration is used only by ContentView (as an
// .overlay on the root NavigationView).


/// One-time celebration shown when the student finishes every Discover
/// scene across all 19 science chapters (171 scenes total). Triggered
/// in ContentView's onChange on `dataStore.discoverProgress.count`; the
/// `hasSeenAllChaptersCelebration` @AppStorage flag prevents reappearance.
///
/// Lives inline in ContentView.swift (not its own file) for the same
/// reason WelcomeSheet + KeyboardShortcutsSheet do — avoids the
/// Xcode-project add-file ceremony for these small companion views.
///
/// Big Sur compatible: pure SwiftUI, no `.foregroundStyle`, no
/// `.symbolEffect`, no macOS 12+ APIs.
// De-privatised when extracted from ContentView.swift 2026-05-22.
struct AllChaptersCompleteOverlay: View {
    @Binding var isVisible: Bool
    let totalScenes: Int
    let totalBossQuizScore: Int?
    let totalBossQuizMax: Int?

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var celebrate = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.55)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            cardBody
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

            if celebrate {
                ParticleEmitter(isActive: true, particleCount: HardwareTier.particleBudget, duration: 4.0)
                    .allowsHitTesting(false)
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            withAnimationRespectingReduceMotion(
                .spring(response: 0.6, dampingFraction: 0.7).delay(0.1)
            ) {
                celebrate = true
            }
        }
    }

    @ViewBuilder
    private var cardBody: some View {
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
                    .font(.title3.monospacedDigit().bold())
                    .foregroundColor(.white)
                    .padding(.top, DesignTokens.Spacing.xs)
            }

            Text("From plants and digestion to light and the Moon — you've explored every chapter of Class 7 Science. Class 8 has more waiting.")
                .font(.callout)
                .foregroundColor(.white.opacity(0.85))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .padding(.horizontal, DesignTokens.Spacing.xl)
                .padding(.top, DesignTokens.Spacing.xs)

            Button(action: dismiss) {
                Text("Continue")
                    .font(.body.weight(.semibold))
                    .padding(.horizontal, DesignTokens.Spacing.xxl)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(Color.white))
                    .foregroundColor(.black)
            }
            .buttonStyle(.plain)
            // Esc and Return both dismiss — this is a hand-rolled overlay
            // (not a .sheet), so without these a keyboard-only user is stuck.
            .keyboardShortcut(.cancelAction)
            .padding(.top, DesignTokens.Spacing.md)
            .accessibilityLabel("Dismiss celebration")
            .accessibilityIdentifier("all-chapters-complete-continue")
        }
    }

    private func dismiss() {
        withAnimation(reduceMotion ? .none : .easeOut(duration: 0.25)) {
            isVisible = false
        }
    }
}
