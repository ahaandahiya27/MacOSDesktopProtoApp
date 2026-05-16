import SwiftUI

/// Scene 5 — Sea Breeze, Land Breeze.
/// Day/Night toggle shows convection currents reversing between sea and land.
/// Big Sur (macOS 11) compatible — breeze arrow animation now uses
/// Timer.publish + ForEach of BreezeArrow shapes instead of Canvas.
struct Scene5_SeaBreezeLandBreeze: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var isDay = true
    @State private var tick: TimeInterval = 0
    @State private var animationTimer: Timer? = nil
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 16) {
                    Spacer()

                    // Day / Night toggle
                    HStack(spacing: 12) {
                        Image(systemName: "sun.max.fill")
                            .foregroundColor(.yellow)
                            .opacity(isDay ? 1 : 0.3)
                        Toggle("", isOn: $isDay)
                            .toggleStyle(.switch)
                            .labelsHidden()
                        Image(systemName: "moon.fill")
                            .foregroundColor(Color.compatIndigo)
                            .opacity(isDay ? 0.3 : 1)
                        Text(isDay ? "Daytime" : "Nighttime")
                            .font(.headline)
                    }
                    .accessibilityLabel(isDay ? "Daytime mode" : "Nighttime mode")

                    // Landscape scene
                    ZStack {
                        // Sky
                        Rectangle()
                            .fill(isDay
                                  ? LinearGradient(colors: [Color.compatCyan.opacity(0.6), .blue.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                                  : LinearGradient(colors: [Color.compatIndigo.opacity(0.8), .black.opacity(0.6)], startPoint: .top, endPoint: .bottom))
                            .frame(height: 160)
                            .offset(y: -60)

                        // Sun or moon
                        Image(systemName: isDay ? "sun.max.fill" : "moon.stars.fill")
                            .font(.system(size: 40))
                            .foregroundColor(isDay ? .yellow : .white)
                            .offset(y: -120)
                            .accessibilityLabel(isDay ? "Sun" : "Moon")

                        // Land (right side)
                        HStack(spacing: 0) {
                            // Sea
                            Rectangle()
                                .fill(LinearGradient(colors: [.blue.opacity(0.5), Color.compatCyan.opacity(0.4)], startPoint: .top, endPoint: .bottom))
                            // Land
                            Rectangle()
                                .fill(LinearGradient(colors: [
                                    isDay ? Color.compatBrown.opacity(0.7) : Color.compatBrown.opacity(0.4),
                                    .green.opacity(0.5)
                                ], startPoint: .top, endPoint: .bottom))
                        }
                        .frame(height: 100)
                        .offset(y: 60)

                        // Labels
                        Text("Sea")
                            .font(.caption.bold())
                            .foregroundColor(.white)
                            .offset(x: -80, y: 60)
                        Text("Land")
                            .font(.caption.bold())
                            .foregroundColor(.white)
                            .offset(x: 80, y: 60)

                        // Heat indicators
                        if isDay {
                            // Land heats up fast
                            Text("HOT")
                                .font(.caption2.bold())
                                .foregroundColor(.red)
                                .offset(x: 80, y: 40)
                            Text("COOL")
                                .font(.caption2.bold())
                                .foregroundColor(.blue)
                                .offset(x: -80, y: 40)
                        } else {
                            Text("WARM")
                                .font(.caption2.bold())
                                .foregroundColor(.orange)
                                .offset(x: -80, y: 40)
                            Text("COOL")
                                .font(.caption2.bold())
                                .foregroundColor(.blue)
                                .offset(x: 80, y: 40)
                        }

                        // Arrows showing breeze direction
                        if !reduceMotion {
                            breezeArrows
                        } else {
                            staticArrow
                        }
                    }
                    .frame(maxWidth: 500, maxHeight: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(.gray.opacity(0.3), lineWidth: 1)
                    )

                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 14) {
                    Spacer()
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Sea Breeze & Land Breeze", systemImage: "wind")
                                .font(.title2.bold())
                            Text(isDay
                                 ? "During the day, land heats up faster than sea. Hot air rises over land, and cooler air rushes in from the sea — a sea breeze!"
                                 : "At night, land cools faster. The sea stays warmer, so hot air rises over the sea and cool air flows from land to sea — a land breeze!")
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    GotItButton { onComplete() }
                        .padding(.bottom, 12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)
            }
        }
    }

    private var staticArrow: some View {
        Image(systemName: isDay ? "arrow.left" : "arrow.right")
            .font(.title)
            .foregroundColor(.white)
            .offset(y: 10)
            .accessibilityLabel(isDay ? "Breeze from sea to land" : "Breeze from land to sea")
    }

    private var breezeArrows: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                ForEach(0..<4, id: \.self) { i in
                    BreezeArrow(index: i, t: tick, size: geo.size, isDay: isDay)
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityLabel(isDay ? "Animated sea breeze arrows" : "Animated land breeze arrows")
        .onAppear(perform: startAnimation)
        .onDisappear(perform: stopAnimation)
        .pauseTimerWhenBackgrounded(start: startAnimation, stop: stopAnimation)
    }

    private func startAnimation() {
        guard !reduceMotion, animationTimer == nil else { return }
        let start = Date().timeIntervalSince1970
        animationTimer = Timer.scheduledTimer(withTimeInterval: HardwareTier.interval(ideal: 1.0 / 15), repeats: true) { _ in
            tick = Date().timeIntervalSince1970 - start
        }
    }
    private func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
}

private struct BreezeArrow: View {
    let index: Int
    let t: TimeInterval
    let size: CGSize
    let isDay: Bool

    var body: some View {
        let p = compute()
        return BreezeArrowShape(centerX: p.x, centerY: p.y,
                                size: 16, pointsLeft: isDay)
            .fill(Color.white.opacity(0.8))
            .opacity(p.opacity)
    }

    private struct DotPos { let x: Double; let y: Double; let opacity: Double }
    private func compute() -> DotPos {
        let phase: Double = ((Double(t) * 1.2 + Double(index) * 0.5).truncatingRemainder(dividingBy: 2.5)) / 2.5
        let direction: Double = isDay ? -1.0 : 1.0
        let cx: Double = Double(size.width) * 0.5
        let y: Double = Double(size.height) * 0.45
        let x: Double = cx + direction * (phase * Double(size.width) * 0.4 - Double(size.width) * 0.05)
        let opacity: Double = sin(Double(phase) * Double.pi)
        return DotPos(x: x, y: y, opacity: opacity)
    }
}

/// A small triangle that points left (sea breeze, day) or right (land
/// breeze, night). Drawing the triangle as a Shape — rather than placing
/// a positioned Image — keeps the geometry identical to the old Canvas
/// path-based version.
private struct BreezeArrowShape: Shape {
    let centerX: Double
    let centerY: Double
    let size: CGFloat
    let pointsLeft: Bool

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let cx = CGFloat(centerX)
        let cy = CGFloat(centerY)
        if pointsLeft {
            p.move(to: CGPoint(x: cx - size, y: cy))
            p.addLine(to: CGPoint(x: cx, y: cy - size * 0.5))
            p.addLine(to: CGPoint(x: cx, y: cy + size * 0.5))
        } else {
            p.move(to: CGPoint(x: cx + size, y: cy))
            p.addLine(to: CGPoint(x: cx, y: cy - size * 0.5))
            p.addLine(to: CGPoint(x: cx, y: cy + size * 0.5))
        }
        p.closeSubpath()
        return p
    }
}
