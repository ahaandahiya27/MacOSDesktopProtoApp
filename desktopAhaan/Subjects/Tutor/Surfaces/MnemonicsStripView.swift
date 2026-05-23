import SwiftUI

// MARK: - MnemonicsStripView
//
// Horizontal chip strip surfacing `chapter.mnemonics`. Each chip's
// label is the mnemonic's acronym (e.g. "SLAP"); tap opens a popover
// with the unpacking line + optional context.
//
// Note: distinct from `MnemonicCallout.swift`, which is a single-card
// component used INSIDE Discover scenes — that one doesn't read from
// `chapter.mnemonics` and isn't a chip strip.

struct MnemonicsStripView: View {
    let chapter: Chapter

    private var mnemonics: [Mnemonic] { chapter.mnemonicsList }

    var body: some View {
        if !mnemonics.isEmpty {
            ContentChipStrip(
                title: "Mnemonics (\(mnemonics.count))",
                items: mnemonics.map { m in
                    var detail = m.unpacking
                    if let ctx = m.context, !ctx.isEmpty {
                        detail += "\n\nWhen this helps: " + ctx
                    }
                    return ContentChipStripItem(
                        id: m.id,
                        label: m.acronym,
                        detail: detail
                    )
                },
                tint: .compatIndigo
            )
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Mnemonics, \(mnemonics.count) entries")
        }
    }
}
