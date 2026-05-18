import SwiftUI

/// Scene 2 — Water Table Slider. Rainfall vs extraction — table goes up or down.
struct Scene2_WaterTableSlider: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var rain: Double = 5
    @State private var extract: Double = 5

    private var level: Double { 100 + (rain - extract) * 6 }
    private var dryWell: Bool { level <= 0 }

    var body: some View {
        VStack(spacing: 14) {
            Text("Water Table Slider").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Move the two sliders. Watch the underground water level rise and fall.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary).multilineTextAlignment(.center)

            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 12).fill(Color(red: 0.45, green: 0.3, blue: 0.15))
                    .frame(width: 320, height: 220)
                Rectangle().fill(Color.blue.opacity(0.7))
                    .frame(width: 320, height: max(0, min(220, CGFloat(level))))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                Text(dryWell ? "⚠️ Dry well!" : "Water table")
                    .font(.caption.bold())
                    .foregroundColor(dryWell ? .white : .black)
                    .padding(4)
                    .background(Capsule().fill(dryWell ? Color.red.opacity(0.85) : Color.white.opacity(0.9)))
                    .offset(y: -max(0, min(220, CGFloat(level))) - 6)
            }

            VStack {
                HStack { Text("☔ Rainfall"); Spacer(); Text(String(format: "%.0f", rain)) }.frame(maxWidth: 460)
                Slider(value: $rain, in: 0...10, step: 1).frame(maxWidth: 460)
                HStack { Text("🚰 Extraction (pumps)"); Spacer(); Text(String(format: "%.0f", extract)) }.frame(maxWidth: 460)
                Slider(value: $extract, in: 0...10, step: 1).frame(maxWidth: 460)
            }
            .padding(.horizontal, 24)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Use it slower than it refills", systemImage: "arrow.down.to.line")
                        .font(.title2.bold())
                    Text("The water table is the level of water hidden under the ground. Rain seeps down and tops it up; pumps suck it out. If we extract faster than rain replenishes, wells go dry and the table drops.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 10 Geography",
                detail: "Class 10 'Resources and Development' covers groundwater depletion across India — Punjab, Haryana, Tamil Nadu's worst-affected regions. NCERT Geography asks about CGWB (Central Ground Water Board) monitoring data."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Water table in a clear jar",
                detail: "Fill a clear jar half-way with sand. Slowly pour water in. Watch the water rise from the bottom — the boundary between dry and wet sand IS the water table. Pour more water and it rises; tilt the jar and one side's table drops."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
