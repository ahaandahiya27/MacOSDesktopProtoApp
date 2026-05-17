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
///  - options.count must equal outputs.count (precondition).
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
        precondition(options.count == outputs.count,
                     "DiscoveryStepper: options.count must equal outputs.count")
        self.title = title
        self.subtitle = subtitle
        self.options = options
        self._selection = selection
        self.outputs = outputs
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            Text(subtitle)
                .font(.callout)
                .foregroundColor(.primary)
                .lineSpacing(2)
            pillRow
            Text(currentOutput)
                .font(.callout.weight(.medium))
                .foregroundColor(.green)
                .lineSpacing(2)
                .padding(.top, 2)
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
                .foregroundColor(.green)
                .accessibilityHidden(true)
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.green)
            Spacer(minLength: 0)
            Text("\(selection + 1) / \(options.count)")
                .font(.caption.weight(.medium).monospacedDigit())
                .foregroundColor(.green)
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
                        .foregroundColor(selection == i ? .white : .green)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selection == i ? Color.green : Color.green.opacity(0.12))
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(options[i])
                .accessibilityAddTraits(selection == i ? [.isSelected, .isButton] : .isButton)
            }
        }
    }

    private var currentOutput: String {
        let safe = max(0, min(selection, outputs.count - 1))
        return outputs[safe]
    }
}
