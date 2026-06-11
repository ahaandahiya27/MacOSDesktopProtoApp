import SwiftUI

// MARK: - SacredGeographyExplorer
//
// Bespoke interactive for Social Science Ch.8 "How the Land Becomes Sacred"
// (`socialscience_class7` / ssch08). The chapter's most striking idea
// (ssch08_t03_c01) is that India's sacred sites are not scattered at random but
// organised into NETWORKS that span the whole country — the four chār dhām, the
// 12 jyotirlingas and the 51 Shakti pīṭhas — alongside sacred rivers and their
// sangams (t04_c01), the Kumbh Mela's four sites (t04_c02), sacred mountains as
// gateways to heaven (t04_c03), sacred groves that protect biodiversity (t05_c02)
// and the shrines of many faiths (t01_c03). Together they knit India into one
// sacred geography.
//
// This widget upgrades ssch08 from the generic glossary-match to a chapter-
// specific explorer. Tapping an element shows what it is — with its count where
// the chapter gives one (4 / 12 / 51 / 19 / 4) — and why it matters, all straight
// from ssch08_t01–t05.
//
// Big Sur compat: self-contained, @SceneStorage (namespaced by chapter),
// Color(red:green:blue:), SFSymbolCompat (SF Symbols 1 only), RM-gated motion,
// VoiceOver labels. No macOS 12+ APIs (no .animation(_:value:)), no force-unwraps.

struct SacredGeographyExplorer: View {
    let chapterId: String

    @SceneStorage private var selected: Int
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(chapterId: String) {
        self.chapterId = chapterId
        self._selected = SceneStorage(wrappedValue: 0, "ssinteractive.\(chapterId).sacredgeo")
    }

    private let ochre = Color(red: 0.62, green: 0.36, blue: 0.10)

    // MARK: - Elements of India's sacred geography (grounded in ssch08_t01–t05)

    private struct Element {
        let name: String
        let symbol: String
        let count: String      // the chapter's number, or "" if none
        let what: String
        let why: String
    }

    private let elements: [Element] = [
        Element(name: "Chār Dhām", symbol: "mappin.and.ellipse", count: "4 sites",
                what: "Four great pilgrimage sites placed in the northern, southern, eastern and western corners of India.",
                why: "A pilgrim who visits all four crosses the entire land — the network binds the whole country together."),
        Element(name: "Jyotirlingas", symbol: "flame.fill", count: "12 shrines",
                what: "Twelve highly auspicious shrines of Śhiva.",
                why: "Spread right across India, they draw pilgrims from every region to a single shared tradition."),
        Element(name: "Shakti Pīṭhas", symbol: "star.fill", count: "51 sites",
                what: "Fifty-one sacred sites of the Goddess (Devī).",
                why: "They cover the whole map of India — and even reach into present-day Bangladesh and neighbouring lands."),
        Element(name: "Sacred Rivers", symbol: "drop.fill", count: "19 in the Ṛigveda",
                what: "Rivers like the Ganga, Yamuna, Godavari, Sarasvatī, Narmadā, Sindhu and Kāveri, honoured as goddesses since Vedic times.",
                why: "The Ṛigveda's nadīstuti sūkta praises 19 rivers; their confluences (sangams) are treated as especially sacred."),
        Element(name: "Kumbh Mela", symbol: "person.3.fill", count: "4 river sites",
                what: "A vast pilgrimage held at Haridwar, Prayagraj, Nashik and Ujjain.",
                why: "From the legend of the amṛita (nectar) — drops fell at these four places. It is one of the largest gatherings of people on Earth."),
        Element(name: "Sacred Mountains", symbol: "triangle.fill", count: "",
                what: "Peaks and hill shrines like Mount Kailash, Vaishno Devi at Katra and Tiruvannamalai.",
                why: "Because they reach so high, mountains are seen as a gateway from earth to heaven — the hard climb stands for the inner spiritual journey."),
        Element(name: "Sacred Groves", symbol: "leaf.fill", count: "",
                what: "Forests protected by communities as the homes of deities — no hunting, cutting or mining.",
                why: "Their sacred status has made them rich reservoirs of biodiversity, and many shelter small water bodies too."),
        Element(name: "Many Faiths", symbol: "sparkles", count: "",
                what: "Sacred places of every religion — the Ajmer Dargah Sharif, the Velankanni Church, the stūpas of Sanchi and Bodh Gaya.",
                why: "Faiths born in India and those that came from outside all have honoured sites, often visited by people of many religions.")
    ]

    private var current: Element { elements[max(0, min(selected, elements.count - 1))] }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            chipWrap
            detailPanel
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                .fill(Color.white.opacity(0.92))
                .overlay(RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                    .strokeBorder(ochre.opacity(0.28), lineWidth: 1))
        )
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text("India's sacred geography")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Sacred places aren't scattered at random — they form networks that span the whole land. Tap one to explore.")
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // Manual wrapping into rows of up to 2 (element names can be long).
    private var chipWrap: some View {
        let rows = stride(from: 0, to: elements.count, by: 2).map { start -> [Int] in
            Array(elements.indices[start..<min(start + 2, elements.count)])
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
        let element = elements[idx]
        let on = selected == idx
        return Button { selectElement(idx) } label: {
            HStack(spacing: 6) {
                Image(systemName: SFSymbolCompat.name(element.symbol))
                    .font(.caption)
                    .accessibilityHidden(true)
                Text(element.name)
                    .font(.caption.weight(.semibold))
            }
            .foregroundColor(on ? .white : DesignTokens.BrandColor.canvasText)
            .padding(.horizontal, DesignTokens.Spacing.md).padding(.vertical, 7)
            .background(Capsule().fill(on ? ochre : ochre.opacity(0.10)))
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel("\(element.name)\(on ? ", selected" : "")")
        .accessibilityHint("Tap to explore \(element.name) in India's sacred geography.")
    }

    private var detailPanel: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                Image(systemName: SFSymbolCompat.name(current.symbol))
                    .font(.title3)
                    .foregroundColor(ochre)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 1) {
                    Text(current.name)
                        .font(.subheadline.weight(.bold))
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    if !current.count.isEmpty {
                        Text(current.count)
                            .font(.caption2.weight(.bold))
                            .foregroundColor(ochre)
                    }
                }
            }
            Text(current.what)
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
            Text(current.why)
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 8).fill(ochre.opacity(0.12)))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(current.name)\(current.count.isEmpty ? "" : ", \(current.count)"). \(current.what) \(current.why)")
    }

    private func selectElement(_ idx: Int) {
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
            selected = idx
        }
    }
}
