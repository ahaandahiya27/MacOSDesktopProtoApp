import SwiftUI

// MARK: - WhatIfsSectionView
//
// Surfaces `chapter.whatIfs: [WhatIfScenario]?` as a collapsible
// "What if…" section on the chapter detail page. Each card: a
// provocative one-line question + a 3-5 sentence guided answer.
//
// Uses `CollapsibleContentSection` so it visually matches NCERT Q&A
// and Misconceptions.

struct WhatIfsSectionView: View {
    let chapter: Chapter

    private var entries: [WhatIfScenario] { chapter.whatIfsList }

    var body: some View {
        if !entries.isEmpty {
            CollapsibleContentSection(
                title: "What if…",
                icon: "questionmark.bubble.fill",
                badgeCount: entries.count,
                tint: .compatPurple,
                storageKey: "\(chapter.id).whatIfs"
            ) {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                    ForEach(entries) { entry in
                        WhatIfCard(entry: entry)
                    }
                }
            }
        }
    }
}

private struct WhatIfCard: View {
    let entry: WhatIfScenario
    @State private var showAnswer = false

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
                Image(systemName: SFSymbolCompat.name("sparkle"))
                    .font(.body)
                    .foregroundColor(Color.compatPurple)
                    .accessibilityHidden(true)
                Text(entry.question)
                    .font(.callout.weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
            }
            if showAnswer {
                Text(entry.answer)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.leading, 22)
                    .transition(.opacity)
            }
            HStack {
                Spacer()
                Button(showAnswer ? "Hide answer" : "Reveal answer") {
                    withAnimationRespectingReduceMotion(.easeOut(duration: 0.18)) {
                        showAnswer.toggle()
                    }
                }
                .buttonStyle(.borderless)
                .accentColor(Color.compatPurple)
                .accessibilityHint(showAnswer ? "Hides the answer." : "Reveals the guided answer for this what-if.")
            }
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.secondary.opacity(0.25), lineWidth: 1)
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("What if scenario: \(entry.question)")
    }
}
