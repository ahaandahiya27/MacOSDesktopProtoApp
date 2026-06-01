import SwiftUI

// Discover-Mode building blocks for the Class 7 Sanskrit pack
// (`sanskrit_class7`, P1-E build-out, v6 Learning Journey). Like the Social
// Science components, these read their content straight from the pack at
// runtime — a concept's depth-laddered explanation, or a chapter's
// `bossquiz_sch*` MCQs — so one generic chapter view renders a faithful
// 9-scene experience for all 15 NEP chapters (`sch01`–`sch15`) without
// per-chapter literals.
//
// SRS: every boss question records through
// `DataStore.recordReview(questionId:quality:packId:)` with its real pack id
// (`bossquiz_schNN_qII`). Those ids resolve through the SubjectRegistry global
// question index (boss questions are indexed — see SubjectRegistry.swift), so
// Daily Practice "Recently Missed" surfaces and re-drills them natively; no
// ephemeral-prefix wiring is required (the Sanskrit boss questions are real
// pack rows, unlike the Social Science synthetic `bossquiz_ssch` ids).
//
// All Big-Sur-safe: plain Buttons, no macOS 12+ APIs, SF Symbols via
// SFSymbolCompat, `Color.orange` saffron accent used only on fills/borders
// (never `.foregroundColor(.orange)` on Text — WCAG-flagged), motion via
// GotItButton.

// MARK: - Info / concept scene (depth-laddered paragraphs)

struct SanskritDiscoverInfoScene: View {
    let title: String
    let paragraphs: [String]
    let onComplete: () -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text(title)
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.top, 18)
                    .padding(.horizontal, 24)
                ForEach(paragraphs.indices, id: \.self) { i in
                    Text(paragraphs[i])
                        .font(.callout)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
                        .padding(.horizontal, 24)
                }
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }
}

// MARK: - Quick-check scene (one pack MCQ, records SRS)

/// Renders a single chapter MCQ (a topic or boss question) and records the
/// answer to the SM-2 store. `onComplete` reports 1 (correct) / 0 (wrong).
/// `@MainActor` because it calls the `@MainActor` `DataStore.shared`
/// synchronously — required under the Big Sur / Swift 5.5 deploy target.
@MainActor
struct SanskritDiscoverQuickCheckScene: View {
    let intro: String
    let question: Question
    let packId: String
    let onComplete: (Int) -> Void

    @State private var selected: String? = nil
    @State private var recorded = false

    private var options: [String] { question.options ?? [] }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text(intro)
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.top, 18)
                    .padding(.horizontal, 24)
                Text(question.prompt)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                optionList
                if selected != nil {
                    GotItButton(action: { onComplete(selected == question.answer ? 1 : 0) })
                        .padding(.top, 6)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    private var optionList: some View {
        VStack(spacing: 10) {
            ForEach(options, id: \.self) { opt in
                Button {
                    guard selected == nil else { return }
                    selected = opt
                    recordIfNeeded(picked: opt)
                } label: {
                    HStack {
                        Text(opt)
                            .font(.body.weight(.medium))
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        if selected != nil && opt == question.answer {
                            Image(systemName: SFSymbolCompat.name("checkmark.circle.fill"))
                                .foregroundColor(.green)
                        } else if selected == opt {
                            Image(systemName: SFSymbolCompat.name("xmark.circle.fill"))
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal, 16).padding(.vertical, 12)
                    .frame(maxWidth: 360)
                    .background(RoundedRectangle(cornerRadius: 10).fill(optionFill(opt)))
                    .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.orange.opacity(0.3), lineWidth: 1))
                }
                .buttonStyle(.plain)
                .pointingCursor()
                .disabled(selected != nil)
            }
        }
    }

    private func recordIfNeeded(picked: String) {
        guard !recorded else { return }
        recorded = true
        DataStore.shared.recordReview(
            questionId: question.id,
            quality: picked == question.answer ? .good : .forgot,
            packId: packId
        )
    }

    private func optionFill(_ opt: String) -> Color {
        guard let s = selected else { return Color.orange.opacity(0.08) }
        if opt == question.answer { return Color.green.opacity(0.18) }
        if opt == s { return Color.red.opacity(0.15) }
        return Color.orange.opacity(0.05)
    }
}

// MARK: - Boss-quiz scene (multi-question, per-question SRS)

/// Walks the chapter's `bossquiz_sch*` MCQs one at a time, recording each
/// answer to the SM-2 store with the pack id, then shows a score card.
/// `@MainActor` because it calls the `@MainActor` `DataStore.shared`
/// synchronously — required under the Big Sur / Swift 5.5 deploy target.
@MainActor
struct SanskritDiscoverBossQuizScene: View {
    let title: String
    let questions: [Question]
    let packId: String
    let onComplete: (Int) -> Void

    @State private var index = 0
    @State private var picked: String? = nil
    @State private var revealed = false
    @State private var score = 0
    @State private var shuffled: [String] = []

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text(title)
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.top, 18)
                    .padding(.horizontal, 24)
                if index < questions.count {
                    Text("Question \(index + 1) of \(questions.count) · Score \(score)")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    questionCard(questions[index])
                } else {
                    finishCard
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
        .onAppear { if shuffled.isEmpty, index < questions.count { shuffled = (questions[index].options ?? []).shuffled() } }
        .onChange(of: index) { newIndex in
            if newIndex < questions.count { shuffled = (questions[newIndex].options ?? []).shuffled() }
        }
    }

    private func questionCard(_ q: Question) -> some View {
        VStack(spacing: 12) {
            Text(q.prompt)
                .font(.title3.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            optionList(q)
            if revealed {
                explanationAndNext(q)
            }
        }
    }

    private func optionList(_ q: Question) -> some View {
        VStack(spacing: 10) {
            ForEach(shuffled, id: \.self) { opt in
                Button {
                    guard !revealed else { return }
                    picked = opt
                    revealed = true
                    let isCorrect = opt == q.answer
                    if isCorrect { score += 1 }
                    DataStore.shared.recordReview(
                        questionId: q.id,
                        quality: isCorrect ? .good : .forgot,
                        packId: packId
                    )
                } label: {
                    HStack {
                        Text(opt)
                            .font(.body.weight(.medium))
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        if revealed && opt == q.answer {
                            Image(systemName: SFSymbolCompat.name("checkmark.circle.fill"))
                                .foregroundColor(.green)
                        } else if revealed && opt == picked {
                            Image(systemName: SFSymbolCompat.name("xmark.circle.fill"))
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal, 16).padding(.vertical, 12)
                    .frame(maxWidth: 360)
                    .background(RoundedRectangle(cornerRadius: 10).fill(optionFill(opt, q)))
                    .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.orange.opacity(0.3), lineWidth: 1))
                }
                .buttonStyle(.plain)
                .pointingCursor()
                .disabled(revealed)
            }
        }
    }

    private func explanationAndNext(_ q: Question) -> some View {
        VStack(spacing: 10) {
            SoftShadowCard(padding: 12) {
                Label(q.bossExplanation, systemImage: SFSymbolCompat.name("lightbulb.fill"))
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            .frame(maxWidth: 520)
            Button {
                picked = nil
                revealed = false
                index += 1
            } label: {
                Text(index == questions.count - 1 ? "See score" : "Next question")
                    .font(.body.weight(.semibold))
                    .padding(.horizontal, 22).padding(.vertical, 10)
                    .background(Capsule().fill(Color.orange.opacity(0.15)))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            .buttonStyle(.plain)
            .pointingCursor()
            .padding(.top, 4)
        }
    }

    private var finishCard: some View {
        VStack(spacing: 12) {
            if score >= max(1, (questions.count * 4) / 5) {
                Image(systemName: SFSymbolCompat.name("checkmark.seal.fill"))
                    .font(.system(size: 52))
                    .foregroundColor(.green)
                    .accessibilityHidden(true)
            }
            Text("You scored \(score) / \(questions.count)")
                .font(.title2.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text(score == questions.count ? "उत्तमम्! Chapter mastered." : "Great effort — revisit the scenes and try again any time.")
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            GotItButton(label: "Finish chapter", action: { onComplete(score) }).padding(.top, 6)
        }
    }

    private func optionFill(_ opt: String, _ q: Question) -> Color {
        guard let s = picked else { return Color.orange.opacity(0.08) }
        if opt == q.answer { return Color.green.opacity(0.18) }
        if opt == s { return Color.red.opacity(0.15) }
        return Color.orange.opacity(0.05)
    }
}
