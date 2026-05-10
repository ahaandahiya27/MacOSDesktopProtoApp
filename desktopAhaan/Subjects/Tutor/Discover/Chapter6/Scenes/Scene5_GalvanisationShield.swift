import SwiftUI

/// Scene 5 — Galvanisation Shield.
/// Iron pipe exposed to rain rusts. Then zinc coating applied (galvanisation).
/// Rain hits but no rust. Shows zinc protecting iron. Also mentions painting, oiling, alloying.
struct Scene5_GalvanisationShield: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var step: GalvStep = .exposed
    @State private var rustLevel: CGFloat = 0
    @State private var rainActive = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private enum GalvStep: Int, CaseIterable {
        case exposed    // iron pipe + rain = rust
        case coating    // applying zinc layer
        case protected  // galvanised pipe + rain = no rust
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 16) {
                    Text("Galvanisation Shield")
                        .font(.largeTitle.bold())
                        .padding(.top, 18)

                    Text("How do we stop iron from rusting?")
                        .font(.callout)
                        .foregroundStyle(.secondary)

                    Spacer()

                    // Pipe visual
                    ZStack {
                        // Rain
                        if rainActive && !reduceMotion {
                            TimelineView(.animation(minimumInterval: 1.0 / 20)) { timeline in
                                let t = timeline.date.timeIntervalSince1970
                                Canvas { context, size in
                                    var ctx = context
                                    for i in 0..<15 {
                                        let seed = Double(i) * 3.14
                                        let x = (seed * 53.0).truncatingRemainder(dividingBy: 1.0) * Double(size.width)
                                        let fall = (t * 120 + seed * 40.0).truncatingRemainder(dividingBy: Double(size.height))
                                        var drop = Path()
                                        drop.move(to: CGPoint(x: x, y: fall))
                                        drop.addLine(to: CGPoint(x: x, y: fall + 10))
                                        ctx.opacity = 0.4
                                        ctx.stroke(drop, with: .color(.cyan), lineWidth: 1.5)
                                    }
                                }
                            }
                            .frame(width: 300, height: 250)
                            .allowsHitTesting(false)
                        }

                        // The pipe
                        VStack(spacing: 0) {
                            // Top cap
                            RoundedRectangle(cornerRadius: 4)
                                .fill(pipeColor)
                                .frame(width: 60, height: 10)

                            // Body
                            RoundedRectangle(cornerRadius: 6)
                                .fill(pipeColor)
                                .frame(width: 50, height: 160)
                                .overlay(
                                    // Zinc coating layer
                                    RoundedRectangle(cornerRadius: 6)
                                        .strokeBorder(
                                            step == .protected ? Color.mint.opacity(0.8) : .clear,
                                            lineWidth: step == .protected ? 5 : 0
                                        )
                                )

                            // Bottom cap
                            RoundedRectangle(cornerRadius: 4)
                                .fill(pipeColor)
                                .frame(width: 60, height: 10)
                        }

                        // Zinc label
                        if step == .coating || step == .protected {
                            Text("Zn")
                                .font(.title3.bold())
                                .foregroundStyle(.mint)
                                .offset(x: 50)
                                .transition(.opacity)
                        }

                        // Rust spots
                        if step == .exposed && rustLevel > 0.3 {
                            ForEach(0..<Int(rustLevel * 6), id: \.self) { i in
                                Circle()
                                    .fill(Color.brown.opacity(0.7))
                                    .frame(width: CGFloat.random(in: 5...12))
                                    .offset(
                                        x: CGFloat([-18, -8, 5, 15, -12, 10][i % 6]),
                                        y: CGFloat([-50, -20, 10, 40, 60, -35][i % 6])
                                    )
                            }
                        }
                    }
                    .frame(width: 300, height: 250)
                    .accessibilityLabel(stepDescription)

                    // Step controls
                    HStack(spacing: 16) {
                        Button("Expose to rain") {
                            step = .exposed
                            rainActive = true
                            withAnimation(reduceMotion ? .none : .easeInOut(duration: 2.0)) {
                                rustLevel = 1.0
                            }
                        }
                        .buttonStyle(.bordered)
                        .tint(.cyan)
                        .disabled(step != .exposed || rainActive)

                        Button("Apply zinc coating") {
                            withAnimation(reduceMotion ? .none : .spring()) {
                                step = .coating
                                rainActive = false
                                rustLevel = 0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation {
                                    step = .protected
                                    rainActive = true
                                }
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.mint)
                        .disabled(step != .exposed || !rainActive)
                    }

                    Text(stepLabel)
                        .font(.headline)
                        .foregroundStyle(step == .protected ? .green : (step == .exposed && rustLevel > 0 ? .brown : .secondary))

                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 14) {
                    Spacer()
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Preventing rust", systemImage: "shield.lefthalf.filled")
                                .font(.title2.bold())
                            Text("Galvanisation coats iron with a layer of zinc. Even if scratched, zinc reacts first, protecting the iron underneath. Other methods include:")
                                .font(.body)
                                .lineSpacing(4)
                            HStack(spacing: 20) {
                                methodBadge(icon: "paintbrush.fill", label: "Painting", color: .blue)
                                methodBadge(icon: "drop.fill", label: "Oiling / greasing", color: .yellow)
                                methodBadge(icon: "circle.grid.cross.fill", label: "Alloying\n(stainless steel)", color: .gray)
                            }
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

    private var pipeColor: Color {
        if step == .exposed && rustLevel > 0.3 {
            return Color.brown.opacity(0.6 + Double(rustLevel) * 0.4)
        }
        if step == .protected { return .gray }
        return .gray
    }

    private var stepLabel: String {
        switch step {
        case .exposed:
            return rustLevel > 0 ? "Iron rusts in rain!" : "Tap to expose to rain"
        case .coating:
            return "Applying zinc coating..."
        case .protected:
            return "Protected! No rust even in rain."
        }
    }

    private var stepDescription: String {
        switch step {
        case .exposed: return "Bare iron pipe exposed to rain, developing rust"
        case .coating: return "Zinc coating being applied to the iron pipe"
        case .protected: return "Galvanised pipe in rain, no rust forming"
        }
    }

    private func methodBadge(icon: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            Text(label)
                .font(.caption2)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80)
    }
}
