import SwiftUI

/// Scene 4 — Hot Soup, Cold Spoon.
/// Metal spoon in hot soup conducts heat. Toggle to wooden spoon to see insulation.

struct Scene4_HotSoupColdSpoon: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var isWooden = false
    @State private var heating = false
    @State private var dotProgress: CGFloat = 0
    @State private var showOuch = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        // Refactored ZStack-overlap pattern to ScrollView+VStack so
        // explanation cards don't cover the interactive content.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                VStack(spacing: 20) {
                    Spacer()

                    // Toggle spoon type
                    HStack(spacing: 12) {
                        Text("Metal spoon")
                            .fontWeight(isWooden ? .regular : .bold)
                            .foregroundColor(isWooden ? .secondary : .primary)
                        Toggle("", isOn: $isWooden)
                            .toggleStyle(.switch)
                            .labelsHidden()
                            .onChange(of: isWooden) { _ in
                                resetAnimation()
                            }
                        Text("Wooden spoon")
                            .fontWeight(isWooden ? .bold : .regular)
                            .foregroundColor(isWooden ? .primary : .secondary)
                    }
                    .accessibilityLabel("Spoon type: \(isWooden ? "wooden" : "metal")")

                    // Bowl + spoon scene
                    ZStack {
                        // Bowl
                        Ellipse()
                            .fill(LinearGradient(colors: [Color.compatBrown.opacity(0.7), Color.compatBrown.opacity(0.5)], startPoint: .top, endPoint: .bottom))
                            .frame(width: 220, height: 120)
                            .offset(y: 40)

                        // Soup
                        Ellipse()
                            .fill(LinearGradient(colors: [.orange.opacity(0.8), .red.opacity(0.6)], startPoint: .top, endPoint: .bottom))
                            .frame(width: 200, height: 80)
                            .offset(y: 30)

                        // Steam
                        if !reduceMotion {
                            ForEach(0..<3, id: \.self) { i in
                                SteamWisp(index: i)
                            }
                        }

                        // Spoon handle
                        RoundedRectangle(cornerRadius: 4)
                            .fill(isWooden
                                  ? LinearGradient(colors: [Color.compatBrown, Color.compatBrown.opacity(0.7)], startPoint: .bottom, endPoint: .top)
                                  : LinearGradient(colors: [.gray, .gray.opacity(0.5)], startPoint: .bottom, endPoint: .top))
                            .frame(width: 10, height: 160)
                            .rotationEffect(.degrees(-20))
                            .offset(x: 60, y: -50)

                        // Heat dots traveling up the spoon
                        if heating && !isWooden {
                            ForEach(0..<5, id: \.self) { i in
                                Circle()
                                    .fill(Color.orange)
                                    .frame(width: 8, height: 8)
                                    .offset(
                                        x: 60 - CGFloat(i) * 3,
                                        y: 30 - dotProgress * 140 - CGFloat(i) * 18
                                    )
                                    .opacity(Double(dotProgress))
                                    .accessibilityLabel("Heat dot traveling up spoon")
                            }
                        }

                        // Ouch indicator
                        if showOuch {
                            Text("Ouch! 🔥")
                                .font(.title.bold())
                                .foregroundColor(.red)
                                .offset(x: 80, y: -160)
                                .transition(.scale.combined(with: .opacity))
                        }

                        // Wooden spoon blocks heat
                        if heating && isWooden {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.green)
                                .offset(x: 60, y: -10)
                                .accessibilityLabel("Heat blocked by wood")
                        }
                    }
                    .frame(height: 260)

                    Button(heating ? "Reset" : "Wait and watch...") {
                        if heating {
                            resetAnimation()
                        } else {
                            startHeating()
                        }
                    }
                    
                    .accentColor(.orange)

                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity)

                Group {
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Hot Soup, Cold Spoon", systemImage: SFSymbolCompat.name("frying.pan.fill"))
                                .font(.title2.bold())
                            Text(isWooden
                                 ? "Wood is a poor conductor (insulator). Heat barely travels through it, so the handle stays cool."
                                 : "Metal is a good conductor. Heat from the soup travels quickly up the spoon to your fingers!")
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    LookingAheadCallout(
                        title: "Class 11 Physics → JEE (Thermal Conductivity)",
                        detail: "Materials have a thermal-conductivity number k (W/m·K). Copper k=400, aluminium k=237, water k=0.6, wood k=0.13, air k=0.024. The 6,000× difference between copper and wood is why JEE problem sets love these comparisons. Why are pot handles often wood or plastic? Same reason aircraft fuselages have insulation — control where heat goes."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    TryAtHomeCallout(
                        title: "Make your own conductivity ladder",
                        detail: "Take a metal spoon, a wooden chopstick, and a plastic ruler. Stand all three in a cup of warm (NOT boiling) water at the same time. After 30 seconds, touch the top of each. Metal warmest, wood barely warmer, plastic in between. You just ranked three materials by k — informally but accurately."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    GotItButton { onComplete() }
                        .padding(.bottom, 12)
                
                }
                .padding(.horizontal, 24)
            
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    private func startHeating() {
        heating = true
        showOuch = false
        dotProgress = 0
        withAnimation(reduceMotion ? .none : .easeIn(duration: 2.0)) {
            dotProgress = 1.0
        }
        if !isWooden {
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                withAnimation(.spring()) { showOuch = true }
            }
        }
    }

    private func resetAnimation() {
        heating = false
        showOuch = false
        dotProgress = 0
    }
}

// MARK: - Steam wisp

private struct SteamWisp: View {
    let index: Int
    @State private var offset: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Text("~")
            .font(.title2)
            .foregroundColor(.white.opacity(0.5))
            .offset(x: CGFloat(index - 1) * 30, y: -20 - offset)
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(.easeInOut(duration: HardwareTier.duration(ideal: 2)).repeatForever(autoreverses: true).delay(Double(index) * 0.3)) {
                    offset = 30
                }
            }
            .accessibilityHidden(true)
    }
}
