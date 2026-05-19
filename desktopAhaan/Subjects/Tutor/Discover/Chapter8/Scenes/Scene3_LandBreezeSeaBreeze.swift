import SwiftUI

/// Scene 3 — Land Breeze, Sea Breeze. Toggle between day and night; arrows
/// show which way the breeze blows because land heats and cools faster than water.
struct Scene3_LandBreezeSeaBreeze: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    enum TimeOfDay: String, CaseIterable, Identifiable {
        case day = "Day"
        case night = "Night"
        var id: String { rawValue }
    }

    @State private var time: TimeOfDay = .day

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    LazyVStack(alignment: .center, spacing: 14) {
                Text("Land Breeze, Sea Breeze").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Pick Day or Night. Which way does the breeze blow?")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                Picker("", selection: $time) {
                    ForEach(TimeOfDay.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented).discoverControlChrome()
                .frame(maxWidth: 280)

                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(time == .day ? Color.yellow.opacity(0.12) : Color.compatIndigo.opacity(0.18))
                        .frame(width: 460, height: 240)

                    HStack(spacing: 0) {
                        ZStack {
                            Rectangle().fill(Color.compatBrown.opacity(0.4))
                            Text("🏝 Land").font(.headline)
                        }
                        ZStack {
                            Rectangle().fill(Color.blue.opacity(0.4))
                            Text("🌊 Sea").font(.headline)
                        }
                    }
                    .frame(width: 460, height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                    Text(time == .day ? "→ Sea Breeze" : "← Land Breeze")
                        .font(.title2.bold())
                        .padding(8)
                        .background(Capsule().fill(Color.white.opacity(0.85)))
                        .offset(y: -90)
                }

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Land heats and cools faster than water", systemImage: "thermometer.sun")
                            .font(.title2.bold())
                        Text("By day, land is warmer → air over land rises → cool sea air rushes in (sea breeze). By night, land cools faster → air over the sea is warmer → air flows from land to sea (land breeze).")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                LookingAheadCallout(
                    title: "Class 9 Geography",
                    detail: "Class 9 Geography expands this into the Indian monsoon — a continent-scale land-sea breeze driven by the same uneven heating but operating over 6 months instead of 12 hours. NCERT covers the monsoon's role in agriculture and the SW vs NE monsoon mechanism."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Hand-on-window test",
                    detail: "On a hot afternoon, place one hand on a closed window facing the sun, another on the floor under it. The window glass is warmer than the floor. At night the reverse is true. Same uneven-heating mechanism, just smaller scale."
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
