import SwiftUI

/// Scene 2 — Tearing vs Burning Paper.
/// Split screen: left side tears paper (physical), right side burns paper (chemical).
/// Tap each side for explanation. After both tapped: comparison card + GotItButton.

struct Scene2_TearingVsBurningPaper: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var tornTapped = false
    @State private var burntTapped = false
    @State private var paperTorn = false
    @State private var paperBurning = false
    @State private var paperBurnt = false
    @State private var meltVsCook = true   // free-play DiscoveryToggle: melting (physical) vs cooking (chemical)
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var bothDone: Bool { tornTapped && burntTapped }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 16) {
                    Text("Tearing vs Burning Paper")
                        .font(.largeTitle.bold())
                        .padding(.top, 18)

                    Text("Two actions on the same paper. One is physical, the other chemical.")
                        .font(.callout)
                        .foregroundColor(.secondary)

                    HStack(spacing: 24) {
                        // Left: Tearing
                        VStack(spacing: 12) {
                            Text("Tearing Paper")
                                .font(.headline)
                                .foregroundColor(.green)

                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.green.opacity(0.05))
                                    .frame(width: 200, height: 200)

                                if !paperTorn {
                                    paperSheet
                                } else {
                                    HStack(spacing: 10) {
                                        paperPiece.rotationEffect(.degrees(-6))
                                        paperPiece.rotationEffect(.degrees(6))
                                    }
                                }
                            }

                            Button("Tear it") {
                                withAnimation(reduceMotion ? .none : .spring()) {
                                    paperTorn = true
                                    tornTapped = true
                                }
                            }
                            
                            .accentColor(.green)
                            .disabled(paperTorn)

                            if tornTapped {
                                Text("Physical change")
                                    .font(.caption.bold())
                                    .foregroundColor(.green)
                                Text("Still paper. Same substance.\nJust smaller pieces.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .frame(maxWidth: 240)

                        Divider().frame(height: 300)

                        // Right: Burning
                        VStack(spacing: 12) {
                            Text("Burning Paper")
                                .font(.headline)
                                .foregroundColor(.orange)

                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.orange.opacity(0.05))
                                    .frame(width: 200, height: 200)

                                if !paperBurning && !paperBurnt {
                                    paperSheet
                                } else if paperBurning {
                                    ZStack {
                                        paperSheet.opacity(0.4)
                                        Text("🔥")
                                            .font(.system(size: 70))
                                    }
                                } else {
                                    VStack(spacing: 6) {
                                        Text("💨 CO₂ + H₂O")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(Color.gray.opacity(0.5))
                                            .frame(width: 80, height: 14)
                                        Text("Ash")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }

                            Button("Burn it") {
                                withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.4)) {
                                    paperBurning = true
                                }
                                Task { @MainActor in
                                    try? await Task.sleep(nanoseconds: 1_500_000_000)
                                    withAnimation {
                                        paperBurning = false
                                        paperBurnt = true
                                        burntTapped = true
                                    }
                                }
                            }
                            
                            .accentColor(.orange)
                            .disabled(paperBurning || paperBurnt)

                            if burntTapped {
                                Text("Chemical change")
                                    .font(.caption.bold())
                                    .foregroundColor(.red)
                                Text("New substances formed:\nash, CO₂, H₂O. Irreversible.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .frame(maxWidth: 240)
                    }
                    .padding(.top, 8)

                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 14) {
                    Spacer()
                    if bothDone {
                        SoftShadowCard(padding: 18) {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Key difference", systemImage: "arrow.left.arrow.right")
                                    .font(.title2.bold())
                                Text("Tearing changes only the size and shape — the substance stays the same (physical change). Burning produces entirely new substances — ash, carbon dioxide, and water vapour (chemical change). You can tape torn paper back, but you can never un-burn ash.")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
                    }

                    DiscoveryToggle(
                        title: "Discovery — physical or chemical?",
                        subtitle: "Two everyday changes. Same kitchen. Which is which?",
                        optionA: "🧊 Ice melting",
                        optionB: "🍳 Egg cooking",
                        selectionIsA: $meltVsCook,
                        outputA: "Physical change. Same H₂O molecule, just rearranging from solid → liquid. Pop it in the freezer and it's ice again.",
                        outputB: "Chemical change. Heat tangles egg-white proteins permanently. No way to un-cook back to a raw egg."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    if bothDone {
                        GotItButton { onComplete() }
                            .padding(.bottom, 12)
                    } else {
                        Text("Try both sides to continue")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 12)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)
            }
        }
    }

    // MARK: - Helpers

    private var paperSheet: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(NSColor.controlBackgroundColor))
            .frame(width: 100, height: 130)
            .overlay(
                VStack(spacing: 6) {
                    ForEach(0..<5, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(.gray.opacity(0.15))
                            .frame(height: 4)
                    }
                }
                .padding(14)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(.gray.opacity(0.3), lineWidth: 1)
            )
    }

    private var paperPiece: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color(NSColor.controlBackgroundColor))
            .frame(width: 42, height: 110)
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .strokeBorder(.gray.opacity(0.3), lineWidth: 1)
            )
    }
}
