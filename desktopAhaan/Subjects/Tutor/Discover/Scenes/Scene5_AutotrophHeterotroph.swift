import SwiftUI

/// Scene 5 — Autotroph or Heterotroph?
///
/// 12 organism cards float at the top. The kid drags each into one of two
/// drop zones. Wrong drops shake; correct drops settle into the zone with a
/// confetti burst. A score badge tracks "X / 12 placed". When all are placed,
/// a celebration overlay appears and the parent's onComplete is called with
/// the correct count.
///
/// Implementation note: rather than rely on the system `Transferable` /
/// `.draggable` plumbing (which has rough edges on macOS for arbitrary models),
/// we drive the drag with a long-press gesture + offset, and decide the drop
/// target from the final touch position relative to two zone rects we track
/// with `GeometryReader`s. This keeps everything in pure SwiftUI without
/// custom UTIs or AppKit pasteboards.

struct Scene5_AutotrophHeterotroph: View {
    let pack: SubjectPack
    let chapter: Chapter
    /// Reports the number of CORRECTLY placed cards.
    let onComplete: (Int) -> Void

    @State private var tokens: [OrganismToken] = []
    @State private var placed: [String: Bool] = [:]   // tokenId -> isCorrect (true) or false (still wrong-shake state)
    @State private var draggingId: String? = nil
    @State private var dragOffset: CGSize = .zero
    @State private var dragOrigin: CGPoint = .zero

    @State private var autotrophZoneRect: CGRect = .zero
    @State private var heterotrophZoneRect: CGRect = .zero

    @State private var celebrate = false
    @State private var feedback: String? = nil
    @State private var feedbackTimer: Date = .distantPast
    @State private var shakeMap: [String: CGFloat] = [:]

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var allTokens: [OrganismToken] {
        [
            OrganismToken(id: "mango",     emoji: "🌳", label: "mango tree",  isAutotroph: true),
            OrganismToken(id: "elephant",  emoji: "🐘", label: "elephant",    isAutotroph: false),
            OrganismToken(id: "wheat",     emoji: "🌾", label: "wheat",       isAutotroph: true),
            OrganismToken(id: "bee",       emoji: "🐝", label: "bee",         isAutotroph: false),
            OrganismToken(id: "cactus",    emoji: "🌵", label: "cactus",      isAutotroph: true),
            OrganismToken(id: "wolf",      emoji: "🐺", label: "wolf",        isAutotroph: false),
            OrganismToken(id: "sunflower", emoji: "🌻", label: "sunflower",   isAutotroph: true),
            OrganismToken(id: "urchin",    emoji: "🐚", label: "sea urchin",  isAutotroph: false),
            OrganismToken(id: "corn",      emoji: "🌽", label: "corn",        isAutotroph: true),
            OrganismToken(id: "butterfly", emoji: "🦋", label: "butterfly",   isAutotroph: false),
            OrganismToken(id: "strawberry",emoji: "🍓", label: "strawberry",  isAutotroph: true),
            OrganismToken(id: "eagle",     emoji: "🦅", label: "eagle",       isAutotroph: false)
        ]
    }

    private var correctCount: Int { placed.values.filter { $0 }.count }
    private var allPlaced: Bool { correctCount == 12 }

    var body: some View {
        VStack(spacing: 12) {
            headerSection
            instructionLine
            floatingCardsGrid
            dropZonesRow
            feedbackLine
            actionsRow
            Spacer(minLength: 0)
        }
        .overlay(celebrationOverlay)
        .onAppear {
            if tokens.isEmpty { tokens = allTokens.shuffled() }
        }
    }

    @ViewBuilder
    private var headerSection: some View {
        HStack {
            Text("Autotroph or Heterotroph?")
                .font(.largeTitle.bold())
            Spacer()
            ScoreBadge(value: correctCount, total: 12)
        }
        .padding(.horizontal, 24)
        .padding(.top, 18)
    }

    @ViewBuilder
    private var instructionLine: some View {
        Text("Drag each card into the right zone. 🌱 makes its own food. 🐯 eats others.")
            .font(.callout)
            .foregroundColor(.secondary)
    }

    @ViewBuilder
    private func cardCell(at idx: Int) -> some View {
        if idx < tokens.count {
            let token = tokens[idx]
            let isPlacedCorrect = placed[token.id] == true
            DraggableCard(
                token: token,
                settled: isPlacedCorrect,
                shakeOffset: shakeMap[token.id] ?? 0
            )
            .opacity(isPlacedCorrect ? 0.4 : 1)
            .offset(draggingId == token.id ? dragOffset : .zero)
            .zIndex(draggingId == token.id ? 100 : 0)
            .gesture(dragGesture(for: token))
            .accessibilityAction(named: Text("Place in autotrophs")) {
                placeViaA11y(token, asAutotroph: true)
            }
            .accessibilityAction(named: Text("Place in heterotrophs")) {
                placeViaA11y(token, asAutotroph: false)
            }
        }
    }

    @ViewBuilder
    private var floatingCardsGrid: some View {
        ZStack {
            VStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(0..<4, id: \.self) { col in
                            cardCell(at: row * 4 + col)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: 560)
        .padding(.horizontal, 24)
    }

    @ViewBuilder
    private var dropZonesRow: some View {
        HStack(spacing: 16) {
            DropZone(
                title: "🌱 Autotrophs",
                subtitle: "make own food",
                tint: .green
            )
            .background(autotrophZoneTracker)

            DropZone(
                title: "🐯 Heterotrophs",
                subtitle: "eat others",
                tint: .orange
            )
            .background(heterotrophZoneTracker)
        }
        .frame(maxWidth: 600)
        .padding(.horizontal, 24)
    }

    @ViewBuilder
    private var autotrophZoneTracker: some View {
        GeometryReader { geo in
            Color.clear
                .onAppear { autotrophZoneRect = geo.frame(in: .global) }
                .onChange(of: geo.size) { _ in autotrophZoneRect = geo.frame(in: .global) }
        }
    }

    @ViewBuilder
    private var heterotrophZoneTracker: some View {
        GeometryReader { geo in
            Color.clear
                .onAppear { heterotrophZoneRect = geo.frame(in: .global) }
                .onChange(of: geo.size) { _ in heterotrophZoneRect = geo.frame(in: .global) }
        }
    }

    @ViewBuilder
    private var feedbackLine: some View {
        if let fb = feedback {
            Text(fb)
                .font(.callout.weight(.medium))
                .foregroundColor(Color.compatIndigo)
                .padding(.top, 4)
                .transition(.opacity)
        }
    }

    @ViewBuilder
    private var actionsRow: some View {
        HStack(spacing: 14) {
            Button("Skip — show answers") {
                skipAndShow()
            }

            VStack(spacing: 4) {
                GotItButton(action: { onComplete(correctCount) })
                    .disabled(!allPlaced && correctCount == 0)
                    .opacity((allPlaced || correctCount > 0) ? 1 : 0.55)
                if !allPlaced && correctCount == 0 {
                    Text("Place all cards to continue")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.bottom, 12)
    }

    @ViewBuilder
    private var celebrationOverlay: some View {
        if celebrate {
            ZStack {
                Color.black.opacity(0.18).ignoresSafeArea()
                SoftShadowCard {
                    VStack(spacing: 10) {
                        Text("🎉").font(.system(size: 56))
                        Text("Well done!")
                            .font(.title.bold())
                        Text("\(correctCount) out of 12 correct.")
                            .font(.callout)
                            .foregroundColor(.secondary)
                        Button("Continue") {
                            onComplete(correctCount)
                        }
                        .accentColor(.green)
                        .padding(.top, 6)
                    }
                    .padding(20)
                }
                .frame(maxWidth: 320)
                ParticleEmitter(isActive: true, particleCount: 80)
                    .allowsHitTesting(false)
            }
            .transition(.opacity)
        }
    }

    // MARK: - Drag handling

    private func dragGesture(for token: OrganismToken) -> some Gesture {
        DragGesture(minimumDistance: 4, coordinateSpace: .global)
            .onChanged { value in
                draggingId = token.id
                if dragOrigin == .zero {
                    dragOrigin = value.startLocation
                }
                dragOffset = CGSize(
                    width: value.translation.width,
                    height: value.translation.height
                )
            }
            .onEnded { value in
                let drop = value.location
                if autotrophZoneRect.contains(drop) {
                    decideDrop(token: token, droppedAsAutotroph: true)
                } else if heterotrophZoneRect.contains(drop) {
                    decideDrop(token: token, droppedAsAutotroph: false)
                } else {
                    // Released outside any zone — just snap back.
                    withAnimation(.spring()) {
                        dragOffset = .zero
                    }
                }
                draggingId = nil
                dragOffset = .zero
                dragOrigin = .zero
            }
    }

    private func placeViaA11y(_ token: OrganismToken, asAutotroph: Bool) {
        decideDrop(token: token, droppedAsAutotroph: asAutotroph)
    }

    private func decideDrop(token: OrganismToken, droppedAsAutotroph: Bool) {
        let correct = (token.isAutotroph == droppedAsAutotroph)
        if correct {
            withAnimation(.spring()) {
                placed[token.id] = true
            }
            feedback = "✓ Right! \(token.label) — \(token.isAutotroph ? "makes its own food" : "eats other things")."
            if correctCount == 12 && !celebrate {
                withAnimation(.easeInOut) { celebrate = true }
            }
        } else {
            // Shake the card
            shakeMap[token.id] = 12
            withAnimation(.spring(response: 0.18, dampingFraction: 0.4)) { shakeMap[token.id] = -10 }
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 200_000_000)
                withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) { shakeMap[token.id] = 0 }
            }
            feedback = "Try again — \(token.label) is a \(token.isAutotroph ? "🌱 autotroph" : "🐯 heterotroph")."
        }
    }

    private func skipAndShow() {
        withAnimation(.easeInOut) {
            for t in tokens { placed[t.id] = true }
            celebrate = true
        }
    }
}

// MARK: - Helpers

private struct DropZone: View {
    let title: String
    let subtitle: String
    let tint: Color

    var body: some View {
        VStack(spacing: 6) {
            Text(title).font(.title3.bold())
            Text(subtitle).font(.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(tint.opacity(0.12))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(tint.opacity(0.5),
                              style: StrokeStyle(lineWidth: 2, dash: [6, 6]))
        )
    }
}

struct ScoreBadge: View {
    let value: Int
    let total: Int
    var body: some View {
        Text("\(value) / \(total)")
            .font(.headline.monospacedDigit())
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
            .foregroundColor(Color.compatIndigo)
    }
}
