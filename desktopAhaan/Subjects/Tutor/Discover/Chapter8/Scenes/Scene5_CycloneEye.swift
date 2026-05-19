import SwiftUI

/// Scene 5 — Cyclone Eye. A spinning spiral with a calm centre; slider for
/// wind speed labels the cyclone category.
struct Scene5_CycloneEye: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var speed: Double = 90
    @State private var rotation: Double = 0
    @State private var tick: TimeInterval = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var category: String {
        switch speed {
        case ..<63:  return "Tropical depression"
        case ..<89:  return "Tropical storm"
        case ..<118: return "Cyclone"
        case ..<166: return "Severe cyclone"
        default:     return "Super cyclone"
        }
    }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    LazyVStack(alignment: .center, spacing: 14) {
                Text("Cyclone Eye").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Drag the wind-speed slider. The eye stays calm; the bands around it whip faster.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary).multilineTextAlignment(.center)

                ZStack {
                    ForEach(0..<5, id: \.self) { i in
                        Circle()
                            .strokeBorder(Color.compatIndigo.opacity(0.5 - Double(i) * 0.08), lineWidth: 6)
                            .frame(width: CGFloat(60 + i * 50), height: CGFloat(60 + i * 50))
                    }
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                        .overlay(Text("Eye").font(.caption.bold()))
                }
                .frame(width: 320, height: 320)
                .rotationEffect(.degrees(rotation))
                .onChange(of: tick) { _ in
                    guard !reduceMotion else { return }
                    rotation = (rotation + speed * 0.05).truncatingRemainder(dividingBy: 360)
                }
                .timedScene(idealFPS: 30, tick: $tick)

                Text("\(Int(speed)) km/h — \(category)")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(Color.compatIndigo)

                Slider(value: $speed, in: 30...220, step: 1)
                    .frame(maxWidth: 460)
                    .padding(.horizontal, 24)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Calm centre, violent ring", systemImage: "hurricane")
                            .font(.title2.bold())
                        Text("A cyclone is a low-pressure storm where air spirals inwards. The eye in the middle is strangely still — but the wall of clouds around it carries the fastest, most destructive winds.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                // Grouped so the outer VStack stays within Swift 5.5's
                // 10-child ViewBuilder limit (Xcode 13.2.1 / Big Sur target).
                Group {
                    HotspotDiagram(
                        title: "Anatomy of a cyclone — tap each ring",
                        baseSymbol: "hurricane",
                        baseColor: Color.compatIndigo,
                        hotspots: [
                            .init(x: 0.50, y: 0.50, label: "The Eye",
                                  detail: "30–60 km across in a big cyclone. Wind speeds drop to almost zero; clear skies. Air is sinking here, so clouds evaporate."),
                            .init(x: 0.50, y: 0.30, label: "Eye Wall",
                                  detail: "Just outside the eye — the most violent ring. Wall of tall thunderstorms with the cyclone's strongest winds and heaviest rain."),
                            .init(x: 0.20, y: 0.50, label: "Rain Bands (outer)",
                                  detail: "Spiral arms of rain extending hundreds of kilometres out. They carry the bulk of the cyclone's water, dropping it as you near the eye."),
                            .init(x: 0.80, y: 0.50, label: "Inflow",
                                  detail: "Warm, moist surface air is sucked inward toward the low-pressure centre, feeding the storm."),
                            .init(x: 0.50, y: 0.85, label: "Outflow (top)",
                                  detail: "At the cyclone's roof (~15 km up), the air spreads outward — the engine that lets new moist air keep flowing in below.")
                        ]
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)

                    LookingAheadCallout(
                        title: "Class 11 Physics → JEE",
                        detail: "In Class 11 Physics you'll meet the Coriolis force — the rotating-frame effect that decides which way a cyclone spins (counter-clockwise in the Northern Hemisphere, clockwise in the Southern). JEE rarely asks cyclones directly, but Coriolis problems on rotating reference frames are standard."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)

                    TryAtHomeCallout(
                        title: "Glass-of-water cyclone",
                        detail: "Stir a tall glass of water vigorously with a spoon, then pull the spoon out. A miniature 'eye' forms in the middle — the same low-pressure column that exists inside a real cyclone, just made of water instead of air."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)

                    GotItButton { onComplete() }.padding(.bottom, 12)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
