import SwiftUI
import AppKit

// MARK: - InsideTheLeafTour
//
// Five-stop guided walkthrough for the Ch.1 pilot. Presented as a
// sheet from a CTA card on the Ch.1 chapter-detail page. Each stop
// is a SwiftUI composition (no asset images, no third-party deps),
// a narration body, and a "Read aloud" button that hands the body
// to the existing SpeechReader.
//
// Stops:
//   1. .outside     — top-down view of a leaf with a "shrink yourself" CTA.
//   2. .stoma       — guard cells animate open/close based on a slider.
//   3. .mesophyll   — a flow of cells with cytoplasm + nucleus.
//   4. .chloroplast — inner membrane, thylakoid stacks, stroma.
//   5. .thylakoid   — a chlorophyll molecule receives a photon; red/blue
//                     absorbed, green reflected.
//
// Big Sur compat:
//   - All transitions gated by .respectReduceMotion / withAnimation-
//     RespectingReduceMotion. Static fallback when RM is on.
//   - SwiftUI Shape / Path / ZStack only; no Canvas, no @Observable.
//   - @SceneStorage for stop index keyed to chapter id.

struct InsideTheLeafTour: View {
    let chapterId: String
    var onDismiss: () -> Void

    @SceneStorage private var stopIndex: Int
    @ObservedObject private var speech = SpeechReader.shared
    @State private var stomaOpen: Double = 0.7

    private let owner = "ch1.leafTour"

    init(chapterId: String, onDismiss: @escaping () -> Void) {
        self.chapterId = chapterId
        self.onDismiss = onDismiss
        self._stopIndex = SceneStorage(wrappedValue: 0, "leafTour.\(chapterId).stop")
    }

    private var stops: [TourStop] { TourStop.allStops }
    private var current: TourStop { stops[max(0, min(stops.count - 1, stopIndex))] }
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
            Image(systemName: SFSymbolCompat.name("magnifyingglass.circle.fill"))
                .font(.title2)
                .foregroundColor(Color.compatTeal)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 3) {
                Text("Inside the leaf")
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
            .accessibilityLabel("Close leaf tour")
        }
        .padding(.horizontal, DesignTokens.Spacing.xl)
        .padding(.top, 18)
        .padding(.bottom, DesignTokens.Spacing.md)
    }

    /// The big visual + narration card. Each stop swaps via .id() so
    /// SwiftUI rebuilds the subtree on stop change. Transitions are
    /// gated by .respectReduceMotion so Reduce-Motion users get an
    /// instant swap rather than a slide.
    private var sceneBody: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                stopVisualization
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DesignTokens.Spacing.sm)
                    .id("stop-\(stopIndex)")
                narrationCard
            }
            .padding(.horizontal, DesignTokens.Spacing.xl)
            .padding(.vertical, 18)
            .frame(maxWidth: 720, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    /// Per-stop SwiftUI composition. Switches to a different layout
    /// for each TourStop.
    @ViewBuilder
    private var stopVisualization: some View {
        switch current {
        case .outside:     OutsideLeafView()
        case .stoma:       StomaView(openness: $stomaOpen)
        case .mesophyll:   MesophyllView()
        case .chloroplast: ChloroplastView()
        case .thylakoid:   ThylakoidView()
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
                .accentColor(Color.compatTeal)
                .accessibilityLabel(speech.isSpeaking ? "Pause narration" : "Read this stop aloud")
                Spacer()
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.compatTeal.opacity(0.08))
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
                    .fill(i == stopIndex ? Color.compatTeal : Color.secondary.opacity(0.35))
                    .frame(width: 7, height: 7)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Stop \(stopIndex + 1) of \(stops.count)")
    }

    // MARK: - Actions

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

// MARK: - TourStop

enum TourStop: Int, CaseIterable, Identifiable {
    case outside, stoma, mesophyll, chloroplast, thylakoid

    var id: Int { rawValue }

    static var allStops: [TourStop] { Self.allCases }

    var title: String {
        switch self {
        case .outside:     return "Outside the leaf"
        case .stoma:       return "At a stoma — the leaf's mouth"
        case .mesophyll:   return "Inside the mesophyll layer"
        case .chloroplast: return "Inside a chloroplast"
        case .thylakoid:   return "On a thylakoid disc"
        }
    }

    var narration: String {
        switch self {
        case .outside:
            return "Pick a tulsi leaf — about 8 centimetres long. From the outside you see a smooth waxy top and a fuzzy underside. That fuzz is where most of the action happens. Now imagine you can shrink down to half the width of a human hair. Tap continue."
        case .stoma:
            return "You're now at a stoma — a tiny pore on the leaf's underside. Two bean-shaped guard cells flank the opening. When the plant has plenty of water, the guard cells swell and bow outward, opening the pore. When water is tight, they slump and close the pore. Slide to see them open and close in real time."
        case .mesophyll:
            return "Past the stoma you slip into the mesophyll — the leaf's spongy interior. Cells are stacked loosely with gaps between them so air can move freely. Each cell has a fat nucleus tucked at one edge and dozens of small green ovals floating in its cytoplasm. Those green ovals are the kitchens."
        case .chloroplast:
            return "Step inside one of those green ovals — a chloroplast. There's an outer wrapper, an inner membrane just inside it, and a clear fluid called stroma filling the middle. Stacked like coin towers in the stroma are little discs called thylakoids. Pick a thylakoid and step onto its surface."
        case .thylakoid:
            return "You're on a thylakoid now. Embedded in the disc are chlorophyll molecules — they look like four-leaf clovers with a magnesium atom at the centre. A packet of sunlight, a photon, drifts in. The chlorophyll catches red and blue wavelengths and uses their energy. Green light? Bounces off. That's why the whole leaf looks green to us."
        }
    }
}

// MARK: - Per-stop visualisations

private struct OutsideLeafView: View {
    var body: some View {
        ZStack {
            // Background sky tint.
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.compatCyan.opacity(0.10))
            // The leaf shape — a tear-drop.
            LeafTourSilhouette()
                .fill(Color.compatTeal.opacity(0.85))
                .frame(width: 240, height: 140)
                .overlay(
                    LeafTourSilhouette()
                        .stroke(Color.compatTeal, lineWidth: 2)
                        .frame(width: 240, height: 140)
                )
            Text("🔍")
                .font(.system(size: 36))
                .offset(x: 80, y: -30)
                .accessibilityHidden(true)
        }
        .frame(height: 220)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("A whole tulsi leaf, with a magnifying glass icon over it.")
    }
}

private struct StomaView: View {
    @Binding var openness: Double

    var body: some View {
        let guardCellSpacing: CGFloat = max(4, openness * 60)
        return VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.compatTeal.opacity(0.12))
                // Two guard cells: ellipses that bow toward / away from
                // each other as openness changes.
                HStack(spacing: guardCellSpacing) {
                    Ellipse()
                        .fill(Color.compatTeal.opacity(0.85))
                        .frame(width: 90, height: 130)
                    Ellipse()
                        .fill(Color.compatTeal.opacity(0.85))
                        .frame(width: 90, height: 130)
                }
                .respectReduceMotion(animation: .easeInOut(duration: 0.30))
            }
            .frame(height: 200)

            HStack(spacing: DesignTokens.Spacing.sm) {
                Text("Slide:")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Slider(value: $openness, in: 0...1)
                    .accentColor(Color.compatTeal)
                    .accessibilityLabel("Stoma openness")
                    .accessibilityValue("\(Int(openness * 100)) percent open")
                Text(openness < 0.2 ? "Closed" : (openness > 0.7 ? "Wide open" : "Mostly open"))
                    .font(.caption.monospacedDigit())
                    .foregroundColor(.secondary)
                    .frame(width: 86, alignment: .trailing)
            }
        }
    }
}

private struct MesophyllView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.compatTeal.opacity(0.10))
            // A grid of "cells" — circles with little dots inside.
            VStack(spacing: 6) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        ForEach(0..<5, id: \.self) { col in
                            MesophyllCell(seed: row * 5 + col)
                        }
                    }
                }
            }
        }
        .frame(height: 200)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("A grid of mesophyll cells with green ovals inside.")
    }
}

private struct MesophyllCell: View {
    let seed: Int
    var body: some View {
        ZStack {
            Circle().stroke(Color.compatTeal.opacity(0.55), lineWidth: 1.5)
            // Nucleus.
            Circle()
                .fill(Color.compatIndigo.opacity(0.55))
                .frame(width: 8, height: 8)
                .offset(x: -10, y: -10)
            // Chloroplasts.
            ForEach(0..<3, id: \.self) { idx in
                let offX: CGFloat = CGFloat(idx * 6 - 6)
                let offY: CGFloat = CGFloat(idx * 3 + 4)
                Ellipse()
                    .fill(Color.compatTeal.opacity(0.85))
                    .frame(width: 8, height: 4)
                    .offset(x: offX, y: offY)
            }
        }
        .frame(width: 48, height: 48)
    }
}

private struct ChloroplastView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.compatTeal.opacity(0.12))
            // Outer + inner membrane.
            Ellipse()
                .stroke(Color.compatTeal, lineWidth: 3)
                .frame(width: 280, height: 170)
            Ellipse()
                .stroke(Color.compatTeal.opacity(0.6), lineWidth: 2)
                .frame(width: 260, height: 150)
            // Thylakoid stacks — three stacks of three discs.
            HStack(spacing: 22) {
                ForEach(0..<3, id: \.self) { _ in
                    VStack(spacing: 3) {
                        ForEach(0..<3, id: \.self) { _ in
                            Capsule()
                                .fill(Color.compatTeal.opacity(0.95))
                                .frame(width: 38, height: 8)
                        }
                    }
                }
            }
            Text("stroma")
                .font(.caption2.weight(.semibold))
                .foregroundColor(.secondary)
                .offset(x: 100, y: 50)
        }
        .frame(height: 200)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("A chloroplast with outer and inner membranes, three thylakoid stacks, and the stroma fluid around them.")
    }
}

private struct ThylakoidView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.compatTeal.opacity(0.12))
            // The disc surface.
            Capsule()
                .fill(Color.compatTeal.opacity(0.85))
                .frame(width: 320, height: 60)
            // Chlorophyll "clovers" (small petal shapes).
            HStack(spacing: 40) {
                ForEach(0..<4, id: \.self) { _ in
                    Image(systemName: SFSymbolCompat.name("seal.fill"))
                        .font(.system(size: 22))
                        .foregroundColor(Color.compatMint)
                        .accessibilityHidden(true)
                }
            }
            // Incoming photon (yellow streak) + reflected green ray.
            VStack(spacing: 10) {
                HStack(spacing: DesignTokens.Spacing.xs) {
                    Image(systemName: SFSymbolCompat.name("sun.max.fill"))
                        .font(.title3)
                        .foregroundColor(.yellow)
                        .accessibilityHidden(true)
                    Image(systemName: SFSymbolCompat.name("arrow.down"))
                        .font(.caption)
                        .foregroundColor(.orange)
                        .accessibilityHidden(true)
                }
                .offset(x: -90, y: -30)
                HStack(spacing: DesignTokens.Spacing.xs) {
                    Image(systemName: SFSymbolCompat.name("arrow.up.right"))
                        .font(.caption)
                        .foregroundColor(Color.compatTeal)
                        .accessibilityHidden(true)
                    Text("green light reflected")
                        .font(.caption2)
                        .foregroundColor(Color.compatTeal)
                }
                .offset(x: 70, y: -50)
            }
        }
        .frame(height: 200)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("A thylakoid disc surface with chlorophyll molecules. A sunbeam comes in; green light reflects back out.")
    }
}

// MARK: - LeafTourSilhouette

private struct LeafTourSilhouette: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        p.move(to: CGPoint(x: rect.minX, y: rect.midY))
        p.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.midY),
            control: CGPoint(x: w * 0.5, y: rect.minY - h * 0.35)
        )
        p.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.midY),
            control: CGPoint(x: w * 0.5, y: rect.maxY + h * 0.35)
        )
        return p
    }
}
