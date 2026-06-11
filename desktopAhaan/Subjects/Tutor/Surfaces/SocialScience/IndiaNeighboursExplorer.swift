import SwiftUI

// MARK: - IndiaNeighboursExplorer
//
// Bespoke interactive for Social Science Ch.14 "India and Her Neighbours"
// (`socialscience_class7` / ssch14). The chapter's first idea (ssch14_t01_c01) is
// that a neighbour can be a LAND neighbour or a MARITIME (across-the-sea) one, and
// the rest of the chapter walks each one — China, Pakistan, Afghanistan,
// Bangladesh, Nepal, Bhutan and Myanmar by land (t02–t03), Sri Lanka and the
// Maldives across the sea (t04). The recurring theme is that almost every tie is
// an OLD cultural link — Buddhism, shared rivers, an open border, ancient trade
// routes — not just a modern boundary line.
//
// This widget upgrades ssch14 from the generic glossary-match to a chapter-
// specific explorer. Neighbours are grouped into 'By land' and 'Across the sea';
// tapping one shows where it meets India and the shared heritage that connects
// them — all straight from ssch14_t02–t04.
//
// Big Sur compat: self-contained, @SceneStorage (namespaced by chapter),
// Color(red:green:blue:), SFSymbolCompat (SF Symbols 1 only), RM-gated motion,
// VoiceOver labels. No macOS 12+ APIs (no .animation(_:value:)), no force-unwraps.

struct IndiaNeighboursExplorer: View {
    let chapterId: String

    @SceneStorage private var selected: Int
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(chapterId: String) {
        self.chapterId = chapterId
        self._selected = SceneStorage(wrappedValue: 0, "ssinteractive.\(chapterId).neighbour")
    }

    private let leafGreen = Color(red: 0.15, green: 0.42, blue: 0.28)

    // MARK: - India's neighbours (grounded in ssch14_t02–t04)

    private struct Neighbour {
        let name: String
        let band: Int          // 0 = by land · 1 = across the sea
        let where_: String     // where it meets India
        let link: String       // the shared heritage / tie
    }

    private let neighbours: [Neighbour] = [
        Neighbour(name: "China", band: 0,
                  where_: "Across the Himalayas — along Ladakh, Himachal, Uttarakhand, Sikkim & Arunachal Pradesh.",
                  link: "Buddhism began in India and travelled to China around the 1st century CE; monks like Faxian and Xuanzang came to study here."),
        Neighbour(name: "Pakistan", band: 0,
                  where_: "Along Gujarat, Rajasthan, Punjab and the UTs of Jammu & Kashmir and Ladakh.",
                  link: "It was part of India until the 1947 Partition. Despite a hard history, shared languages, food, music and the Kartarpur Corridor pilgrimage are bridges of friendship."),
        Neighbour(name: "Afghanistan", band: 0,
                  where_: "Once a direct land neighbour, before the 1947 creation of Pakistan came between them.",
                  link: "Linked by the ancient Uttarapatha trade route and a shared Buddhist–Hindu past — the giant Bamiyan Buddhas were carved there."),
        Neighbour(name: "Bangladesh", band: 0,
                  where_: "India's longest land border — along West Bengal, Assam, Meghalaya, Tripura & Mizoram.",
                  link: "Born in 1971. Shares the Bangla language with West Bengal, the Ganga–Brahmaputra rivers, and the Sundarbans."),
        Neighbour(name: "Nepal", band: 0,
                  where_: "In the lap of the Himalayas, with an OPEN border — people cross with no passport or visa.",
                  link: "Deep Hindu pilgrimage ties (the Pashupatinath temple in Kathmandu) and the 1950 Treaty of Peace and Friendship."),
        Neighbour(name: "Bhutan", band: 0,
                  where_: "A Himalayan kingdom touching Sikkim, West Bengal, Assam & Arunachal Pradesh.",
                  link: "'Drukyul', the Land of the Thunder Dragon. Joined by Vajrayana Buddhism and hydroelectric cooperation; it pioneered Gross National Happiness."),
        Neighbour(name: "Myanmar", band: 0,
                  where_: "India's 'gateway to Southeast Asia' — a land AND sea border touching Arunachal, Nagaland, Manipur & Mizoram.",
                  link: "Connected by Buddhism and connectivity projects like the Trilateral Highway; India helped restore the Ananda temple in Bagan."),
        Neighbour(name: "Sri Lanka", band: 1,
                  where_: "An island just 32 km across the Palk Strait — India's NEAREST maritime neighbour.",
                  link: "Buddhism was brought there in the 3rd century BCE by Mahendra and Sanghamitra, Emperor Ashoka's children; strong Tamil cultural ties remain."),
        Neighbour(name: "Maldives", band: 1,
                  where_: "Over 1,100 low islets; the nearest is about 130 km from Minicoy in India's Lakshadweep.",
                  link: "Shares South Indian-rooted food and the Dhivehi language (with Sanskrit, Tamil, Malayalam & Hindi words); India is its trusted first responder in crises.")
    ]

    private struct Band { let label: String; let symbol: String; let value: Int }
    private let bands: [Band] = [
        Band(label: "By land", symbol: "map.fill", value: 0),
        Band(label: "Across the sea", symbol: "drop.fill", value: 1)
    ]

    private var current: Neighbour { neighbours[max(0, min(selected, neighbours.count - 1))] }

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
                    .strokeBorder(leafGreen.opacity(0.28), lineWidth: 1))
        )
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text("Meet India's neighbours")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Some neighbours meet India by land, others across the sea — but almost every tie is an old cultural link. Tap one to explore.")
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func bandSection(_ band: Band) -> some View {
        let indices = neighbours.indices.filter { neighbours[$0].band == band.value }
        return VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 6) {
                Image(systemName: SFSymbolCompat.name(band.symbol))
                    .font(.caption)
                    .foregroundColor(leafGreen)
                    .accessibilityHidden(true)
                Text(band.label)
                    .font(.caption.weight(.bold))
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
            chipWrap(indices)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // Manual wrapping into rows of up to 3 (country names are short).
    private func chipWrap(_ indices: [Int]) -> some View {
        let rows = stride(from: 0, to: indices.count, by: 3).map { start -> [Int] in
            Array(indices[start..<min(start + 3, indices.count)])
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
        let neighbour = neighbours[idx]
        let on = selected == idx
        return Button { selectNeighbour(idx) } label: {
            Text(neighbour.name)
                .font(.caption.weight(.semibold))
                .foregroundColor(on ? .white : DesignTokens.BrandColor.canvasText)
                .padding(.horizontal, DesignTokens.Spacing.md).padding(.vertical, 7)
                .background(Capsule().fill(on ? leafGreen : leafGreen.opacity(0.10)))
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel("\(neighbour.name)\(on ? ", selected" : "")")
        .accessibilityHint("Tap to see how India and \(neighbour.name) are connected.")
    }

    private var detailPanel: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("India & \(current.name)")
                .font(.subheadline.weight(.bold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            detailRow(symbol: "mappin.circle.fill", text: current.where_)
            detailRow(symbol: "link", text: current.link)
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.sm).fill(leafGreen.opacity(0.12)))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("India and \(current.name). \(current.where_) \(current.link)")
    }

    private func detailRow(symbol: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: SFSymbolCompat.name(symbol))
                .font(.caption2)
                .foregroundColor(leafGreen)
                .accessibilityHidden(true)
            Text(text)
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func selectNeighbour(_ idx: Int) {
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
            selected = idx
        }
    }
}
