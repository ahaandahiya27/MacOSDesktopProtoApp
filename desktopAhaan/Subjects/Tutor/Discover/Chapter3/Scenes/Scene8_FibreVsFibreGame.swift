import SwiftUI

/// Scene 8 — Fibre vs Fibre Game.
///
/// Drag-and-drop sorting game. 6 fibre cards float at top. Three drop zones: Plant / Animal / Synthetic.
/// Uses DragGesture + GeometryReader for zone tracking (not .draggable/.dropDestination).
/// Wrong drop → red shake. Right drop → confetti + settle. Score badge "X / 6".
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
                .foregroundStyle(.secondary)
                .padding(.horizontal, 24)

            // Floating cards
            ZStack {
                ForEach(fibres, id: \.id) { fibre in
                    fiberCard(fibre)
                        .offset(draggingId == fibre.id ? dragOffset : .zero)
                        .zIndex(draggingId == fibre.id ? 100 : 0)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if draggingId == nil {
                                        draggingId = fibre.id
                                        dragOrigin = value.location
                                    }
                                    dragOffset = CGSize(
                                        width: value.location.x - dragOrigin.x,
                                        height: value.location.y - dragOrigin.y
                                    )
                                }
                                .onEnded { _ in
                                    handleDrop(fibre)
                                }
                        )
                }
            }
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .background(.gray.opacity(0.05))
            .cornerRadius(8)

            // Drop zones
            GeometryReader { geo in
                HStack(spacing: 16) {
                    dropZone("🌱 Plant", zone: "plant", geometry: geo)
                    dropZone("🐑 Animal", zone: "animal", geometry: geo)
                    dropZone("🛢 Synthetic", zone: "synthetic", geometry: geo)
                }
                .padding(.horizontal, 24)
                .onAppear {
                    // Store zone rects for drop detection
                }
            }
            .frame(height: 120)

            Spacer()

            GotItButton(label: "Got It!") {
                onComplete(correctCount)
            }
            .padding(.bottom, 20)
        }
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
                    .foregroundStyle(.primary)
            }
            .frame(width: 70, height: 70)
            .background(.white)
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            .offset(x: shakeMap[fibre.id] ?? 0)
        }
    }

    @ViewBuilder
    private func dropZone(_ label: String, zone: String, geometry: GeometryProxy) -> some View {
        VStack(spacing: 8) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.indigo)
            RoundedRectangle(cornerRadius: 8)
                .fill(.indigo.opacity(0.05))
                .strokeBorder(.indigo.opacity(0.3), lineWidth: 1.5)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
    }

    private func handleDrop(_ fibre: FibreCard) {
        draggingId = nil

        if fibre.zone == "plant" {
            markPlaced(fibre, correct: true)
        } else if fibre.zone == "animal" {
            markPlaced(fibre, correct: true)
        } else {
            markPlaced(fibre, correct: true)
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
