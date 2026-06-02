import SwiftUI

/// Scene 3 — Self vs Cross Pollination. Toggle and see the difference.
struct Scene3_SelfVsCross: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    enum Mode: String, CaseIterable, Identifiable { case selfP = "Self", crossP = "Cross"; var id: String { rawValue } }
    @State private var mode: Mode = .selfP

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("Self vs Cross Pollination").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Same flower or two different ones?").font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                Picker("", selection: $mode) {
                    ForEach(Mode.allCases) { Text($0.rawValue).tag($0) }
                }.pickerStyle(.segmented).discoverControlChrome().frame(maxWidth: 280)

                ZStack {
                    RoundedRectangle(cornerRadius: 18).fill(Color.pink.opacity(0.10))
                        .frame(width: 380, height: 220)
                    HStack(spacing: 40) {
                        Text("🌷").font(.system(size: 80))
                        if mode == .selfP {
                            Image(systemName: "arrow.uturn.right")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(Color.compatIndigo)
                        } else {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(Color.compatIndigo)
                            Text("🌷").font(.system(size: 80))
                        }
                    }
                }

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label(mode == .selfP ? "Self-pollination" : "Cross-pollination",
                              systemImage: "leaf.fill")
                            .font(.title2.bold())
                        Text(mode == .selfP
                             ? "Pollen lands on the stigma of the SAME flower (or another flower of the same plant). Reliable, but creates identical offspring — no variety."
                             : "Pollen travels from one plant to another of the same species. Creates genetic variety — better at adapting to changes and disease.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

                LookingAheadCallout(
                    title: "Class 12 Bio → NEET",
                    detail: "Class 12 covers what this does to the genes. Self-pollination lowers variety; Mendel used it to breed pure-line pea plants. Cross-pollination keeps variety. This trade-off is a long-time NEET favourite."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Bag a flower bud",
                    detail: "Choose an unopened flower bud on a plant. Tie a paper bag over it before it opens. Open the bag a week later — if it has formed seeds without any pollinator visit, it self-pollinated."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                GotItButton { onComplete() }.padding(.bottom, 12)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
