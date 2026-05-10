import SwiftUI

/// A 3D flip card. Tap to rotate around the Y axis and reveal the back.
/// Tap again to flip back.
struct FlipCard<Front: View, Back: View>: View {
    let frontEmoji: String
    let frontTitle: String
    let frontSubtitle: String
    @ViewBuilder var back: () -> Back
    /// Optional custom front view. If nil, a default emoji + title front is used.
    var customFront: (() -> Front)? = nil

    @State private var isFlipped = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(
        frontEmoji: String,
        frontTitle: String,
        frontSubtitle: String,
        @ViewBuilder back: @escaping () -> Back
    ) where Front == EmptyView {
        self.frontEmoji = frontEmoji
        self.frontTitle = frontTitle
        self.frontSubtitle = frontSubtitle
        self.back = back
        self.customFront = nil
    }

    var body: some View {
        ZStack {
            frontFace
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(
                    .degrees(isFlipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
            backFace
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(
                    .degrees(isFlipped ? 0 : -180),
                    axis: (x: 0, y: 1, z: 0)
                )
        }
        .frame(width: 220, height: 300)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(reduceMotion ? .none : .spring(response: 0.55, dampingFraction: 0.78)) {
                isFlipped.toggle()
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel("\(frontTitle). \(frontSubtitle). Activate to flip.")
    }

    private var frontFace: some View {
        VStack(spacing: 12) {
            Text(frontEmoji)
                .font(.system(size: 88))
                .accessibilityHidden(true)
            Text(frontTitle)
                .font(.title2.bold())
            Text(frontSubtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
            Spacer(minLength: 0)
            Label("Tap to flip", systemImage: "hand.tap")
                .font(.caption)
                .foregroundStyle(.indigo)
                .padding(.bottom, 12)
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [.white, Color(red: 0.96, green: 0.99, blue: 0.92)],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .shadow(color: .black.opacity(0.12), radius: 14, x: 0, y: 6)
        )
    }

    private var backFace: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(frontEmoji)
                    .font(.title)
                Text(frontTitle)
                    .font(.title3.bold())
                Spacer()
            }
            Divider()
            back()
                .font(.callout)
            Spacer(minLength: 0)
            Label("Tap to flip back", systemImage: "arrow.uturn.left")
                .font(.caption)
                .foregroundStyle(.indigo)
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(red: 0.97, green: 0.97, blue: 1.0))
                .shadow(color: .black.opacity(0.12), radius: 14, x: 0, y: 6)
        )
    }
}
