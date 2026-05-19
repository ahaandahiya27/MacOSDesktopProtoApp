import SwiftUI

/// Scene 7 — The Cocoon Reel.
///
/// Cocoon in centre. "Pull thread!" button unwinds filament onto a reel to the right.
/// Counter: "Filament unwound: X m / 1200 m". When full, cocoon shrinks and finished thread shown.
/// Includes ethics disclosure: "Why is the pupa killed?"
/// Big Sur (macOS 11) compatible — reel + wrapped thread drawn with
/// Ellipse + dynamic Shape (CocoonReelThreadShape) instead of Canvas.
struct Scene7_TheCocoonReel: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var metersUnwound: Double = 0
    @State private var cocoonScale: CGFloat = 1.0
    @State private var showFinished = false
    @State private var showEthicsDisclosure = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let maxMeters = 1200.0

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 18) {
                HStack {
                    Text("The Cocoon Reel")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color.compatIndigo)
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Progress")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        ProgressView(value: metersUnwound, total: maxMeters)
                            .frame(width: 120)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // Visualization
                ZStack {
                    HStack(spacing: 40) {
                        // Cocoon
                        VStack {
                            Text("🛏")
                                .font(.system(size: 64))
                                .scaleEffect(cocoonScale)
                            Text("Cocoon")
                                .font(.caption)
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        }
                        .frame(maxWidth: .infinity)

                        // Reel with wrapped thread (Shapes, was Canvas)
                        VStack {
                            ZStack(alignment: .topLeading) {
                                ZStack {
                                    Ellipse().fill(Color.gray.opacity(0.3))
                                    Ellipse().stroke(Color.gray, lineWidth: 2)
                                }
                                .frame(width: 60, height: 60)
                                .offset(x: 140, y: 60)

                                CocoonReelThreadShape(metersUnwound: CGFloat(metersUnwound))
                                    .stroke(Color.yellow.opacity(0.7), lineWidth: 2)
                            }
                            .frame(width: 300, height: 150)

                            Text("Reel")
                                .font(.caption)
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 24)
                }
                .frame(height: 180)

                // Counter
                VStack(spacing: 4) {
                    Text("Filament Unwound")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    Text("\(Int(metersUnwound)) m / \(Int(maxMeters)) m")
                        .font(.title2.weight(.bold))
                        .foregroundColor(Color.compatIndigo)
                }

                Group {
                    // Pull thread button
                    Button {
                        pullThread()
                    } label: {
                        Label(metersUnwound >= maxMeters ? "Complete!" : "Pull Thread!", systemImage: "arrow.right.to.line")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .accentColor(Color.compatIndigo)
                    .disabled(metersUnwound >= maxMeters)
                    .padding(.horizontal, 24)

                    ExpandableCard(
                        isExpanded: $showEthicsDisclosure,
                        systemImage: "exclamationmark.circle",
                        title: "Why is the pupa killed?",
                        tint: .orange,
                        background: Color.white.opacity(0.95)
                    ) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Traditional silk production kills the pupa inside the cocoon before reeling so the cocoon remains whole and the fibre unbroken.")
                                .font(.caption)
                                .foregroundColor(DesignTokens.BrandColor.canvasText)
                            Divider()
                            Text("Some believe this is ethically questionable. Peace silk lets the moth emerge first, but yields shorter, lower-grade fibre. You can choose based on your values.")
                                .font(.caption)
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        }
                    }
                    .padding(.horizontal, 24)

                    LookingAheadCallout(
                        title: "Class 12 Materials Science → JEE",
                        detail: "Silk fibroin has a tensile strength close to steel by weight — JEE Materials questions love this comparison. Silk's secret: a β-pleated sheet structure where amino acids stack via hydrogen bonds. Modern bioengineering grows artificial spider silk in goats (transgenic, milked from milk) — same protein, factory scale."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)

                    TryAtHomeCallout(
                        title: "Pull test silk vs cotton",
                        detail: "Find a single thread of silk (a silk saree's frayed edge works) and a single cotton thread. Hold each between thumbs and pull steadily. Silk stretches noticeably then snaps. Cotton snaps almost immediately. You just measured tensile elongation — the same property structural engineers chart for steel and concrete."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)

                    GotItButton {
                        onComplete()
                    }
                    .padding(.bottom, 12)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    private func pullThread() {
        let pullAmount = 80.0 + Double.random(in: -20...20)
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) {
            metersUnwound = min(metersUnwound + pullAmount, maxMeters)
            if metersUnwound >= maxMeters {
                cocoonScale = 0.2
            } else {
                cocoonScale = 1.0 - (metersUnwound / maxMeters) * 0.7
            }
        }
    }
}

/// Spiral of progressively-larger arcs showing how much filament has been
/// wound onto the reel. Was a Canvas loop; rebuilt as a Shape so it
/// renders on macOS 11.
struct CocoonReelThreadShape: Shape {
    let metersUnwound: CGFloat

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let center = CGPoint(x: 170, y: 90)
        let wraps = Int(metersUnwound / 100)
        guard wraps > 0 else { return p }
        for i in 0..<wraps {
            let angle = CGFloat(i) * 0.2
            p.addArc(
                center: center,
                radius: 15 + CGFloat(i) * 2,
                startAngle: .degrees(0),
                endAngle: .degrees(Double(angle) * 57.3),
                clockwise: false
            )
        }
        return p
    }
}
