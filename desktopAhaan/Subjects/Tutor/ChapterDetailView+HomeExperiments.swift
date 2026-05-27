import SwiftUI

// MARK: - Home Experiments sheet
//
// A dedicated UI surface for hands-on experiments tied to a chapter.
// Separate from Discover (interactive in-app) and Articles (long-form
// reading) — these are real-world activities the kid can run with kitchen
// or garden supplies. Big Sur compatible: no .foregroundStyle, no
// .symbolEffect, no Color.brown.
//
// Lifted out of `ChapterDetailView.swift` to keep the main view under
// the Big Sur Swift 5.5 type-checker risk threshold (~600 LOC). The
// HomeExperimentCard sub-view is visible at file-scope (no `private`)
// so HomeExperimentsSheet (also moved here) can construct it.

struct HomeExperiment: Identifiable {
    let id: String
    let emoji: String
    let title: String
    let needs: [String]
    let steps: [String]
    let whyItWorks: String
    let estimatedMinutes: Int
}

enum HomeExperimentLibrary {
    static let experiments: [String: [HomeExperiment]] = [
        "ch01": [
            HomeExperiment(
                id: "ch01_exp_starch_map",
                emoji: "🌿",
                title: "Iodine starch map of a leaf",
                needs: [
                    "One healthy potted plant (mint, money plant or hibiscus all work)",
                    "A small piece of black paper or cardboard",
                    "Iodine solution from the chemist (or povidone-iodine in a pinch)",
                    "Boiling water and warm alcohol (ask a grown-up)",
                    "A white plate"
                ],
                steps: [
                    "Cover a corner of one leaf (on the plant) with black paper. Tape it down so no light gets in.",
                    "Leave the plant in bright sunlight for a full day.",
                    "Pluck the leaf. Boil it for 1 minute in water to kill it.",
                    "Move it to warm alcohol — the leaf turns pale as chlorophyll washes out.",
                    "Rinse it. Drop iodine onto the leaf for 30 seconds, then rinse again.",
                    "Look closely. The covered part stays pale; the rest turns blue-black."
                ],
                whyItWorks: "Iodine turns blue-black wherever starch is hiding. Sunlit parts of the leaf made starch by photosynthesis; the covered corner could not. You just photographed photosynthesis.",
                estimatedMinutes: 60
            ),
            HomeExperiment(
                id: "ch01_exp_celery_xylem",
                emoji: "💧",
                title: "Coloured-water celery — xylem in action",
                needs: [
                    "One stalk of fresh celery with leaves",
                    "A glass of water",
                    "A small bottle of red or blue food colour",
                    "A sharp knife (use it with an adult)"
                ],
                steps: [
                    "Trim 2 cm off the bottom of the celery stalk so the cut is fresh.",
                    "Pour water into the glass and add 10 drops of food colour. Stir.",
                    "Stand the celery in the coloured water with the cut end down.",
                    "Wait 3–4 hours. Check the leaves and the stalk.",
                    "Slice the stalk crossways. Count the coloured dots."
                ],
                whyItWorks: "The dots are the xylem — tiny straws that pull water up from roots to leaves using a force called capillary action plus the suction from leaves losing water. You can literally see the plant's plumbing.",
                estimatedMinutes: 240
            ),
            HomeExperiment(
                id: "ch01_exp_mimosa_clock",
                emoji: "🤚",
                title: "Mimosa pudica reaction time",
                needs: [
                    "A touch-me-not (Mimosa pudica) plant in a pot or in a garden",
                    "A stopwatch or phone timer",
                    "A pencil to gently poke"
                ],
                steps: [
                    "Sit with the plant in a quiet spot in mid-morning.",
                    "Start the timer and gently touch one leaflet with the pencil tip.",
                    "Stop the timer the moment the whole leaf has folded.",
                    "Wait 5 minutes for it to reopen, then repeat with a different leaf.",
                    "Try at 9 a.m., noon, and 4 p.m. and compare times."
                ],
                whyItWorks: "Mimosa cells at the base of each leaflet lose water in a flash when poked. The leaf collapses, hiding it from imaginary herbivores. J. C. Bose's crescograph in Calcutta a hundred years ago first recorded responses like this and proved plants can react in seconds, not days.",
                estimatedMinutes: 30
            ),
            HomeExperiment(
                id: "ch01_exp_pondscope",
                emoji: "🔬",
                title: "Spirogyra oxygen bubbles",
                needs: [
                    "A pinch of bright-green pond scum (Spirogyra) from any clean pond or fish tank",
                    "A small glass jar with water",
                    "Sunlight from a window",
                    "A magnifying glass (optional)"
                ],
                steps: [
                    "Place the green algae in the jar of water.",
                    "Stand the jar in bright direct sunlight.",
                    "Watch closely for 15 minutes — tiny silver bubbles will start to rise from the algae.",
                    "After an hour, gently push the green strands aside. The bubbles will keep coming."
                ],
                whyItWorks: "Each bubble is pure oxygen made by photosynthesis. The same gas you are breathing right now was made — over hundreds of millions of years — by green cells just like these. You are watching the air being born.",
                estimatedMinutes: 60
            ),
            HomeExperiment(
                id: "ch01_exp_root_nodules",
                emoji: "🌱",
                title: "Chickpea root nodules in a jar",
                needs: [
                    "A handful of dry kala chana or whole black gram (uncooked)",
                    "A jar with garden soil",
                    "Water",
                    "Patience for 2–3 weeks"
                ],
                steps: [
                    "Soak the chana in water overnight.",
                    "Push 4 soaked seeds into the soil about 2 cm deep, water lightly.",
                    "Keep the jar near a window. Water every 2 days.",
                    "After 2–3 weeks, gently lift out one seedling with all its roots.",
                    "Rinse the roots in a bowl. Look for tiny round bumps."
                ],
                whyItWorks: "Those bumps are root nodules. Inside each one lives a colony of Rhizobium bacteria pulling nitrogen straight out of the air and trading it to the plant for sugar. Farmers have used this trade for thousands of years — that's why crops are rotated with legumes.",
                estimatedMinutes: 60
            )
        ],
        "ch02": [
            HomeExperiment(
                id: "ch02_exp_saliva_starch",
                emoji: "🍞",
                title: "Saliva digesting starch — taste it happen",
                needs: [
                    "A small bite of plain bread (no jam, no butter)",
                    "A glass of water to rinse afterwards",
                    "A working tongue and a quiet 5 minutes"
                ],
                steps: [
                    "Take a small bite of plain bread. Don't swallow.",
                    "Chew slowly for 1 full minute.",
                    "Pay attention to the taste at 1 minute, 2 minutes, 3 minutes.",
                    "By the 3rd minute the bread tastes noticeably sweeter."
                ],
                whyItWorks: "Saliva contains an enzyme called amylase that breaks starch into maltose, a sweet sugar. You are watching the very first step of digestion happen on your own tongue.",
                estimatedMinutes: 5
            ),
            HomeExperiment(
                id: "ch02_exp_eggshell_acid",
                emoji: "🥚",
                title: "Eggshell vs vinegar (stomach acid simulator)",
                needs: [
                    "A clean raw eggshell — wash it well",
                    "A small bowl of white vinegar",
                    "24 hours of patience"
                ],
                steps: [
                    "Drop the eggshell into the bowl of vinegar.",
                    "Watch — bubbles will start rising immediately.",
                    "Leave it for 24 hours.",
                    "Lift the shell out. It will be soft, bendy, or partly gone."
                ],
                whyItWorks: "Vinegar (acetic acid) is far weaker than stomach acid (hydrochloric acid), but it still dissolves the calcium carbonate in eggshell. Your stomach makes acid 1,000 times stronger — that's why a layer of fresh mucus matters.",
                estimatedMinutes: 1440
            ),
            HomeExperiment(
                id: "ch02_exp_tongue_map_myth",
                emoji: "👅",
                title: "Bust the tongue-map myth",
                needs: [
                    "Three small cups: salt water, sugar water, lemon juice",
                    "Three cotton buds / earbuds",
                    "A mirror or a curious partner"
                ],
                steps: [
                    "Dab one bud in sugar water and touch it to the BACK of your tongue.",
                    "Notice — you taste sweet, even though textbooks say the tip handles sweet.",
                    "Repeat with salt water on the back and centre.",
                    "Try lemon juice on the tip — you'll still taste sour."
                ],
                whyItWorks: "The old tongue map (sweet-tip / sour-sides / bitter-back) is a translation error from a 1901 paper. Every taste bud detects every taste. Science updates itself when better evidence shows up.",
                estimatedMinutes: 10
            ),
            HomeExperiment(
                id: "ch02_exp_curd_making",
                emoji: "🥛",
                title: "Make curd at home — see lactic acid in action",
                needs: [
                    "1 cup of warm milk (just-warm to the wrist, not hot)",
                    "1 teaspoon of existing curd (the starter)",
                    "A bowl with a lid",
                    "A warm spot in the kitchen, overnight"
                ],
                steps: [
                    "Pour the warm milk into the bowl.",
                    "Add the spoonful of curd. Stir gently for 10 seconds.",
                    "Cover the bowl. Leave it on the kitchen counter overnight.",
                    "In the morning — solid curd."
                ],
                whyItWorks: "The bit of curd you added contained Lactobacillus bacteria. Overnight, those bacteria converted the sugar in milk (lactose) into lactic acid. Acid makes milk proteins clump — that's the solid curd you eat.",
                estimatedMinutes: 720
            ),
            HomeExperiment(
                id: "ch02_exp_stomach_rumble",
                emoji: "🥁",
                title: "Listen to your stomach's 90-minute clock",
                needs: [
                    "A quiet room, an empty stomach (2+ hours since last meal)",
                    "Optional: an ear pressed to a clean drinking glass against your belly",
                    "A notebook and a clock"
                ],
                steps: [
                    "Sit quietly for 5 minutes after at least 2 hours of not eating.",
                    "Listen for low gurgles or rumbles from your stomach.",
                    "Note the time when you hear them.",
                    "Wait. Listen again at 30 minutes, 60, and 90 minutes."
                ],
                whyItWorks: "When your stomach is empty, it contracts in waves about every 90 minutes — the Migrating Motor Complex. The waves sweep crumbs and bacteria through to the small intestine. Your gut has its own clock, all by itself.",
                estimatedMinutes: 120
            )
        ]
    ]

    /// The experiments are all hardcoded SCIENCE content keyed by bare `chNN`
    /// chapter ids. Maths AND Sanskrit reuse those same ids, so the lookup
    /// MUST be gated on the subject — otherwise the Science iodine-leaf test
    /// leaks into Maths Ch.1 / Sanskrit Ch.1. Pure + testable
    /// (`HomeExperimentSubjectGateTests`); the surfacing in ChapterDetailView
    /// routes through here so the gate can't diverge.
    static func hasExperiments(forPackId packId: String, chapterId: String) -> Bool {
        guard packId == "science_class7" else { return false }
        guard let list = experiments[chapterId] else { return false }
        return !list.isEmpty
    }

    /// Per-chapter Try-at-Home count (drives the card's "N experiments" label).
    static func count(forChapterId chapterId: String) -> Int {
        (experiments[chapterId] ?? []).count
    }

    /// Per-chapter Try-at-Home subtitle, derived from the actual experiment
    /// titles (no hand-authored copy — so it can't drift from the content).
    /// Falls back to the generic line if a chapter has none.
    static func subtitle(forChapterId chapterId: String) -> String {
        let titles = (experiments[chapterId] ?? []).map { $0.title }
        guard let first = titles.first else {
            return "Hands-on experiments you can try this weekend."
        }
        if titles.count == 1 { return first + "." }
        return first + ", and \(titles.count - 1) more to try this weekend."
    }
}

struct HomeExperimentsSheet: View {
    let chapterId: String
    let chapterTitle: String

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Try at Home")
                        .font(.title2.bold())
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    Text(chapterTitle)
                        .font(.subheadline)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }
                Spacer()
                Button("Close") { presentationMode.wrappedValue.dismiss() }
                    .keyboardShortcut(.cancelAction)
            }
            .padding(20)
            .background(Color.white.opacity(0.5))

            Divider()

            ScrollView {
                LazyVStack(spacing: 14) {
                    if let list = HomeExperimentLibrary.experiments[chapterId] {
                        ForEach(list) { exp in
                            HomeExperimentCard(experiment: exp)
                        }
                    } else {
                        VStack(spacing: 10) {
                            Text("🧪").font(.system(size: 56))
                            Text("No home experiments yet")
                                .font(.title3.bold())
                                .foregroundColor(DesignTokens.BrandColor.canvasText)
                            Text("We are adding hands-on activities chapter by chapter. Check back soon.")
                                .font(.callout)
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(40)
                    }
                }
                .padding(20)
                .frame(maxWidth: 720)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .frame(minWidth: 640, minHeight: 540)
    }
}

struct HomeExperimentCard: View {
    let experiment: HomeExperiment
    @State private var expanded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) { expanded.toggle() }
            } label: {
                HStack(spacing: 12) {
                    Text(experiment.emoji).font(.system(size: 28))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(experiment.title)
                            .font(.headline)
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                            .multilineTextAlignment(.leading)
                        Text("\u{2248} \(experiment.estimatedMinutes) min")
                            .font(.caption)
                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    }
                    Spacer()
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .font(.callout)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }
                .padding(14)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if expanded {
                VStack(alignment: .leading, spacing: 14) {
                    Divider()

                    Group {
                        Text("What you'll need")
                            .font(.subheadline.bold())
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                        ForEach(experiment.needs.indices, id: \.self) { idx in let item = experiment.needs[idx];
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                Text(item).multilineTextAlignment(.leading)
                            }
                            .font(.callout)
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                        }
                    }

                    Group {
                        Text("What you'll do")
                            .font(.subheadline.bold())
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                        ForEach(experiment.steps.indices, id: \.self) { idx in let step = experiment.steps[idx];
                            HStack(alignment: .top, spacing: 8) {
                                Text("\(idx + 1).")
                                    .frame(width: 22, alignment: .trailing)
                                Text(step).multilineTextAlignment(.leading)
                            }
                            .font(.callout)
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                        }
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Why it works")
                            .font(.subheadline.bold())
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                        Text(experiment.whyItWorks)
                            .font(.callout)
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.compatIndigo.opacity(0.10))
                    )
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 14)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(Color.gray.opacity(0.15), lineWidth: 1)
        )
    }
}
