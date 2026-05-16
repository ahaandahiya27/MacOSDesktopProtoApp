import SwiftUI

/// Scene 8 — Fibre vs Fibre Game.
///
/// Drag-and-drop sorting game. 6 fibre cards float at top. Three drop zones: Plant / Animal / Synthetic.
/// Uses DragGesture + GeometryReader for zone tracking (not .draggable/.dropDestination).
/// Wrong drop → red shake. Right drop → confetti + settle. Score badge "X / 6".
@available(macOS 12, *)
struct Scene8_FibreVsFibreGame: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    @State private var fibres: [FibreCard] = []
    @State private var placed: [String: Bool] = [:]
    @State private var draggingId: String? = nil
    @State private var dragOffset: CGSize = .zero
    @State private var dragOrigin: CGPoint = .zero
    @State private var zoneRects: [String: CGRect] = [:]
    @State private var shakeMap: [String: CGFloat] = [:]
    @State private var celebrate = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var correctCount: Int {
        placed.values.filter { $0 }.count
    }

    private var allPlaced: Bool {
        correctCount == 6
    }

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Text("Fibre vs Fibre Game")
                    .font(.largeTitle.bold())
                Spacer()
                ScoreBadge(value: correctCount, total: 6)
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)

            Text("Drag each fibre to the correct category.")
                .font(.callout)
                .foregroundColor(.secondary)
                .padding(.horizontal, 24)

            // Floating cards
            ZStack {
                ForEach(fibres, id: \.id) { fibre in
                    fiberCard(fibre)
                        .offset(draggingId == fibre.id ? dragOffset : .zero)
                        .zIndex(draggingId == fibre.id ? 100 : 0)
                        .gesture(
                            DragGesture(coordinateSpace: .named("fibreGame"))
                                .onChanged { value in
                                    if draggingId == nil {
                                        draggingId = fibre.id
                                        dragOrigin = value.startLocation
                                    }
                                    dragOffset = CGSize(
                                        width: value.location.x - dragOrigin.x,
                                        height: value.location.y - dragOrigin.y
                                    )
                                }
                                .onEnded { value in
                                    handleDrop(fibre, at: value.location)
                                }
                        )
                }
            }
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)

            // Drop zones
            HStack(spacing: 16) {
                dropZone("🌱 Plant", zone: "plant")
                dropZone("🐑 Animal", zone: "animal")
                dropZone("🛢 Synthetic", zone: "synthetic")
            }
            .padding(.horizontal, 24)
            .frame(height: 120)

            Spacer()

            GotItButton(label: "Got It!") {
                onComplete(correctCount)
            }
            .padding(.bottom, 20)
        }
        .coordinateSpace(name: "fibreGame")
        .onAppear {
            initializeFibres()
        }
    }

    private func initializeFibres() {
        if fibres.isEmpty {
            fibres = [
                FibreCard(emoji: "🌱", label: "Cotton", zone: "plant"),
                FibreCard(emoji: "🐑", label: "Wool", zone: "animal"),
                FibreCard(emoji: "🐛", label: "Silk", zone: "animal"),
                FibreCard(emoji: "🛢", label: "Polyester", zone: "synthetic"),
                FibreCard(emoji: "🛢", label: "Nylon", zone: "synthetic"),
                FibreCard(emoji: "🌿", label: "Jute", zone: "plant")
            ]
        }
    }

    @ViewBuilder
    private func fiberCard(_ fibre: FibreCard) -> some View {
        if placed[fibre.id] != true {
            VStack(spacing: 4) {
                Text(fibre.emoji)
                    .font(.system(size: 28))
                Text(fibre.label)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.primary)
            }
            .frame(width: 70, height: 70)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: .black.opacity(draggingId == fibre.id ? 0.25 : 0.1), radius: draggingId == fibre.id ? 12 : 4, x: 0, y: draggingId == fibre.id ? 6 : 2)
            .scaleEffect(draggingId == fibre.id ? 1.08 : 1.0)
            .offset(x: shakeMap[fibre.id] ?? 0)
        }
    }

    @ViewBuilder
    private func dropZone(_ label: String, zone: String) -> some View {
        VStack(spacing: 8) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundColor(Color.compatIndigo)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color.compatIndigo.opacity(0.05))
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1.5)
                    .foregroundColor(Color.compatIndigo.opacity(0.3))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(
            GeometryReader { geo in
                Color.clear.onAppear {
                    zoneRects[zone] = geo.frame(in: .named("fibreGame"))
                }
            }
        )
    }

    private func handleDrop(_ fibre: FibreCard, at location: CGPoint) {
        draggingId = nil

        var droppedZone: String? = nil
        for (zone, rect) in zoneRects {
            if rect.contains(location) {
                droppedZone = zone
                break
            }
        }

        withAnimation(reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.7)) {
            dragOffset = .zero
        }

        guard let targetZone = droppedZone else {
            return
        }

        let isCorrect = fibre.zone == targetZone
        if isCorrect {
            markPlaced(fibre, correct: true)
        } else {
            shakeCard(fibre.id)
        }
    }

    private func shakeCard(_ id: String) {
        guard !reduceMotion else { return }
        Task { @MainActor in
            withAnimation(.easeInOut(duration: 0.08)) {
                shakeMap[id] = 12
            }
            try? await Task.sleep(nanoseconds: 80_000_000)
            withAnimation(.easeInOut(duration: 0.08)) {
                shakeMap[id] = -12
            }
            try? await Task.sleep(nanoseconds: 80_000_000)
            withAnimation(.easeInOut(duration: 0.08)) {
                shakeMap[id] = 8
            }
            try? await Task.sleep(nanoseconds: 80_000_000)
            withAnimation(.easeInOut(duration: 0.08)) {
                shakeMap[id] = 0
            }
        }
    }

    private func markPlaced(_ fibre: FibreCard, correct: Bool) {
        withAnimation(reduceMotion ? .none : .spring(response: 0.4, dampingFraction: 0.6)) {
            placed[fibre.id] = correct
        }

        if correct && allPlaced {
            celebrate = true
        }
    }
}

private struct FibreCard {
    let id: String = UUID().uuidString
    let emoji: String
    let label: String
    let zone: String
}
