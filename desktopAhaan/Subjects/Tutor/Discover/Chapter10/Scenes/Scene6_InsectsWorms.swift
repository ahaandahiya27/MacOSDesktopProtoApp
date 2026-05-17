import SwiftUI

/// Scene 6 — How Insects & Worms Breathe. Tap each creature to learn its trick.
struct Scene6_InsectsWorms: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    enum Creature: String, CaseIterable, Identifiable {
        case cockroach = "Cockroach"
        case earthworm = "Earthworm"
        case frog = "Frog"
        var id: String { rawValue }
        var emoji: String {
            switch self { case .cockroach: return "🪳"; case .earthworm: return "🪱"; case .frog: return "🐸" }
        }
        var organ: String {
            switch self {
            case .cockroach: return "Tracheae through spiracles — tiny tubes carry air directly to cells."
            case .earthworm: return "Moist skin — oxygen dissolves and diffuses straight into the blood."
            case .frog:      return "Lungs on land, moist skin in water — switches between both!"
            }
        }
    }

    @State private var pick: Creature = .cockroach

    var body: some View {
        VStack(spacing: 14) {
            Text("How Insects & Worms Breathe").font(.largeTitle.bold()).padding(.top, 18)
            Text("Each species solved \"how to get oxygen\" differently.")
                .font(.callout).foregroundColor(.secondary)

            Picker("", selection: $pick) {
                ForEach(Creature.allCases) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented).frame(maxWidth: 380)

            ZStack {
                RoundedRectangle(cornerRadius: 18).fill(Color.green.opacity(0.10))
                    .frame(width: 320, height: 220)
                VStack(spacing: 6) {
                    Text(pick.emoji).font(.system(size: 80))
                    Text(pick.rawValue).font(.title3.bold())
                }
            }

            SoftShadowCard(padding: 18) {
                Text(pick.organ).font(.body).lineSpacing(4)
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
