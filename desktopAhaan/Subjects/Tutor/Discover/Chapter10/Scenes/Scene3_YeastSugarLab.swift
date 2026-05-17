import SwiftUI

/// Scene 3 — Yeast & Sugar Lab. Tap "Add yeast", balloon inflates with CO₂.
struct Scene3_YeastSugarLab: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var added = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 14) {
            Text("Yeast & Sugar Lab").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Sugar + warm water + yeast → CO₂. Watch the balloon inflate.")
                .font(.callout).foregroundColor(.secondary).multilineTextAlignment(.center)

            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 18).fill(Color.yellow.opacity(0.10))
                    .frame(width: 320, height: 320)

                VStack(spacing: 4) {
                    Text("🎈").font(.system(size: added ? 96 : 40))
                        .animation(reduceMotion ? .none : .easeInOut(duration: 1.6), value: added)
                        .accessibilityLabel(added ? "Balloon inflated by yeast CO2" : "Empty balloon")
                    Text("🧪").font(.system(size: 64))
                }
                .padding(.top, 16)
            }

            Button(added ? "Reset" : "Add yeast 🧫") { added.toggle() }
                .accentColor(Color.compatIndigo)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Anaerobic respiration in action", systemImage: "wand.and.stars")
                        .font(.title2.bold())
                    Text("Yeast cells eat sugar without oxygen, producing alcohol and carbon dioxide. The CO₂ inflates the balloon. This is how bread rises and how wine is made.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Make a yeast balloon",
                detail: "In an empty plastic bottle: 1 tsp dry yeast + 1 tsp sugar + warm (not hot) water. Stretch a balloon over the neck. In 15 to 30 minutes the balloon inflates as yeast produces CO₂."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
