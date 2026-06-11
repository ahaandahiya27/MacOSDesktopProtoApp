import SwiftUI

// MARK: - CroppingSeasonExplorer
//
// Bespoke interactive for Social Science Ch.13 "The Story of Indian Farming"
// (`socialscience_class7` / ssch13). The chapter's concept ssch13_t02_c03 and its
// deepDive 'Farming on the monsoon's clock' teach that India's year has three
// cropping seasons set by the monsoon: KHARIF (Arabic for 'autumn' — sown with
// the southwest monsoon, the thirsty rainy-season crops), RABI ('spring' — sown
// on the moisture the monsoon leaves behind, grown through the cool dry winter),
// and ZAID (the short hot summer season in the gap between them).
//
// This widget shows a twelve-month calendar strip and lets a learner tap a season
// to light up the months it spans, see its crops, and read why it sits where it
// does on the monsoon's clock (including what the Arabic name means). Three
// thematic icons — rain for kharif, a snowflake for the cool rabi, a sun for the
// hot zaid — make the rhythm of the year visible.
//
// Big Sur compat: self-contained, @SceneStorage (namespaced by chapter),
// Color(red:green:blue:), SFSymbolCompat (SF Symbols 1 only), RM-gated motion,
// VoiceOver labels. No macOS 12+ APIs (no .animation(_:value:)), no force-unwraps.

struct CroppingSeasonExplorer: View {
    let chapterId: String

    @SceneStorage private var selected: Int   // 0 Kharif · 1 Rabi · 2 Zaid
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(chapterId: String) {
        self.chapterId = chapterId
        self._selected = SceneStorage(wrappedValue: 0, "ssinteractive.\(chapterId).season")
    }

    private let cropGreen = Color(red: 0.30, green: 0.52, blue: 0.22)
    private let monthLetters = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]

    // MARK: - The three seasons (grounded in ssch13_t02_c03 + the monsoon deepDive)

    private struct Season {
        let name: String
        let symbol: String
        let months: Set<Int>      // 0 = Jan … 11 = Dec
        let monthsLabel: String
        let crops: String
        let why: String
        let tint: Color
    }

    private let seasons: [Season] = [
        Season(name: "Kharif", symbol: "cloud.rain.fill",
               months: [5, 6, 7, 8, 9],
               monthsLabel: "June–October",
               crops: "Rice, maize, jowar, bajra, cotton, sugarcane, groundnut",
               why: "Kharif is Arabic for 'autumn'. These thirsty crops are sown with the arrival of the southwest monsoon around June and harvested after the rains — they need plenty of water.",
               tint: Color(red: 0.20, green: 0.45, blue: 0.70)),
        Season(name: "Rabi", symbol: "snowflake",
               months: [10, 11, 0, 1, 2],
               monthsLabel: "November–March",
               crops: "Wheat, barley, gram, peas, mustard",
               why: "Rabi is Arabic for 'spring'. Sown in the cooler, drier months on the moisture the monsoon left behind, these crops grow with less water and are harvested in spring.",
               tint: Color(red: 0.35, green: 0.45, blue: 0.62)),
        Season(name: "Zaid", symbol: "sun.max.fill",
               months: [3, 4, 5],
               monthsLabel: "April–June",
               crops: "Watermelon, muskmelon, cucumber, pumpkin",
               why: "Zaid is the short summer season in the gap between rabi and kharif — quick crops grown where water is available during the hot months.",
               tint: Color(red: 0.85, green: 0.55, blue: 0.10))
    ]

    private var current: Season { seasons[max(0, min(selected, seasons.count - 1))] }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            calendarStrip
            seasonChips
            detailPanel
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                .fill(Color.white.opacity(0.92))
                .overlay(RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                    .strokeBorder(cropGreen.opacity(0.30), lineWidth: 1))
        )
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text("The monsoon's farming calendar")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Tap a season to see when it's grown across the year and which crops it brings.")
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // Twelve month cells; the selected season's months light up in its tint.
    private var calendarStrip: some View {
        HStack(spacing: 3) {
            ForEach(monthLetters.indices, id: \.self) { m in
                let inSeason = current.months.contains(m)
                Text(monthLetters[m])
                    .font(.caption2.weight(.bold))
                    .foregroundColor(inSeason ? .white : DesignTokens.BrandColor.canvasTextSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DesignTokens.Spacing.sm)
                    .background(RoundedRectangle(cornerRadius: 5)
                        .fill(inSeason ? current.tint : current.tint.opacity(0.08)))
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(current.name) season runs \(current.monthsLabel).")
    }

    private var seasonChips: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            ForEach(seasons.indices, id: \.self) { i in seasonChip(i) }
        }
    }

    private func seasonChip(_ i: Int) -> some View {
        let s = seasons[i]
        let on = selected == i
        return Button { selectSeason(i) } label: {
            HStack(spacing: 5) {
                Image(systemName: SFSymbolCompat.name(s.symbol))
                    .font(.caption)
                    .accessibilityHidden(true)
                Text(s.name)
                    .font(.caption.weight(.semibold))
            }
            .foregroundColor(on ? .white : DesignTokens.BrandColor.canvasText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 9)
            .background(RoundedRectangle(cornerRadius: 9).fill(on ? s.tint : s.tint.opacity(0.12)))
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel("\(s.name) season\(on ? ", selected" : "")")
        .accessibilityHint("Tap to see when \(s.name) crops are grown and which crops they are.")
    }

    private var detailPanel: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 7) {
                Image(systemName: SFSymbolCompat.name(current.symbol))
                    .foregroundColor(current.tint)
                    .accessibilityHidden(true)
                Text("\(current.name) · \(current.monthsLabel)")
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            HStack(alignment: .top, spacing: 6) {
                Image(systemName: SFSymbolCompat.name("leaf.fill"))
                    .font(.caption2)
                    .foregroundColor(cropGreen)
                    .accessibilityHidden(true)
                Text(current.crops)
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Text(current.why)
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 8).fill(current.tint.opacity(0.12)))
        .accessibilityElement(children: .combine)
    }

    private func selectSeason(_ i: Int) {
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
            selected = i
        }
    }
}
