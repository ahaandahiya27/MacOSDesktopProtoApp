import SwiftUI

// MARK: - ThreeOrgansSorter
//
// Bespoke interactive for Social Science Ch.18 "The State, the Government, and
// You" (`socialscience_class7` / ssch18). The chapter's topic ssch18_t03 teaches
// the three organs of government: the Legislature (makes laws — t03_c01), the
// Executive (carries out laws; political + permanent — t03_c02), and the
// Judiciary (the 'watchdog' that settles disputes, interprets laws and protects
// rights — t03_c03). The exam-and-Olympiad skill is matching a real function to
// the right organ, and seeing the separation of powers in action.
//
// This widget shows one government function at a time and asks the learner to
// tap the organ responsible. Each card carries a short reason drawn straight
// from the chapter, so a wrong tap teaches rather than just buzzes. A running
// score and a 'sorted all N' finish line reward completing the set. Nine cards,
// three per organ, in a fixed order (no randomness — banned on the target).
//
// Big Sur compat: self-contained, @SceneStorage (namespaced by chapter) for the
// card index, @State for the per-card pick, Color.compat* + Color(red:green:blue:),
// RM-gated motion, SFSymbolCompat (SF Symbols 1/2 only), VoiceOver labels. No
// macOS 12+ APIs, no force-unwraps.

struct ThreeOrgansSorter: View {
    let chapterId: String

    @SceneStorage private var index: Int
    @State private var picked: Int? = nil        // organ index tapped for current card
    @State private var solved: Set<Int> = []     // card indices answered correctly
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(chapterId: String) {
        self.chapterId = chapterId
        self._index = SceneStorage(wrappedValue: 0, "ssinteractive.\(chapterId).organidx")
    }

    // MARK: - The three organs (grounded in ssch18_t03)

    private struct Organ { let name: String; let symbol: String }
    private let organs: [Organ] = [
        Organ(name: "Legislature", symbol: "building.columns.fill"),
        Organ(name: "Executive",   symbol: "briefcase.fill"),
        Organ(name: "Judiciary",   symbol: "checkmark.shield.fill")
    ]

    // Each function maps to one organ (index into `organs`) with a chapter-grounded reason.
    private struct Task { let text: String; let organ: Int; let reason: String }
    private let tasks: [Task] = [
        Task(text: "Make the country's laws.", organ: 0,
             reason: "The Legislature is the lawmaking body — elected members make rules that apply to everyone."),
        Task(text: "Members are elected by the people to represent them.", organ: 0,
             reason: "The Legislature represents the people; its members are chosen through elections."),
        Task(text: "A state's Vidhan Sabha making laws just for that state.", organ: 0,
             reason: "States have their own legislatures, which make laws for that state."),
        Task(text: "Carry out the laws and make policy decisions.", organ: 1,
             reason: "The Executive carries out the laws made by the Legislature and takes policy decisions."),
        Task(text: "The Prime Minister and ministers running the country.", organ: 1,
             reason: "The political executive — elected leaders who serve a fixed term — is part of the Executive."),
        Task(text: "IAS and IPS officers selected through the UPSC exam.", organ: 1,
             reason: "The permanent executive — unelected civil servants — keeps the government running whoever is in power."),
        Task(text: "Settle disputes and protect people's rights.", organ: 2,
             reason: "The Judiciary settles disputes and protects the rights given by the Constitution."),
        Task(text: "Explain what a law means when its wording is unclear.", organ: 2,
             reason: "The Judiciary interprets laws when people disagree about their meaning."),
        Task(text: "Check whether a law is fair, through judicial review.", organ: 2,
             reason: "The Judiciary is the 'watchdog' — judicial review lets it safeguard the Constitution.")
    ]

    private var current: Task { tasks[max(0, min(index, tasks.count - 1))] }
    private var answered: Bool { picked != nil }
    private var wasCorrect: Bool { picked == current.organ }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            progressRow
            functionCard
            organButtons
            if answered { feedbackBanner }
            if answered { nextButton }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                .fill(Color.white.opacity(0.92))
                .overlay(RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                    .strokeBorder(Color.compatPurple.opacity(0.28), lineWidth: 1))
        )
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Which organ does this?")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Tap the organ of government responsible for each job — Legislature, Executive or Judiciary.")
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var progressRow: some View {
        HStack(spacing: 6) {
            let done = solved.count >= tasks.count
            Image(systemName: SFSymbolCompat.name(done ? "checkmark.seal.fill" : "list.number"))
                .foregroundColor(done ? .green : DesignTokens.BrandColor.canvasTextSecondary)
                .accessibilityHidden(true)
            Text(done
                 ? "You matched all \(tasks.count) jobs to the right organ!"
                 : "Card \(index + 1) of \(tasks.count) · \(solved.count) solved")
                .font(.caption.weight(.medium))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
    }

    private var functionCard: some View {
        Text(current.text)
            .font(.title3.weight(.semibold))
            .foregroundColor(DesignTokens.BrandColor.canvasText)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.compatPurple.opacity(0.08)))
            .accessibilityLabel("Government job: \(current.text)")
    }

    private var organButtons: some View {
        HStack(spacing: 8) {
            ForEach(organs.indices, id: \.self) { i in organButton(i) }
        }
    }

    private func organButton(_ i: Int) -> some View {
        let organ = organs[i]
        let isPick = picked == i
        let showAsAnswer = answered && i == current.organ
        let tint: Color = showAsAnswer ? .green : (isPick ? .red : Color.compatPurple)
        return Button { pick(i) } label: {
            VStack(spacing: 6) {
                Image(systemName: SFSymbolCompat.name(organ.symbol))
                    .font(.title3)
                    .accessibilityHidden(true)
                Text(organ.name)
                    .font(.caption.weight(.semibold))
                    .multilineTextAlignment(.center)
            }
            .foregroundColor(answered ? (showAsAnswer || isPick ? .white : DesignTokens.BrandColor.canvasText) : .white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12).padding(.horizontal, 6)
            .background(RoundedRectangle(cornerRadius: 10)
                .fill(answered ? tint.opacity(showAsAnswer || isPick ? 0.9 : 0.12) : Color.compatPurple))
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .disabled(answered)
        .accessibilityLabel(organ.name)
        .accessibilityHint("Tap if the \(organ.name) is responsible for this job.")
    }

    private var feedbackBanner: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: SFSymbolCompat.name(wasCorrect ? "checkmark.circle.fill" : "xmark.circle.fill"))
                .foregroundColor(wasCorrect ? .green : .red)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(wasCorrect ? "Correct — that's the \(organs[current.organ].name)." : "Not quite — it's the \(organs[current.organ].name).")
                    .font(.caption.weight(.bold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Text(current.reason)
                    .font(.caption)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8)
            .fill((wasCorrect ? Color.green : Color.red).opacity(0.12)))
        .accessibilityElement(children: .combine)
    }

    private var nextButton: some View {
        Button { advance() } label: {
            Text(index + 1 < tasks.count ? "Next job →" : "Start over")
                .font(.caption.weight(.semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 16).padding(.vertical, 8)
                .background(Capsule().fill(Color.compatPurple))
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel(index + 1 < tasks.count ? "Next job" : "Start over")
    }

    // MARK: - Actions

    private func pick(_ i: Int) {
        guard picked == nil else { return }
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
            picked = i
            if i == current.organ { solved.insert(index) }
        }
    }

    private func advance() {
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
            picked = nil
            index = index + 1 < tasks.count ? index + 1 : 0
        }
    }
}
