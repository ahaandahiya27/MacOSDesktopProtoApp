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
        VStack(spacing: 14) {
            Text("Land Breeze, Sea Breeze").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Pick Day or Night. Which way does the breeze blow?")
                .font(.callout).foregroundColor(.secondary)

            Picker("", selection: $time) {
                ForEach(TimeOfDay.allCases) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented)
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

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
