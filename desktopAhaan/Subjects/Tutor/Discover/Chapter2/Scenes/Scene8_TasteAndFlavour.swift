import SwiftUI

/// Scene 8 — Taste & Flavour.
///
/// Top: stylised tongue with 5 colour-coded zones (sweet/salty/sour/bitter/umami).
/// Bottom: 4 food cards. "Pinch nose" toggle shows the same foods reduce to
/// "Sweet + Watery" when smell is blocked — demonstrating 90% of flavour is smell.
/// Text from ch02_t03_c03.
@available(macOS 12, *)
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
                .frame(maxWidth: 640)

                GotItButton { onComplete() }
                    .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}

// MARK: - Tongue View

@available(macOS 12, *)
struct TongueView: View {
    var body: some View {
        Canvas { context, _ in
            let centerX: CGFloat = 200
            let centerY: CGFloat = 70

            // Tongue outline
            var tonguePath = Path()
            tonguePath.move(to: CGPoint(x: centerX, y: centerY - 50))
            tonguePath.addCurve(
                to: CGPoint(x: centerX, y: centerY + 40),
                control1: CGPoint(x: centerX - 40, y: centerY),
                control2: CGPoint(x: centerX - 40, y: centerY + 30)
            )
            tonguePath.addCurve(
                to: CGPoint(x: centerX, y: centerY - 50),
                control1: CGPoint(x: centerX + 40, y: centerY + 30),
                control2: CGPoint(x: centerX + 40, y: centerY)
            )

            context.fill(tonguePath, with: .color(.pink.opacity(0.3)))
            context.stroke(tonguePath, with: .color(.pink.opacity(0.6)), lineWidth: 2)

            // Taste zones with labels
            let zones: [(String, String, CGFloat, CGFloat, Color)] = [
                ("SWEET", "🟡", centerX, centerY - 35, .yellow),
                ("SALTY", "🟢", centerX - 30, centerY - 10, .green),
                ("SOUR", "🔵", centerX + 30, centerY - 10, .blue),
                ("BITTER", "🟣", centerX - 25, centerY + 20, .purple),
                ("UMAMI", "🔴", centerX + 25, centerY + 20, .red)
            ]

            for (_, _, x, y, color) in zones {
                // Zone circle
                context.fill(
                    Path(ellipseIn: CGRect(x: x - 15, y: y - 15, width: 30, height: 30)),
                    with: .color(color.opacity(0.4))
                )

                // Label text (simple)
                context.drawLayer { ctx in
                    // We can't directly draw text, so we'll use emoji as indicator
                }
            }
        }
    }
}

// MARK: - Food Card

@available(macOS 12, *)
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
