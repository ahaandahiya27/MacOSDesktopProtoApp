import SwiftUI

/// Scene 3 — Inside a Leaf.
///
/// A stylized cross-section drawn with `Path`. Tappable hotspots reveal a
/// callout explaining each part. Stomata pulse open/closed; water rises in
/// xylem, sugar flows down in phloem.
@available(macOS 12, *)
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
                          systemImage: "hand.tap.fill")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: 640)

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
                    Circle().strokeBorder(.white, lineWidth: 1.5)
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

@available(macOS 12, *)
private struct LeafCrossSection: View {
    let reduceMotion: Bool

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30, paused: reduceMotion)) { ctx in
            let phase = (ctx.date.timeIntervalSince1970.truncatingRemainder(dividingBy: 2)) / 2
            ZStack {
                // Outer cuticle (waxy band)
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(colors: [.green.opacity(0.4), .green.opacity(0.65)],
                                         startPoint: .top, endPoint: .bottom))
                    .frame(height: 18)
                    .frame(maxWidth: .infinity)
                    .position(x: 250, y: 22)

                // Body of leaf (palisade + spongy mesophyll)
                RoundedRectangle(cornerRadius: 18)
                    .fill(.green.opacity(0.18))
                    .frame(width: 460, height: 230)
                    .position(x: 250, y: 150)

                // Cells (drawn as ovals) with chloroplasts (small green dots)
                ForEach(0..<6, id: \.self) { i in
                    let x = 70 + Double(i) * 60
                    Ellipse()
                        .stroke(.green.opacity(0.55), lineWidth: 1.5)
                        .frame(width: 58, height: 70)
                        .position(x: x, y: 110)
                    // 3 chloroplasts per cell
                    ForEach(0..<3, id: \.self) { j in
                        Capsule()
                            .fill(.green.opacity(0.85))
                            .frame(width: 12, height: 8)
                            .position(x: x - 12 + Double(j) * 12, y: 110 + Double(j % 2) * 18 - 8)
                    }
                }

                // Xylem channel (right side, water rising)
                xylemColumn(phase: phase)
                // Phloem channel (right side, sugar going down)
                phloemColumn(phase: phase)

                // Stomata (pair of guard cells at the bottom centre, opening/closing)
                stomata(phase: phase)
            }
            .frame(width: 500, height: 280)
        }
    }

    private func xylemColumn(phase: Double) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .stroke(.blue.opacity(0.5), lineWidth: 1.5)
                .frame(width: 22, height: 200)
                .position(x: 380, y: 140)
            ForEach(0..<3, id: \.self) { i in
                let p = (phase + Double(i) / 3).truncatingRemainder(dividingBy: 1)
                Image(systemName: "drop.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.blue.opacity(0.85))
                    .position(x: 380, y: 240 - 200 * p)
            }
        }
    }

    private func phloemColumn(phase: Double) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .stroke(.orange.opacity(0.5), lineWidth: 1.5)
                .frame(width: 22, height: 200)
                .position(x: 415, y: 140)
            ForEach(0..<3, id: \.self) { i in
                let p = (phase + Double(i) / 3).truncatingRemainder(dividingBy: 1)
                Circle()
                    .fill(.orange.opacity(0.8))
                    .frame(width: 8, height: 8)
                    .position(x: 415, y: 40 + 200 * p)
            }
        }
    }

    private func stomata(phase: Double) -> some View {
        let openness = 0.4 + 0.6 * abs(sin(phase * 2 * .pi))
        return HStack(spacing: 1) {
            Capsule()
                .fill(.green.opacity(0.7))
                .frame(width: 16, height: 28)
                .rotationEffect(.degrees(-15 * openness))
            Capsule()
                .fill(.green.opacity(0.7))
                .frame(width: 16, height: 28)
                .rotationEffect(.degrees(15 * openness))
        }
        .position(x: 250, y: 258)
    }
}
