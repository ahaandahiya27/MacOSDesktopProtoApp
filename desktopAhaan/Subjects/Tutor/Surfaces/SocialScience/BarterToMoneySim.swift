import SwiftUI

// MARK: - BarterToMoneySim
//
// Bespoke interactive for Social Science Ch.11 "From Barter to Money"
// (`socialscience_class7` / ssch11). The chapter's central idea is the
// "double coincidence of wants" (concept ssch11_t02_c01): under barter a trade
// only works when each person wants exactly what the other has. This widget
// lets a learner FEEL that friction, then watch money dissolve it.
//
// You hold one good. A row of villagers each want a specific good and offer
// one in return. In Barter mode, tapping a villager only trades if they want
// what you're holding — otherwise the trade fails ("they don't want your
// wheat"). Flip on Money mode and every villager accepts coins, so any trade
// succeeds — the lesson that money is a universally accepted medium of
// exchange that removes the double-coincidence problem.
//
// Big Sur compat: self-contained, @State + @SceneStorage (namespaced by
// chapter), SwiftUI Shapes + Color(red:green:blue:)/compatIndigo, RM-gated
// motion, VoiceOver labels. No macOS 12+ APIs, no randomness.

struct BarterToMoneySim: View {
    let chapterId: String

    @SceneStorage private var heldGoodIndex: Int
    @SceneStorage private var moneyMode: Bool
    @State private var feedback: String? = nil
    @State private var lastSuccess = false
    @State private var trades = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(chapterId: String) {
        self.chapterId = chapterId
        self._heldGoodIndex = SceneStorage(wrappedValue: 0, "ssinteractive.\(chapterId).held")
        self._moneyMode = SceneStorage(wrappedValue: false, "ssinteractive.\(chapterId).money")
    }

    // MARK: - Goods + villagers (a small barter village)

    private struct Good { let name: String; let glyph: String }
    private let goods: [Good] = [
        Good(name: "wheat", glyph: "🌾"),
        Good(name: "fish",  glyph: "🐟"),
        Good(name: "cloth", glyph: "🧵"),
        Good(name: "pot",   glyph: "🏺")
    ]

    private struct Villager { let name: String; let wants: Int; let offers: Int }
    // Each villager wants one good and offers another (indices into `goods`).
    private let villagers: [Villager] = [
        Villager(name: "Meena the weaver",  wants: 0, offers: 2), // wants wheat, offers cloth
        Villager(name: "Raju the fisher",   wants: 2, offers: 1), // wants cloth, offers fish
        Villager(name: "Devi the potter",   wants: 1, offers: 3), // wants fish, offers pot
        Villager(name: "Hari the farmer",   wants: 3, offers: 0)  // wants pot, offers wheat
    ]

    private var held: Good { goods[max(0, min(heldGoodIndex, goods.count - 1))] }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            modeToggle
            heldRow
            villagerList
            if let f = feedback { feedbackBanner(f) }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                .fill(Color.white.opacity(0.92))
                .overlay(RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                    .strokeBorder(Color.compatIndigo.opacity(0.25), lineWidth: 1))
        )
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text("Trade in the village")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text(moneyMode
                 ? "Money mode: everyone accepts coins, so any trade works."
                 : "Barter mode: a trade only works if the villager wants what you hold.")
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var modeToggle: some View {
        HStack(spacing: 10) {
            Button { setMode(false) } label: { modeChip("Barter", on: !moneyMode) }
                .buttonStyle(.plain).pointingCursor()
                .accessibilityLabel("Barter mode\(moneyMode ? "" : ", selected")")
            Button { setMode(true) } label: { modeChip("Money 🪙", on: moneyMode) }
                .buttonStyle(.plain).pointingCursor()
                .accessibilityLabel("Money mode\(moneyMode ? ", selected" : "")")
            Spacer(minLength: 0)
            if trades > 0 {
                Text("\(trades) trade\(trades == 1 ? "" : "s")")
                    .font(.caption).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
        }
    }

    private func modeChip(_ label: String, on: Bool) -> some View {
        Text(label)
            .font(.caption.weight(.semibold))
            .foregroundColor(on ? .white : DesignTokens.BrandColor.canvasText)
            .padding(.horizontal, 14).padding(.vertical, 7)
            .background(Capsule().fill(on ? Color.compatIndigo : Color.compatIndigo.opacity(0.10)))
    }

    private var heldRow: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            Text("You hold:")
                .font(.subheadline)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            Text("\(held.glyph) \(held.name)")
                .font(.subheadline.weight(.bold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Spacer(minLength: 0)
        }
        .padding(.vertical, DesignTokens.Spacing.xxs)
    }

    private var villagerList: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            ForEach(villagers.indices, id: \.self) { i in
                let v = villagers[i]
                Button { trade(with: i) } label: {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(v.name)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                        Text("Wants \(goods[v.wants].glyph) \(goods[v.wants].name) · offers \(goods[v.offers].glyph) \(goods[v.offers].name)")
                            .font(.caption)
                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 14).padding(.vertical, 10)
                    .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.sm).fill(Color.compatIndigo.opacity(0.06)))
                    .overlay(RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                        .strokeBorder(Color.compatIndigo.opacity(0.22), lineWidth: 1))
                }
                .buttonStyle(.plain)
                .pointingCursor()
                .accessibilityLabel("\(v.name), wants \(goods[v.wants].name), offers \(goods[v.offers].name)")
                .accessibilityHint("Tap to try to trade your \(held.name).")
            }
        }
    }

    private func feedbackBanner(_ text: String) -> some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            Image(systemName: SFSymbolCompat.name(lastSuccess ? "checkmark.circle.fill" : "xmark.circle.fill"))
                .foregroundColor(lastSuccess ? .green : .red)
                .accessibilityHidden(true)
            Text(text)
                .font(.caption.weight(.medium))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Spacer(minLength: 0)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
            .fill((lastSuccess ? Color.green : Color.red).opacity(0.12)))
        .accessibilityElement(children: .combine)
    }

    // MARK: - Actions

    private func setMode(_ money: Bool) {
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
            moneyMode = money
            feedback = nil
        }
    }

    private func trade(with villagerIndex: Int) {
        let v = villagers[villagerIndex]
        let success = moneyMode || v.wants == heldGoodIndex
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
            lastSuccess = success
            if success {
                trades += 1
                let got = goods[v.offers]
                feedback = moneyMode && v.wants != heldGoodIndex
                    ? "Trade done — you paid with coins and got \(got.glyph) \(got.name)."
                    : "Trade done — \(v.name) wanted your \(held.name)! You now hold \(got.glyph) \(got.name)."
                heldGoodIndex = v.offers
            } else {
                feedback = "No deal — \(v.name) doesn't want your \(held.name). That's the double coincidence of wants. Try Money mode!"
            }
        }
    }
}
