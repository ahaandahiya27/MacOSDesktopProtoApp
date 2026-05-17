import SwiftUI

/// Scene 6 — Bawdi (Stepwell). Drag the slider to descend into the stepwell.
struct Scene6_BawdiStepwell: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var depth: Double = 0

    var body: some View {
        VStack(spacing: 14) {
            Text("Bawdi — the Stepwell").font(.largeTitle.bold()).padding(.top, 18)
            Text("Ancient Indian water architecture. Slide down to the cool depths.")
                .font(.callout).foregroundColor(.secondary).multilineTextAlignment(.center)

            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 16).fill(Color.compatBrown.opacity(0.4))
                    .frame(width: 220, height: 260)
                VStack(spacing: 8) {
                    Text("☀️").font(.system(size: 24))
                    ForEach(0..<6, id: \.self) { _ in
                        Rectangle().fill(Color.compatBrown).frame(width: 160, height: 10)
                    }
                    Rectangle().fill(Color.blue.opacity(0.7)).frame(width: 140, height: 24)
                }
                Text("🚶").font(.system(size: 30)).offset(y: CGFloat(depth) * 200)
            }

            Text("Depth: \(Int(depth * 30)) m").font(.headline).foregroundColor(Color.compatIndigo)
            Slider(value: $depth, in: 0...1).frame(maxWidth: 460).padding(.horizontal, 24)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Genius of dry-region India", systemImage: "building.columns")
                        .font(.title2.bold())
                    Text("Bawdis (stepwells) like Chand Baori and Rani Ki Vav let villagers walk down to the water table even in the driest months. Some are 9 storeys deep — magnificent works of architecture that also stored monsoon runoff.")
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
