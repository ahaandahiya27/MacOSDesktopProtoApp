import SwiftUI

/// Scene 6 — Acid or Base Sorting Lab. Drag-and-drop game, 12 items, scored.
/// Uses DragGesture with zone rect tracking.
@available(macOS 12, *)
struct Scene6_AcidOrBaseSortingLab: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    private struct Substance: Identifiable {
        let id = UUID()
        let name: String
        let emoji: String
        let isAcid: Bool
    }

    private static let allSubstances: [Substance] = [
        Substance(name: "HCl", emoji: "\u{1F9EA}", isAcid: true),
        Substance(name: "NaOH", emoji: "\u{1F9FF}", isAcid: false),
        Substance(name: "Vinegar", emoji: "\u{1FAD9}", isAcid: true),
        Substance(name: "Lime water", emoji: "\u{1F95B}", isAcid: false),
        Substance(name: "Lemon juice", emoji: "\u{1F34B}", isAcid: true),
        Substance(name: "Soap solution", emoji: "\u{1F9FC}", isAcid: false),
        Substance(name: "Curd", emoji: "\u{1F95B}", isAcid: true),
        Substance(name: "Baking soda", emoji: "\u{1F9C2}", isAcid: false),
        Substance(name: "Gastric juice", emoji: "\u{1FAE0}", isAcid: true),
        Substance(name: "Ammonia", emoji: "\u{1F9F4}", isAcid: false),
        Substance(name: "Tartaric acid", emoji: "\u{1F347}", isAcid: true),
        Substance(name: "Calcium hydroxide", emoji: "\u{1FAA8}", isAcid: false),
    ]

    @State private var remaining: [Substance] = Scene6_AcidOrBaseSortingLab.allSubstances.shuffled()
    @State private var acidBin: [Substance] = []
    @State private var baseBin: [Substance] = []
    @State private var score: Int = 0
    @State private var dragOffsets: [UUID: CGSize] = [:]
    @State private var shakeId: UUID? = nil
    @State private var showConfetti = false
    @State private var acidRect: CGRect = .zero
    @State private var baseRect: CGRect = .zero
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var isDone: Bool { remaining.isEmpty }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 12) {
                    // Score
                    HStack {
                        Spacer()
                        Text("Score: \(score) / 12")
                            .font(.headline.monospacedDigit())
                            .foregroundColor(Color.compatIndigo)
                            .padding(.trailing, 24)
                            .padding(.top, 8)
                    }

                    // Items to drag
                    if !isDone {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10)], spacing: 10) {
                            ForEach(remaining) { sub in
                                substanceChip(sub)
                            }
                        }
                        .padding(.horizontal, 24)
                        .frame(maxHeight: 180)
                    } else {
                        Text("All sorted!")
                            .font(.title2.bold())
                            .foregroundColor(.green)
                            .padding(.top, 20)
                    }

                    // Drop zones
                    HStack(spacing: 20) {
                        dropZone(title: "Acid", color: .red, items: acidBin, isAcidZone: true)
                        dropZone(title: "Base", color: .blue, items: baseBin, isAcidZone: false)
                    }
                    .padding(.horizontal, 24)
                    .frame(maxHeight: 200)

                    Spacer()
                }

                VStack(spacing: 14) {
                    Spacer()
                    if isDone {
                        SoftShadowCard(padding: 18) {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Great sorting!", systemImage: "star.fill")
                                    .font(.title2.bold())
                                    .foregroundColor(.orange)
                                Text("Acids like HCl, vinegar, and lemon juice taste sour and turn blue litmus red. Bases like NaOH, soap, and baking soda taste bitter and turn red litmus blue.")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: 640)
                        GotItButton { onComplete(score) }
                            .padding(.bottom, 12)
                    } else {
                        SoftShadowCard(padding: 18) {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Acid or Base?", systemImage: "arrow.left.arrow.right")
                                    .font(.title2.bold())
                                Text("Drag each substance into the correct zone \u{2014} Acid or Base.")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: 640)
                        .padding(.bottom, 12)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)

                if showConfetti {
                    ParticleEmitter(isActive: true, particleCount: 40, duration: 1.5)
                        .allowsHitTesting(false)
                        .ignoresSafeArea()
                }
            }
        }
    }

    // MARK: - Substance chip with DragGesture

    private func substanceChip(_ sub: Substance) -> some View {
        let offset = dragOffsets[sub.id] ?? .zero
        let isShaking = shakeId == sub.id

        return VStack(spacing: 2) {
            Text(sub.emoji)
                .font(.title2)
            Text(sub.name)
                .font(.caption.weight(.medium))
                .multilineTextAlignment(.center)
        }
        .frame(width: 100, height: 64)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(NSColor.windowBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(.gray.opacity(0.25), lineWidth: 1)
        )
        .shadow(color: .black.opacity(offset != .zero ? 0.25 : 0), radius: 12, x: 0, y: 6)
        .scaleEffect(offset != .zero ? 1.08 : 1.0)
        .offset(offset)
        .offset(x: isShaking ? -6 : 0)
        .zIndex(offset == .zero ? 0 : 10)
        .gesture(
            DragGesture(coordinateSpace: .global)
                .onChanged { val in
                    dragOffsets[sub.id] = val.translation
                }
                .onEnded { val in
                    let dropPt = val.location
                    handleDrop(sub, at: dropPt)
                    dragOffsets[sub.id] = .zero
                }
        )
        .accessibilityLabel("\(sub.name). Drag to acid or base zone.")
    }

    // MARK: - Drop zone

    private func dropZone(title: String, color: Color, items: [Substance], isAcidZone: Bool) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundColor(color)

            let cols = [GridItem(.adaptive(minimum: 70), spacing: 4)]
            LazyVGrid(columns: cols, spacing: 4) {
                ForEach(items) { s in
                    Text("\(s.emoji) \(s.name)")
                        .font(.caption2)
                        .padding(4)
                        .background(color.opacity(0.1))
                        .cornerRadius(6)
                }
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(color.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(color.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
        )
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        let frame = geo.frame(in: .global)
                        if isAcidZone { acidRect = frame }
                        else { baseRect = frame }
                    }
                    .onChange(of: geo.size) { _ in
                        let frame = geo.frame(in: .global)
                        if isAcidZone { acidRect = frame }
                        else { baseRect = frame }
                    }
            }
        )
        .accessibilityLabel("\(title) zone with \(items.count) items")
    }

    // MARK: - Drop logic

    private func handleDrop(_ sub: Substance, at point: CGPoint) {
        let droppedInAcid = acidRect.contains(point)
        let droppedInBase = baseRect.contains(point)

        guard droppedInAcid || droppedInBase else { return }

        let correct = (droppedInAcid && sub.isAcid) || (droppedInBase && !sub.isAcid)

        if correct {
            score += 1
            withAnimation(.easeInOut(duration: 0.25)) {
                remaining.removeAll { $0.id == sub.id }
                if sub.isAcid { acidBin.append(sub) }
                else { baseBin.append(sub) }
            }
            showConfetti = true
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 1_500_000_000)
                showConfetti = false
            }
        } else {
            shakeId = sub.id
            if !reduceMotion {
                withAnimation(.spring(response: 0.15, dampingFraction: 0.3)) {
                    shakeId = sub.id
                }
            }
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 400_000_000)
                shakeId = nil
            }
        }
    }
}
