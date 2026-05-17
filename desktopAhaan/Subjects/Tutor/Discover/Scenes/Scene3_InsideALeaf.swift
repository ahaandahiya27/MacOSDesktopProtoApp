import SwiftUI

/// Scene 3 — Inside a Leaf.
///
/// A stylized cross-section drawn with `Path`. Tappable hotspots reveal a
/// callout explaining each part. Stomata pulse open/closed; water rises in
/// xylem, sugar flows down in phloem.
///
/// Big Sur (macOS 11) compatible — the `TimelineView(.animation)` driving
/// the xylem / phloem / stomata animation is replaced with a 30 fps
/// `Timer.publish` writing into a `@State tick: TimeInterval`. The per-
/// particle position math is also lifted into small subviews with
/// explicit `Double` types to keep the Swift 5.5 type-checker happy.
struct Scene3_InsideALeaf: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var selectedPart: LeafPart? = nil
    @State private var zoomed = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    enum LeafPart: String, CaseIterable, Identifiable {
        case cuticle, stomata, chloroplasts, xylem, phloem
        var id: String { rawValue }
        var title: String {
            switch self {
            case .cuticle: return "Cuticle"
            case .stomata: return "Stomata"
            case .chloroplasts: return "Chloroplasts"
            case .xylem: return "Xylem"
            case .phloem: return "Phloem"
            }
        }
        var emoji: String {
            switch self {
            case .cuticle: return "🛡️"
            case .stomata: return "👄"
            case .chloroplasts: return "🟢"
            case .xylem: return "💧⬆️"
            case .phloem: return "🍯⬇️"
            }
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            Text("Inside a Leaf")
                .font(.largeTitle.bold())
                .padding(.top, 18)
            Text("Tap each part to learn what it does.")
                .font(.callout)
                .foregroundColor(.secondary)

            // The cross-section
            ZStack {
                LeafCrossSection(reduceMotion: reduceMotion)
                    .frame(height: 280)
                    .scaleEffect(zoomed ? 1.4 : 1.0, anchor: .center)

                // Invisible hit areas overlaid on the cross-section
                GeometryReader { geo in
                    let w = geo.size.width
                    let h = geo.size.height
                    Group {
                        partHotspot(.cuticle,      at: CGPoint(x: w * 0.5, y: h * 0.10))
                        partHotspot(.stomata,      at: CGPoint(x: w * 0.5, y: h * 0.92))
                        partHotspot(.chloroplasts, at: CGPoint(x: w * 0.32, y: h * 0.45))
                        partHotspot(.xylem,        at: CGPoint(x: w * 0.78, y: h * 0.40))
                        partHotspot(.phloem,       at: CGPoint(x: w * 0.78, y: h * 0.65))
                    }
                }
            }
            .frame(maxWidth: 560, maxHeight: 320)
            .clipped()

            HStack(spacing: 12) {
                Button {
                    withAnimation(.spring()) { zoomed.toggle() }
                } label: {
                    Label(zoomed ? "Zoom out" : "🔍 Zoom in",
                          systemImage: zoomed ? "minus.magnifyingglass" : "plus.magnifyingglass")
                }

            }

            // Callout for the selected part
            SoftShadowCard(padding: 16) {
                if let part = selectedPart {
                    HStack(alignment: .top, spacing: 12) {
                        Text(part.emoji).font(.system(size: 28))
                        VStack(alignment: .leading, spacing: 4) {
                            Text(part.title)
                                .font(.title3.bold())
                            Text(explanation(for: part))
                                .font(.callout)
                                .foregroundColor(.primary)
                        }
                        Spacer(minLength: 0)
                    }
                } else {
                    Label("Tap any glowing dot on the leaf above.",
                          systemImage: SFSymbolCompat.name("hand.tap.fill"))
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth)

            LookingAheadCallout(
                title: "Class 11 Biology → NEET",
                detail: "Each leaf part you just clicked becomes a whole NEET topic: mesophyll cells (palisade vs spongy → light-capture vs gas-exchange specialisation), stomatal guard cells (turgor mechanics, transpiration physics), vascular bundles (xylem ↑ water, phloem ↓ sugar). Knowing the parts now means in Class 11 you're learning their *physiology*, not their *names*."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "See stomata yourself",
                detail: "Peel the thin underside skin off a fresh leaf (Rheo or money-plant works best — it lifts off in big sheets). Lay it on a glass slide. Even a 10× pocket magnifier will show the mouth-like stomata. Each one is two guard cells curved around an opening, breathing for the plant."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton(action: onComplete)
                .padding(.bottom, 12)
                .disabled(selectedPart == nil)
                .opacity(selectedPart == nil ? 0.55 : 1)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func partHotspot(_ part: LeafPart, at position: CGPoint) -> some View {
        Button {
            withAnimation(.easeInOut) {
                selectedPart = part
            }
        } label: {
            Circle()
                .fill(Color.compatIndigo.opacity(selectedPart == part ? 0.55 : 0.28))
                .overlay(
                    Circle().strokeBorder(Color.white, lineWidth: 1.5)
                )
                .frame(width: 22, height: 22)
                .shadow(color: Color.compatIndigo.opacity(0.5), radius: 4)
        }
        .buttonStyle(.plain)
        .position(position)
        .accessibilityLabel("Show information about \(part.title)")
    }

    private func explanation(for part: LeafPart) -> String {
        switch part {
        case .cuticle:
            return "A waxy outer coat that keeps the leaf from drying out. Like a raincoat for the plant."
        case .stomata:
            return pack.conceptIndex["ch01_t01_c03"]?.explanation(at: .kidFriendly)
                ?? "Tiny mouths on the underside that open to take in CO₂ and let O₂ out."
        case .chloroplasts:
            return pack.conceptIndex["ch01_t01_c04"]?.explanation(at: .kidFriendly)
                ?? "Tiny green bags inside leaf cells. They hold chlorophyll and run photosynthesis."
        case .xylem:
            return "Pipes that carry water UP from the roots to the leaves."
        case .phloem:
            return "Pipes that carry sugar DOWN from the leaves to the rest of the plant."
        }
    }
}

// MARK: - The drawn cross-section

/// Cross-section with an internal 30 fps timer that drives the xylem,
/// phloem, and stomata animations. Was a TimelineView (macOS 12+).
private struct LeafCrossSection: View {
    let reduceMotion: Bool

    @State private var tick: TimeInterval = 0

    var body: some View {
        // `phase` cycles 0 → 1 every 2 seconds, exactly matching the old
        // TimelineView's `phase = (date.timeIntervalSince1970 % 2) / 2`.
        let phase: Double = (tick.truncatingRemainder(dividingBy: 2.0)) / 2.0
        ZStack {
            // Outer cuticle (waxy band)
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(
                    colors: [Color.green.opacity(0.4), Color.green.opacity(0.65)],
                    startPoint: .top, endPoint: .bottom))
                .frame(height: 18)
                .frame(maxWidth: .infinity)
                .position(x: 250, y: 22)

            // Body of leaf (palisade + spongy mesophyll)
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.green.opacity(0.18))
                .frame(width: 460, height: 230)
                .position(x: 250, y: 150)

            // Cells (drawn as ovals) with chloroplasts (small green dots)
            ForEach(0..<6, id: \.self) { i in
                LeafCellWithChloroplasts(index: i)
            }

            // Xylem channel (right side, water rising)
            XylemColumn(phase: phase)
            // Phloem channel (right side, sugar going down)
            PhloemColumn(phase: phase)

            // Stomata (pair of guard cells at the bottom centre, opening/closing)
            StomataPair(phase: phase)
        }
        .frame(width: 500, height: 280)
        .timedScene(idealFPS: 30, tick: $tick)
    }
}

// MARK: - Small subviews (so the Swift 5.5 type-checker stays happy)

private struct LeafCellWithChloroplasts: View {
    let index: Int
    var body: some View {
        let x: Double = 70.0 + Double(index) * 60.0
        ZStack {
            Ellipse()
                .stroke(Color.green.opacity(0.55), lineWidth: 1.5)
                .frame(width: 58, height: 70)
                .position(x: CGFloat(x), y: 110)
            ForEach(0..<3, id: \.self) { j in
                let cx: Double = x - 12.0 + Double(j) * 12.0
                let cy: Double = 110.0 + Double(j % 2) * 18.0 - 8.0
                Capsule()
                    .fill(Color.green.opacity(0.85))
                    .frame(width: 12, height: 8)
                    .position(x: CGFloat(cx), y: CGFloat(cy))
            }
        }
    }
}

private struct XylemColumn: View {
    let phase: Double
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.blue.opacity(0.5), lineWidth: 1.5)
                .frame(width: 22, height: 200)
                .position(x: 380, y: 140)
            ForEach(0..<3, id: \.self) { i in
                XylemDrop(phase: phase, index: i)
            }
        }
    }
}

private struct XylemDrop: View {
    let phase: Double
    let index: Int
    var body: some View {
        let p: Double = (phase + Double(index) / 3.0).truncatingRemainder(dividingBy: 1.0)
        let y: Double = 240.0 - 200.0 * p
        Image(systemName: "drop.fill")
            .font(.system(size: 12))
            .foregroundColor(Color.blue.opacity(0.85))
            .position(x: 380, y: CGFloat(y))
    }
}

private struct PhloemColumn: View {
    let phase: Double
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.orange.opacity(0.5), lineWidth: 1.5)
                .frame(width: 22, height: 200)
                .position(x: 415, y: 140)
            ForEach(0..<3, id: \.self) { i in
                PhloemDot(phase: phase, index: i)
            }
        }
    }
}

private struct PhloemDot: View {
    let phase: Double
    let index: Int
    var body: some View {
        let p: Double = (phase + Double(index) / 3.0).truncatingRemainder(dividingBy: 1.0)
        let y: Double = 40.0 + 200.0 * p
        Circle()
            .fill(Color.orange.opacity(0.8))
            .frame(width: 8, height: 8)
            .position(x: 415, y: CGFloat(y))
    }
}

private struct StomataPair: View {
    let phase: Double
    var body: some View {
        let openness: Double = 0.4 + 0.6 * abs(sin(Double(phase) * 2.0 * Double.pi))
        HStack(spacing: 1) {
            Capsule()
                .fill(Color.green.opacity(0.7))
                .frame(width: 16, height: 28)
                .rotationEffect(.degrees(-15 * openness))
            Capsule()
                .fill(Color.green.opacity(0.7))
                .frame(width: 16, height: 28)
                .rotationEffect(.degrees(15 * openness))
        }
        .position(x: 250, y: 258)
    }
}
