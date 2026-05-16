import SwiftUI

/// Scene 8 — Acid Rain Story.
/// Illustrated scrollable panels: factory -> clouds -> acidic rain -> damage. Canvas rain animation.
@available(macOS 12, *)
struct Scene8_AcidRainStory: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var currentPanel: Int = 0
    @State private var viewedPanels: Set<Int> = [0]

    private let panels: [(title: String, emoji: String, text: String)] = [
        ("Factory Emissions",
         "\u{1F3ED}",
         "Factories and vehicles burn fossil fuels, releasing sulphur dioxide (SO\u{2082}) and nitrogen oxides (NOx) into the air."),
        ("Clouds Absorb Gases",
         "\u{2601}\u{FE0F}",
         "These gases rise into the atmosphere and dissolve in water droplets inside clouds, forming sulphuric acid and nitric acid."),
        ("Rain Becomes Acidic",
         "\u{1F327}\u{FE0F}",
         "When it rains, the water is no longer pure \u{2014} it carries these acids down to Earth. This is called acid rain (pH below 5.6)."),
        ("Damage to Buildings",
         "\u{1F3DB}\u{FE0F}",
         "Acid rain corrodes marble and limestone. The Taj Mahal in Agra has been damaged by acid rain from nearby industries \u{2014} a phenomenon called 'marble cancer'."),
        ("Harm to Nature",
         "\u{1F41F}",
         "Acid rain makes lakes and rivers too acidic for fish and other aquatic life. It also damages leaves and roots of trees, weakening forests."),
    ]

    private var allViewed: Bool { viewedPanels.count >= panels.count }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 14) {
                    Text("Acid Rain Story")
                        .font(.title2.bold())
                        .padding(.top, 18)

                    // Progress dots
                    HStack(spacing: 6) {
                        ForEach(0..<panels.count, id: \.self) { i in
                            Circle()
                                .fill(i == currentPanel ? Color.compatIndigo : (viewedPanels.contains(i) ? .green : .gray.opacity(0.25)))
                                .frame(width: 10, height: 10)
                        }
                    }

                    // Panel display
                    let panel = panels[currentPanel]
                    SoftShadowCard(padding: 24) {
                        VStack(spacing: 14) {
                            Text(panel.emoji)
                                .font(.system(size: 56))

                            Text(panel.title)
                                .font(.title3.bold())

                            Text(panel.text)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: 560)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                    .id(currentPanel)

                    // Rain animation (only on rain panel)
                    if currentPanel == 2 {
                        rainView
                            .frame(maxWidth: 400, maxHeight: 80)
                    }

                    // Navigation buttons
                    HStack(spacing: 16) {
                        Button {
                            goPanel(-1)
                        } label: {
                            Label("Back", systemImage: "chevron.left")
                        }
                        
                        .disabled(currentPanel == 0)

                        Spacer()

                        Text("\(currentPanel + 1) / \(panels.count)")
                            .font(.caption.monospacedDigit())
                            .foregroundColor(.secondary)

                        Spacer()

                        Button {
                            goPanel(1)
                        } label: {
                            Label("Next", systemImage: "chevron.right")
                                .labelStyle(.titleAndIcon)
                        }
                        
                        .accentColor(Color.compatIndigo)
                        .disabled(currentPanel == panels.count - 1)
                    }
                    .frame(maxWidth: 500)

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                VStack(spacing: 14) {
                    Spacer()
                    if allViewed {
                        SoftShadowCard(padding: 18) {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Acid Rain", systemImage: "cloud.rain.fill")
                                    .font(.title2.bold())
                                Text("Acid rain is caused by pollution. We can reduce it by using cleaner fuels, reducing emissions, and using catalytic converters in vehicles.")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: 640)
                        GotItButton { onComplete() }
                            .padding(.bottom, 12)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)
            }
        }
    }

    // MARK: - Rain animation

    private var rainView: some View {
        Group {
            if reduceMotion {
                HStack(spacing: 8) {
                    ForEach(0..<6, id: \.self) { _ in
                        Image(systemName: "drop.fill")
                            .foregroundColor(.blue.opacity(0.5))
                    }
                }
            } else {
                TimelineView(.animation(minimumInterval: 1.0 / 20)) { ctx in
                    let t = ctx.date.timeIntervalSince1970
                    Canvas { context, size in
                        var gfx = context
                        drawRain(gfx: &gfx, size: size, t: t)
                    }
                }
            }
        }
    }

    private func drawRain(gfx: inout GraphicsContext, size: CGSize, t: TimeInterval) {
        for i in 0..<20 {
            let seed = Double(i) * 1.7
            let x = (seed * 37.0).truncatingRemainder(dividingBy: size.width)
            let speed = 1.5 + (seed * 0.3).truncatingRemainder(dividingBy: 1.0)
            let yPhase = (t * speed + seed).truncatingRemainder(dividingBy: 2.0) / 2.0
            let y = yPhase * size.height

            var dropPath = Path()
            dropPath.move(to: CGPoint(x: x, y: y))
            dropPath.addLine(to: CGPoint(x: x, y: y + 8))

            gfx.opacity = 0.5
            gfx.stroke(dropPath, with: .color(.blue), lineWidth: 1.5)
        }
    }

    private func goPanel(_ delta: Int) {
        let next = currentPanel + delta
        guard next >= 0 && next < panels.count else { return }
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.3)) {
            currentPanel = next
        }
        viewedPanels.insert(next)
    }
}
