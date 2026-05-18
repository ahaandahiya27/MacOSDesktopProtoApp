import SwiftUI

/// Scene 3 — Blood Sort. Match 4 components to their jobs.
struct Scene3_BloodSort: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Pair: Identifiable { let id = UUID(); let part: String; let job: String }
    private let pairs: [Pair] = [
        Pair(part: "🔴 RBC (Red blood cells)",   job: "Carry oxygen"),
        Pair(part: "⚪ WBC (White blood cells)", job: "Fight germs"),
        Pair(part: "🩸 Platelets",                job: "Help blood clot"),
        Pair(part: "💧 Plasma",                    job: "Carry food, hormones, waste"),
    ]
    private let options = ["Carry oxygen", "Fight germs", "Help blood clot", "Carry food, hormones, waste"]
    @State private var picks: [UUID: String] = [:]

    private var done: Bool { picks.count == pairs.count }
    private var score: Int { pairs.reduce(0) { $0 + ((picks[$1.id] == $1.job) ? 1 : 0) } }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    VStack(spacing: 12) {
                Text("Blood Components").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Each component has a different job. Match them up.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                VStack(spacing: 10) {
                    ForEach(pairs) { p in
                        HStack {
                            Text(p.part).font(.headline).frame(width: 240, alignment: .leading)
                            Picker("", selection: Binding(
                                get: { picks[p.id] ?? "" },
                                set: { picks[p.id] = $0 }
                            )) {
                                Text("— pick —").tag("")
                                ForEach(options, id: \.self) { Text($0).tag($0) }
                            }
                            .pickerStyle(.menu).frame(width: 240)
                            if let v = picks[p.id], !v.isEmpty {
                                Image(systemName: v == p.job ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(v == p.job ? .green : .red)
                            }
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.95)))
                    }
                }
                .frame(maxWidth: 600)

                if done {
                    Text("Score: \(score) / \(pairs.count)").font(.title3.bold()).foregroundColor(Color.compatIndigo)
                }

                SoftShadowCard(padding: 14) {
                    Text("Blood is part cells (RBC, WBC, platelets) and part fluid (plasma). Together they deliver oxygen and nutrients, fight infection, plug wounds and carry waste away.")
                        .font(.callout).lineSpacing(4)
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

                LookingAheadCallout(
                    title: "Class 12 Bio → NEET",
                    detail: "Class 12 'Body Fluids and Circulation' (plus Class 12 Health & Disease) covers ABO + Rh blood groups, blood typing for transfusions, haemophilia genetics, and the immune role of WBCs (B-cells, T-cells, antibodies). Blood-group genetics problems appear in nearly every NEET paper."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Microscope a blood smear",
                    detail: "Most school science labs have prepared blood-smear slides. Under a microscope you'll see tiny red dots (RBCs), an occasional larger irregular blob (WBC), and the smaller speckles (platelets) floating in plasma."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                if done { GotItButton { onComplete(score) }.padding(.bottom, 12) }
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
