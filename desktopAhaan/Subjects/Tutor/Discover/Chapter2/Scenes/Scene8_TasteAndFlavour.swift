import SwiftUI

/// Scene 8 — Taste & Flavour.
///
/// Top: stylised tongue with 5 colour-coded zones (sweet/salty/sour/bitter/umami).
/// Bottom: 4 food cards. "Pinch nose" toggle shows the same foods reduce to
/// "Sweet + Watery" when smell is blocked — demonstrating 90% of flavour is smell.
/// Text from ch02_t03_c03.
///
/// Big Sur (macOS 11) compatible — TongueView replaces its Canvas with a
/// custom TongueShape + ZStack of Circle taste zones.
struct Scene8_TasteAndFlavour: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var nosePressed = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var flavourExplanation: String {
        pack.conceptIndex["ch02_t03_c03"]?.explanation(at: .kidFriendly)
            ?? "Most of what you call 'taste' is actually smell! Your tongue only detects sweet, salty, sour, bitter, and umami. The rest comes from your nose."
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 16) {
                Text("Taste & Flavour")
                    .font(.title.bold())
                    .foregroundColor(.red)

                TongueView()
                    .frame(height: 140)
                    .padding(.horizontal, 24)

                HStack {
                    Toggle("Pinch Nose", isOn: $nosePressed)
                        .font(.body)
                        .padding(.horizontal, 24)
                    Spacer()
                    if nosePressed {
                        Text("Smell blocked!")
                            .font(.caption)
                            .foregroundColor(.orange)
                            .padding(.horizontal, 24)
                    }
                }

                // Food cards
                HStack(spacing: 12) {
                    FoodCard(food: "apple", flavour: nosePressed ? "Sweet + Watery" : "Apple")
                    FoodCard(food: "onion", flavour: nosePressed ? "Sweet + Watery" : "Onion")
                    FoodCard(food: "strawberry", flavour: nosePressed ? "Sweet + Watery" : "Strawberry")
                    FoodCard(food: "mango", flavour: nosePressed ? "Sweet + Watery" : "Mango")
                }
                .padding(.horizontal, 24)

                Spacer()

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Taste & Flavour", systemImage: "nose.fill")
                            .font(.title2.bold())
                            .foregroundColor(.red)
                        Text(flavourExplanation)
                            .font(.body)
                            .foregroundColor(.primary)
                            .lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth)

                GotItButton { onComplete() }
                    .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}

// MARK: - Tongue View

/// Tongue with five colour-coded taste zones. Rewritten from `Canvas` to
/// a `ZStack` of a custom `TongueShape` + `Circle` zone markers so the
/// scene renders on Big Sur. Geometry matches the old Canvas version.
struct TongueView: View {
    private let centerX: CGFloat = 200
    private let centerY: CGFloat = 70

    /// (label, x, y, fill colour) tuples for the five taste zones.
    private var zones: [(String, CGFloat, CGFloat, Color)] {
        [
            ("SWEET",  centerX,      centerY - 35, .yellow),
            ("SALTY",  centerX - 30, centerY - 10, .green),
            ("SOUR",   centerX + 30, centerY - 10, .blue),
            ("BITTER", centerX - 25, centerY + 20, .purple),
            ("UMAMI",  centerX + 25, centerY + 20, .red)
        ]
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Pink tongue silhouette.
            TongueShape(centerX: centerX, centerY: centerY)
                .fill(Color.pink.opacity(0.3))
            TongueShape(centerX: centerX, centerY: centerY)
                .stroke(Color.pink.opacity(0.6), lineWidth: 2)

            // Five round taste zones.
            ForEach(0..<zones.count, id: \.self) { i in
                let z = zones[i]
                Circle()
                    .fill(z.3.opacity(0.4))
                    .frame(width: 30, height: 30)
                    .position(x: z.1, y: z.2)
            }
        }
    }
}

/// Tongue silhouette path — extracted so fill + stroke can layer.
struct TongueShape: Shape {
    let centerX: CGFloat
    let centerY: CGFloat

    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: centerX, y: centerY - 50))
        p.addCurve(
            to: CGPoint(x: centerX, y: centerY + 40),
            control1: CGPoint(x: centerX - 40, y: centerY),
            control2: CGPoint(x: centerX - 40, y: centerY + 30)
        )
        p.addCurve(
            to: CGPoint(x: centerX, y: centerY - 50),
            control1: CGPoint(x: centerX + 40, y: centerY + 30),
            control2: CGPoint(x: centerX + 40, y: centerY)
        )
        return p
    }
}

// MARK: - Food Card

struct FoodCard: View {
    let food: String
    let flavour: String

    var body: some View {
        VStack(spacing: 8) {
            Text(foodEmoji(food))
                .font(.system(size: 28))

            Text(flavour)
                .font(.caption2.weight(.semibold))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(6)
        .transition(.scale)
    }

    private func foodEmoji(_ name: String) -> String {
        switch name {
        case "apple": return "🍎"
        case "onion": return "🧅"
        case "strawberry": return "🍓"
        case "mango": return "🥭"
        default: return "🍴"
        }
    }
}
