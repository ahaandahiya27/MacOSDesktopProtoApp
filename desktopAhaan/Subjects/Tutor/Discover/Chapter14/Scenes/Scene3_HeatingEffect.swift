import SwiftUI

/// Scene 3 — Heating Effect. Slider for current; nichrome wire glows red.
struct Scene3_HeatingEffect: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var current: Double = 0

    private var glowColor: Color {
        if current < 2 { return Color.gray.opacity(0.5) }
        if current < 5 { return Color.orange }
        return Color.red
    }
    private var glowLabel: String {
        if current < 2 { return "Cool" }
        if current < 5 { return "Warm" }
        if current < 8 { return "Hot — orange glow" }
        return "Very hot — red glow"
    }

    var body: some View {
        VStack(spacing: 14) {
            Text("Heating Effect").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Current flowing through a wire heats it up.").font(.callout).foregroundColor(.secondary)

            ZStack {
                Capsule().fill(glowColor.opacity(0.3))
                    .frame(width: 280, height: 12)
                Capsule().fill(glowColor)
                    .frame(width: 280, height: 6)
            }
            .shadow(color: glowColor.opacity(current / 10), radius: CGFloat(current * 2))

            Text("Current: \(String(format: "%.1f", current)) A — \(glowLabel)")
                .font(.headline).foregroundColor(glowColor)

            Slider(value: $current, in: 0...10, step: 0.1).frame(maxWidth: 460).padding(.horizontal, 24)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Why electric heaters work", systemImage: "flame.fill")
                        .font(.title2.bold())
                    Text("Resistance turns electrical energy into heat. Nichrome wire has high resistance — perfect for heaters, toasters, irons and fuses. The more current that flows, the hotter it gets.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
