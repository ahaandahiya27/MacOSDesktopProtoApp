import SwiftUI

/// Scene 1 — Heart Beats. Custom 4-chamber heart drawn with `Path`. Pulses
/// at the chosen BPM. Right side (oxygen-poor) blue, left side (oxygen-rich)
/// red, with arrows showing which side pumps where.
struct Scene1_HeartBeats: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var bpm: Double = 72
    @State private var pulse = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("Heart Beats").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Set a heart rate. Watch the beat.").font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                FourChamberHeart()
                    .frame(width: 220, height: 220)
                    .scaleEffect(pulse ? 1.10 : 1.0)
                    // Big Sur (macOS 11) lacks `.animation(_:value:)`; drive
                    // the pulse via withAnimation around the state-flip in
                    // .onAppear instead. Honors reduceMotion + HardwareTier.
                    .onAppear {
                        guard !reduceMotion else { return }
                        let dur = HardwareTier.duration(ideal: 60.0 / bpm / 2.0)
                        withAnimation(.easeInOut(duration: dur).repeatForever(autoreverses: true)) {
                            pulse = true
                        }
                    }
                    .accessibilityLabel("Four-chamber heart, beating at \(Int(bpm)) BPM")

                Text("\(Int(bpm)) BPM")
                    .font(.system(size: 36, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.compatIndigo)

                Slider(value: $bpm, in: 50...180, step: 1).frame(maxWidth: 460).padding(.horizontal, 24)
                HStack {
                    Text("Rest").font(.caption).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary); Spacer()
                    Text("Exercising").font(.caption).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }.frame(maxWidth: 460).padding(.horizontal, 24)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Two pumps in one organ", systemImage: "heart.fill")
                            .font(.title2.bold())
                        Text("Your heart has 4 chambers — two on top (atria) and two below (ventricles). The right side sends blood to the lungs to grab oxygen. The left side pumps that oxygen-rich blood to the whole body. Around 100,000 beats a day.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

                // Grouped so the outer VStack stays within Swift 5.5's
                // 10-child ViewBuilder limit (Xcode 13.2.1 / Big Sur target).
                Group {
                    HotspotDiagram(
                        title: "Heart parts — tap each chamber",
                        baseSymbol: "heart.fill",
                        baseColor: .red,
                        hotspots: [
                            .init(x: 0.30, y: 0.30, label: "Right atrium",
                                  detail: "Receives oxygen-poor blood from the body via the vena cavae. Pushes it into the right ventricle."),
                            .init(x: 0.70, y: 0.30, label: "Left atrium",
                                  detail: "Receives oxygen-rich blood from the lungs via the pulmonary veins. Pushes it into the left ventricle."),
                            .init(x: 0.30, y: 0.65, label: "Right ventricle",
                                  detail: "Pumps oxygen-poor blood TO the lungs through the pulmonary artery. Thinner wall — short trip."),
                            .init(x: 0.70, y: 0.65, label: "Left ventricle",
                                  detail: "Pumps oxygen-rich blood to the WHOLE body through the aorta. Thickest wall — biggest job."),
                            .init(x: 0.50, y: 0.15, label: "Aorta + Vena cavae",
                                  detail: "The big pipes on top: aorta carries blood out to the body; vena cavae bring it back."),
                            .init(x: 0.50, y: 0.50, label: "Septum",
                                  detail: "The muscular wall between left and right sides. Stops oxygen-rich and oxygen-poor blood from mixing.")
                        ]
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)

                    LookingAheadCallout(
                        title: "Class 11 Biology → NEET",
                        detail: "In Class 11 \"Body Fluids and Circulation\", the same heart you played with here becomes the focus: SAN/AVN pacemaker cells, cardiac cycle, ECG reading, double circulation. A perennial NEET high-yield topic."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)

                    TryAtHomeCallout(
                        title: "Heartbeat through a tube",
                        detail: "Roll up a sheet of paper into a long tube. Press one end to a friend's chest (over the heart, below the left collarbone) and the other to your ear. Listen — you'll hear lub-DUB...lub-DUB."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)

                    RelatedConceptsCallout(
                        title: "Related: Ch 10 (Respiration), Ch 1 (Nutrition in Plants)",
                        detail: "The heart's right side pumps blood TO the lungs (Ch 10) to pick up oxygen; the left side pumps it to every cell that respires (Ch 10 again). The same oxygen was made by plants doing photosynthesis (Ch 1)."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)
                }

                GotItButton { onComplete() }.padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// A simplified anatomical heart: outer rounded "heart shape" silhouette,
/// split vertically into right (blue, deoxygenated) and left (red, oxygenated),
/// with a horizontal line separating atrium (top) from ventricle (bottom).
private struct FourChamberHeart: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                // Right half (oxygen-poor — blue)
                HalfHeart(side: .right)
                    .fill(Color.blue.opacity(0.7))
                // Left half (oxygen-rich — red)
                HalfHeart(side: .left)
                    .fill(Color.red.opacity(0.75))

                // Vertical septum
                Path { p in
                    p.move(to: CGPoint(x: w / 2, y: h * 0.10))
                    p.addLine(to: CGPoint(x: w / 2, y: h * 0.92))
                }
                .stroke(Color.white, lineWidth: 3)

                // Atrium/ventricle horizontal divider
                Path { p in
                    p.move(to: CGPoint(x: w * 0.12, y: h * 0.45))
                    p.addLine(to: CGPoint(x: w * 0.88, y: h * 0.45))
                }
                .stroke(Color.white.opacity(0.85), lineWidth: 2)

                // Labels
                Text("RA").font(.caption2.bold()).foregroundColor(.white)
                    .position(x: w * 0.30, y: h * 0.28)
                Text("LA").font(.caption2.bold()).foregroundColor(.white)
                    .position(x: w * 0.70, y: h * 0.28)
                Text("RV").font(.caption2.bold()).foregroundColor(.white)
                    .position(x: w * 0.32, y: h * 0.68)
                Text("LV").font(.caption2.bold()).foregroundColor(.white)
                    .position(x: w * 0.68, y: h * 0.68)
            }
        }
    }
}

/// One half of the heart silhouette. Drawn as a smooth lobed shape so the
/// two halves together form a recognisable heart outline.
private struct HalfHeart: Shape {
    enum Side { case left, right }
    let side: Side

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        let midX = w / 2

        if side == .left {
            // Top lobe + right side curve + bottom point — drawn left to right.
            p.move(to: CGPoint(x: midX, y: h * 0.20))
            p.addQuadCurve(to: CGPoint(x: midX, y: h * 0.08),
                           control: CGPoint(x: midX + w * 0.04, y: h * 0.02))
            p.addCurve(to: CGPoint(x: w * 0.95, y: h * 0.35),
                       control1: CGPoint(x: midX + w * 0.20, y: h * 0.00),
                       control2: CGPoint(x: w * 0.98, y: h * 0.10))
            p.addQuadCurve(to: CGPoint(x: midX, y: h * 0.95),
                           control: CGPoint(x: w * 0.95, y: h * 0.75))
            p.addLine(to: CGPoint(x: midX, y: h * 0.20))
        } else {
            p.move(to: CGPoint(x: midX, y: h * 0.20))
            p.addQuadCurve(to: CGPoint(x: midX, y: h * 0.08),
                           control: CGPoint(x: midX - w * 0.04, y: h * 0.02))
            p.addCurve(to: CGPoint(x: w * 0.05, y: h * 0.35),
                       control1: CGPoint(x: midX - w * 0.20, y: h * 0.00),
                       control2: CGPoint(x: w * 0.02, y: h * 0.10))
            p.addQuadCurve(to: CGPoint(x: midX, y: h * 0.95),
                           control: CGPoint(x: w * 0.05, y: h * 0.75))
            p.addLine(to: CGPoint(x: midX, y: h * 0.20))
        }
        return p
    }
}
