import SwiftUI

/// Scene 7 — Daily Water Audit. Tap activities to add their litres.
struct Scene7_WaterAudit: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    struct Item: Identifiable { let id = UUID(); let name: String; let litres: Int }
    private let items: [Item] = [
        Item(name: "Brushing teeth (tap running)", litres: 12),
        Item(name: "Bath in a bucket",              litres: 18),
        Item(name: "Shower (10 min)",                litres: 80),
        Item(name: "Flushing toilet",                 litres: 10),
        Item(name: "Washing a car with hose",        litres: 100),
        Item(name: "Cooking & drinking",              litres: 8),
    ]
    @State private var checked: Set<UUID> = []
    @State private var familySize: Double = 4    // free-play: scale total by household size

    private var total: Int { items.filter { checked.contains($0.id) }.reduce(0) { $0 + $1.litres } }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: DesignTokens.Spacing.md) {
                Text("Daily Water Audit").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Tap each activity you did today. See your total.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                VStack(spacing: DesignTokens.Spacing.sm) {
                    ForEach(items) { item in
                        HStack {
                            Image(systemName: checked.contains(item.id) ? "checkmark.square.fill" : "square")
                                .foregroundColor(Color.compatIndigo)
                            Text(item.name).frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(item.litres) L").font(.headline.monospacedDigit()).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        }
                        .padding(10)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if checked.contains(item.id) { checked.remove(item.id) }
                            else { checked.insert(item.id) }
                        }
                        .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.md).fill(Color.white.opacity(0.95)))
                    }
                }
                .frame(maxWidth: 540)

                Text("Total today: \(total) L")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color.compatIndigo)

                SoftShadowCard(padding: 14) {
                    Text("An average Indian uses around 135 L per day; in cities it can climb past 200 L. Closing the tap, switching to a bucket bath, and fixing leaky taps each save dozens of litres daily.")
                        .font(.callout).lineSpacing(4)
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, DesignTokens.Spacing.xl)

                LookingAheadCallout(
                    title: "Civics / EVS",
                    detail: "Class 9 Civics, 'Working of Institutions', covers India's water policy: the Jal Shakti Ministry (2019), court cases on water as a basic right, and the Atal Bhujal Yojana. Class 10 EVS asks how your own choices affect the environment."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                TryAtHomeCallout(
                    title: "One-day water log",
                    detail: "Tomorrow, count every tap-use: brushing teeth (12 L), bath (40-80 L), flushing (10 L each), cooking (5 L), drinking (3 L). Add it up. Total daily water = how many 20-L bottles? Now imagine carrying that from a well 1 km away (the reality for millions)."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                DiscoveryWidget(
                    title: "Discovery — scale to family size",
                    subtitle: "Your audit shows YOUR water use. Now drag the family-size slider to see the household's daily total.",
                    value: $familySize,
                    range: 1...10,
                    step: 1,
                    valueLabel: { v in String(format: "Family: %.0f people", v) },
                    output: { v in self.familyTotalExplanation(v) }
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                GotItButton { onComplete() }.padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    private func familyTotalExplanation(_ size: Double) -> String {
        let perPerson = max(total, 135)   // if user has not yet checked items, use national average
        let dailyTotal = Int(Double(perPerson) * size)
        let bottles20L = (dailyTotal + 19) / 20
        let label: String
        switch size {
        case ..<2:
            label = "A single resident's footprint — small but still requires the city water network."
        case ..<5:
            label = "Typical Indian household. ~600 L is roughly 30 large bottles per day."
        case ..<8:
            label = "Joint family. Multi-generational homes account for a sizeable chunk of city demand."
        default:
            label = "Hostel / extended family. Bulk-billing kicks in; conservation matters most here."
        }
        return "Daily household total ≈ \(dailyTotal) L (\(bottles20L) × 20-L bottles). " + label
    }
}
