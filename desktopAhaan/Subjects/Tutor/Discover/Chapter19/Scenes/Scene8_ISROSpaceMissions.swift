import SwiftUI

/// Scene 8 — ISRO Space Missions.
/// Four Indian space mission cards side by side. Tap each for details.
/// After all 4 explored, show GotIt.

struct Scene8_ISROSpaceMissions: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var selectedMission: Int? = nil
    @State private var explored: Set<Int> = []
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private struct SpaceMission: Identifiable {
        let id: Int
        let name: String
        let year: String
        let symbol: String
        let color: Color
        let tagline: String
        let facts: [String]
    }

    private let missions: [SpaceMission] = [
        SpaceMission(
            id: 0,
            name: "Chandrayaan-1",
            year: "2008",
            symbol: "moon.fill",
            color: Color.compatIndigo,
            tagline: "India's First Lunar Mission",
            facts: [
                "India\u{2019}s first mission to the Moon, launched on 22 October 2008.",
                "Carried the Moon Impact Probe (MIP) that was deliberately crashed into the lunar surface.",
                "Discovered water molecules (H\u{2082}O) on the Moon\u{2019}s surface \u{2014} a breakthrough finding confirmed by NASA\u{2019}s instrument aboard.",
                "Operated for 312 days and mapped the Moon in great detail."
            ]
        ),
        SpaceMission(
            id: 1,
            name: "Chandrayaan-3",
            year: "2023",
            symbol: "moon.fill",
            color: Color.compatTeal,
            tagline: "Soft Landing near Lunar South Pole",
            facts: [
                "Successfully soft-landed on the Moon on 23 August 2023, making India the 4th country to achieve this.",
                "First-ever landing near the lunar south pole, a region no other country had reached.",
                "The Pragyan rover rolled out and studied lunar soil composition for 14 days.",
                "Confirmed presence of sulphur and other elements in the south-polar regolith."
            ]
        ),
        SpaceMission(
            id: 2,
            name: "Aditya-L1",
            year: "2023",
            symbol: "sun.max.fill",
            color: .orange,
            tagline: "India's First Solar Observatory",
            facts: [
                "India\u{2019}s first space-based mission dedicated to studying the Sun.",
                "Placed in a halo orbit around the L1 Lagrange point, about 1.5 million km from Earth.",
                "From L1, it can observe the Sun continuously without any eclipses or occultation.",
                "Studies the Sun\u{2019}s corona, solar wind, and coronal mass ejections that affect Earth."
            ]
        ),
        SpaceMission(
            id: 3,
            name: "Mangalyaan",
            year: "2013",
            symbol: "globe.americas.fill",
            color: .red,
            tagline: "Mars Orbiter Mission",
            facts: [
                "India\u{2019}s Mars Orbiter Mission, launched on 5 November 2013.",
                "India became the first country to reach Mars orbit on its very first attempt.",
                "Achieved at a cost of about \u{20B9}450 crore \u{2014} less than the budget of many Hollywood films!",
                "Carried five scientific instruments to study Mars\u{2019} surface, atmosphere and mineral composition."
            ]
        )
    ]

    private var allExplored: Bool { explored.count == missions.count }

    var body: some View {
        GeometryReader { _ in
            ZStack {
                VStack(spacing: 14) {
                    Text("ISRO Space Missions")
                        .font(.title2.bold())
                        .padding(.top, 14)

                    Text("\(explored.count) / \(missions.count) missions explored")
                        .font(.caption.weight(.medium))
                        .foregroundColor(.secondary)

                    // Space backdrop
                    ZStack {
                        LinearGradient(
                            colors: [
                                Color(red: 0.02, green: 0.02, blue: 0.1),
                                Color(red: 0.0, green: 0.0, blue: 0.05)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )

                        // Stars
                        ForEach(0..<25, id: \.self) { i in
                            Circle()
                                .fill(.white.opacity(Double.random(in: 0.3...0.9)))
                                .frame(width: CGFloat.random(in: 1.5...3))
                                .offset(
                                    x: CGFloat.random(in: -240...240),
                                    y: CGFloat.random(in: -40...40)
                                )
                        }

                        // ISRO label
                        Text("ISRO")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.15))
                    }
                    .frame(maxWidth: 540, maxHeight: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(.gray.opacity(0.2), lineWidth: 1)
                    )

                    // Mission cards
                    HStack(spacing: 14) {
                        ForEach(missions) { mission in
                            let isSelected = selectedMission == mission.id
                            let isExplored = explored.contains(mission.id)

                            Button {
                                withAnimation(reduceMotion ? .none : .spring()) {
                                    selectedMission = mission.id
                                    explored.insert(mission.id)
                                }
                            } label: {
                                VStack(spacing: 6) {
                                    Image(systemName: mission.symbol)
                                        .font(.title2)
                                        .foregroundColor(isSelected ? .white : mission.color)
                                    Text(mission.name)
                                        .font(.caption.weight(.bold))
                                        .foregroundColor(isSelected ? .white : .primary)
                                        .multilineTextAlignment(.center)
                                    Text(mission.year)
                                        .font(.caption2.weight(.medium))
                                        .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                                    if isExplored {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.caption2)
                                            .foregroundColor(isSelected ? .white : .green)
                                    }
                                }
                                .frame(width: 115, height: 110)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(isSelected ? mission.color : Color(NSColor.windowBackgroundColor))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .strokeBorder(isExplored ? .green.opacity(0.4) : .gray.opacity(0.2), lineWidth: 1.5)
                                )
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("\(mission.name) \(mission.year). \(isExplored ? "Explored" : "Tap to explore")")
                        }
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)

                VStack(spacing: 14) {
                    Spacer()

                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            if let idx = selectedMission,
                               let mission = missions.first(where: { $0.id == idx }) {
                                HStack(spacing: 8) {
                                    Image(systemName: mission.symbol)
                                        .font(.title2)
                                        .foregroundColor(mission.color)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(mission.name)
                                            .font(.title2.bold())
                                        Text("\(mission.tagline) (\(mission.year))")
                                            .font(.subheadline.weight(.medium))
                                            .foregroundColor(.secondary)
                                    }
                                }

                                ForEach(mission.facts, id: \.self) { fact in
                                    HStack(alignment: .top, spacing: 6) {
                                        Image(systemName: "arrow.right.circle.fill")
                                            .font(.caption2)
                                            .foregroundColor(mission.color.opacity(0.7))
                                            .padding(.top, 3)
                                        Text(fact)
                                            .font(.callout)
                                            .foregroundColor(.secondary)
                                            .lineSpacing(3)
                                    }
                                }
                            } else {
                                Label("Indian Space Exploration", systemImage: "airplane")
                                    .font(.title2.bold())
                                    .foregroundColor(Color.compatIndigo)
                                Text("India\u{2019}s space agency ISRO has achieved remarkable milestones \u{2014} from discovering water on the Moon to reaching Mars on the first try. Tap each mission card to explore these proud achievements!")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    LookingAheadCallout(
                        title: "Class 11 / 12 Physics → JEE / ISRO entrance",
                        detail: "ISRO's missions are JEE Physics live-action: Chandrayaan-3 used a gravity-assist trajectory (saves fuel). Mangalyaan reached Mars using only 75 kg of fuel — cheapest interplanetary mission ever. Aditya-L1 sits at Lagrangian point L1 (gravitational equilibrium between Earth + Sun, the maths is a JEE Advanced problem). Future Gaganyaan crewed missions and Chandrayaan-4 sample-return will keep extending the curriculum's reach into the real world."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    TryAtHomeCallout(
                        title: "Watch the next ISRO launch live",
                        detail: "ISRO live-streams every launch from Sriharikota on YouTube (channel: ISRO Official). The countdown commentary explains pad, payload, orbit, separation timings in real-time. After launch, the satellite track is on isro.gov.in. Watching a launch is the most exciting introduction to Class 11/12 mechanics + thermodynamics + materials science a kid can have."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    if allExplored {
                        GotItButton { onComplete() }
                            .padding(.bottom, 12)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)
            }
        }
    }
}
