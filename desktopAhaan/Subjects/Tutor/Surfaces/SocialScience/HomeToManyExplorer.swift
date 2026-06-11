import SwiftUI

// MARK: - HomeToManyExplorer
//
// Bespoke interactive for Social Science Ch.17 "India, a Home to Many"
// (`socialscience_class7` / ssch17). The chapter's organising idea
// (ssch17_t01_c02) is that newcomers came to India for two main reasons — some
// seeking REFUGE from persecution (the Jews, Syriac Christians, Parsis, Baha'is,
// Tibetans, and the orphaned Polish children) and others seeking OPPORTUNITY
// through trade (Arab and Armenian merchants) — while the Siddis have a different,
// harder story, brought to India enslaved. Over time every one of these
// communities became part of Indian society — the chapter's ethos of acceptance.
//
// This widget upgrades ssch17 from the generic glossary-match to a chapter-
// specific explorer. Communities are grouped by WHY they came; tapping one shows
// where and when they arrived and the story the chapter tells about them — all
// straight from ssch17_t01–t04, with the Siddis honoured in their own honest band.
//
// Big Sur compat: self-contained, @SceneStorage (namespaced by chapter),
// Color(red:green:blue:), SFSymbolCompat (SF Symbols 1 only), RM-gated motion,
// VoiceOver labels. No macOS 12+ APIs (no .animation(_:value:)), no force-unwraps.

struct HomeToManyExplorer: View {
    let chapterId: String

    @SceneStorage private var selected: Int
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(chapterId: String) {
        self.chapterId = chapterId
        self._selected = SceneStorage(wrappedValue: 0, "ssinteractive.\(chapterId).hometomany")
    }

    private let terracotta = Color(red: 0.62, green: 0.30, blue: 0.20)

    // MARK: - The communities (grounded in ssch17_t01–t04)

    private struct Community {
        let name: String
        let band: Int          // 0 = refuge · 1 = opportunity · 2 = brought against their will
        let from: String       // where & when they arrived
        let story: String      // the memorable detail the chapter tells
    }

    private let communities: [Community] = [
        Community(name: "Jews", band: 0,
                  from: "The Bene Israel reached the Konkan coast around 175 BCE; the Cochin Jews settled in Kerala.",
                  story: "An early community to find safety here — the Raja of Kochi granted them land 'as long as the world endures'."),
        Community(name: "Syriac Christians", band: 0,
                  from: "From the 4th century CE, along trade routes to the Malabar coast of Kerala.",
                  story: "Persecuted in West Asia, they came to India where they could live and worship freely."),
        Community(name: "Parsis", band: 0,
                  from: "Fled the 7th-century Islamic conquest of Persia, reaching Gujarat in the 8th–10th centuries.",
                  story: "Followers of Zoroastrianism. The milk-and-sugar legend shows how they promised to enrich, not burden, their new home."),
        Community(name: "Baha'is", band: 0,
                  from: "From the late 19th century, fleeing persecution in Persia (Iran).",
                  story: "Their faith teaches the unity of all people; today most Baha'is here are Indian, and Delhi's Lotus Temple welcomes every religion."),
        Community(name: "Tibetans", band: 0,
                  from: "From 1959, after China annexed Tibet and the 14th Dalai Lama crossed the Himalaya.",
                  story: "India helped them build settlements and monasteries and preserve their culture and medicine (Sowa Rigpa)."),
        Community(name: "Polish children", band: 0,
                  from: "During World War II, sheltered at Nawanagar (today's Jamnagar, Gujarat).",
                  story: "Maharaja Digvijaysinhji took in about a thousand orphaned children — the 'Good Maharaja', honoured with a memorial in Warsaw."),
        Community(name: "Arab merchants", band: 1,
                  from: "From the 7th century onward, on the west coast — Kerala, Gujarat, Karnataka.",
                  story: "They traded spices, married locally, formed the Mappila Muslim community and helped build India's oldest mosque, the Cheraman Juma Masjid."),
        Community(name: "Armenians", band: 1,
                  from: "From around the 8th century on the Malabar coast; later in Mughal Agra and Kolkata.",
                  story: "Merchants in spices and fine muslin; Akbar let them build a church, and Kolkata became a major Armenian hub."),
        Community(name: "Siddis", band: 2,
                  from: "Brought to India enslaved by Arab, Portuguese and British traders between the 7th and 19th centuries.",
                  story: "A harder story — yet they built a unique African-Indian culture, are recognised as a scheduled tribe, and include Padma Shri awardee Hirabai Lobi.")
    ]

    private struct Band { let label: String; let symbol: String; let value: Int }
    private let bands: [Band] = [
        Band(label: "Came seeking refuge", symbol: "house.fill", value: 0),
        Band(label: "Came seeking opportunity", symbol: "bag.fill", value: 1),
        Band(label: "Brought against their will", symbol: "person.2.fill", value: 2)
    ]

    private var current: Community { communities[max(0, min(selected, communities.count - 1))] }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            ForEach(bands.indices, id: \.self) { b in bandSection(bands[b]) }
            detailPanel
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                .fill(Color.white.opacity(0.92))
                .overlay(RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                    .strokeBorder(terracotta.opacity(0.28), lineWidth: 1))
        )
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text("India, a home to many")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Over the centuries, many communities made India their home. Tap one to see where they came from and why.")
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func bandSection(_ band: Band) -> some View {
        let indices = communities.indices.filter { communities[$0].band == band.value }
        return VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 6) {
                Image(systemName: SFSymbolCompat.name(band.symbol))
                    .font(.caption)
                    .foregroundColor(terracotta)
                    .accessibilityHidden(true)
                Text(band.label)
                    .font(.caption.weight(.bold))
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
            chipWrap(indices)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // Manual wrapping into rows of up to 2 (community names can be long).
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
        let community = communities[idx]
        let on = selected == idx
        return Button { selectCommunity(idx) } label: {
            Text(community.name)
                .font(.caption.weight(.semibold))
                .foregroundColor(on ? .white : DesignTokens.BrandColor.canvasText)
                .padding(.horizontal, DesignTokens.Spacing.md).padding(.vertical, 7)
                .background(Capsule().fill(on ? terracotta : terracotta.opacity(0.10)))
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel("\(community.name)\(on ? ", selected" : "")")
        .accessibilityHint("Tap to see the story of the \(community.name) in India.")
    }

    private var detailPanel: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("The \(current.name)")
                .font(.subheadline.weight(.bold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            detailRow(symbol: "mappin.circle.fill", text: current.from)
            detailRow(symbol: "book.fill", text: current.story)
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.sm).fill(terracotta.opacity(0.12)))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("The \(current.name). \(current.from) \(current.story)")
    }

    private func detailRow(symbol: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: SFSymbolCompat.name(symbol))
                .font(.caption2)
                .foregroundColor(terracotta)
                .accessibilityHidden(true)
            Text(text)
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func selectCommunity(_ idx: Int) {
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
            selected = idx
        }
    }
}
