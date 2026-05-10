import SwiftUI

/// A small identifier used by Scene 5's drag-and-drop game. The drag is
/// driven manually with `DragGesture` + offset (Scene 5 tracks zone rects via
/// GeometryReader), so we don't need `Transferable` / `.draggable`.
struct OrganismToken: Hashable, Identifiable {
    let id: String
    let emoji: String
    let label: String
    /// True if this organism makes its own food (autotroph).
    let isAutotroph: Bool
}

/// One floating organism card in the autotroph/heterotroph game. Tracks its
/// own "shake on wrong" animation and a "settled" state once it's been
/// dropped successfully.
struct DraggableCard: View {
    let token: OrganismToken
    var settled: Bool = false
    var shakeOffset: CGFloat = 0

    var body: some View {
        VStack(spacing: 4) {
            Text(token.emoji)
                .font(.system(size: 36))
                .accessibilityHidden(true)
            Text(token.label)
                .font(.callout.weight(.medium))
                .foregroundStyle(.primary)
        }
        .frame(width: 110, height: 96)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(nsColor: .windowBackgroundColor))
                .shadow(color: .black.opacity(settled ? 0.0 : 0.12), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(
                    settled ? Color.green.opacity(0.5) : Color.gray.opacity(0.2),
                    lineWidth: settled ? 2 : 1
                )
        )
        .opacity(settled ? 0.55 : 1)
        .offset(x: shakeOffset)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(token.label), \(token.isAutotroph ? "makes its own food" : "eats other things")")
    }
}
