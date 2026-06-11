import SwiftUI
import AppKit

// MARK: - ConceptMapView
//
// Chapter-agnostic visual node-and-edge graph of how a chapter's
// concepts connect, plus cross-chapter pointers. Renders
// `chapter.conceptMap`; auto-hides behind the CTA if the chapter has
// no conceptMap authored.
//
// Pan + zoom via DragGesture + MagnificationGesture. Tap a concept
// node → opens the concept detail. Tap a cross-chapter node → opens
// the linked chapter.
//
// Lineage:
//   - 2026-05-23 — shipped as `Ch1ConceptMap` in the Ch.1 pilot at
//                  `Subjects/Tutor/Surfaces/Ch1/`. Single-chapter
//                  scope at the time because only Ch.1 had authored
//                  conceptMap data.
//   - 2026-05-24 — content propagation populated `chapter.conceptMap`
//                  for all 19 chapters. The renderer was generic-by-
//                  construction; only the name and home directory
//                  were chapter-pinned. Promoted to a shared
//                  Component this commit. Old file deleted.
//
// Accessibility: the visual canvas is `.accessibilityHidden(true)`
// (lines + offsets aren't VoiceOver-meaningful). A semantic List of
// "<from-label> → <relation> → <to-label>" rows sits below the
// canvas, focus-navigable by VoiceOver, carrying the same
// information.
//
// Big Sur compat:
//   - ZStack of SwiftUI Shapes + GeometryReader. No Canvas (macOS 12+).
//   - DragGesture / MagnificationGesture: macOS 10.15+.
//   - All animations gated by .respectReduceMotion(animation:).

struct ConceptMapView: View {
    let pack: SubjectPack
    let chapter: Chapter
    var onDismiss: () -> Void

    @EnvironmentObject private var nav: TutorNavigationState

    @State private var zoom: CGFloat = 1.0
    @State private var pan: CGSize = .zero
    @GestureState private var dragOffset: CGSize = .zero
    @GestureState private var liveZoom: CGFloat = 1.0

    private var conceptMap: ConceptMap? { chapter.conceptMap }
    private var nodes: [ConceptMapNode] { conceptMap?.nodes ?? [] }
    private var edges: [ConceptMapEdge] { conceptMap?.edges ?? [] }

    /// Concept-id → label lookup so the a11y list can render
    /// "<from-label> → <to-label>" rather than ids.
    private var labelByNodeId: [String: String] {
        // Soft de-dup: conceptMap node ids are hand-authored (incl. synthetic
        // pivot / cross-chapter ids), so a duplicate is plausible. The unsafe
        // `Dictionary(uniqueKeysWithValues:)` would TRAP on a dup and kill the
        // session when the kid opens this chapter's map — log + keep first.
        Dictionary(nodes.map { ($0.id, $0.label) }, uniquingKeysWith: { first, _ in
            CrashReporter.shared.logDataIssue("Duplicate conceptMap node id: keeping first label '\(first)'")
            return first
        })
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            if nodes.isEmpty {
                emptyState
            } else {
                canvasBlock
                Divider()
                a11yListFallback
            }
            Divider()
            footerBar
        }
        .frame(minWidth: 640, idealWidth: 820, maxWidth: 1100,
               minHeight: 540, idealHeight: 720, maxHeight: 920)
        .background(Color(NSColor.windowBackgroundColor))
        .background(
            Button("Dismiss", action: onDismiss)
                .keyboardShortcut(.cancelAction)
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
        )
    }

    // MARK: - Header / footer

    private var header: some View {
        HStack(spacing: 14) {
            Image(systemName: SFSymbolCompat.name("point.3.connected.trianglepath.dotted"))
                .font(.title3)
                .foregroundColor(Color.compatIndigo)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 3) {
                Text("See the connections")
                    .font(.title3.bold())
                Text("Ch. \(chapter.number) · \(nodes.count) ideas, \(edges.count) links")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
            zoomControls
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
            .pointingCursor()
            .accessibilityLabel("Close concept map")
        }
        .padding(.horizontal, 22)
        .padding(.top, 18)
        .padding(.bottom, DesignTokens.Spacing.md)
    }

    private var zoomControls: some View {
        HStack(spacing: DesignTokens.Spacing.xs) {
            Button(action: zoomOut) {
                Image(systemName: "minus.magnifyingglass")
            }
            .buttonStyle(.borderless)
            .accessibilityLabel("Zoom out")
            Button("Reset") { resetView() }
                .buttonStyle(.borderless)
                .font(.caption.weight(.semibold))
                .accessibilityLabel("Reset zoom and pan")
            Button(action: zoomIn) {
                Image(systemName: "plus.magnifyingglass")
            }
            .buttonStyle(.borderless)
            .accessibilityLabel("Zoom in")
        }
    }

    private var footerBar: some View {
        HStack {
            Text("Tap a concept to open it. Dashed nodes are in other chapters.")
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            Button("Done", action: onDismiss)
                .keyboardShortcut(.defaultAction)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, DesignTokens.Spacing.md)
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: SFSymbolCompat.name("point.3.connected.trianglepath.dotted"))
                .font(.system(size: 44))
                .foregroundColor(.secondary)
            Text("No concept map authored for this chapter yet.")
                .font(.callout)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 80)
    }

    // MARK: - Canvas

    private var canvasBlock: some View {
        GeometryReader { geo in
            let edgeLayer = edgesLayer(in: geo.size)
            let nodeLayer = nodesLayer(in: geo.size)
            let offsetX: CGFloat = pan.width + dragOffset.width
            let offsetY: CGFloat = pan.height + dragOffset.height
            let totalZoom: CGFloat = zoom * liveZoom
            ZStack {
                Color.compatIndigo.opacity(0.04)
                edgeLayer
                nodeLayer
            }
            .scaleEffect(totalZoom)
            .offset(x: offsetX, y: offsetY)
            .respectReduceMotion(animation: .easeOut(duration: 0.15))
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation
                    }
                    .onEnded { value in
                        pan.width += value.translation.width
                        pan.height += value.translation.height
                    }
            )
            .simultaneousGesture(
                MagnificationGesture()
                    .updating($liveZoom) { value, state, _ in
                        state = value
                    }
                    .onEnded { value in
                        zoom = max(0.4, min(2.5, zoom * value))
                    }
            )
            .clipped()
            .accessibilityHidden(true)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 360)
    }

    @ViewBuilder
    private func edgesLayer(in size: CGSize) -> some View {
        ZStack {
            ForEach(edges) { edge in
                if let from = nodes.first(where: { $0.id == edge.from }),
                   let to   = nodes.first(where: { $0.id == edge.to }) {
                    EdgePath(
                        from: CGPoint(x: from.x * size.width, y: from.y * size.height),
                        to:   CGPoint(x: to.x * size.width,   y: to.y * size.height)
                    )
                    .stroke(Color.compatIndigo.opacity(0.45), lineWidth: 1.4)
                    if let label = edge.label {
                        edgeLabel(text: label, from: from, to: to, size: size)
                    }
                }
            }
        }
    }

    private func edgeLabel(text: String, from: ConceptMapNode, to: ConceptMapNode, size: CGSize) -> some View {
        let mx = (from.x + to.x) * 0.5 * size.width
        let my = (from.y + to.y) * 0.5 * size.height
        return Text(text)
            .font(.system(size: 8, weight: .semibold))
            .foregroundColor(.secondary)
            .padding(.horizontal, 3)
            .padding(.vertical, 1)
            .background(Color(NSColor.windowBackgroundColor).opacity(0.85))
            .position(x: mx, y: my)
    }

    @ViewBuilder
    private func nodesLayer(in size: CGSize) -> some View {
        ZStack {
            ForEach(nodes) { node in
                let nodeX: CGFloat = node.x * size.width
                let nodeY: CGFloat = node.y * size.height
                Button {
                    handleNodeTap(node)
                } label: {
                    NodeChip(node: node)
                }
                .buttonStyle(.plain)
                .pointingCursor()
                .position(
                    x: nodeX,
                    y: nodeY
                )
            }
        }
    }

    // MARK: - A11y list fallback

    private var a11yListFallback: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                Text("Connections")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .accessibilityAddTraits(.isHeader)
                ForEach(edges) { edge in
                    edgeRow(edge: edge)
                }
            }
            .padding(.horizontal, 22)
            .padding(.vertical, DesignTokens.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 180)
    }

    private func edgeRow(edge: ConceptMapEdge) -> some View {
        let fromLabel = labelByNodeId[edge.from] ?? edge.from
        let toLabel   = labelByNodeId[edge.to]   ?? edge.to
        let relation  = edge.label ?? "is connected to"
        return HStack(alignment: .top, spacing: 6) {
            Text("•").font(.caption.weight(.bold)).foregroundColor(.secondary)
            Text("\(fromLabel) ").font(.caption.weight(.semibold))
                + Text(relation).font(.caption.italic()).foregroundColor(.secondary)
                + Text(" \(toLabel)").font(.caption.weight(.semibold))
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(fromLabel) \(relation) \(toLabel)")
    }

    // MARK: - Gestures + actions

    private func zoomIn() {
        withAnimationRespectingReduceMotion(.easeOut(duration: 0.18)) {
            zoom = min(2.5, zoom * 1.2)
        }
    }
    private func zoomOut() {
        withAnimationRespectingReduceMotion(.easeOut(duration: 0.18)) {
            zoom = max(0.4, zoom / 1.2)
        }
    }
    private func resetView() {
        withAnimationRespectingReduceMotion(.easeOut(duration: 0.22)) {
            zoom = 1.0
            pan = .zero
        }
    }

    private func handleNodeTap(_ node: ConceptMapNode) {
        // Defer nav.push so SwiftUI's render commit finishes before the
        // navigation push — same dismantle-order pattern as the other
        // ChapterDetail nav.push call sites.
        switch node.kind {
        case .concept:
            let packId = pack.id
            let conceptId = node.id
            DispatchQueue.main.async {
                nav.push(.concept(packId: packId, conceptId: conceptId))
                onDismiss()
            }
        case .crossChapter:
            // Cross-chapter id form: "chXX:<conceptId>"
            let parts = node.id.split(separator: ":", maxSplits: 1)
            guard parts.count == 2 else { return }
            let packId = pack.id
            let chId = String(parts[0])
            DispatchQueue.main.async {
                nav.push(.chapter(packId: packId, chapterId: chId))
                onDismiss()
            }
        case .pivot:
            // Pivots are decorative — no navigation.
            break
        }
    }
}

// MARK: - NodeChip

private struct NodeChip: View {
    let node: ConceptMapNode

    var body: some View {
        Text(node.label)
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(.primary)
            .lineLimit(2)
            .multilineTextAlignment(.center)
            .padding(.horizontal, DesignTokens.Spacing.sm)
            .padding(.vertical, 5)
            .frame(maxWidth: 130)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundFill)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(
                        borderColor,
                        style: StrokeStyle(
                            lineWidth: 1.5,
                            dash: node.kind == .crossChapter ? [3, 3] : []
                        )
                    )
            )
    }

    private var backgroundFill: Color {
        switch node.kind {
        case .concept:      return Color(NSColor.controlBackgroundColor)
        case .crossChapter: return Color.compatPurple.opacity(0.10)
        case .pivot:        return Color.compatIndigo.opacity(0.15)
        }
    }

    private var borderColor: Color {
        switch node.kind {
        case .concept:      return Color.compatIndigo.opacity(0.65)
        case .crossChapter: return Color.compatPurple.opacity(0.85)
        case .pivot:        return Color.compatIndigo.opacity(0.85)
        }
    }
}

// MARK: - EdgePath

private struct EdgePath: Shape {
    let from: CGPoint
    let to: CGPoint
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: from)
        p.addLine(to: to)
        return p
    }
}
