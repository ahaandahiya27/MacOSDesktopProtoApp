import SwiftUI
import AppKit

// MARK: - InsideTheLensTour
//
// Five-stop guided walkthrough for Ch.15 (Light). A convex-lens
// journey: from a distant light source, into the lens, through
// refraction at the curved surfaces, to the focal point, and finally
// to image formation under two distinct object distances (real-
// inverted vs. virtual-magnified).
//
// Stops:
//   1. .lightSource    — parallel rays from a distant object.
//   2. .lensSurface    — rays bending as they cross the curved
//                        glass-air boundary.
//   3. .focalPoint     — rays converging to F. Definition of focal
//                        length f.
//   4. .imageFormation — object > 2f → real, inverted, smaller image
//                        (the camera / eye case).
//   5. .magnifier      — object < f → virtual, erect, magnified
//                        image (the magnifying-glass case).
//
// Big Sur compat: same as other tour surfaces.

struct InsideTheLensTour: View {
    let chapterId: String
    var onDismiss: () -> Void

    @SceneStorage private var stopIndex: Int
    @ObservedObject private var speech = SpeechReader.shared
    @State private var objectDistance: Double = 0.7

    private let owner = "ch15.lensTour"

    init(chapterId: String, onDismiss: @escaping () -> Void) {
        self.chapterId = chapterId
        self.onDismiss = onDismiss
        self._stopIndex = SceneStorage(wrappedValue: 0, "lensTour.\(chapterId).stop")
    }

    private var stops: [LensTourStop] { LensTourStop.allStops }
    private var current: LensTourStop { stops[max(0, min(stops.count - 1, stopIndex))] }
    private var isFirst: Bool { stopIndex == 0 }
    private var isLast: Bool { stopIndex >= stops.count - 1 }

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            sceneBody
            Divider()
            footerBar
        }
        .frame(minWidth: 620, idealWidth: 780, maxWidth: 920,
               minHeight: 540, idealHeight: 640, maxHeight: 820)
        .background(Color(NSColor.windowBackgroundColor))
        .background(
            Button("Dismiss", action: onDismissAndStopNarration)
                .keyboardShortcut(.cancelAction)
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
        )
        .onDisappear { speech.stop(owner: owner) }
    }

    private var header: some View {
        HStack(spacing: 14) {
            Image(systemName: SFSymbolCompat.name("eye.fill"))
                .font(.title2)
                .foregroundColor(Color.compatPurple)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 3) {
                Text("Inside the lens")
                    .font(.title3.bold())
                Text("Step \(stopIndex + 1) of \(stops.count) — \(current.title)")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
            Button(action: onDismissAndStopNarration) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
            .pointingCursor()
            .accessibilityLabel("Close lens tour")
        }
        .padding(.horizontal, DesignTokens.Spacing.xl)
        .padding(.top, 18)
        .padding(.bottom, DesignTokens.Spacing.md)
    }

    private var sceneBody: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                stopVisualization
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DesignTokens.Spacing.sm)
                    .id("lens-stop-\(stopIndex)")
                narrationCard
            }
            .padding(.horizontal, DesignTokens.Spacing.xl)
            .padding(.vertical, 18)
            .frame(maxWidth: 720, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    @ViewBuilder
    private var stopVisualization: some View {
        switch current {
        case .lightSource:    LensSourceView()
        case .lensSurface:    LensSurfaceView()
        case .focalPoint:     LensFocalPointView()
        case .imageFormation: LensImageFormationView(distance: $objectDistance)
        case .magnifier:      LensMagnifierView()
        }
    }

    private var narrationCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(current.title)
                .font(.title3.bold())
                .accessibilityAddTraits(.isHeader)
            Text(current.narration)
                .font(.body)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
            HStack {
                Button(action: toggleNarration) {
                    HStack(spacing: 6) {
                        Image(systemName: SFSymbolCompat.name(speech.isSpeaking ? "pause.fill" : "speaker.wave.2.fill"))
                            .font(.body)
                        Text(speech.isSpeaking ? "Pause" : "Read aloud")
                            .font(.callout.weight(.semibold))
                    }
                }
                .buttonStyle(.bordered)
                .accentColor(Color.compatPurple)
                .accessibilityLabel(speech.isSpeaking ? "Pause narration" : "Read this stop aloud")
                Spacer()
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.compatPurple.opacity(0.10))
        )
    }

    private var footerBar: some View {
        HStack(spacing: 10) {
            Button("← Back") { goPrev() }
                .disabled(isFirst)
                .accessibilityHint(isFirst ? "First stop — no previous." : "Go to the previous stop.")
            Spacer()
            progressDots
            Spacer()
            Button(isLast ? "Done" : "Continue exploring →") {
                if isLast { onDismissAndStopNarration() } else { goNext() }
            }
            .keyboardShortcut(.defaultAction)
            .accessibilityHint(isLast ? "Closes the tour." : "Go to the next stop on the journey.")
        }
        .padding(.horizontal, DesignTokens.Spacing.xl)
        .padding(.vertical, DesignTokens.Spacing.md)
    }

    private var progressDots: some View {
        HStack(spacing: 6) {
            ForEach(0..<stops.count, id: \.self) { i in
                Circle()
                    .fill(i == stopIndex ? Color.compatPurple : Color.secondary.opacity(0.35))
                    .frame(width: 7, height: 7)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Stop \(stopIndex + 1) of \(stops.count)")
    }

    private func goNext() {
        speech.stop(owner: owner)
        withAnimationRespectingReduceMotion(.easeInOut(duration: 0.32)) {
            stopIndex = min(stops.count - 1, stopIndex + 1)
        }
    }

    private func goPrev() {
        speech.stop(owner: owner)
        withAnimationRespectingReduceMotion(.easeInOut(duration: 0.32)) {
            stopIndex = max(0, stopIndex - 1)
        }
    }

    private func toggleNarration() {
        if speech.isSpeaking {
            speech.stop(owner: owner)
        } else {
            speech.speak(current.narration, owner: owner)
        }
    }

    private func onDismissAndStopNarration() {
        speech.stop(owner: owner)
        onDismiss()
    }
}

// MARK: - LensTourStop

enum LensTourStop: Int, CaseIterable, Identifiable {
    case lightSource, lensSurface, focalPoint, imageFormation, magnifier

    var id: Int { rawValue }
    static var allStops: [LensTourStop] { Self.allCases }

    var title: String {
        switch self {
        case .lightSource:    return "Light leaves a distant object"
        case .lensSurface:    return "At the lens surface"
        case .focalPoint:     return "Converging at the focal point"
        case .imageFormation: return "Forming a real image"
        case .magnifier:      return "Acting as a magnifying glass"
        }
    }

    var narration: String {
        switch self {
        case .lightSource:
            return "A bright object far away — a candle flame, a distant lamp, anything — sends light in every direction. By the time the light has travelled many metres, the rays heading toward your lens are essentially parallel. This is the assumption every camera, telescope, and human eye makes: a distant object sends parallel rays."
        case .lensSurface:
            return "The parallel rays now meet the front surface of a convex lens. Light travels slightly slower inside glass than in air. At the curved boundary, each ray bends — refracts — toward the thicker centre of the lens. The bending happens twice for a thin lens: once on the way in, once on the way out. The total deflection sends every ray toward a single point on the far side."
        case .focalPoint:
            return "All the parallel rays meet at one spot called the focal point, labelled F. The distance from the lens to F is the focal length, f. A fat lens has a short f and bends rays hard. A thin lens has a long f and bends rays gently. A magnifying glass and a camera lens both work on this — they just have different focal lengths for different jobs."
        case .imageFormation:
            return "Now place a real object — say a candle — beyond twice the focal length, so it's NOT at infinity. Three rays from the candle's tip behave predictably: one parallel ray bends through F, one through-the-centre ray goes straight, one through-F ray emerges parallel. Where any two meet, the image forms. Result: a real, inverted, smaller image on the far side. This is exactly what a camera sees, and what your eye projects onto the retina."
        case .magnifier:
            return "Move the candle closer than F — inside the focal length. Now the three rays diverge after the lens; they don't meet on the far side. But traced BACKWARDS, they meet on the SAME side as the candle, much further out. Your eye, looking through the lens, perceives a virtual, erect, magnified image. This is the magnifying glass. The same lens does both jobs depending on where you put the object."
        }
    }
}

// MARK: - Per-stop visualisations

/// Helper — draw the lens silhouette (two circular arcs).
private struct LensSilhouette: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let cx = rect.midX, cy = rect.midY
        let h = rect.height / 2
        let w = rect.width / 2
        p.move(to: CGPoint(x: cx, y: cy - h))
        p.addQuadCurve(to: CGPoint(x: cx, y: cy + h),
                       control: CGPoint(x: cx + w, y: cy))
        p.addQuadCurve(to: CGPoint(x: cx, y: cy - h),
                       control: CGPoint(x: cx - w, y: cy))
        return p
    }
}

private struct LensSourceView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.compatPurple.opacity(0.10))
            HStack {
                // Distant source — a tiny sun
                ZStack {
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 26, height: 26)
                    Circle()
                        .fill(Color.yellow.opacity(0.3))
                        .frame(width: 60, height: 60)
                        .blur(radius: 6)
                }
                Spacer()
                // Parallel rays
                VStack(spacing: DesignTokens.Spacing.md) {
                    ForEach(0..<5, id: \.self) { _ in
                        Rectangle()
                            .fill(Color.yellow.opacity(0.6))
                            .frame(width: 260, height: 2)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, DesignTokens.Spacing.xl)
        }
        .frame(height: 220)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("A distant light source sending parallel rays toward a lens.")
    }
}

private struct LensSurfaceView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.compatPurple.opacity(0.10))
            HStack(spacing: 0) {
                // Parallel rays approaching
                VStack(spacing: 14) {
                    ForEach(0..<5, id: \.self) { _ in
                        Rectangle()
                            .fill(Color.yellow.opacity(0.7))
                            .frame(width: 220, height: 2)
                    }
                }
                // Lens (convex, vertical)
                LensSilhouette()
                    .fill(Color.compatCyan.opacity(0.45))
                    .frame(width: 50, height: 180)
                    .overlay(
                        LensSilhouette()
                            .stroke(Color.compatCyan, lineWidth: 2)
                    )
                // Rays bending toward focal point — drawn as
                // converging lines (a stylised representation).
                ConvergingRaysView()
                    .frame(width: 200, height: 180)
            }
            .padding(.horizontal, 18)
        }
        .frame(height: 220)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Parallel rays meeting a convex lens and bending toward its centre.")
    }
}

/// Draws 5 rays starting from evenly spaced y positions on the left,
/// all converging to a single point on the right.
private struct ConvergingRaysView: View {
    var body: some View {
        GeometryReader { geo in
            let cx = geo.size.width
            let cy = geo.size.height / 2
            ForEach(0..<5, id: \.self) { i in
                Path { path in
                    let y = CGFloat(i) * geo.size.height / 4
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: cx, y: cy))
                }
                .stroke(Color.yellow.opacity(0.85), lineWidth: 2)
            }
        }
    }
}

private struct LensFocalPointView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.compatPurple.opacity(0.10))
            HStack(spacing: 0) {
                Spacer().frame(width: 80)
                LensSilhouette()
                    .fill(Color.compatCyan.opacity(0.45))
                    .frame(width: 50, height: 160)
                    .overlay(
                        LensSilhouette()
                            .stroke(Color.compatCyan, lineWidth: 2)
                    )
                ConvergingRaysView()
                    .frame(width: 180, height: 160)
                // The F point
                ZStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 14, height: 14)
                    Text("F")
                        .font(.caption.bold())
                        .foregroundColor(.white)
                }
                .offset(x: -10)
                Spacer()
            }
        }
        .frame(height: 220)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Parallel rays converging at the focal point F on the far side of the lens.")
    }
}

private struct LensImageFormationView: View {
    @Binding var distance: Double

    var body: some View {
        let objectOffsetX: CGFloat = -120 + CGFloat(distance) * -40
        return VStack(alignment: .leading, spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.compatPurple.opacity(0.10))
                // Principal axis
                Rectangle()
                    .fill(Color.gray.opacity(0.40))
                    .frame(height: 1)
                // Object — an upright arrow at the LEFT
                let objectFontSize: CGFloat = 30 + CGFloat(distance) * 20
                Image(systemName: SFSymbolCompat.name("arrow.up"))
                    .font(.system(size: objectFontSize))
                    .foregroundColor(.orange)
                    .offset(x: objectOffsetX, y: -16)
                // Lens
                LensSilhouette()
                    .fill(Color.compatCyan.opacity(0.45))
                    .frame(width: 36, height: 130)
                    .overlay(
                        LensSilhouette()
                            .stroke(Color.compatCyan, lineWidth: 2)
                    )
                // Image — inverted arrow at the RIGHT
                Image(systemName: SFSymbolCompat.name("arrow.down"))
                    .font(.system(size: 22))
                    .foregroundColor(.red)
                    .offset(x: 110, y: 14)
            }
            .frame(height: 200)

            HStack(spacing: DesignTokens.Spacing.sm) {
                Text("Object distance:")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Slider(value: $distance, in: 0...1)
                    .accentColor(Color.compatPurple)
                    .accessibilityLabel("Object distance")
                    .accessibilityValue("\(Int(distance * 100)) percent of max")
                Text("\(Int(distance * 100))%")
                    .font(.caption.monospacedDigit())
                    .foregroundColor(.secondary)
                    .frame(width: 44, alignment: .trailing)
            }
        }
    }
}

private struct LensMagnifierView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.compatPurple.opacity(0.10))
            HStack(spacing: 0) {
                // Tiny real object close to the lens
                Image(systemName: SFSymbolCompat.name("ant.fill"))
                    .font(.system(size: 22))
                    .foregroundColor(.black)
                    .offset(x: 50)
                LensSilhouette()
                    .fill(Color.compatCyan.opacity(0.45))
                    .frame(width: 50, height: 200)
                    .overlay(
                        LensSilhouette()
                            .stroke(Color.compatCyan, lineWidth: 2)
                    )
                    .offset(x: 80)
                // Eye on the far side
                Image(systemName: SFSymbolCompat.name("eye.fill"))
                    .font(.system(size: 32))
                    .foregroundColor(Color.compatPurple)
                    .offset(x: 130)
                Spacer()
            }
            // Magnified virtual image — ghost ant on the SAME side as object
            Image(systemName: SFSymbolCompat.name("ant.fill"))
                .font(.system(size: 58))
                .foregroundColor(.black.opacity(0.30))
                .offset(x: -120)
        }
        .frame(height: 240)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("A small object close to a lens, with an eye on the far side seeing a magnified virtual image.")
    }
}
