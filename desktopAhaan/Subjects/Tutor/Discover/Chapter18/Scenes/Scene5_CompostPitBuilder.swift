import SwiftUI

/// Scene 5 — Compost Pit Builder. Add layers, watch waste turn into compost.
struct Scene5_CompostPitBuilder: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var greens = false
    @State private var browns = false
    @State private var moisture = false
    @State private var weeks: Double = 0

    private var ready: Bool { greens && browns && moisture && weeks >= 6 }

    var body: some View {
        VStack(spacing: 14) {
            Text("Compost Pit Builder").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Add greens, browns, moisture — then wait 6+ weeks.")
                .font(.callout).foregroundColor(.secondary)

            ZStack {
                RoundedRectangle(cornerRadius: 16).fill(Color.compatBrown.opacity(0.3))
                    .frame(width: 240, height: 180)
                VStack(spacing: 4) {
                    if greens   { Text("🥬").font(.system(size: 30)) }
                    if browns   { Text("🍂").font(.system(size: 30)) }
                    if moisture { Text("💧").font(.system(size: 30)) }
                    if ready    { Text("🟫 Compost ready!").font(.headline).foregroundColor(.green) }
                }
            }

            VStack(spacing: 8) {
                Toggle("Add kitchen greens", isOn: $greens)
                Toggle("Add dry browns (leaves)", isOn: $browns)
                Toggle("Add a sprinkle of water", isOn: $moisture)
                HStack { Text("Time: \(Int(weeks)) weeks"); Spacer(); Slider(value: $weeks, in: 0...12, step: 1).frame(width: 200) }
            }
            .frame(maxWidth: 460).padding(.horizontal, 24)

            SoftShadowCard(padding: 14) {
                Text("Half of household waste is organic. Composting at home (or in a community pit) turns kitchen scraps into rich, dark soil — no truck or treatment plant needed.")
                    .font(.callout).lineSpacing(4)
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
