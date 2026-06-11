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
        // A real Button (plain style preserves the card's appearance) so the
        // card is flippable by keyboard (Tab + Space/Return) and VoiceOver,
        // not just by tap. Safe because every FlipCard call site supplies a
        // non-interactive `back()` (Text/bullets) — no nested controls that a
        // Button wrap would shadow.
        Button {
            withAnimation(reduceMotion ? .none : .spring(response: 0.55, dampingFraction: 0.78)) {
                isFlipped.toggle()
            }
        } label: {
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
            // Default sized to fit emoji + title + subtitle + "Tap to flip"
            // hint on the front, and 3-4 facts on the back. Callers can
            // override with their own `.frame(...)` but smaller than ~220×280
            // will crop (Scene2_MeetTheWoolAnimals previously used 200×220 →
            // "Wool Source" subtitle got cropped; now matches 220×300).
            .frame(width: 220, height: 300)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(frontTitle). \(frontSubtitle). Activate to flip.")
        .accessibilityHint("Flips the card to reveal the back side")
    }

    private var frontFace: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Text(frontEmoji)
                .font(.system(size: 88))
                .accessibilityHidden(true)
            Text(frontTitle)
                .font(.title2.bold())
            Text(frontSubtitle)
                .font(.subheadline)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DesignTokens.Spacing.md)
            Spacer(minLength: 0)
            Label("Tap to flip", systemImage: SFSymbolCompat.name("hand.tap"))
                .font(.caption)
                .foregroundColor(Color.compatIndigo)
                .padding(.bottom, DesignTokens.Spacing.md)
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
                .foregroundColor(Color.compatIndigo)
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
