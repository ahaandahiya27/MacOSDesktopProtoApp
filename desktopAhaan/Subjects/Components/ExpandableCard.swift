import SwiftUI

struct ExpandableCard<Content: View>: View {
    @Binding var isExpanded: Bool
    let systemImage: String
    let title: String
    var tint: Color = Color.compatIndigo
    var background: Color = Color.gray.opacity(0.10)
    @ViewBuilder var content: () -> Content

    @State private var isHovered = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.22)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundColor(tint)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))

                    Image(systemName: systemImage)
                        .foregroundColor(tint)
                        .font(.body)

                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Spacer(minLength: 0)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(isHovered ? background.opacity(1.4) : background)
                )
            }
            .buttonStyle(.plain)
            .onHover { hovering in isHovered = hovering }
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isButton)
            .accessibilityHint(isExpanded ? "Collapse \(title)" : "Expand \(title)")

            if isExpanded {
                content()
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .transition(.opacity)  // Big Sur: combined-with-.move can render-loop
            }
        }
    }
}
