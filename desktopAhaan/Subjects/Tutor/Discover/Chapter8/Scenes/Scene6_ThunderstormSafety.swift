import SwiftUI

/// Scene 6 — Thunderstorm Safety. Six actions: tap Safe/Unsafe. Score out of 6.
struct Scene6_ThunderstormSafety: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Action: Identifiable {
        let id = UUID()
        let text: String
        let isSafe: Bool
    }

    @State private var items: [Action] = [
        Action(text: "Shelter inside a pucca building", isSafe: true),
        Action(text: "Stand under a tall tree", isSafe: false),
        Action(text: "Stay in an open field with an umbrella", isSafe: false),
        Action(text: "Crouch low if you're in the open", isSafe: true),
        Action(text: "Keep away from metal poles & wires", isSafe: true),
        Action(text: "Take a shower or bath during the storm", isSafe: false),
    ]
    @State private var answers: [UUID: Bool] = [:]

    private var done: Bool { answers.count == items.count }
    private var score: Int { items.reduce(0) { $0 + ((answers[$1.id] == $1.isSafe) ? 1 : 0) } }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    VStack(spacing: 12) {
                Text("Thunderstorm Safety").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Tap Safe or Unsafe for each action.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                VStack(spacing: 8) {
                    ForEach(items) { item in
                        HStack {
                            Text(item.text).frame(maxWidth: .infinity, alignment: .leading)
                            Button("Safe")  { answers[item.id] = true  }
                                .disabled(answers[item.id] != nil)
                                .accentColor(answers[item.id] == true ? .green : .gray)
                            Button("Unsafe"){ answers[item.id] = false }
                                .disabled(answers[item.id] != nil)
                                .accentColor(answers[item.id] == false ? .red : .gray)
                            if let chosen = answers[item.id] {
                                Image(systemName: chosen == item.isSafe ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(chosen == item.isSafe ? .green : .red)
                            }
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.95)))
                    }
                }
                .frame(maxWidth: 620)
                .padding(.horizontal, 24)

                if done {
                    Text("Score: \(score) / \(items.count)")
                        .font(.title3.bold())
                        .foregroundColor(Color.compatIndigo)
                }

                SoftShadowCard(padding: 14) {
                    Text("Lightning takes the easiest path to the ground — tall trees, metal poles, and even plumbing pipes conduct it. Crouching low and keeping away from conductors keeps you safer.")
                        .font(.callout).lineSpacing(4)
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                if done {
                LookingAheadCallout(
                    title: "Class 12 Physics → NEET",
                    detail: "Lightning is a giant electrostatic discharge. Class 12 'Electrostatics' covers the physics of charge build-up, dielectric breakdown of air (~3 MV/m), and how a lightning rod works (sharp tip = high electric field that ionises air before damage occurs). JEE asks problems on capacitance and breakdown voltage every year."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Count the lightning",
                    detail: "Next thunderstorm (from inside a building, not in the open!): count seconds between lightning flash and thunder. Divide by 3 — that's the distance to the storm in kilometres (sound travels 343 m/s)."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                    GotItButton { onComplete(score) }.padding(.bottom, 12)
                }
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
