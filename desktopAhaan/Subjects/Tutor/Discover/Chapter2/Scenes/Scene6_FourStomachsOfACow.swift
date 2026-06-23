import SwiftUI

/// Scene 6 — The Four-Stomach Cow Tour.
///
/// A side-view cow with 4 internal chambers. A grass icon travels chamber by chamber
/// as the kid taps "Next chamber". At each step, a callout describes what happens.
/// At the end, a thought bubble answers "Why don't humans have four stomachs?"
/// Text from ch02_t02_c01. A "Watch again" button restarts the tour.
///
/// Big Sur (macOS 11) compatible — CowDiagram now uses Shape/Ellipse/Path
/// views instead of a SwiftUI Canvas.
struct Scene6_FourStomachsOfACow: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var currentChamber: Int = 0
    @State private var foodPosition: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var cowExplanation: String {
        pack.conceptIndex["ch02_t02_c01"]?.explanation(at: .kidFriendly)
            ?? "Cows have four stomachs to digest tough grass. Different chambers do different jobs: mixing, breaking down, squeezing, and final digestion."
    }

    private var chamberDescriptions: [String] {
        [
            "🐄 Rumen — stores & mixes grass with bacteria",
            "🔄 Reticulum — softens the grass",
            "⚙️ Omasum — squeezes out water",
            "🧬 Abomasum — final digestion with acid & enzymes"
        ]
    }

    var body: some View {

        ScrollView {

            VStack(spacing: 14) {
                Text("The Four-Stomach Cow Tour")
                    .font(.title.bold())
                    .foregroundColor(Color.compatBrown)

                ZStack {
                    CowDiagram(currentChamber: currentChamber, foodPosition: foodPosition)
                        .frame(height: 200)

                    if currentChamber <= 3 {
                        let foodX: CGFloat = 100 + foodPosition * 100
                        Text("🌾")
                            .font(.system(size: 32))
                            .position(x: foodX, y: 100)
                    }
                }
                .padding(.horizontal, DesignTokens.Spacing.xl)

                HStack {
                    if currentChamber > 0 {
                        Button(action: { previousChamber() }) {
                            Label("Previous", systemImage: "chevron.left")
                        }
                        
                    }

                    if currentChamber < 4 {
                        Button(action: { nextChamber() }) {
                            Label("Next Chamber", systemImage: "chevron.right")
                        }
                        
                        .accentColor(Color.compatBrown)
                    } else {
                        Button(action: { reset() }) {
                            Label("Watch Again", systemImage: "arrow.clockwise")
                        }
                        
                        .accentColor(Color.compatBrown)
                    }
                }
                .padding(.horizontal, DesignTokens.Spacing.xl)

                if currentChamber < 4 {
                    ChamberCallout(text: chamberDescriptions[currentChamber])
                        .padding(.horizontal, DesignTokens.Spacing.xl)
                } else {
                    SoftShadowCard(padding: 14) {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            Text("🤔 Why don't humans have four stomachs?")
                                .font(.body.weight(.semibold))
                                .foregroundColor(Color.compatBrown)
                            Text("We eat softer, easier-to-digest foods like cooked meat & plants. Cows need four stomachs because grass is tough and takes time to break down with bacteria.")
                                .font(.body)
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                                .lineSpacing(3)
                        }
                    }
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                }

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        Label("The Four-Stomach Cow Tour", systemImage: SFSymbolCompat.name("hare.fill"))
                            .font(.title2.bold())
                            .foregroundColor(Color.compatBrown)
                        Text(cowExplanation)
                            .font(.body)
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                            .lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth)

                LookingAheadCallout(
                    title: "Class 11 / NEET — Cellulose digestion",
                    detail: "Humans can't digest cellulose (no enzyme). Cows can't either — but the bacteria + protozoa in the rumen CAN, and they live there for free. The cow eats grass; microbes eat the cellulose; cow eats the microbes (kind of). NEET tests this as 'mutualism with rumen microbiota' and pairs it with termite-gut symbionts and Rhizobium-root nodules from Ch 1."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                TryAtHomeCallout(
                    title: "Spot the cud",
                    detail: "Next time you see a cow lying down peacefully, watch its jaw. It'll be moving in circles even when no food is in sight. That's it ruminating — pulling food back up from the rumen for a second chew. Time the chews — 50-70 per minute is typical. You're watching four-stomach digestion live."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                GotItButton { onComplete() }
                    .padding(.bottom, DesignTokens.Spacing.md)
            

            }

            .frame(maxWidth: .infinity)

            .padding(.bottom, DesignTokens.Spacing.md)

        }
    }

    private func nextChamber() {
        if currentChamber < 4 {
            withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.6)) {
                currentChamber += 1
                foodPosition = min(1.0, foodPosition + 0.25)
            }
        }
    }

    private func previousChamber() {
        if currentChamber > 0 {
            withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.6)) {
                currentChamber -= 1
                foodPosition = max(0.0, foodPosition - 0.25)
            }
        }
    }

    private func reset() {
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.4)) {
            currentChamber = 0
            foodPosition = 0
        }
    }
}

// MARK: - Cow Diagram

/// Side-view cow with four stomach chambers. Rewritten from `Canvas`
/// (macOS 12+) to a `ZStack` of standard SwiftUI shapes so it renders
/// on Big Sur. Geometry coordinates are kept identical to the old
/// Canvas version.
struct CowDiagram: View {
    let currentChamber: Int
    let foodPosition: CGFloat

    private let chambers: [CGRect] = [
        CGRect(x: 50, y: 65, width: 30, height: 20),
        CGRect(x: 85, y: 65, width: 25, height: 20),
        CGRect(x: 115, y: 65, width: 20, height: 20),
        CGRect(x: 140, y: 65, width: 18, height: 20)
    ]
    private let chamberLabels = ["R", "Re", "O", "A"]
    private let legXs: [CGFloat] = [60, 80, 100, 120]

    var body: some View {
        let bodyX: CGFloat = 30 + 50
        let bodyY: CGFloat = 50 + 30
        let headX: CGFloat = 130 + 15
        let headY: CGFloat = 60 + 12.5
        return ZStack {
            // Cow body (outlined ellipse)
            Ellipse()
                .stroke(Color.compatBrown.opacity(0.4), lineWidth: 2)
                .frame(width: 100, height: 60)
                .position(x: bodyX, y: bodyY)

            // Head (filled ellipse)
            Ellipse()
                .fill(Color.compatBrown.opacity(0.3))
                .frame(width: 30, height: 25)
                .position(x: headX, y: headY)

            // Four stomach chambers
            ForEach(0..<chambers.count, id: \.self) { i in
                chamberView(at: i)
            }

            // Legs
            ForEach(legXs, id: \.self) { x in
                Path { p in
                    p.move(to: CGPoint(x: x, y: 110))
                    p.addLine(to: CGPoint(x: x, y: 135))
                }
                .stroke(Color.compatBrown.opacity(0.5), lineWidth: 2)
            }
        }
    }

    @ViewBuilder
    private func chamberView(at i: Int) -> some View {
        let rect = chambers[i]
        let isActive = i <= currentChamber
        let color: Color = isActive ? .green : .gray
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .stroke(color.opacity(isActive ? 0.6 : 0.2),
                        lineWidth: isActive ? 2 : 1)
            Text(chamberLabels[i])
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(color)
        }
        .frame(width: rect.width, height: rect.height)
        .position(x: rect.midX, y: rect.midY)
    }
}

// MARK: - Chamber Callout

struct ChamberCallout: View {
    let text: String

    var body: some View {
        SoftShadowCard(padding: 14) {
            Text(text)
                .font(.body)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .lineSpacing(3)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .transition(.opacity)  // Big Sur: combined transitions can render-loop
    }
}
