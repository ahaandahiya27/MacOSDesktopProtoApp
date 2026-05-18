import SwiftUI

/// Scene 7 — Mirrors in Real Life. Match 3 uses to mirror types.
struct Scene7_MirrorsInRealLife: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Item: Identifiable { let id = UUID(); let use: String; let answer: String }
    private let items: [Item] = [
        Item(use: "🚗 Car side mirror (wide view of traffic)", answer: "Convex"),
        Item(use: "🪞 Dentist's tiny mirror (magnified tooth)",  answer: "Concave"),
        Item(use: "🛁 Bathroom mirror",                         answer: "Plane"),
    ]
    private let options = ["Plane", "Concave", "Convex"]
    @State private var picks: [UUID: String] = [:]

    private var done: Bool { picks.count == items.count }
    private var score: Int { items.reduce(0) { $0 + ((picks[$1.id] == $1.answer) ? 1 : 0) } }

    var body: some View {
        VStack(spacing: 12) {
            Text("Mirrors in Real Life").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Which type of mirror is used in each case?")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

            VStack(spacing: 10) {
                ForEach(items) { item in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.use).font(.body)
                        HStack(spacing: 8) {
                            ForEach(options, id: \.self) { opt in
                                Button(opt) { picks[item.id] = opt }
                                    .accentColor(picks[item.id] == opt ? Color.compatIndigo : .gray)
                            }
                            if let p = picks[item.id] {
                                Image(systemName: p == item.answer ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(p == item.answer ? .green : .red)
                            }
                        }
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.95)))
                }
            }
            .frame(maxWidth: 640).padding(.horizontal, 24)

            if done {
                Text("Score: \(score) / \(items.count)").font(.title3.bold()).foregroundColor(Color.compatIndigo)
            }

            LookingAheadCallout(
                title: "Class 10 / JEE Optics",
                detail: "Class 10 Light: 'Spherical Mirrors and Image Formation' covers the same use-cases formally — concave for shaving + headlight + telescope, convex for vehicle mirrors. Class 12 / JEE adds the silvering process and front-surface vs back-surface mirrors."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Mirror inventory",
                detail: "List every mirror in your home, then guess what type each is: bathroom plane mirror, shaving concave mirror (if any), car side-view convex mirror, decorative reflectors. Note which one makes you look bigger / smaller / same-size."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            if done { GotItButton { onComplete(score) }.padding(.bottom, 12) }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
