import SwiftUI
import AppKit

// MARK: - InsideTheDigestiveTour
//
// Five-stop guided walkthrough for Ch.2 (Nutrition in Animals). The
// student rides along with a piece of food from mouth to colon,
// seeing what each organ contributes to digestion and absorption.
//
// Stops:
//   1. .mouth          — teeth + tongue + saliva (amylase).
//   2. .stomach        — HCl + pepsin churn protein into peptides.
//   3. .smallIntestine — villi absorb most of the nutrients.
//   4. .liverPancreas  — bile + pancreatic juice (chemical kitchen).
//   5. .largeIntestine — water absorption; gut microbiota; exit.

struct InsideTheDigestiveTour: View {
    let chapterId: String
    var onDismiss: () -> Void

    @SceneStorage private var stopIndex: Int
    @ObservedObject private var speech = SpeechReader.shared

    private let owner = "ch02.digestiveTour"

    init(chapterId: String, onDismiss: @escaping () -> Void) {
        self.chapterId = chapterId
        self.onDismiss = onDismiss
        self._stopIndex = SceneStorage(wrappedValue: 0, "digestiveTour.\(chapterId).stop")
    }

    private var stops: [DigestiveTourStop] { DigestiveTourStop.allStops }
    private var current: DigestiveTourStop { stops[max(0, min(stops.count - 1, stopIndex))] }
    private var isFirst: Bool { stopIndex == 0 }
    private var isLast: Bool { stopIndex >= stops.count - 1 }

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            sceneBody
            Divider()
            footerBar
        }
        .frame(minWidth: 620, idealWidth: 780, maxWidth: 920,
               minHeight: 540, idealHeight: 640, maxHeight: 820)
        .background(Color(NSColor.windowBackgroundColor))
        .background(
            Button("Dismiss", action: onDismissAndStopNarration)
                .keyboardShortcut(.cancelAction)
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
        )
        .onDisappear { speech.stop(owner: owner) }
    }

    private var header: some View {
        HStack(spacing: 14) {
            Image(systemName: SFSymbolCompat.name("fork.knife"))
                .font(.title2)
                .foregroundColor(DesignTokens.BrandColor.tryAtHome)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 3) {
                Text("Inside the digestive system")
                    .font(.title3.bold())
                Text("Step \(stopIndex + 1) of \(stops.count) — \(current.title)")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
            Button(action: onDismissAndStopNarration) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
            .pointingCursor()
            .accessibilityLabel("Close digestive tour")
        }
        .padding(.horizontal, DesignTokens.Spacing.xl)
        .padding(.top, 18)
        .padding(.bottom, DesignTokens.Spacing.md)
    }

    private var sceneBody: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                stopVisualization
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DesignTokens.Spacing.sm)
                    .id("digestive-stop-\(stopIndex)")
                narrationCard
            }
            .padding(.horizontal, DesignTokens.Spacing.xl)
            .padding(.vertical, 18)
            .frame(maxWidth: 720, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    @ViewBuilder
    private var stopVisualization: some View {
        switch current {
        case .mouth:           DigestiveMouthView()
        case .stomach:         DigestiveStomachView()
        case .smallIntestine:  DigestiveSmallIntestineView()
        case .liverPancreas:   DigestiveLiverPancreasView()
        case .largeIntestine:  DigestiveLargeIntestineView()
        }
    }

    private var narrationCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(current.title)
                .font(.title3.bold())
                .accessibilityAddTraits(.isHeader)
            Text(current.narration)
                .font(.body)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
            HStack {
                Button(action: toggleNarration) {
                    HStack(spacing: 6) {
                        Image(systemName: SFSymbolCompat.name(speech.isSpeaking ? "pause.fill" : "speaker.wave.2.fill"))
                            .font(.body)
                        Text(speech.isSpeaking ? "Pause" : "Read aloud")
                            .font(.callout.weight(.semibold))
                    }
                }
                .buttonStyle(.bordered)
                .accentColor(DesignTokens.BrandColor.tryAtHome)
                .accessibilityLabel(speech.isSpeaking ? "Pause narration" : "Read this stop aloud")
                Spacer()
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(DesignTokens.BrandColor.tryAtHome.opacity(0.10))
        )
    }

    private var footerBar: some View {
        HStack(spacing: 10) {
            Button("← Back") { goPrev() }
                .disabled(isFirst)
                .accessibilityHint(isFirst ? "First stop — no previous." : "Go to the previous stop.")
            Spacer()
            progressDots
            Spacer()
            Button(isLast ? "Done" : "Continue exploring →") {
                if isLast { onDismissAndStopNarration() } else { goNext() }
            }
            .keyboardShortcut(.defaultAction)
            .accessibilityHint(isLast ? "Closes the tour." : "Go to the next stop on the journey.")
        }
        .padding(.horizontal, DesignTokens.Spacing.xl)
        .padding(.vertical, DesignTokens.Spacing.md)
    }

    private var progressDots: some View {
        HStack(spacing: 6) {
            ForEach(0..<stops.count, id: \.self) { i in
                Circle()
                    .fill(i == stopIndex ? DesignTokens.BrandColor.tryAtHome : Color.secondary.opacity(0.35))
                    .frame(width: 7, height: 7)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Stop \(stopIndex + 1) of \(stops.count)")
    }

    private func goNext() {
        speech.stop(owner: owner)
        withAnimationRespectingReduceMotion(.easeInOut(duration: 0.32)) {
            stopIndex = min(stops.count - 1, stopIndex + 1)
        }
    }

    private func goPrev() {
        speech.stop(owner: owner)
        withAnimationRespectingReduceMotion(.easeInOut(duration: 0.32)) {
            stopIndex = max(0, stopIndex - 1)
        }
    }

    private func toggleNarration() {
        if speech.isSpeaking {
            speech.stop(owner: owner)
        } else {
            speech.speak(current.narration, owner: owner)
        }
    }

    private func onDismissAndStopNarration() {
        speech.stop(owner: owner)
        onDismiss()
    }
}

// MARK: - DigestiveTourStop

enum DigestiveTourStop: Int, CaseIterable, Identifiable {
    case mouth, stomach, smallIntestine, liverPancreas, largeIntestine

    var id: Int { rawValue }
    static var allStops: [DigestiveTourStop] { Self.allCases }

    var title: String {
        switch self {
        case .mouth:           return "Mouth — chewing + saliva"
        case .stomach:         return "Stomach — acid + churn"
        case .smallIntestine:  return "Small intestine — absorption"
        case .liverPancreas:   return "Liver + pancreas — chemical kitchen"
        case .largeIntestine:  return "Large intestine — finishing touches"
        }
    }

    var narration: String {
        switch self {
        case .mouth:
            return "Take a bite of a chapati. Teeth break it into smaller pieces — incisors cut, molars grind. The tongue mixes it with saliva, which contains an enzyme called salivary amylase. Amylase starts breaking starch into smaller sugars even before you swallow. That's why a slice of bread, chewed for a minute, starts tasting sweet. Tongue + saliva = the first chemical attack on your food."
        case .stomach:
            return "Through the oesophagus, the food reaches the stomach — a J-shaped bag. The stomach lining secretes hydrochloric acid (HCl) so strong it could dissolve a coin, plus an enzyme called pepsin that attacks proteins. Powerful muscle waves churn the food into a thick semi-liquid called chyme. The stomach has a thick mucus lining that keeps the acid from eating the stomach wall itself."
        case .smallIntestine:
            return "Chyme passes into the small intestine — a 6-metre-long tube coiled in your abdomen. This is where MOST absorption happens. The inner wall is covered with millions of tiny finger-like projections called villi, and each villus has its own micro-villi. Total absorbing surface: about 250 square metres — the size of a tennis court — packed into your belly. Nutrients pass through the villus walls into the blood."
        case .liverPancreas:
            return "Two organs nearby help out. The liver makes bile, stored in the gall bladder; bile emulsifies fat (breaks fat globs into tiny droplets so enzymes can attack them — same trick dishwashing soap uses on grease). The pancreas makes pancreatic juice with three enzymes — amylase for more starch, lipase for fats, trypsin for proteins. Both fluids dump into the small intestine via a single duct."
        case .largeIntestine:
            return "What's left — water, fibre, dead cells, undigested matter — enters the large intestine. Its job is mostly water reabsorption (your body recycles about 8 litres per day this way) and hosting a community of trillions of bacteria called the gut microbiome. These microbes finish digesting fibre, make vitamin K, and outcompete bad germs. The waste finally exits via the rectum and anus, completing a 24-hour journey."
        }
    }
}

// MARK: - Per-stop visualisations

private struct DigestiveMouthView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(DesignTokens.BrandColor.tryAtHome.opacity(0.10))
            HStack(spacing: 14) {
                Image(systemName: SFSymbolCompat.name("mouth.fill"))
                    .font(.system(size: 60))
                    .foregroundColor(DesignTokens.BrandColor.tryAtHome)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                    HStack(spacing: 6) {
                        Image(systemName: SFSymbolCompat.name("scissors"))
                            .foregroundColor(.gray)
                        Text("Teeth: cut + grind")
                            .font(.callout.weight(.semibold))
                    }
                    HStack(spacing: 6) {
                        Image(systemName: SFSymbolCompat.name("drop.fill"))
                            .foregroundColor(Color.compatCyan)
                        Text("Saliva: amylase → sugars")
                            .font(.callout.weight(.semibold))
                    }
                }
            }
        }
        .frame(height: 220)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Mouth — teeth cutting and saliva starting starch digestion.")
    }
}

private struct DigestiveStomachView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.red.opacity(0.10))
            // J-shape made of two arcs
            Path { p in
                p.addEllipse(in: CGRect(x: 30, y: 10, width: 130, height: 170))
                p.addEllipse(in: CGRect(x: 90, y: 90, width: 110, height: 120))
            }
            .fill(Color.red.opacity(0.65))
            .frame(width: 240, height: 220)
            VStack(spacing: DesignTokens.Spacing.xs) {
                Text("HCl + pepsin")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.white)
                Text("pH 1.5–3.5")
                    .font(.caption2.monospacedDigit())
                    .foregroundColor(.white.opacity(0.90))
            }
            .padding(DesignTokens.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.40))
            )
        }
        .frame(height: 240)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Stomach — J-shaped sac with HCl and pepsin churning food.")
    }
}

private struct DigestiveSmallIntestineView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(DesignTokens.BrandColor.tryAtHome.opacity(0.10))
            VStack(spacing: 6) {
                // Long coiled tube — represented as alternating segments
                ForEach(0..<5, id: \.self) { i in
                    Capsule()
                        .fill(DesignTokens.BrandColor.tryAtHome.opacity(0.80))
                        .frame(width: CGFloat([280, 260, 280, 260, 280][i]), height: 20)
                }
                Text("Villi: 250 m² absorbing surface")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                    .padding(.top, 6)
            }
        }
        .frame(height: 220)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Small intestine — coiled tube with villi covering 250 square metres of absorbing surface.")
    }
}

private struct DigestiveLiverPancreasView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(DesignTokens.BrandColor.mnemonic.opacity(0.10))
            HStack(spacing: 18) {
                VStack(spacing: DesignTokens.Spacing.xs) {
                    Ellipse()
                        .fill(DesignTokens.BrandColor.danger)
                        .frame(width: 120, height: 80)
                    Text("Liver → bile")
                        .font(.caption.weight(.semibold))
                }
                VStack(spacing: DesignTokens.Spacing.xs) {
                    Ellipse()
                        .fill(DesignTokens.BrandColor.mnemonic)
                        .frame(width: 100, height: 50)
                    Text("Pancreas → enzymes")
                        .font(.caption.weight(.semibold))
                }
            }
        }
        .frame(height: 200)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Liver producing bile and pancreas producing enzymes to feed into the small intestine.")
    }
}

private struct DigestiveLargeIntestineView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.compatBrown.opacity(0.18))
            // Inverted-U shape representing the colon
            Path { p in
                p.move(to: CGPoint(x: 30, y: 170))
                p.addLine(to: CGPoint(x: 30, y: 40))
                p.addLine(to: CGPoint(x: 250, y: 40))
                p.addLine(to: CGPoint(x: 250, y: 170))
            }
            .stroke(Color.compatBrown, lineWidth: 22)
            .frame(width: 280, height: 200)
            Text("Water absorbed · Gut microbiome at work")
                .font(.caption.weight(.semibold))
                .foregroundColor(.secondary)
                .offset(y: 95)
        }
        .frame(height: 220)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Large intestine — inverted U-shape where water is reabsorbed and gut microbes finish processing.")
    }
}
