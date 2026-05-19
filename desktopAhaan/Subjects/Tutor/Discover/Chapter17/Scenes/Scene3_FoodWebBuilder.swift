import SwiftUI

/// Scene 3 — Food Web Builder. Tap each link to add it. The diagram fades in
/// the connected creatures so the web grows as the kid builds it.
struct Scene3_FoodWebBuilder: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var arrows: Set<String> = []
    private let edges = ["🌱→🐰", "🌱→🦌", "🐰→🦊", "🦌→🐅", "🦊→🦅"]

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    LazyVStack(alignment: .center, spacing: 12) {
                Text("Food Web Builder").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Tap each link to add it to the web. Energy flows from plants up.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary).multilineTextAlignment(.center)

                HStack(alignment: .center, spacing: 28) {
                    VStack(spacing: 18) {
                        Text("🌱").font(.system(size: 44))
                        Text("Plants").font(.caption)
                    }
                    VStack(spacing: 18) {
                        Text("🐰").font(.system(size: 40)).opacity(arrows.contains("🌱→🐰") ? 1.0 : 0.25)
                        Text("🦌").font(.system(size: 40)).opacity(arrows.contains("🌱→🦌") ? 1.0 : 0.25)
                    }
                    VStack(spacing: 12) {
                        Text("🦊").font(.system(size: 38)).opacity(arrows.contains("🐰→🦊") ? 1.0 : 0.25)
                        Text("🐅").font(.system(size: 38)).opacity(arrows.contains("🦌→🐅") ? 1.0 : 0.25)
                        Text("🦅").font(.system(size: 38)).opacity(arrows.contains("🦊→🦅") ? 1.0 : 0.25)
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: arrows)

                VStack(spacing: 6) {
                    ForEach(edges, id: \.self) { e in
                        Button(arrows.contains(e) ? "✅ \(e)" : "Add link: \(e)") {
                            if arrows.contains(e) { arrows.remove(e) } else { arrows.insert(e) }
                        }
                        .accentColor(arrows.contains(e) ? .green : Color.compatIndigo)
                    }
                }

                SoftShadowCard(padding: 14) {
                    Text("A food web is a tangled set of food chains. If a top predator is removed, prey populations explode, plants get over-grazed, and the whole forest changes.")
                        .font(.callout).lineSpacing(4)
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

                LookingAheadCallout(
                    title: "Class 12 Bio → NEET",
                    detail: "Class 12 'Ecosystem' covers food chains, food webs, and the 10% rule of energy transfer (only ~10% of energy at each trophic level reaches the next). NEET asks energy-pyramid calculations and the difference between detritus and grazing food chains."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Garden food web",
                    detail: "Sit in a park or garden for 10 minutes with paper. List everything alive you spot: grass, ants, beetles, sparrows, crows, dog. Draw arrows showing 'eats': grass → ant → spider → sparrow. You've drawn a food chain. Combine three of them and you get a food web."
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
