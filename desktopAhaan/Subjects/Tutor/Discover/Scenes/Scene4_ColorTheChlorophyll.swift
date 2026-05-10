import SwiftUI

/// Scene 4 — Color the Chlorophyll.
///
/// Top: a rainbow spectrum bar. Middle: a chlorophyll molecule. Bottom: light
/// beams travel from the spectrum down to the molecule. Red and blue are
/// absorbed; green is reflected. The kid can tap each colour to see the
/// behaviour, and toggle a "what if chlorophyll absorbed green instead?" view.
struct Scene4_ColorTheChlorophyll: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var selectedBand: Int? = nil
    @State private var invertedMode = false
    @State private var shake: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let bands: [(Color, String)] = [
        (.red, "Red"),
        (Color(red: 1, green: 0.55, blue: 0), "Orange"),
        (.yellow, "Yellow"),
        (.green, "Green"),
        (Color.cyan, "Cyan"),
        (.blue, "Blue"),
        (.purple, "Violet")
    ]

    /// True if the band at index i is absorbed (in normal mode: red/blue/violet
    /// are absorbed; green/yellow are reflected — simplified to red & blue).
    private func isAbsorbed(_ i: Int) -> Bool {
        // Normal mode: 0,1,5,6 absorbed (red/orange/blue/violet); 2,3,4 reflected
        // Inverted (toy) mode: only green absorbed
        if invertedMode {
            return i == 3
        }
        return i == 0 || i == 1 || i == 5 || i == 6
    }

    var body: some View {
        VStack(spacing: 14) {
            Text("Why are leaves green?")
                .font(.largeTitle.bold())
                .padding(.top, 18)
            Text("White light is a rainbow. Tap each colour and see what chlorophyll does with it.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            // Spectrum bar
            HStack(spacing: 0) {
                ForEach(0..<bands.count, id: \.self) { i in
                    Button {
                        tapBand(i)
                    } label: {
                        Rectangle()
                            .fill(bands[i].0)
                            .frame(height: 36)
                            .overlay(
                                Text(bands[i].1)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white.opacity(0.92))
                            )
                            .overlay(
                                Rectangle()
                                    .strokeBorder(selectedBand == i ? .white : .clear, lineWidth: 3)
                            )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(bands[i].1) light")
                }
            }
            .frame(maxWidth: 560)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)

            // Animated beam
            ZStack {
                if let i = selectedBand {
                    BeamView(
                        color: bands[i].0,
                        absorbed: isAbsorbed(i),
                        reduceMotion: reduceMotion
                    )
                    .id("beam-\(i)-\(invertedMode)")  // re-trigger on band change
                    .frame(height: 140)
                } else {
                    Color.clear.frame(height: 140)
                }
            }

            // Chloroplast
            DrawnChloroplast(excitation: selectedBand.flatMap { isAbsorbed($0) ? 1 : 0 } ?? 0)
                .frame(width: 200, height: 200)
                .offset(x: shake)

            // Speech bubble
            SoftShadowCard(padding: 14) {
                if let i = selectedBand {
                    HStack(alignment: .top, spacing: 10) {
                        Text(isAbsorbed(i) ? "🥢" : "🪞")
                            .font(.system(size: 22))
                        VStack(alignment: .leading, spacing: 4) {
                            if isAbsorbed(i) {
                                Text("\(bands[i].1) light: ABSORBED")
                                    .font(.headline)
                                    .foregroundStyle(.green)
                                Text("Chlorophyll grabs this colour and uses its energy to cook food.")
                                    .font(.callout)
                            } else {
                                Text("\(bands[i].1) light: REFLECTED")
                                    .font(.headline)
                                    .foregroundStyle(.indigo)
                                Text("Chlorophyll bounces this colour back. That's the colour your eyes see — which is why leaves look the colour they do.")
                                    .font(.callout)
                            }
                        }
                        Spacer(minLength: 0)
                    }
                } else {
                    Label("Pick a colour from the spectrum above.", systemImage: "hand.tap.fill")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: 560)

            HStack {
                Toggle("What if chlorophyll absorbed green instead?", isOn: $invertedMode)
                    .toggleStyle(.switch)
                    .controlSize(.small)
            }
            .frame(maxWidth: 560)

            GotItButton(action: onComplete)
                .padding(.bottom, 12)
                .disabled(selectedBand == nil)
                .opacity(selectedBand == nil ? 0.55 : 1)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func tapBand(_ i: Int) {
        withAnimation(.easeInOut) { selectedBand = i }
        if !isAbsorbed(i) && !reduceMotion {
            // Quick shake for "rejected"
            withAnimation(.spring(response: 0.18, dampingFraction: 0.4)) { shake = 12 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.18, dampingFraction: 0.4)) { shake = -8 }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) { shake = 0 }
            }
        }
    }
}

private struct BeamView: View {
    let color: Color
    let absorbed: Bool
    let reduceMotion: Bool

    @State private var progress: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let h = geo.size.height
            let w = geo.size.width
            let midX = w / 2
            ZStack {
                // Down beam
                Capsule()
                    .fill(color.opacity(0.85))
                    .frame(width: 8, height: max(8, h * progress))
                    .position(x: midX, y: (h * progress) / 2)
                if !absorbed {
                    // Bounce-back beam
                    Capsule()
                        .fill(color.opacity(0.6))
                        .frame(width: 6, height: max(0, h * (progress - 0.55) * 2))
                        .position(x: midX + 30, y: max(0, h - h * (progress - 0.55) * 2 / 2))
                }
            }
        }
        .onAppear {
            if reduceMotion {
                progress = 1
            } else {
                withAnimation(.easeIn(duration: 0.7)) { progress = 1 }
            }
        }
    }
}
