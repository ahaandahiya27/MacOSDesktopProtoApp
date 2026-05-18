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
        VStack(spacing: 14) {
            Text("Cyclone Eye").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
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
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
