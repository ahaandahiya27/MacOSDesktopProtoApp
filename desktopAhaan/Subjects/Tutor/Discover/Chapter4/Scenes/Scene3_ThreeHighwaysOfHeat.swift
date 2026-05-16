import SwiftUI

/// Scene 3 — Three Highways of Heat.
/// Three side-by-side lanes: Conduction, Convection, Radiation. Tap each for explanation.
@available(macOS 12, *)
struct Scene3_ThreeHighwaysOfHeat: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var tappedLanes: Set<Int> = []
    @State private var activeLane: Int? = nil
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var allTapped: Bool { tappedLanes.count >= 3 }

    private let laneData: [(title: String, icon: String, color: Color, desc: String)] = [
        ("Conduction",
         "hand.raised.fill",
         .orange,
         "Heat travels through a solid by molecule-to-molecule contact — like dominoes bumping each other along a metal rod."),
        ("Convection",
         "arrow.circlepath",
         .blue,
         "In liquids and gases, hot fluid rises and cool fluid sinks, creating circular currents that carry heat around."),
        ("Radiation",
         "sun.max.fill",
         .yellow,
         "Heat can travel through empty space as invisible waves. That is how the Sun warms the Earth across 150 million km!")
    ]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                HStack(spacing: 16) {
                    ForEach(0..<3, id: \.self) { i in
                        laneView(index: i, height: geo.size.height * 0.45)
                    }
                }
                .frame(maxWidth: 720, maxHeight: .infinity, alignment: .top)
                .padding(.top, 20)
                .frame(maxWidth: .infinity)

                VStack(spacing: 14) {
                    Spacer()

                    if let lane = activeLane {
                        SoftShadowCard(padding: 18) {
                            VStack(alignment: .leading, spacing: 8) {
                                Label(laneData[lane].title, systemImage: laneData[lane].icon)
                                    .font(.title2.bold())
                                    .foregroundColor(laneData[lane].color)
                                Text(laneData[lane].desc)
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: 640)
                        .transition(.opacity)
                    } else {
                        SoftShadowCard(padding: 18) {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Three Highways of Heat", systemImage: "arrow.triangle.branch")
                                    .font(.title2.bold())
                                Text("Heat can travel in three ways: conduction, convection, and radiation. Tap each lane to learn how!")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: 640)
                    }

                    if allTapped {
                        GotItButton { onComplete() }
                            .padding(.bottom, 12)
                    } else {
                        Text("Tap all 3 lanes to continue")
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

    @ViewBuilder
    private func laneView(index: Int, height: CGFloat) -> some View {
        let d = laneData[index]
        let isTapped = tappedLanes.contains(index)

        Button {
            withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.3)) {
                tappedLanes.insert(index)
                activeLane = index
            }
        } label: {
            VStack(spacing: 12) {
                Image(systemName: d.icon)
                    .font(.system(size: 36))
                    .foregroundColor(d.color)

                laneAnimation(index: index, height: height * 0.5)
                    .frame(height: height * 0.5)

                Text(d.title)
                    .font(.headline)

                if isTapped {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(isTapped ? d.color.opacity(0.1) : Color(NSColor.windowBackgroundColor))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(activeLane == index ? d.color : .gray.opacity(0.2), lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(d.title) lane. \(isTapped ? "Explored." : "Tap to explore.")")
    }

    @ViewBuilder
    private func laneAnimation(index: Int, height: CGFloat) -> some View {
        if reduceMotion {
            staticLane(index: index)
        } else {
            TimelineView(.animation(minimumInterval: 1.0 / 20)) { ctx in
                let t = ctx.date.timeIntervalSince1970
                Canvas { context, size in
                    switch index {
                    case 0: drawConduction(context: context, size: size, t: t)
                    case 1: drawConvection(context: context, size: size, t: t)
                    default: drawRadiation(context: context, size: size, t: t)
                    }
                }
            }
        }
    }

    private func staticLane(index: Int) -> some View {
        VStack {
            switch index {
            case 0: Image(systemName: "line.horizontal.3").font(.title).foregroundColor(.orange)
            case 1: Image(systemName: "arrow.circlepath").font(.title).foregroundColor(.blue)
            default: Image(systemName: "wave.3.right").font(.title).foregroundColor(.yellow)
            }
        }
    }

    // MARK: - Canvas drawings

    private func drawConduction(context: GraphicsContext, size: CGSize, t: TimeInterval) {
        var ctx = context
        let y = size.height * 0.5
        for i in 0..<6 {
            let phase = (t * 2 + Double(i) * 0.4).truncatingRemainder(dividingBy: 2.0) / 2.0
            let x = size.width * 0.1 + size.width * 0.8 * (CGFloat(i) / 5.0)
            let glow = sin(phase * .pi + Double(i) * 0.5) * 0.5 + 0.5
            let rect = CGRect(x: x - 8, y: y - 8, width: 16, height: 16)
            ctx.opacity = glow
            ctx.fill(Path(ellipseIn: rect), with: .color(.orange))
        }
        // Rod line
        ctx.opacity = 0.3
        var rod = Path()
        rod.move(to: CGPoint(x: size.width * 0.08, y: y))
        rod.addLine(to: CGPoint(x: size.width * 0.92, y: y))
        ctx.stroke(rod, with: .color(.gray), lineWidth: 4)
    }

    private func drawConvection(context: GraphicsContext, size: CGSize, t: TimeInterval) {
        var ctx = context
        let cx = size.width * 0.5, cy = size.height * 0.5
        let rx = size.width * 0.3, ry = size.height * 0.35
        for i in 0..<8 {
            let angle = (t * 0.8 + Double(i) * 0.785)
            let x = cx + rx * CGFloat(cos(angle))
            let y = cy + ry * CGFloat(sin(angle))
            let isRising = sin(angle) < 0
            let color: Color = isRising ? .red : .blue
            let rect = CGRect(x: x - 6, y: y - 6, width: 12, height: 12)
            ctx.opacity = 0.7
            ctx.fill(Path(ellipseIn: rect), with: .color(color))
        }
    }

    private func drawRadiation(context: GraphicsContext, size: CGSize, t: TimeInterval) {
        var ctx = context
        for i in 0..<5 {
            let phase = (t * 1.5 + Double(i) * 0.4).truncatingRemainder(dividingBy: 2.0) / 2.0
            let x = size.width * 0.15 + size.width * 0.7 * CGFloat(phase)
            let y = size.height * 0.3 + CGFloat(i) * (size.height * 0.08)
            let wave = sin(phase * .pi * 4) * 8
            let rect = CGRect(x: x - 3, y: y + wave - 3, width: 6, height: 6)
            ctx.opacity = 1 - phase
            ctx.fill(Path(ellipseIn: rect), with: .color(.yellow))
        }
    }
}
