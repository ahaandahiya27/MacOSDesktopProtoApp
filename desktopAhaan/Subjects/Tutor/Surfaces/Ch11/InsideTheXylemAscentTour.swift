import SwiftUI
import AppKit

// MARK: - InsideTheXylemAscentTour
//
// Five-stop guided walkthrough for Ch.11 (Transportation in Animals
// & Plants). Follows a water molecule from a root hair, up the
// xylem, through the stem, into a leaf vein, and finally out a
// stoma as transpiration — the upward pull that drives water up
// trees 100 metres tall without any pump.
//
// Stops:
//   1. .rootHair     — root-hair cell soaks up soil water via osmosis.
//   2. .xylemEntry   — water enters the xylem tubes (hollow dead cells).
//   3. .stemAscent   — capillary action + cohesion-tension ascent.
//   4. .leafVein     — water spreads into the leaf's vein network.
//   5. .stoma        — water evaporates out through guard cells.

struct InsideTheXylemAscentTour: View {
    let chapterId: String
    var onDismiss: () -> Void

    @SceneStorage private var stopIndex: Int
    @ObservedObject private var speech = SpeechReader.shared

    private let owner = "ch11.xylemTour"

    init(chapterId: String, onDismiss: @escaping () -> Void) {
        self.chapterId = chapterId
        self.onDismiss = onDismiss
        self._stopIndex = SceneStorage(wrappedValue: 0, "xylemTour.\(chapterId).stop")
    }

    private var stops: [XylemTourStop] { XylemTourStop.allStops }
    private var current: XylemTourStop { stops[max(0, min(stops.count - 1, stopIndex))] }
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
            Image(systemName: SFSymbolCompat.name("drop.fill"))
                .font(.title2)
                .foregroundColor(Color.compatBlue)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 3) {
                Text("The xylem ascent")
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
            .accessibilityLabel("Close xylem tour")
        }
        .padding(.horizontal, 24)
        .padding(.top, 18)
        .padding(.bottom, 12)
    }

    private var sceneBody: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                stopVisualization
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .id("xylem-stop-\(stopIndex)")
                narrationCard
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
            .frame(maxWidth: 720, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    @ViewBuilder
    private var stopVisualization: some View {
        switch current {
        case .rootHair:   XylemRootHairView()
        case .xylemEntry: XylemEntryView()
        case .stemAscent: XylemStemView()
        case .leafVein:   XylemLeafVeinView()
        case .stoma:      XylemStomaView()
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
                .accentColor(Color.compatBlue)
                .accessibilityLabel(speech.isSpeaking ? "Pause narration" : "Read this stop aloud")
                Spacer()
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.compatBlue.opacity(0.10))
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
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }

    private var progressDots: some View {
        HStack(spacing: 6) {
            ForEach(0..<stops.count, id: \.self) { i in
                Circle()
                    .fill(i == stopIndex ? Color.compatBlue : Color.secondary.opacity(0.35))
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

// MARK: - XylemTourStop

enum XylemTourStop: Int, CaseIterable, Identifiable {
    case rootHair, xylemEntry, stemAscent, leafVein, stoma

    var id: Int { rawValue }
    static var allStops: [XylemTourStop] { Self.allCases }

    var title: String {
        switch self {
        case .rootHair:   return "At a root hair — water enters by osmosis"
        case .xylemEntry: return "Stepping into the xylem"
        case .stemAscent: return "Up the stem — the cohesion-tension lift"
        case .leafVein:   return "Spreading through the leaf veins"
        case .stoma:      return "Out a stoma — the journey ends"
        }
    }

    var narration: String {
        switch self {
        case .rootHair:
            return "Find a root hair — a thin finger-like extension of a single root cell, less than half a millimetre long. Soil water sits just outside, in films between sand grains. The cell's interior has dissolved minerals; the soil water doesn't. Water moves spontaneously from where it's pure (outside) to where it's concentrated (inside) — that's osmosis. The plant doesn't 'suck'. Physics does the pulling."
        case .xylemEntry:
            return "From the root hair, water passes cell to cell inward until it reaches the xylem. The xylem is a system of hollow tubes made of dead cells stacked end-to-end with their walls dissolved. Think of it as a continuous straw running from root to leaf tip. In a tall tree this single straw can be 100 metres long — and yet water gets to the top without any pump."
        case .stemAscent:
            return "Climbing the xylem isn't 'sucking from the bottom'. It's 'pulling from the top'. Water molecules stick to each other (cohesion) and to the xylem walls (adhesion). At the top, evaporation pulls a water molecule out — and that pull is transmitted all the way down the unbroken column. Cohesion-tension theory, proven by Dixon and Joly in 1894. The water is under negative pressure (tension) the entire way up."
        case .leafVein:
            return "Water arrives at the petiole (leaf stalk) and spreads into the leaf's vein network — the lines you see on the back of any leaf. Veins branch like rivers run in reverse: from one trunk to many tiny tributaries serving each leaf cell. The smallest veins are just a few cells thick. Every leaf cell is within four cells of a water source — extremely efficient distribution."
        case .stoma:
            return "At the leaf surface, the journey ends. Water evaporates through the stoma — the same pore you saw in the Ch.1 pilot. Up to 99% of water absorbed by the roots eventually leaves through stomata; only about 1% is used in photosynthesis or for cell turgor. This loss isn't waste — it's the pull that lifts new water from the soil. A single maize plant transpires about 200 litres of water in its 4-month life. A mango tree transpires that much in a day."
        }
    }
}

// MARK: - Per-stop visualisations

private struct XylemRootHairView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.compatBrown.opacity(0.18))
            // Soil — brown rectangles
            ForEach(0..<8, id: \.self) { i in
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.compatBrown.opacity(0.55))
                    .frame(width: CGFloat([28, 36, 22, 40, 18, 32, 26, 24][i]),
                           height: CGFloat([16, 22, 14, 24, 12, 20, 18, 14][i]))
                    .offset(x: CGFloat([-120, -80, -60, -30, 30, 70, 100, 130][i]),
                            y: CGFloat([-50, 20, -10, 40, -30, 10, -20, 30][i]))
            }
            // The root hair
            Capsule()
                .fill(Color.compatTeal.opacity(0.85))
                .frame(width: 20, height: 130)
                .rotationEffect(.degrees(20))
            // Water droplets
            ForEach(0..<5, id: \.self) { i in
                Circle()
                    .fill(Color.compatBlue.opacity(0.85))
                    .frame(width: 10, height: 10)
                    .offset(x: CGFloat([40, -50, 65, -30, 20][i]),
                            y: CGFloat([-20, -40, 30, 50, -60][i]))
            }
        }
        .frame(height: 220)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("A root hair extending into soil, with water droplets being absorbed.")
    }
}

private struct XylemEntryView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.compatTeal.opacity(0.10))
            // Stack of xylem tubes (hollow vertical capsules)
            HStack(spacing: 12) {
                ForEach(0..<5, id: \.self) { _ in
                    Capsule()
                        .stroke(Color.compatTeal, lineWidth: 2)
                        .frame(width: 22, height: 160)
                }
            }
            // Water in tubes (blue fills)
            HStack(spacing: 12) {
                ForEach(0..<5, id: \.self) { _ in
                    Capsule()
                        .fill(Color.compatBlue.opacity(0.55))
                        .frame(width: 18, height: 150)
                }
            }
        }
        .frame(height: 220)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Xylem tubes — hollow vertical capsules with water inside.")
    }
}

private struct XylemStemView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.compatTeal.opacity(0.10))
            // Stem trunk (vertical brown rectangle)
            Rectangle()
                .fill(Color.compatBrown.opacity(0.60))
                .frame(width: 30, height: 200)
            // Water column inside (vertical blue rectangle)
            Rectangle()
                .fill(Color.compatBlue.opacity(0.75))
                .frame(width: 10, height: 180)
            // Upward arrows
            VStack(spacing: 20) {
                ForEach(0..<4, id: \.self) { _ in
                    Image(systemName: SFSymbolCompat.name("arrow.up"))
                        .foregroundColor(Color.compatBlue)
                        .font(.headline)
                }
            }
            .offset(x: 30)
        }
        .frame(height: 240)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Stem trunk with water rising in a continuous column inside.")
    }
}

private struct XylemLeafVeinView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.compatTeal.opacity(0.15))
            // Leaf silhouette
            Ellipse()
                .fill(Color.compatTeal.opacity(0.55))
                .frame(width: 200, height: 140)
            // Midrib
            Capsule()
                .fill(Color.compatBlue.opacity(0.85))
                .frame(width: 200, height: 4)
            // Side veins
            ForEach(0..<4, id: \.self) { i in
                Capsule()
                    .fill(Color.compatBlue.opacity(0.65))
                    .frame(width: 90, height: 2)
                    .rotationEffect(.degrees(Double(i % 2 == 0 ? 25 : -25)))
                    .offset(x: CGFloat(i * 20 - 30), y: CGFloat(i % 2 == 0 ? -22 : 22))
            }
        }
        .frame(height: 200)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Leaf with midrib and branching side veins.")
    }
}

private struct XylemStomaView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.compatTeal.opacity(0.15))
            // Two guard cells (ellipses)
            HStack(spacing: 30) {
                Ellipse()
                    .fill(Color.compatTeal.opacity(0.85))
                    .frame(width: 70, height: 110)
                Ellipse()
                    .fill(Color.compatTeal.opacity(0.85))
                    .frame(width: 70, height: 110)
            }
            // Water vapour droplets escaping upward
            VStack(spacing: 10) {
                ForEach(0..<3, id: \.self) { _ in
                    HStack(spacing: 8) {
                        Image(systemName: SFSymbolCompat.name("drop.fill"))
                            .foregroundColor(Color.compatBlue.opacity(0.70))
                        Image(systemName: SFSymbolCompat.name("drop.fill"))
                            .foregroundColor(Color.compatBlue.opacity(0.50))
                        Image(systemName: SFSymbolCompat.name("drop.fill"))
                            .foregroundColor(Color.compatBlue.opacity(0.30))
                    }
                }
            }
            .offset(y: -120)
        }
        .frame(height: 240)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Stoma with two guard cells and water vapour escaping upward — transpiration.")
    }
}
