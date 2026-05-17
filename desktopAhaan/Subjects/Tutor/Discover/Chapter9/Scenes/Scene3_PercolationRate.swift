import SwiftUI

/// Scene 3 — Percolation Rate Lab. Pick a soil; water sinks faster or slower.
struct Scene3_PercolationRate: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    enum Soil: String, CaseIterable, Identifiable {
        case sandy = "Sandy"
        case loamy = "Loamy"
        case clayey = "Clayey"
        var id: String { rawValue }
        var rate: Double {
            switch self { case .sandy: return 30; case .loamy: return 15; case .clayey: return 4 }
        }
        var color: Color {
            switch self { case .sandy: return .yellow; case .loamy: return Color.compatBrown; case .clayey: return .gray }
        }
    }

    @State private var soil: Soil = .loamy
    @State private var pouring = false
    @State private var fillFraction: CGFloat = 0
    @State private var runID: UUID = UUID()
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Cap animation to 5 s so clayey doesn't feel broken (was 15 s).
    private var animationDuration: Double {
        let raw = 60.0 / soil.rate
        return min(raw, 5.0)
    }

    var body: some View {
        VStack(spacing: 14) {
            Text("Percolation Rate").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Pour the same amount of water. How fast does it sink through?").font(.callout).foregroundColor(.secondary)

            Picker("", selection: $soil) {
                ForEach(Soil.allCases) { Text($0.rawValue).tag($0) }
            }.pickerStyle(.segmented).frame(maxWidth: 360)

            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 14).fill(Color.gray.opacity(0.15))
                    .frame(width: 200, height: 260)
                Rectangle().fill(soil.color.opacity(0.55))
                    .frame(width: 200, height: fillFraction * 260)
                    .animation(reduceMotion ? .none : .easeInOut(duration: animationDuration), value: fillFraction)
            }
            .clipShape(RoundedRectangle(cornerRadius: 14))

            Button(pouring ? "Pouring…" : "Pour 200 ml") {
                pouring = true
                fillFraction = 0
                let token = UUID()
                runID = token
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    guard token == runID else { return }
                    fillFraction = 1.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration + 0.2) {
                        guard token == runID else { return }
                        pouring = false
                    }
                }
            }
            .accentColor(Color.compatIndigo)
            .disabled(pouring)

            Text("\(soil.rawValue) percolation rate: \(Int(soil.rate)) ml/min")
                .font(.headline)
                .foregroundColor(Color.compatIndigo)

            SoftShadowCard(padding: 14) {
                Text("Percolation = how fast water seeps down. Sandy soils drain fast (low water holding). Clayey soils drain slowly (waterlogged). Loamy soils are in between — ideal for most crops.")
                    .font(.callout).lineSpacing(4)
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Three-cup race",
                detail: "Get three plastic cups; punch the same number of holes in the bottoms. Fill one with sand, one with garden soil, one with clay-rich mud. Pour the same amount of water in each and time how fast it drains."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onDisappear { runID = UUID() }
    }
}
