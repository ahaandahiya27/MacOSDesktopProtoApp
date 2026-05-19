import SwiftUI

/// Scene 3 — The Stomach Bath.
///
/// A drawn stomach (curved sac). Three "ingredient" buttons (Protein, Starch, Milk).
/// Tap each to drop it in. Once dropped, HCl droplets (red) and pepsin enzymes (purple)
/// animate around it. After 4 seconds, food breaks into smaller fragments.
/// Caption from ch02_t01_c04.

struct Scene3_TheStomachBath: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var droppedItems: [DroppedFood] = []
    @State private var enzymeParticles: [EnzymeParticle] = []
    @State private var nextId = 0
    @State private var sceneActive = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var stomachExplanation: String {
        pack.conceptIndex["ch02_t01_c04"]?.explanation(at: .kidFriendly)
            ?? "Your stomach produces acid and enzymes to break down food into a soupy paste called chyme."
    }

    var body: some View {
        // Refactored GeometryReader+VStack+mid-Spacer to ScrollView+VStack
        // so cards flow naturally below the stomach diagram without an
        // empty band in the middle.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("The Stomach Bath")
                    .font(.title.bold())
                    .foregroundColor(.red)

                HStack(spacing: 12) {
                    ForEach([("Protein", "🥩"), ("Starch", "🍚"), ("Milk", "🥛")], id: \.0) { name, emoji in
                        Button(action: { dropFood(name: name, emoji: emoji) }) {
                            VStack(spacing: 4) {
                                Text(emoji).font(.system(size: 24))
                                Text(name).font(.caption2)
                            }
                            .padding(8)
                            .background(Color.gray.opacity(0.15))
                            .cornerRadius(6)
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)

                ZStack {
                    ZStack {
                        StomachShape()
                            .foregroundColor(Color.pink.opacity(0.15))
                        StomachShape()
                            .stroke(lineWidth: 2)
                            .foregroundColor(Color.pink.opacity(0.5))
                    }

                    // Dropped food items
                    ForEach(droppedItems) { item in
                        VStack(spacing: 0) {
                            Text(item.emoji)
                                .font(.system(size: 32))
                        }
                        .position(x: item.x, y: item.y)
                        .scaleEffect(item.broken ? 0.5 : 1.0)
                        .opacity(item.broken ? 0.6 : 1.0)
                    }

                    // Acid droplets and enzymes
                    ForEach(enzymeParticles) { particle in
                        Circle()
                            .fill(particle.isAcid ? Color.red.opacity(0.6) : Color.purple.opacity(0.6))
                            .frame(width: 6, height: 6)
                            .position(x: particle.x, y: particle.y)
                            .accessibilityLabel(particle.isAcid ? "HCl droplet" : "Pepsin enzyme")
                    }
                }
                .frame(height: 240)
                .padding(.horizontal, 24)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("The Stomach Bath", systemImage: "drop.triangle.fill")
                            .font(.title2.bold())
                            .foregroundColor(.red)
                        Text(stomachExplanation)
                            .font(.body)
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                            .lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth)

                LookingAheadCallout(
                    title: "Class 11 + 12 Chemistry → JEE / NEET",
                    detail: "Stomach HCl has pH ~1.5 — a million times more acidic than blood. JEE Chem asks 'how does the stomach not digest itself?' Answer: a bicarbonate-rich mucus layer with pH ~7 lines the inside, neutralising HCl that touches the wall. The enzyme pepsin you saw works ONLY at acidic pH, then snaps off when food enters the alkaline intestine — pH-gated activity."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "pH-test antacid neutralisation",
                    detail: "Crush half an antacid tablet (Eno / Digene) into a glass of vinegar. Watch the fizzing. The base in the antacid neutralises the acid like it does inside the stomach during heartburn. Test with red litmus (turns blue when base wins) or pH paper if you have any."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                GotItButton { onComplete() }
                    .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
        .onAppear {
            sceneActive = true
            startEnzymeAnimation()
        }
        .onDisappear {
            sceneActive = false
        }
    }

    private func dropFood(name: String, emoji: String) {
        let food = DroppedFood(
            id: nextId,
            name: name,
            emoji: emoji,
            x: 200 + CGFloat.random(in: -40...40),
            y: 130 + CGFloat.random(in: -20...20)
        )
        nextId += 1
        droppedItems.append(food)

        // Simulate digestion after 4 seconds
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 4_000_000_000)
            if let index = droppedItems.firstIndex(where: { $0.id == food.id }) {
                withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.8)) {
                    droppedItems[index].broken = true
                }
            }
        }
    }

    private func startEnzymeAnimation() {
        if reduceMotion { return }
        generateEnzymeParticles()
    }

    private func generateEnzymeParticles() {
        guard sceneActive else { return }
        var particles: [EnzymeParticle] = []
        for _ in 0..<8 {
            particles.append(EnzymeParticle(
                id: Int.random(in: 0..<10000),
                x: CGFloat.random(in: 100...300),
                y: CGFloat.random(in: 80...180),
                isAcid: Bool.random()
            ))
        }
        enzymeParticles = particles
        let count = particles.count

        Task { @MainActor in
            for i in 0..<count {
                try? await Task.sleep(nanoseconds: 100_000_000)
                guard sceneActive else { return }
                withAnimation(reduceMotion ? .none : .easeInOut(duration: 1.5)) {
                    if i < enzymeParticles.count {
                        enzymeParticles[i].x += CGFloat.random(in: -60...60)
                        enzymeParticles[i].y += CGFloat.random(in: -40...40)
                    }
                }
            }
        }

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            generateEnzymeParticles()
        }
    }
}

// MARK: - Stomach Shape

struct StomachShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let width = rect.width * 0.7
        let height = rect.height * 0.8

        // Curved stomach sac
        path.move(to: CGPoint(x: center.x - width / 2, y: center.y - height / 3))
        path.addCurve(
            to: CGPoint(x: center.x + width / 2, y: center.y - height / 3),
            control1: CGPoint(x: center.x - width / 2, y: center.y - height / 2),
            control2: CGPoint(x: center.x + width / 2, y: center.y - height / 2)
        )
        path.addCurve(
            to: CGPoint(x: center.x, y: center.y + height / 2),
            control1: CGPoint(x: center.x + width / 2, y: center.y),
            control2: CGPoint(x: center.x, y: center.y + height / 2.5)
        )
        path.addCurve(
            to: CGPoint(x: center.x - width / 2, y: center.y - height / 3),
            control1: CGPoint(x: center.x, y: center.y + height / 2.5),
            control2: CGPoint(x: center.x - width / 2, y: center.y)
        )

        return path
    }
}

// MARK: - Models

struct DroppedFood: Identifiable {
    let id: Int
    let name: String
    let emoji: String
    var x: CGFloat
    var y: CGFloat
    var broken: Bool = false
}

struct EnzymeParticle: Identifiable {
    let id: Int
    var x: CGFloat
    var y: CGFloat
    let isAcid: Bool
}
