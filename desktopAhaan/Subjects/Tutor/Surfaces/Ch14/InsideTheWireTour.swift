import SwiftUI
import AppKit

// MARK: - InsideTheWireTour
//
// Five-stop guided walkthrough for Ch.14 (Electric Current and its
// Effects). Presented as a sheet from a CTA card on the Ch.14
// chapter-detail page. Each stop is a SwiftUI Shape/Path composition
// (no asset images, no third-party deps), a narration body, and a
// "Read aloud" button that hands the body to SpeechReader.
//
// Stops:
//   1. .battery     — terminals shown, electron pile-up on the
//                     negative side waiting to flow.
//   2. .wireEntry   — copper-atom lattice with free electrons drifting.
//   3. .freeElectron — single electron's path: drift speed vs. signal
//                     propagation speed.
//   4. .resistor    — electrons bumping into atoms → heating effect.
//   5. .bulb        — filament glows; chemical → electrical → heat →
//                     light energy chain.
//
// Big Sur compat:
//   - All transitions gated by .respectReduceMotion / withAnimation-
//     RespectingReduceMotion. Static fallback when RM is on.
//   - SwiftUI Shape / Path / ZStack only; no Canvas, no @Observable.
//   - @SceneStorage for stop index keyed to chapter id.

struct InsideTheWireTour: View {
    let chapterId: String
    var onDismiss: () -> Void

    @SceneStorage private var stopIndex: Int
    @ObservedObject private var speech = SpeechReader.shared
    @State private var electronOffset: Double = 0.0

    private let owner = "ch14.wireTour"

    init(chapterId: String, onDismiss: @escaping () -> Void) {
        self.chapterId = chapterId
        self.onDismiss = onDismiss
        self._stopIndex = SceneStorage(wrappedValue: 0, "wireTour.\(chapterId).stop")
    }

    private var stops: [WireTourStop] { WireTourStop.allStops }
    private var current: WireTourStop { stops[max(0, min(stops.count - 1, stopIndex))] }
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
            Image(systemName: SFSymbolCompat.name("bolt.fill"))
                .font(.title2)
                .foregroundColor(.yellow)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 3) {
                Text("Inside the wire")
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
            .accessibilityLabel("Close wire tour")
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
                    .id("wire-stop-\(stopIndex)")
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
        case .battery:      WireBatteryView()
        case .wireEntry:    WireLatticeView()
        case .freeElectron: WireElectronDriftView(offset: $electronOffset)
        case .resistor:     WireResistorView()
        case .bulb:         WireBulbView()
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
                .accentColor(.yellow)
                .accessibilityLabel(speech.isSpeaking ? "Pause narration" : "Read this stop aloud")
                Spacer()
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.yellow.opacity(0.10))
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
                    .fill(i == stopIndex ? Color.yellow : Color.secondary.opacity(0.35))
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

// MARK: - WireTourStop

enum WireTourStop: Int, CaseIterable, Identifiable {
    case battery, wireEntry, freeElectron, resistor, bulb

    var id: Int { rawValue }
    static var allStops: [WireTourStop] { Self.allCases }

    var title: String {
        switch self {
        case .battery:      return "At the battery's negative terminal"
        case .wireEntry:    return "Stepping into the copper wire"
        case .freeElectron: return "Watching one free electron"
        case .resistor:     return "Squeezing through a resistor"
        case .bulb:         return "Inside the bulb filament"
        }
    }

    var narration: String {
        switch self {
        case .battery:
            return "You're at the negative terminal of a small cell. Chemicals inside the battery have pushed extra electrons here — they're crowded together, repelling each other, waiting for a path to the positive side. Connect a wire and they get one. Tap continue."
        case .wireEntry:
            return "Inside the copper wire, atoms are arranged in a regular lattice — like apples stacked at a fruit shop. But unlike fruit, each copper atom donates one electron to a 'sea' that drifts between the atoms. These free electrons are why metals conduct electricity at all. Insulators like rubber don't have them."
        case .freeElectron:
            return "Pick one electron. Without a battery, it wanders randomly — bumping around at millions of metres per second. Connect the battery and a tiny push is added to every random step. The electron now drifts toward the positive terminal at only about 1 millimetre per second — slower than you walking. But the SIGNAL (the push wave) moves at nearly the speed of light, which is why bulbs glow instantly."
        case .resistor:
            return "Now the wire narrows into a resistor — a region where atoms are packed tighter or the path is thinner. The free electrons have to push past more atoms. Every collision transfers a tiny bit of energy to the atom, which vibrates a bit more — and atoms vibrating faster IS heat. This is the heating effect of current. An electric iron, kettle, and toaster all live on this exact effect."
        case .bulb:
            return "At the bulb's filament, the wire is so thin and the resistance so high that collisions become violent. Atoms vibrate so fast they emit light — not just heat. The chain is: chemical energy (battery) → electrical energy (current) → heat → light. Three energy transformations in a millimetre of glowing tungsten. When you switch off, the chain breaks at step one and the bulb cools in seconds."
        }
    }
}

// MARK: - Per-stop visualisations

private struct WireBatteryView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.yellow.opacity(0.10))
            HStack(spacing: 30) {
                // Battery body
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.20))
                        .frame(width: 120, height: 180)
                    VStack(spacing: 8) {
                        Text("+").font(.title.bold()).foregroundColor(.red)
                        Spacer()
                        Text("−").font(.title.bold()).foregroundColor(.blue)
                    }
                    .frame(width: 80, height: 150)
                }
                // Crowd of electrons at the negative terminal
                VStack(alignment: .leading, spacing: 4) {
                    Text("Electrons crowded:")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary)
                    HStack(spacing: 3) {
                        ForEach(0..<8, id: \.self) { _ in
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 12, height: 12)
                        }
                    }
                }
            }
        }
        .frame(height: 220)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("A battery with crowded electrons at the negative terminal.")
    }
}

private struct WireLatticeView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.yellow.opacity(0.10))
            VStack(spacing: 10) {
                ForEach(0..<5, id: \.self) { row in
                    HStack(spacing: 18) {
                        ForEach(0..<7, id: \.self) { col in
                            ZStack {
                                Circle()
                                    .fill(Color.compatBrown.opacity(0.85))
                                    .frame(width: 22, height: 22)
                                if (row + col) % 2 == 0 {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 7, height: 7)
                                        .offset(x: 12, y: -8)
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(height: 220)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Copper-atom lattice with free electrons scattered through it.")
    }
}

private struct WireElectronDriftView: View {
    @Binding var offset: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.yellow.opacity(0.10))
                // The wire (long horizontal channel)
                Capsule()
                    .stroke(Color.compatBrown, lineWidth: 2)
                    .frame(height: 60)
                    .padding(.horizontal, 24)
                // The electron — moves with offset
                GeometryReader { geo in
                    let posX: CGFloat = 30 + CGFloat(offset) * max(0, geo.size.width - 60)
                    let posY: CGFloat = geo.size.height / 2
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 18, height: 18)
                        .position(
                            x: posX,
                            y: posY
                        )
                        .respectReduceMotion(animation: .easeInOut(duration: 0.6))
                }
            }
            .frame(height: 160)
            HStack(spacing: 8) {
                Text("Drift:")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Slider(value: $offset, in: 0...1)
                    .accentColor(.blue)
                    .accessibilityLabel("Electron drift position")
                    .accessibilityValue("\(Int(offset * 100)) percent along the wire")
                Text("\(Int(offset * 100))%")
                    .font(.caption.monospacedDigit())
                    .foregroundColor(.secondary)
                    .frame(width: 44, alignment: .trailing)
            }
        }
    }
}

private struct WireResistorView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.red.opacity(0.10))
            HStack(spacing: 4) {
                // Wide entrance
                Rectangle()
                    .fill(Color.compatBrown.opacity(0.55))
                    .frame(width: 100, height: 60)
                // Narrow resistor — atoms packed
                ZStack {
                    Rectangle()
                        .fill(Color.red.opacity(0.55))
                        .frame(width: 110, height: 30)
                    HStack(spacing: 3) {
                        ForEach(0..<10, id: \.self) { _ in
                            Circle()
                                .fill(Color.compatBrown)
                                .frame(width: 10, height: 10)
                        }
                    }
                }
                // Wide exit
                Rectangle()
                    .fill(Color.compatBrown.opacity(0.55))
                    .frame(width: 100, height: 60)
            }
        }
        .frame(height: 200)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("A resistor — wire narrowed into a packed channel, where electrons collide with atoms and generate heat.")
    }
}

private struct WireBulbView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.yellow.opacity(0.18))
            VStack(spacing: 10) {
                // Bulb glass + filament
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.60), lineWidth: 3)
                        .frame(width: 130, height: 130)
                    // Filament — zigzag line
                    Path { path in
                        path.move(to: CGPoint(x: 30, y: 60))
                        path.addLine(to: CGPoint(x: 50, y: 30))
                        path.addLine(to: CGPoint(x: 70, y: 60))
                        path.addLine(to: CGPoint(x: 90, y: 30))
                        path.addLine(to: CGPoint(x: 110, y: 60))
                    }
                    .stroke(Color.orange, lineWidth: 3)
                    .frame(width: 140, height: 90)
                    Circle()
                        .fill(Color.yellow.opacity(0.4))
                        .frame(width: 100, height: 100)
                        .blur(radius: 6)
                }
                Text("Tungsten filament — heated white-hot")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
            }
        }
        .frame(height: 220)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("An incandescent bulb with a glowing tungsten filament.")
    }
}
