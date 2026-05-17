import SwiftUI

/// Scene 4 — Which Crop, Which Soil? Match 4 crops to their soil.
struct Scene4_WhichCropWhichSoil: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Pair: Identifiable { let id = UUID(); let crop: String; let soil: String }
    private let pairs: [Pair] = [
        Pair(crop: "🌾 Paddy (rice)",     soil: "Clayey"),
        Pair(crop: "🌶 Chilli / Vegetables", soil: "Loamy"),
        Pair(crop: "🥜 Groundnut",          soil: "Sandy"),
        Pair(crop: "🌿 Cotton",              soil: "Black soil"),
    ]
    private let options = ["Sandy", "Loamy", "Clayey", "Black soil"]
    @State private var picks: [UUID: String] = [:]

    private var done: Bool { picks.count == pairs.count }
    private var score: Int { pairs.reduce(0) { $0 + ((picks[$1.id] == $1.soil) ? 1 : 0) } }

    var body: some View {
        VStack(spacing: 12) {
            Text("Which Crop, Which Soil?").font(.largeTitle.bold()).padding(.top, 18)
            Text("Pick the best soil for each crop.").font(.callout).foregroundColor(.secondary)

            VStack(spacing: 10) {
                ForEach(pairs) { p in
                    HStack {
                        Text(p.crop).font(.headline).frame(width: 200, alignment: .leading)
                        Picker("", selection: Binding(
                            get: { picks[p.id] ?? "" },
                            set: { picks[p.id] = $0 }
                        )) {
                            Text("— pick —").tag("")
                            ForEach(options, id: \.self) { Text($0).tag($0) }
                        }
                        .pickerStyle(.menu).frame(width: 180)
                        if let v = picks[p.id], !v.isEmpty {
                            Image(systemName: v == p.soil ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(v == p.soil ? .green : .red)
                        }
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.06)))
                }
            }
            .frame(maxWidth: 560)

            if done {
                Text("Score: \(score) / \(pairs.count)").font(.title3.bold()).foregroundColor(Color.compatIndigo)
            }

            SoftShadowCard(padding: 14) {
                Text("Paddy needs standing water → clayey. Cotton thrives on mineral-rich black soil. Groundnut loves loose sandy soil. Most vegetables do best on balanced loam.")
                    .font(.callout).lineSpacing(4)
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            if done { GotItButton { onComplete(score) }.padding(.bottom, 12) }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
