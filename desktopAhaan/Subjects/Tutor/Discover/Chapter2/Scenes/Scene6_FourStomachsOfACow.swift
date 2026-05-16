import SwiftUI

/// Scene 6 — The Four-Stomach Cow Tour.
///
/// A side-view cow with 4 internal chambers. A grass icon travels chamber by chamber
/// as the kid taps "Next chamber". At each step, a callout describes what happens.
/// At the end, a thought bubble answers "Why don't humans have four stomachs?"
/// Text from ch02_t02_c01. A "Watch again" button restarts the tour.
@available(macOS 12, *)
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
        GeometryReader { geo in
            VStack(spacing: 16) {
                Text("The Four-Stomach Cow Tour")
                    .font(.title.bold())
                    .foregroundColor(.brown)

                ZStack {
                    CowDiagram(currentChamber: currentChamber, foodPosition: foodPosition)
                        .frame(height: 200)

                    if currentChamber <= 3 {
                        Text("🌾")
                            .font(.system(size: 32))
                            .position(x: 100 + foodPosition * 100, y: 100)
                    }
                }
                .padding(.horizontal, 24)

                HStack {
                    if currentChamber > 0 {
                        Button(action: { previousChamber() }) {
                            Label("Previous", systemImage: "chevron.left")
                        }
                        
                    }

                    Spacer()

                    if currentChamber < 4 {
                        Button(action: { nextChamber() }) {
                            Label("Next Chamber", systemImage: "chevron.right")
                        }
                        
                        .accentColor(.brown)
                    } else {
                        Button(action: { reset() }) {
                            Label("Watch Again", systemImage: "arrow.clockwise")
                        }
                        
                        .accentColor(.brown)
                    }
                }
                .padding(.horizontal, 24)

                if currentChamber < 4 {
                    ChamberCallout(text: chamberDescriptions[currentChamber])
                        .padding(.horizontal, 24)
                } else {
                    SoftShadowCard(padding: 14) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("🤔 Why don't humans have four stomachs?")
                                .font(.body.weight(.semibold))
                                .foregroundColor(.brown)
                            Text("We eat softer, easier-to-digest foods like cooked meat & plants. Cows need four stomachs because grass is tough and takes time to break down with bacteria.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineSpacing(3)
                        }
                    }
                    .padding(.horizontal, 24)
                }

                Spacer()

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("The Four-Stomach Cow Tour", systemImage: "hare.fill")
                            .font(.title2.bold())
                            .foregroundColor(.brown)
                        Text(cowExplanation)
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
        withAnimation(.easeInOut(duration: 0.4)) {
            currentChamber = 0
            foodPosition = 0
        }
    }
}

// MARK: - Cow Diagram

@available(macOS 12, *)
struct CowDiagram: View {
    let currentChamber: Int
    let foodPosition: CGFloat

    var body: some View {
        Canvas { context, _ in
            // Cow body (simplified side view)
            let bodyPath = Path(ellipseIn: CGRect(x: 30, y: 50, width: 100, height: 60))
            context.stroke(bodyPath, with: .color(.brown.opacity(0.4)), lineWidth: 2)

            // Head
            context.fill(
                Path(ellipseIn: CGRect(x: 130, y: 60, width: 30, height: 25)),
                with: .color(.brown.opacity(0.3))
            )

            // Four stomach chambers (drawn as nested rectangles)
            let chambers = [
                CGRect(x: 50, y: 65, width: 30, height: 20),
                CGRect(x: 85, y: 65, width: 25, height: 20),
                CGRect(x: 115, y: 65, width: 20, height: 20),
                CGRect(x: 140, y: 65, width: 18, height: 20)
            ]

            for (i, rect) in chambers.enumerated() {
                let isActive = i <= currentChamber
                let color: Color = isActive ? .green : .gray
                context.stroke(
                    Path(roundedRect: rect, cornerRadius: 3),
                    with: .color(color.opacity(isActive ? 0.6 : 0.2)),
                    lineWidth: isActive ? 2 : 1
                )

                let label: String
                switch i {
                case 0: label = "R"
                case 1: label = "Re"
                case 2: label = "O"
                default: label = "A"
                }
                context.draw(
                    Text(label).font(.system(size: 8, weight: .bold))
                        .foregroundColor(color),
                    at: CGPoint(x: rect.midX, y: rect.midY)
                )
            }

            // Legs (simple lines)
            for x in [60, 80, 100, 120] {
                var legPath = Path()
                legPath.move(to: CGPoint(x: x, y: 110))
                legPath.addLine(to: CGPoint(x: x, y: 135))
                context.stroke(legPath, with: .color(.brown.opacity(0.5)), lineWidth: 2)
            }
        }
    }
}

// MARK: - Chamber Callout

@available(macOS 12, *)
struct ChamberCallout: View {
    let text: String

    var body: some View {
        SoftShadowCard(padding: 14) {
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
                .lineSpacing(3)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .transition(.scale.combined(with: .opacity))
    }
}
