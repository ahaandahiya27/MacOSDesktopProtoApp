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
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 20) {
                    Spacer()

                    // Toggle spoon type
                    HStack(spacing: 12) {
                        Text("Metal spoon")
                            .fontWeight(isWooden ? .regular : .bold)
                            .foregroundStyle(isWooden ? .secondary : .primary)
                        Toggle("", isOn: $isWooden)
                            .toggleStyle(.switch)
                            .labelsHidden()
                            .onChange(of: isWooden) { _, _ in
                                resetAnimation()
                            }
                        Text("Wooden spoon")
                            .fontWeight(isWooden ? .bold : .regular)
                            .foregroundStyle(isWooden ? .primary : .secondary)
                    }
                    .accessibilityLabel("Spoon type: \(isWooden ? "wooden" : "metal")")

                    // Bowl + spoon scene
                    ZStack {
                        // Bowl
                        Ellipse()
                            .fill(LinearGradient(colors: [.brown.opacity(0.7), .brown.opacity(0.5)], startPoint: .top, endPoint: .bottom))
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
                                  ? LinearGradient(colors: [.brown, .brown.opacity(0.7)], startPoint: .bottom, endPoint: .top)
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
                                .foregroundStyle(.red)
                                .offset(x: 80, y: -160)
                                .transition(.scale.combined(with: .opacity))
                        }

                        // Wooden spoon blocks heat
                        if heating && isWooden {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundStyle(.green)
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
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)

                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 14) {
                    Spacer()
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Hot Soup, Cold Spoon", systemImage: "frying.pan.fill")
                                .font(.title2.bold())
                            Text(isWooden
                                 ? "Wood is a poor conductor (insulator). Heat barely travels through it, so the handle stays cool."
                                 : "Metal is a good conductor. Heat from the soup travels quickly up the spoon to your fingers!")
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: 640)
                    GotItButton { onComplete() }
                        .padding(.bottom, 12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)
            }
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
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
            .foregroundStyle(.white.opacity(0.5))
            .offset(x: CGFloat(index - 1) * 30, y: -20 - offset)
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(Double(index) * 0.3)) {
                    offset = 30
                }
            }
            .accessibilityHidden(true)
    }
}
