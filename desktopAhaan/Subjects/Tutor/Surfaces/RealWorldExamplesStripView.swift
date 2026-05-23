import SwiftUI

// MARK: - RealWorldExamplesStripView
//
// Horizontal chip strip surfacing `chapter.realWorldExamples` on the
// chapter detail page. Each chip's label is the example's title; tap
// opens a popover with the 60–100 word body.
//
// Auto-hides when the chapter has no authored examples. Uses
// `ContentChipStrip` for the row + sheet.

struct RealWorldExamplesStripView: View {
    let chapter: Chapter

    private var examples: [RealWorldExample] { chapter.realWorldExamplesList }

    var body: some View {
        if !examples.isEmpty {
            ContentChipStrip(
                title: "Real-world examples (\(examples.count))",
                items: examples.map { ex in
                    ContentChipStripItem(
                        id: ex.id,
                        label: ex.title,
                        detail: ex.body
                    )
                },
                tint: .compatTeal
            )
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Real-world examples, \(examples.count) entries")
        }
    }
}
