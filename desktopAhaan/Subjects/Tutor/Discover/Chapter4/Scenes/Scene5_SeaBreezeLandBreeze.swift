import SwiftUI

/// Scene 5 — Sea Breeze, Land Breeze.
/// Day/Night toggle shows convection currents reversing between sea and land.
struct Scene5_SeaBreezeLandBreeze: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var isDay = true
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 16) {
                    Spacer()

                    // Day / Night toggle
                    HStack(spacing: 12) {
                        Image(systemName: "sun.max.fill")
                            .foregroundStyle(.yellow)
                            .opacity(isDay ? 1 : 0.3)
                        Toggle("", isOn: $isDay)
                            .toggleStyle(.switch)
                            .labelsHidden()
                        Image(systemName: "moon.fill")
                            .foregroundStyle(.indigo)
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
                                  ? LinearGradient(colors: [.cyan.opacity(0.6), .blue.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                                  : LinearGradient(colors: [.indigo.opacity(0.8), .black.opacity(0.6)], startPoint: .top, endPoint: .bottom))
                            .frame(height: 160)
                            .offset(y: -60)

                        // Sun or moon
                        Image(systemName: isDay ? "sun.max.fill" : "moon.stars.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(isDay ? .yellow : .white)
                            .offset(y: -120)
                            .accessibilityLabel(isDay ? "Sun" : "Moon")

                        // Land (right side)
                        HStack(spacing: 0) {
                            // Sea
                            Rectangle()
                                .fill(LinearGradient(colors: [.blue.opacity(0.5), .cyan.opacity(0.4)], startPoint: .top, endPoint: .bottom))
                            // Land
                            Rectangle()
                                .fill(LinearGradient(colors: [
                                    isDay ? .brown.opacity(0.7) : .brown.opacity(0.4),
                                    .green.opacity(0.5)
                                ], startPoint: .top, endPoint: .bottom))
                        }
                        .frame(height: 100)
                        .offset(y: 60)

                        // Labels
                        Text("Sea")
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                            .offset(x: -80, y: 60)
                        Text("Land")
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                            .offset(x: 80, y: 60)

                        // Heat indicators
                        if isDay {
                            // Land heats up fast
                            Text("HOT")
                                .font(.caption2.bold())
                                .foregroundStyle(.red)
                                .offset(x: 80, y: 40)
                            Text("COOL")
                                .font(.caption2.bold())
                                .foregroundStyle(.blue)
                                .offset(x: -80, y: 40)
                        } else {
                            Text("WARM")
                                .font(.caption2.bold())
                                .foregroundStyle(.orange)
                                .offset(x: -80, y: 40)
                            Text("COOL")
                                .font(.caption2.bold())
                                .foregroundStyle(.blue)
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
                    .frame(maxWidth: 640)
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
            .foregroundStyle(.white)
            .offset(y: 10)
            .accessibilityLabel(isDay ? "Breeze from sea to land" : "Breeze from land to sea")
    }

    private var breezeArrows: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 15)) { ctx in
            let t = ctx.date.timeIntervalSince1970
            Canvas { context, size in
                let cx = size.width * 0.5
                let y = size.height * 0.45
                for i in 0..<4 {
                    let phase = (t * 1.2 + Double(i) * 0.5).truncatingRemainder(dividingBy: 2.5) / 2.5
                    let direction: CGFloat = isDay ? -1 : 1
                    let x = cx + direction * (CGFloat(phase) * size.width * 0.4 - size.width * 0.05)
                    let opacity = sin(phase * .pi)
                    let arrowSize: CGFloat = 16
                    // Draw a small triangle arrow
                    var path = Path()
                    if isDay {
                        path.move(to: CGPoint(x: x - arrowSize, y: y))
                        path.addLine(to: CGPoint(x: x, y: y - arrowSize * 0.5))
                        path.addLine(to: CGPoint(x: x, y: y + arrowSize * 0.5))
                    } else {
                        path.move(to: CGPoint(x: x + arrowSize, y: y))
                        path.addLine(to: CGPoint(x: x, y: y - arrowSize * 0.5))
                        path.addLine(to: CGPoint(x: x, y: y + arrowSize * 0.5))
                    }
                    path.closeSubpath()
                    context.opacity = opacity
                    context.fill(path, with: .color(.white.opacity(0.8)))
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityLabel(isDay ? "Animated sea breeze arrows" : "Animated land breeze arrows")
    }
}
