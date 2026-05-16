import SwiftUI

/// Scene 3 — Three Highways of Heat.
/// Three side-by-side lanes: Conduction, Convection, Radiation. Tap each for explanation.
///
/// Big Sur (macOS 11) compatible — each lane's animation runs from a single
/// 20 fps Timer.publish writing into a shared `tick` state, with per-particle
/// View structs replacing the old Canvas calls.
struct Scene3_ThreeHighwaysOfHeat: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var tappedLanes: Set<Int> = []
    @State private var activeLane: Int? = nil
    @State private var tick: TimeInterval = 0
    @State private var animationTimer: Timer? = nil
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
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
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
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
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
        .onAppear(perform: startAnimation)
        .onDisappear(perform: stopAnimation)
    }

    private func startAnimation() {
        guard !reduceMotion, animationTimer == nil else { return }
        let start = Date().timeIntervalSince1970
        animationTimer = Timer.scheduledTimer(withTimeInterval: HardwareTier.interval(ideal: 1.0 / 20), repeats: true) { _ in
            tick = Date().timeIntervalSince1970 - start
        }
    }
    private func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
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
            GeometryReader { geo in
                ZStack(alignment: .topLeading) {
                    switch index {
                    case 0: ConductionLane(t: tick, size: geo.size)
                    case 1: ConvectionLane(t: tick, size: geo.size)
                    default: RadiationLane(t: tick, size: geo.size)
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
}

// MARK: - Per-lane animated subviews
//
// Each Canvas-based drawing is replaced with a small View struct that uses
// a ForEach of positioned shapes. Position math lives in computed
// properties or helper functions so the Swift 5.5 type-checker doesn't
// time out inside @ViewBuilder closures.

private struct ConductionLane: View {
    let t: TimeInterval
    let size: CGSize
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Rod line
            Path { p in
                let y: CGFloat = size.height * 0.5
                p.move(to: CGPoint(x: size.width * 0.08, y: y))
                p.addLine(to: CGPoint(x: size.width * 0.92, y: y))
            }
            .stroke(Color.gray.opacity(0.3), lineWidth: 4)

            ForEach(0..<6, id: \.self) { i in
                ConductionDot(index: i, t: t, size: size)
            }
        }
    }
}

private struct ConductionDot: View {
    let index: Int
    let t: TimeInterval
    let size: CGSize
    var body: some View {
        let p = compute()
        return Circle()
            .fill(Color.orange)
            .frame(width: 16, height: 16)
            .opacity(p.opacity)
            .position(x: CGFloat(p.x), y: CGFloat(p.y))
    }
    private struct DotPos { let x: Double; let y: Double; let opacity: Double }
    private func compute() -> DotPos {
        let phase: Double = ((Double(t) * 2.0 + Double(index) * 0.4).truncatingRemainder(dividingBy: 2.0)) / 2.0
        let x: Double = Double(size.width) * 0.1 + Double(size.width) * 0.8 * (Double(index) / 5.0)
        let y: Double = Double(size.height) * 0.5
        let glow: Double = sin(Double(phase) * Double.pi + Double(index) * 0.5) * 0.5 + 0.5
        return DotPos(x: x, y: y, opacity: glow)
    }
}

private struct ConvectionLane: View {
    let t: TimeInterval
    let size: CGSize
    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(0..<8, id: \.self) { i in
                ConvectionDot(index: i, t: t, size: size)
            }
        }
    }
}

private struct ConvectionDot: View {
    let index: Int
    let t: TimeInterval
    let size: CGSize
    var body: some View {
        let p = compute()
        return Circle()
            .fill(p.color)
            .frame(width: 12, height: 12)
            .opacity(0.7)
            .position(x: CGFloat(p.x), y: CGFloat(p.y))
    }
    private struct DotPos { let x: Double; let y: Double; let color: Color }
    private func compute() -> DotPos {
        let cx: Double = Double(size.width) * 0.5
        let cy: Double = Double(size.height) * 0.5
        let rx: Double = Double(size.width) * 0.3
        let ry: Double = Double(size.height) * 0.35
        let angle: Double = Double(t) * 0.8 + Double(index) * 0.785
        let x: Double = cx + rx * cos(angle)
        let y: Double = cy + ry * sin(angle)
        let isRising: Bool = sin(angle) < 0
        let color: Color = isRising ? Color.red : Color.blue
        return DotPos(x: x, y: y, color: color)
    }
}

private struct RadiationLane: View {
    let t: TimeInterval
    let size: CGSize
    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(0..<5, id: \.self) { i in
                RadiationDot(index: i, t: t, size: size)
            }
        }
    }
}

private struct RadiationDot: View {
    let index: Int
    let t: TimeInterval
    let size: CGSize
    var body: some View {
        let p = compute()
        return Circle()
            .fill(Color.yellow)
            .frame(width: 6, height: 6)
            .opacity(p.opacity)
            .position(x: CGFloat(p.x), y: CGFloat(p.y))
    }
    private struct DotPos { let x: Double; let y: Double; let opacity: Double }
    private func compute() -> DotPos {
        let phase: Double = ((Double(t) * 1.5 + Double(index) * 0.4).truncatingRemainder(dividingBy: 2.0)) / 2.0
        let x: Double = Double(size.width) * 0.15 + Double(size.width) * 0.7 * phase
        let baseY: Double = Double(size.height) * 0.3 + Double(index) * Double(size.height) * 0.08
        let wave: Double = sin(Double(phase) * Double.pi * 4.0) * 8.0
        let y: Double = baseY + wave
        return DotPos(x: x, y: y, opacity: 1.0 - phase)
    }
}
