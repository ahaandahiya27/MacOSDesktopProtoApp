import SwiftUI

/// Green-tinted "Discovery Mode" discrete-preset picker. The variant of
/// DiscoveryWidget for categorical / staged variables — e.g., clock types
/// (sundial → pendulum → quartz → atomic), states of matter, plant growth
/// stages. Each preset has a name and a one-line consequence.
///
/// Pattern:
///   DiscoveryStepper(
///       title: "Travel through time-keeping history",
///       subtitle: "Pick an era. See its accuracy.",
///       options: ["Sundial", "Pendulum", "Quartz", "Atomic"],
///       selection: $eraIndex,
///       outputs: [
///           "Accurate to ~1 hour. Only works in sunshine.",
///           "Accurate to ~10 seconds/day. The 17th-century revolution.",
///           "Accurate to ~1 s/month. Your wristwatch.",
///           "Accurate to 1 s in 30 million years. The GPS backbone."
///       ]
///   )
///
/// Renders as a horizontal pill-row (tap to pick) plus a result line. Uses
/// the same green palette + slider.horizontal.3 header icon as the other
/// DiscoveryWidget variants so kids can recognise "this is play with me".
///
/// macOS 11 (Big Sur) / Swift 5.5 compatible:
///  - HStack + Button + RoundedRectangle + Text only.
///  - Each @ViewBuilder closure ≤ 10 direct children.
///  - options.count is expected to equal outputs.count; mismatches
///    are logged via CrashReporter.logDataIssue and `outputs` is
///    padded/clipped so the widget still renders.
struct DiscoveryStepper: View {
    let title: String
    let subtitle: String
    let options: [String]
    @Binding var selection: Int
    let outputs: [String]

    init(title: String,
         subtitle: String,
         options: [String],
         selection: Binding<Int>,
         outputs: [String]) {
        self.title = title
        self.subtitle = subtitle
        self.options = options
        self._selection = selection
        // Soft-fail instead of `precondition` — if a future scene ever
        // ships mismatched lists, log it to the crash file and pad/clip
        // `outputs` so the widget renders something sensible rather than
        // killing the whole Discover scene. `currentOutput` already
        // clamps the index defensively.
        if options.count == outputs.count {
            self.outputs = outputs
        } else {
            CrashReporter.shared.logDataIssue(
                "DiscoveryStepper: options.count (\(options.count)) != outputs.count (\(outputs.count)) — title=\(title)"
            )
            if outputs.count >= options.count {
                self.outputs = Array(outputs.prefix(options.count))
            } else {
                self.outputs = outputs + Array(repeating: "", count: options.count - outputs.count)
            }
        }
    }

    private static let darkGreen: Color = Color(red: 0.10, green: 0.45, blue: 0.20)

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            Text(subtitle)
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
            pillRow
            Text(currentOutput)
                .font(.callout.weight(.medium))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .lineSpacing(2)
                .padding(.top, 2)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityLabel("Result: \(currentOutput)")
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.green.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.green.opacity(0.35), lineWidth: 1)
        )
        .accessibilityElement(children: .contain)
    }

    private var header: some View {
        HStack(spacing: 10) {
            Image(systemName: "slider.horizontal.3")
                .font(.title3)
                .foregroundColor(Self.darkGreen)
                .accessibilityHidden(true)
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(Self.darkGreen)
            Spacer(minLength: 0)
            Text("\(selection + 1) / \(options.count)")
                .font(.caption.weight(.medium).monospacedDigit())
                .foregroundColor(Self.darkGreen)
        }
    }

    private var pillRow: some View {
        HStack(spacing: 6) {
            ForEach(0..<options.count, id: \.self) { i in
                Button {
                    selection = i
                } label: {
                    Text(options[i])
                        .font(.caption.weight(.medium))
                        .foregroundColor(selection == i ? .white : Self.darkGreen)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selection == i ? Color.green : Color.green.opacity(0.18))
                        )
                }
                .buttonStyle(PressableButtonStyle())
                .pointingCursor()
                .accessibilityLabel(options[i])
                .accessibilityValue(currentOutput)
                .accessibilityAddTraits(selection == i ? [.isSelected, .isButton] : .isButton)
            }
        }
    }

    private var currentOutput: String {
        let safe = max(0, min(selection, outputs.count - 1))
        return outputs[safe]
    }
}
