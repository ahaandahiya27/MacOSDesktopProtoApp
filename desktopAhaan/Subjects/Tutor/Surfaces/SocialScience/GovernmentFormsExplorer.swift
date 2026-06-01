import SwiftUI

// MARK: - GovernmentFormsExplorer
//
// Bespoke interactive for Social Science Ch.9 "From the Rulers to the Ruled:
// Types of Governments" (`socialscience_class7` / ssch09). The chapter's whole
// thesis is a spectrum — who actually holds power? — running from one ruler to a
// few to the people. Topic ssch09_t04 covers monarchy (absolute / constitutional
// — t04_c01), theocracy and dictatorship (t04_c02) and oligarchy (t04_c03), while
// t02–t03 cover democracy and the republic, and t05 the deep idea of choosing
// rulers.
//
// This widget arranges those forms along the chapter's own axis, grouped by how
// many people hold power: 'One person rules' (absolute monarchy, dictatorship),
// 'A few rule' (oligarchy, theocracy) and 'The people rule' (democracy, republic,
// constitutional monarchy). Person-count icons (one / a few / many) make the
// spectrum visible, and tapping any form reveals who holds power, a real-world
// example and its key feature — all straight from the chapter.
//
// Big Sur compat: self-contained, @SceneStorage (namespaced by chapter),
// Color(red:green:blue:), SFSymbolCompat (SF Symbols 1 only), RM-gated motion,
// VoiceOver labels. No macOS 12+ APIs (no .animation(_:value:)), no force-unwraps.

struct GovernmentFormsExplorer: View {
    let chapterId: String

    @SceneStorage private var selected: Int
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(chapterId: String) {
        self.chapterId = chapterId
        // Default to Democracy (index 5) so a meaningful detail shows on open.
        self._selected = SceneStorage(wrappedValue: 5, "ssinteractive.\(chapterId).govform")
    }

    private let govMaroon = Color(red: 0.52, green: 0.22, blue: 0.34)

    // MARK: - Forms of government (grounded in ssch09_t02–t05)

    private struct Form {
        let name: String
        let band: Int          // 0 = one rules · 1 = a few rule · 2 = the people rule
        let who: String
        let example: String
        let feature: String
    }

    private let forms: [Form] = [
        Form(name: "Absolute Monarchy", band: 0,
             who: "One — a king or queen who inherits the throne and makes the laws.",
             example: "Saudi Arabia",
             feature: "The monarch holds all the power; the position passes down within the family."),
        Form(name: "Dictatorship", band: 0,
             who: "One person (or a tiny group) with absolute power and no legal limits.",
             example: "Germany under Adolf Hitler",
             feature: "No constitution or law restrains the ruler — history's dictators caused terrible suffering."),
        Form(name: "Oligarchy", band: 1,
             who: "A few — a small, powerful group, often wealthy families or influential people.",
             example: "Aristocratic families in ancient Greece",
             feature: "From Greek olígos ('a few') + árkhō ('to rule'). Even a democracy can drift this way if a few gain too much influence."),
        Form(name: "Theocracy", band: 1,
             who: "Religious leaders, governing by the rules of a religion.",
             example: "Iran — its Supreme Leader is chosen by religious clerics",
             feature: "The highest authority is religious, though it may also have an elected president and parliament."),
        Form(name: "Republic", band: 2,
             who: "The people — the head of state is elected, not a hereditary king.",
             example: "India today; the ancient Vajji–Lichchhavi chose leaders by merit",
             feature: "An old idea: the Uttaramerur inscriptions describe Chola-era village elections with sealed ballot boxes."),
        Form(name: "Democracy", band: 2,
             who: "The people, who elect their leaders and can vote them out.",
             example: "India",
             feature: "'Rule of the people' — built on equality, freedom, universal adult franchise and an independent judiciary."),
        Form(name: "Constitutional Monarchy", band: 2,
             who: "The people — a king or queen remains but holds only in-name power.",
             example: "United Kingdom",
             feature: "Real power lies with an elected parliament and prime minister, not the crown.")
    ]

    private struct Band { let label: String; let symbol: String; let value: Int }
    private let bands: [Band] = [
        Band(label: "One person rules", symbol: "person.fill", value: 0),
        Band(label: "A few rule", symbol: "person.2.fill", value: 1),
        Band(label: "The people rule", symbol: "person.3.fill", value: 2)
    ]

    private var current: Form { forms[max(0, min(selected, forms.count - 1))] }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            ForEach(bands.indices, id: \.self) { b in bandSection(bands[b]) }
            detailPanel
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                .fill(Color.white.opacity(0.92))
                .overlay(RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                    .strokeBorder(govMaroon.opacity(0.28), lineWidth: 1))
        )
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Who holds the power?")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Every government answers one question — who gets to decide? Tap a form to find out.")
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func bandSection(_ band: Band) -> some View {
        let indices = forms.indices.filter { forms[$0].band == band.value }
        return VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 6) {
                Image(systemName: SFSymbolCompat.name(band.symbol))
                    .font(.caption)
                    .foregroundColor(govMaroon)
                    .accessibilityHidden(true)
                Text(band.label)
                    .font(.caption.weight(.bold))
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
            chipWrap(indices)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // Manual wrapping into rows of up to 2 (form names are long).
    private func chipWrap(_ indices: [Int]) -> some View {
        let rows = stride(from: 0, to: indices.count, by: 2).map { start -> [Int] in
            Array(indices[start..<min(start + 2, indices.count)])
        }
        return VStack(alignment: .leading, spacing: 7) {
            ForEach(rows.indices, id: \.self) { r in
                HStack(spacing: 7) {
                    ForEach(rows[r], id: \.self) { idx in chip(idx) }
                    Spacer(minLength: 0)
                }
            }
        }
    }

    private func chip(_ idx: Int) -> some View {
        let form = forms[idx]
        let on = selected == idx
        return Button { selectForm(idx) } label: {
            Text(form.name)
                .font(.caption.weight(.semibold))
                .foregroundColor(on ? .white : DesignTokens.BrandColor.canvasText)
                .padding(.horizontal, 12).padding(.vertical, 7)
                .background(Capsule().fill(on ? govMaroon : govMaroon.opacity(0.10)))
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel("\(form.name)\(on ? ", selected" : "")")
        .accessibilityHint("Tap to see who holds power in a \(form.name).")
    }

    private var detailPanel: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(current.name)
                .font(.subheadline.weight(.bold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            detailRow(symbol: "crown.fill", text: current.who)
            detailRow(symbol: "mappin.circle.fill", text: "Example: \(current.example)")
            Text(current.feature)
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 8).fill(govMaroon.opacity(0.12)))
        .accessibilityElement(children: .combine)
    }

    private func detailRow(symbol: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: SFSymbolCompat.name(symbol))
                .font(.caption2)
                .foregroundColor(govMaroon)
                .accessibilityHidden(true)
            Text(text)
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func selectForm(_ idx: Int) {
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
            selected = idx
        }
    }
}
