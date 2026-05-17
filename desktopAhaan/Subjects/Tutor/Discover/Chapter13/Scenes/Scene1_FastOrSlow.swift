import SwiftUI

/// Scene 1 — Fast or Slow. Order 4 vehicles by typical speed.
struct Scene1_FastOrSlow: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Vehicle: Identifiable, Equatable {
        let id = UUID(); let name: String; let kmh: Int
    }

    private let correctOrder: [Vehicle] = [
        Vehicle(name: "🚲 Cycle", kmh: 15),
        Vehicle(name: "🚗 Car",   kmh: 80),
        Vehicle(name: "🚄 Train", kmh: 160),
        Vehicle(name: "✈️ Plane", kmh: 900),
    ]
    @State private var current: [Vehicle] = []
    @State private var done = false

    private var score: Int {
        zip(current, correctOrder).reduce(0) { $0 + ($1.0.id == $1.1.id ? 1 : 0) }
    }

    var body: some View {
        VStack(spacing: 12) {
            Text("Fast or Slow?").font(.largeTitle.bold()).padding(.top, 18)
            Text("Drag/tap to order these from slowest → fastest.")
                .font(.callout).foregroundColor(.secondary)

            VStack(spacing: 8) {
                ForEach(Array(current.enumerated()), id: \.element.id) { i, v in
                    HStack {
                        Text("\(i + 1).").font(.headline).frame(width: 30)
                        Text(v.name).font(.headline)
                        Spacer()
                        Button("↑") { swapUp(i) }.disabled(i == 0)
                        Button("↓") { swapDown(i) }.disabled(i == current.count - 1)
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.06)))
                }
            }
            .frame(maxWidth: 480)

            HStack(spacing: 16) {
                Button("Check") { done = true }.accentColor(Color.compatIndigo)
                Button("Shuffle") { current.shuffle(); done = false }
            }

            if done {
                Text("Score: \(score) / \(correctOrder.count)").font(.title3.bold()).foregroundColor(Color.compatIndigo)
            }

            SoftShadowCard(padding: 14) {
                Text("Speed = distance ÷ time. A cycle ≈ 15 km/h, a car ≈ 80, a train ≈ 160, a plane ≈ 900. Bigger speed = covers more ground per minute.")
                    .font(.callout).lineSpacing(4)
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            if done { GotItButton { onComplete(score) }.padding(.bottom, 12) }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear { if current.isEmpty { current = correctOrder.shuffled() } }
    }

    private func swapUp(_ i: Int) { current.swapAt(i, i - 1); done = false }
    private func swapDown(_ i: Int) { current.swapAt(i, i + 1); done = false }
}
