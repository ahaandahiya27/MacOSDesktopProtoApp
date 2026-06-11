import SwiftUI
import AppKit

// MARK: - BuildAMotionSandbox
//
// Three-slider kinematics sandbox for Ch.13 (Motion and Time). The
// student sets initial velocity (u), acceleration (a), and elapsed
// time (t). Outputs: final velocity v = u + at, distance travelled
// s = ut + 0.5*a*t², and a live trail showing the runner's position
// along a horizontal axis.
//
// The model is the standard Class 9 kinematics formulas dressed
// down for Class 7 — sliders show normalised values 0..1 mapping
// to user-friendly ranges (u: 0–10 m/s, a: −5 to +5 m/s², t: 0–10 s).

struct BuildAMotionSandbox: View {
    let chapterId: String

    @SceneStorage private var u01: Double     // 0..1 → 0..10 m/s
    @SceneStorage private var a01: Double     // 0..1 → −5..+5 m/s²  (0.5 = 0)
    @SceneStorage private var t01: Double     // 0..1 → 0..10 s
    @State private var isShowingExplainer: Bool = false

    init(chapterId: String) {
        self.chapterId = chapterId
        self._u01 = SceneStorage(wrappedValue: 0.5, "sandbox.\(chapterId).u")
        self._a01 = SceneStorage(wrappedValue: 0.6, "sandbox.\(chapterId).a")
        self._t01 = SceneStorage(wrappedValue: 0.5, "sandbox.\(chapterId).t")
    }

    // MARK: - Model

    private var u: Double { u01 * 10.0 }
    private var a: Double { (a01 - 0.5) * 10.0 }
    private var t: Double { t01 * 10.0 }

    private var v: Double { u + a * t }
    private var s: Double { u * t + 0.5 * a * t * t }

    private var avgSpeed: Double { t > 0 ? s / t : u }

    private var motionLabel: String {
        if abs(a) < 0.05 { return "Uniform motion" }
        if a > 0 { return "Accelerating" }
        return "Decelerating"
    }

    /// Normalised position 0..1 for the runner along the bar.
    /// Negative distance shows as 0 (the runner went backward).
    private var runnerPosition: Double {
        let maxDist = 100.0  // typical s for u=10, a=5, t=10
        return max(0, min(1, s / maxDist))
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            slidersBlock
            runnerTrack
            outputBlock
            explainerToggle
            if isShowingExplainer {
                explainerBody
            }
        }
        .padding(DesignTokens.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.compatPurple.opacity(0.10))
        )
        .respectReduceMotion(animation: .easeInOut(duration: 0.22))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Build-a-motion sandbox")
        .accessibilityHint("Three sliders let you set initial velocity, acceleration, and elapsed time. The output shows final velocity and distance travelled.")
    }

    private var header: some View {
        HStack(spacing: 10) {
            Image(systemName: SFSymbolCompat.name("figure.run"))
                .font(.title3)
                .foregroundColor(Color.compatPurple)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                Text("Build-a-Motion sandbox")
                    .font(.headline)
                Text("Set u, a, t — predict how far the runner goes.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
        }
    }

    private var slidersBlock: some View {
        VStack(spacing: 10) {
            MotionSliderRow(
                label: "Initial velocity u",
                value: $u01,
                readout: String(format: "%.1f m/s", u),
                color: Color.compatTeal,
                symbol: "arrow.right")
            MotionSliderRow(
                label: "Acceleration a",
                value: $a01,
                readout: String(format: "%+.1f m/s²", a),
                color: Color.compatPurple,
                symbol: "bolt.fill")
            MotionSliderRow(
                label: "Time t",
                value: $t01,
                readout: String(format: "%.1f s", t),
                color: DesignTokens.BrandColor.tryAtHome,
                symbol: "clock.fill")
        }
    }

    private var runnerTrack: some View {
        GeometryReader { geo in
            let runnerX: CGFloat = max(0, geo.size.width - 24) * CGFloat(runnerPosition)
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.secondary.opacity(0.20))
                    .frame(height: 6)
                Image(systemName: SFSymbolCompat.name("figure.run"))
                    .font(.title3)
                    .foregroundColor(Color.compatPurple)
                    .offset(x: runnerX)
                    .respectReduceMotion(animation: .easeInOut(duration: 0.32))
                    .accessibilityHidden(true)
            }
        }
        .frame(height: 28)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Runner position: \(Int(runnerPosition * 100)) percent of max.")
    }

    private var outputBlock: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            HStack {
                Text("Final velocity v")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Spacer()
                Text(String(format: "%+.1f m/s", v))
                    .font(.caption.monospacedDigit().weight(.bold))
                    .foregroundColor(.primary)
            }
            HStack {
                Text("Distance s")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Spacer()
                Text(String(format: "%.1f m", s))
                    .font(.caption.monospacedDigit().weight(.bold))
                    .foregroundColor(.primary)
            }
            HStack {
                Text("Average speed")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Spacer()
                Text(String(format: "%.1f m/s", avgSpeed))
                    .font(.caption.monospacedDigit().weight(.bold))
                    .foregroundColor(.primary)
            }
            HStack {
                Text("Motion type")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Spacer()
                Text(motionLabel)
                    .font(.caption.weight(.bold))
                    .foregroundColor(DesignTokens.BrandColor.relatedConcepts)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Motion output")
        .accessibilityValue("Final velocity \(String(format: "%.1f", v)) m/s. Distance \(String(format: "%.1f", s)) metres. Average speed \(String(format: "%.1f", avgSpeed)) m/s. Motion type: \(motionLabel).")
    }

    private var explainerToggle: some View {
        Button(action: {
            withAnimationRespectingReduceMotion(.easeOut(duration: 0.18)) {
                isShowingExplainer.toggle()
            }
        }) {
            HStack(spacing: 6) {
                Image(systemName: isShowingExplainer ? "chevron.down" : "chevron.right")
                    .font(.caption.weight(.bold))
                Text(isShowingExplainer ? "Hide formulas" : "Show the formulas")
                    .font(.caption.weight(.semibold))
            }
            .foregroundColor(Color.compatPurple)
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityHint("Reveals the kinematics formulas v = u + at and s = ut + half a t squared.")
    }

    private var explainerBody: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text("Two formulas describe motion at constant acceleration:")
                .font(.callout)
            Text("v = u + a·t")
                .font(.body.monospacedDigit().weight(.semibold))
                .foregroundColor(Color.compatPurple)
            Text("s = u·t + ½·a·t²")
                .font(.body.monospacedDigit().weight(.semibold))
                .foregroundColor(Color.compatPurple)
            Text("'a' is rate of change of velocity. Positive a speeds you up; negative a slows you down. When a = 0 the motion is uniform: v stays at u and s = u·t. When u = 0 you start from rest and s = ½·a·t². These show up in cars, falling balls, and even rocket trajectories.")
                .font(.callout)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, DesignTokens.Spacing.xs)
        .transition(.opacity)
        .accessibilityHint("Kinematics formulas in plain notation.")
    }
}

// MARK: - MotionSliderRow

private struct MotionSliderRow: View {
    let label: String
    @Binding var value: Double
    let readout: String
    let color: Color
    let symbol: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(spacing: 6) {
                Image(systemName: SFSymbolCompat.name(symbol))
                    .font(.caption)
                    .foregroundColor(color)
                    .accessibilityHidden(true)
                Text(label)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.primary)
                Spacer()
                Text(readout)
                    .font(.caption.monospacedDigit())
                    .foregroundColor(.secondary)
            }
            Slider(value: $value, in: 0...1)
                .accentColor(color)
                .accessibilityLabel(label)
                .accessibilityValue(readout)
                .accessibilityHint("Drag to change \(label.lowercased()).")
        }
    }
}
