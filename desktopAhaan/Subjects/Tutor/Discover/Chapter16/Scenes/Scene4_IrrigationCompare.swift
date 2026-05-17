import SwiftUI

/// Scene 4 — Irrigation Comparison. Rank 3 methods by efficiency.
struct Scene4_IrrigationCompare: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Method: Identifiable { let id = UUID(); let name: String; let efficiency: String }
    private let methods: [Method] = [
        Method(name: "💧 Drip irrigation",        efficiency: "Most efficient"),
        Method(name: "🌧 Sprinkler irrigation",   efficiency: "Medium efficient"),
        Method(name: "🌊 Flood irrigation",       efficiency: "Least efficient"),
    ]
    private let options = ["Most efficient", "Medium efficient", "Least efficient"]
    @State private var picks: [UUID: String] = [:]

    private var done: Bool { picks.count == methods.count }
    private var score: Int { methods.reduce(0) { $0 + ((picks[$1.id] == $1.efficiency) ? 1 : 0) } }

    var body: some View {
        VStack(spacing: 12) {
            Text("Drip, Sprinkler or Flood?").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Rank these irrigation methods by water efficiency.")
                .font(.callout).foregroundColor(.secondary)

            VStack(spacing: 10) {
                ForEach(methods) { m in
                    HStack {
                        Text(m.name).font(.headline).frame(maxWidth: .infinity, alignment: .leading)
                        Picker("", selection: Binding(
                            get: { picks[m.id] ?? "" }, set: { picks[m.id] = $0 }
                        )) {
                            Text("— pick —").tag("")
                            ForEach(options, id: \.self) { Text($0).tag($0) }
                        }.pickerStyle(.menu).frame(width: 180)
                        if let v = picks[m.id], !v.isEmpty {
                            Image(systemName: v == m.efficiency ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(v == m.efficiency ? .green : .red)
                        }
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.06)))
                }
            }
            .frame(maxWidth: 620).padding(.horizontal, 24)

            if done {
                Text("Score: \(score) / \(methods.count)").font(.title3.bold()).foregroundColor(Color.compatIndigo)
            }

            SoftShadowCard(padding: 14) {
                Text("Drip puts water exactly at the root, evaporates almost nothing. Sprinklers spray over a wider area but lose ~30% to evaporation. Flood irrigation soaks the whole field — easiest, but wastes the most.")
                    .font(.callout).lineSpacing(4)
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 10 Geography",
                detail: "Class 10 'Agriculture' covers irrigation in India — major canal systems (Indira Gandhi, Bhakra-Nangal), tank irrigation in TN, and the drip-irrigation revolution in arid Rajasthan and Gujarat. Asked in CBSE board exams."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            if done { GotItButton { onComplete(score) }.padding(.bottom, 12) }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
