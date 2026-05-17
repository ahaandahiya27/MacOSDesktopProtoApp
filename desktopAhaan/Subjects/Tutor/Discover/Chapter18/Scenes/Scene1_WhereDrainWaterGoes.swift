import SwiftUI

/// Scene 1 — Where Drain Water Goes. Follow the pipe from sink to treatment plant.
struct Scene1_WhereDrainWaterGoes: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var step: Int = 0
    private let path = ["🚿 Sink / toilet", "🚰 House drain", "🕳 Sewer pipe", "🏭 Wastewater plant", "🌊 Clean → river"]

    var body: some View {
        VStack(spacing: 14) {
            Text("Where Does Drain Water Go?").font(.largeTitle.bold()).padding(.top, 18)
            Text("Tap Next to follow the journey from your tap to the river.")
                .font(.callout).foregroundColor(.secondary)

            VStack(spacing: 8) {
                ForEach(0..<path.count, id: \.self) { i in
                    HStack {
                        Text(path[i]).font(.headline)
                            .foregroundColor(i <= step ? Color.compatIndigo : .secondary)
                        Spacer()
                        if i <= step { Image(systemName: "drop.fill").foregroundColor(.blue) }
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.06)))
                }
            }
            .frame(maxWidth: 480)

            HStack(spacing: 14) {
                Button("Next step") { step = min(step + 1, path.count - 1) }.accentColor(Color.compatIndigo)
                Button("Reset") { step = 0 }
            }

            SoftShadowCard(padding: 14) {
                Text("Wastewater (or sewage) is the dirty water from kitchens, bathrooms and industries. It travels through underground sewer pipes to a treatment plant before being returned to rivers or the sea.")
                    .font(.callout).lineSpacing(4)
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
