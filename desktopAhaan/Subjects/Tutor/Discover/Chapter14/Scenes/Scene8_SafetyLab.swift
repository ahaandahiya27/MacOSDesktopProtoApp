import SwiftUI

/// Scene 8 — Safety Lab. Pick safe vs unsafe — 5 scenarios.
struct Scene8_SafetyLab: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Item: Identifiable { let id = UUID(); let text: String; let isSafe: Bool }
    private let items: [Item] = [
        Item(text: "Use a rubber-handled screwdriver when working with switches", isSafe: true),
        Item(text: "Touch a plug with wet hands",                                 isSafe: false),
        Item(text: "Replace a blown fuse with thicker wire",                       isSafe: false),
        Item(text: "Use earthing in metal appliances",                             isSafe: true),
        Item(text: "Hang clothes on the live wire",                                isSafe: false),
    ]
    @State private var picks: [UUID: Bool] = [:]

    private var done: Bool { picks.count == items.count }
    private var score: Int { items.reduce(0) { $0 + ((picks[$1.id] == $1.isSafe) ? 1 : 0) } }

    var body: some View {
        VStack(spacing: 12) {
            Text("Safety Lab").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Tap Safe or Unsafe for each action.")
                .font(.callout).foregroundColor(.secondary)

            VStack(spacing: 10) {
                ForEach(items) { item in
                    HStack {
                        Text(item.text).frame(maxWidth: .infinity, alignment: .leading)
                        Button("Safe")  { picks[item.id] = true  }.accentColor(picks[item.id] == true ? .green : .gray)
                        Button("Unsafe"){ picks[item.id] = false }.accentColor(picks[item.id] == false ? .red : .gray)
                        if let p = picks[item.id] {
                            Image(systemName: p == item.isSafe ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(p == item.isSafe ? .green : .red)
                        }
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.06)))
                }
            }
            .frame(maxWidth: 680).padding(.horizontal, 24)

            if done {
                Text("Score: \(score) / \(items.count)").font(.title3.bold()).foregroundColor(Color.compatIndigo)
            }

            LookingAheadCallout(
                title: "Class 10 Physics + ITI",
                detail: "Class 10 covers home wiring — live (red), neutral (black), earth (green/yellow); 3-pin plugs; MCBs and ELCBs. Industrial Training (ITI / polytechnic) takes this further into wiring codes and load calculation. JEE rarely asks safety directly but tests power-supply problems."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Three-pin plug inspection",
                detail: "Examine an unplugged 3-pin Indian plug. The two thinner pins are LIVE (right) and NEUTRAL (left). The thicker top pin is EARTH — it's longer so it connects first. The plastic body is insulator. Total safety in one design."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            if done { GotItButton { onComplete(score) }.padding(.bottom, 12) }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
