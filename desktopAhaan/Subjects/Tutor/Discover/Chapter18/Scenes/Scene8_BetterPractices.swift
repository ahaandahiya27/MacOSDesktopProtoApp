import SwiftUI

/// Scene 8 — Better Practices. Mark each habit good or bad.
struct Scene8_BetterPractices: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Item: Identifiable { let id = UUID(); let text: String; let isGood: Bool }
    private let items: [Item] = [
        Item(text: "Pour cooking oil down the drain",     isGood: false),
        Item(text: "Compost vegetable peels at home",      isGood: true),
        Item(text: "Throw used diapers into the toilet",    isGood: false),
        Item(text: "Fix a leaking tap as soon as you see it", isGood: true),
        Item(text: "Wash car at car-wash that recycles water", isGood: true),
    ]
    @State private var picks: [UUID: Bool] = [:]

    private var done: Bool { picks.count == items.count }
    private var score: Int { items.reduce(0) { $0 + ((picks[$1.id] == $1.isGood) ? 1 : 0) } }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: DesignTokens.Spacing.md) {
                Text("Better Practices").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Pick Good or Bad for each habit.").font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                VStack(spacing: 10) {
                    ForEach(items) { item in
                        HStack {
                            Text(item.text).frame(maxWidth: .infinity, alignment: .leading)
                            Button("Good") { picks[item.id] = true  }.accentColor(picks[item.id] == true ? .green : .gray)
                            Button("Bad")  { picks[item.id] = false }.accentColor(picks[item.id] == false ? .red   : .gray)
                            if let p = picks[item.id] {
                                Image(systemName: p == item.isGood ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(p == item.isGood ? .green : .red)
                            }
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.md).fill(Color.white.opacity(0.95)))
                    }
                }
                .frame(maxWidth: 680).padding(.horizontal, DesignTokens.Spacing.xl)

                if done {
                    Text("Score: \(score) / \(items.count)").font(.title3.bold()).foregroundColor(Color.compatIndigo)
                }

                LookingAheadCallout(
                    title: "Class 12 Bio + Civics",
                    detail: "Class 12 'Environmental Issues' covers how people and policy respond to pollution. Class 10 Civics covers India's environmental law. This includes the Polluter Pays principle. It also covers the EPA 1986 and the National Green Tribunal."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                TryAtHomeCallout(
                    title: "One-week waste diary",
                    detail: "Track everything that goes down your drains and into your trash for one week. List patterns. Pick ONE thing to change next week — usually cooking oil, sanitary waste, or single-use plastic. Small habits compound."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                if done { GotItButton { onComplete(score) }.padding(.bottom, DesignTokens.Spacing.md) }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }
}
