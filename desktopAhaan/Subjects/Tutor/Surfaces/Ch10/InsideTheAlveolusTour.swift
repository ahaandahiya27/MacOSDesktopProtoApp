import SwiftUI
import AppKit

// MARK: - InsideTheAlveolusTour
//
// Five-stop guided walkthrough for Ch.10 (Respiration in Organisms).
// Each stop is a SwiftUI composition + narration + Read-aloud button.
//
// Stops:
//   1. .nostril   — air enters; cilia and mucus catch dust.
//   2. .trachea   — windpipe with C-shaped cartilage rings.
//   3. .bronchi   — branching tree narrowing toward the air sacs.
//   4. .alveolus  — single grape-cluster air sac wrapped in
//                   capillaries; the gas-exchange site.
//   5. .redCell   — haemoglobin loaded with O₂ heading to body cells.

struct InsideTheAlveolusTour: View {
    let chapterId: String
    var onDismiss: () -> Void

    @SceneStorage private var stopIndex: Int
    @ObservedObject private var speech = SpeechReader.shared

    private let owner = "ch10.alveolusTour"

    init(chapterId: String, onDismiss: @escaping () -> Void) {
        self.chapterId = chapterId
        self.onDismiss = onDismiss
        self._stopIndex = SceneStorage(wrappedValue: 0, "alveolusTour.\(chapterId).stop")
    }

    private var stops: [AlveolusTourStop] { AlveolusTourStop.allStops }
    private var current: AlveolusTourStop { stops[max(0, min(stops.count - 1, stopIndex))] }
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
            Image(systemName: SFSymbolCompat.name("lungs.fill"))
                .font(.title2)
                .foregroundColor(Color.compatTeal)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 3) {
                Text("Inside an alveolus")
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
            .accessibilityLabel("Close alveolus tour")
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
                    .id("alveolus-stop-\(stopIndex)")
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
        case .nostril:  AlveolusNostrilView()
        case .trachea:  AlveolusTracheaView()
        case .bronchi:  AlveolusBronchiView()
        case .alveolus: AlveolusSacView()
        case .redCell:  AlveolusRedCellView()
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
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
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

// MARK: - AlveolusTourStop

enum AlveolusTourStop: Int, CaseIterable, Identifiable {
    case nostril, trachea, bronchi, alveolus, redCell

    var id: Int { rawValue }
    static var allStops: [AlveolusTourStop] { Self.allCases }

    var title: String {
        switch self {
        case .nostril:  return "At the nostril — first filter"
        case .trachea:  return "Down the trachea (windpipe)"
        case .bronchi:  return "Branching through the bronchi"
        case .alveolus: return "Inside one alveolus"
        case .redCell:  return "Loaded onto a red blood cell"
        }
    }

    var narration: String {
        switch self {
        case .nostril:
            return "Take a breath in. Air enters your nostrils — not your mouth, your nose first. The nasal cavity is lined with tiny hairs (cilia) and sticky mucus. Together they catch dust, pollen, and even small insects before they can go deeper. The air also gets warmed and humidified here, so cold winter air doesn't shock your lungs."
        case .trachea:
            return "From the nose, air goes down the trachea — the windpipe, about 10 cm long. It is held open by C-shaped rings of cartilage (you can feel them on the front of your throat). Without those rings, the trachea would collapse like a wet straw every time you inhaled. The rings are open at the back so your oesophagus (food pipe) behind it can expand when you swallow."
        case .bronchi:
            return "The trachea splits into two bronchi — one for each lung. Each bronchus then splits into smaller bronchioles, and those split again. The branching pattern is fractal — same shape repeating at smaller and smaller scales — like an upside-down tree. By the time the air reaches the end of the smallest branches, it has split into about 30,000 micro-tubes per lung."
        case .alveolus:
            return "Each smallest tube ends in a cluster of alveoli — tiny air sacs shaped like microscopic balloons. Your lungs hold about 300 million of them. Each alveolus has walls just one cell thick, wrapped in a mesh of blood capillaries also one cell thick. Two cells separate the air you breathed in from the blood travelling beneath. Total surface area: about 70 square metres — roughly the size of a tennis court, folded into your chest."
        case .redCell:
            return "Inside a capillary, a red blood cell glides past. It carries haemoglobin — a protein with four iron-centred pockets. Each pocket grabs one O₂ molecule from the alveolar air. Loaded with four oxygens, the cell turns bright red and heads back to the heart. CO₂ travels the other way — out of the blood, into the alveolus, up the trachea, out your nose. One breath, one exchange, repeated about 15 times every minute."
        }
    }
}

// MARK: - Per-stop visualisations

private struct AlveolusNostrilView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.compatTeal.opacity(0.10))
            HStack(spacing: 18) {
                Image(systemName: SFSymbolCompat.name("nose.fill"))
                    .font(.system(size: 56))
                    .foregroundColor(Color.compatTeal)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: SFSymbolCompat.name("wind"))
                            .foregroundColor(Color.compatCyan)
                        Text("Air in →").font(.callout.weight(.semibold))
                    }
                    Text("• Cilia catch dust")
                        .font(.caption)
                    Text("• Mucus traps particles")
                        .font(.caption)
                    Text("• Air warmed + moistened")
                        .font(.caption)
                }
            }
        }
        .frame(height: 220)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Nostril filtering air with cilia and mucus.")
    }
}

private struct AlveolusTracheaView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.compatTeal.opacity(0.10))
            VStack(spacing: 6) {
                ForEach(0..<7, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.compatTeal, lineWidth: 2)
                        .frame(width: 110, height: 12)
                }
            }
        }
        .frame(height: 220)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Trachea stack of C-shaped cartilage rings.")
    }
}

private struct AlveolusBronchiView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.compatTeal.opacity(0.10))
            // Schematic bronchi tree (stacked Vs widening downward)
            VStack(spacing: 8) {
                Capsule()
                    .fill(Color.compatTeal.opacity(0.85))
                    .frame(width: 14, height: 30)
                HStack(spacing: 40) {
                    Capsule()
                        .fill(Color.compatTeal.opacity(0.75))
                        .frame(width: 8, height: 26)
                    Capsule()
                        .fill(Color.compatTeal.opacity(0.75))
                        .frame(width: 8, height: 26)
                }
                HStack(spacing: 18) {
                    ForEach(0..<4, id: \.self) { _ in
                        Capsule()
                            .fill(Color.compatTeal.opacity(0.55))
                            .frame(width: 6, height: 18)
                    }
                }
                HStack(spacing: 8) {
                    ForEach(0..<8, id: \.self) { _ in
                        Capsule()
                            .fill(Color.compatTeal.opacity(0.40))
                            .frame(width: 4, height: 12)
                    }
                }
            }
        }
        .frame(height: 220)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Bronchial tree branching from trachea down to small bronchioles.")
    }
}

private struct AlveolusSacView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.compatTeal.opacity(0.10))
            ZStack {
                // The grape cluster of alveoli
                ForEach(0..<7, id: \.self) { i in
                    Circle()
                        .fill(Color.pink.opacity(0.60))
                        .frame(width: 50, height: 50)
                        .offset(
                            x: CGFloat([-60, 0, 60, -30, 30, -10, 40][i]),
                            y: CGFloat([-40, -50, -40, 0, 5, 50, 55][i])
                        )
                }
                // Capillary mesh — thin red lines arched over the sac
                ForEach(0..<5, id: \.self) { i in
                    let capillaryY: CGFloat = CGFloat(i * 22 - 44)
                    Capsule()
                        .stroke(Color.red.opacity(0.85), lineWidth: 1.5)
                        .frame(width: 150, height: 8)
                        .offset(y: capillaryY)
                }
            }
        }
        .frame(height: 240)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Cluster of alveoli wrapped in a mesh of capillaries.")
    }
}

private struct AlveolusRedCellView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.red.opacity(0.10))
            HStack(spacing: 24) {
                // A red blood cell (biconcave disc)
                ZStack {
                    Ellipse()
                        .fill(Color.red.opacity(0.85))
                        .frame(width: 140, height: 100)
                    Ellipse()
                        .fill(Color.red.opacity(0.55))
                        .frame(width: 70, height: 50)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text("Carrying:")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary)
                    HStack(spacing: 4) {
                        ForEach(0..<4, id: \.self) { _ in
                            Circle()
                                .fill(Color.compatBlue)
                                .frame(width: 14, height: 14)
                                .overlay(
                                    Text("O₂")
                                        .font(.system(size: 8).bold())
                                        .foregroundColor(.white)
                                )
                        }
                    }
                    Text("4 O₂ per haemoglobin")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(height: 220)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("A red blood cell carrying four oxygen molecules on its haemoglobin pockets.")
    }
}
