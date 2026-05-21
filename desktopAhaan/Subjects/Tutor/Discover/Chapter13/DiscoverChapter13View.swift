import SwiftUI

struct DiscoverChapter13View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(13)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Fast or Slow?",
        "Pendulum Lab",
        "Distance–Time Graph",
        "Speedometer & Odometer",
        "Uniform vs Non-Uniform",
        "Sundial",
        "Stopwatch Race",
        "Units of Time",
        "Speed Formula Lab",
        "World Records Atlas",
        "Atomic Clock Story",
        "Time Zones Wheel",
        "Galileo's Pendulum Story",
        "Quartz Watch Inside",
        "Lap Timer Mini-Game",
        "Relative Motion Train",
        "Speed Limits Quiz",
        "Average vs Instantaneous Speed",
        "Motion Quiz",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 13 — Motion and Time",
            sceneTitles: sceneTitles,
            currentScene: $currentScene,
            scene: sceneBody
        )
        // Defensive (2026-05-21): a stale @AppStorage value from before
        // a scene-count change could point past sceneTitles.count - 1.
        // sceneBody guards out-of-range by returning EmptyView, but a
        // blank canvas reads as a crash to the kid. Force a valid index
        // on every appearance.
        .onAppear {
            let maxIndex = sceneTitles.count - 1
            if currentScene < 0 || currentScene > maxIndex {
                currentScene = max(0, min(currentScene, maxIndex))
            }
        }
    }
    private func sceneBody(_ index: Int) -> AnyView {
        guard index >= 0 && index < sceneBuilders.count else { return AnyView(EmptyView()) }
        return sceneBuilders[index]()
    }

    private var sceneBuilders: [() -> AnyView] {
        [
            { AnyView(Scene1_FastOrSlow(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(0, score: score, max: 4) })) },
            { AnyView(Scene2_PendulumLab(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(1) })) },
            { AnyView(Scene3_DistanceTimeGraph(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(2) })) },
            { AnyView(Scene4_SpeedometerOdometer(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(3) })) },
            { AnyView(Scene5_UniformNonUniform(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(4, score: score, max: 4) })) },
            { AnyView(Scene6_Sundial(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(5) })) },
            { AnyView(Scene7_StopwatchRace(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(6) })) },
            { AnyView(Scene8_UnitsOfTime(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(7) })) },
            { AnyView(SpeedFormulaLabScene(onComplete: { self.markComplete(8) })) },
            { AnyView(WorldRecordsAtlasScene(onComplete: { self.markComplete(9) })) },
            { AnyView(AtomicClockStoryScene(onComplete: { self.markComplete(10) })) },
            { AnyView(TimeZonesWheelScene(onComplete: { self.markComplete(11) })) },
            { AnyView(GalileoPendulumScene(onComplete: { self.markComplete(12) })) },
            { AnyView(QuartzWatchScene(onComplete: { self.markComplete(13) })) },
            { AnyView(LapTimerScene(onComplete: { self.markComplete(14) })) },
            { AnyView(RelativeMotionTrainScene(onComplete: { self.markComplete(15) })) },
            { AnyView(SpeedLimitsQuizScene(onComplete: { score in self.markComplete(16, score: score, max: 4) })) },
            { AnyView(AvgVsInstantSpeedScene(onComplete: { self.markComplete(17) })) },
            { AnyView(MotionQuizScene(onComplete: { score in self.markComplete(18, score: score, max: 4) })) },
            { AnyView(Scene9_BossQuiz_Ch13(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(19, score: score, max: 10) })) }
        ]
    }

    private func markComplete(_ index: Int, score: Int? = nil, max: Int? = nil) {
        let id = "scene\(index + 1)"
        dataStore.markSceneComplete(chapterId: chapter.id, sceneId: id, score: score, maxScore: max)
        if index < sceneTitles.count - 1 {
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 400_000_000)
                advanceDiscoverScene($currentScene, total: sceneTitles.count, reduceMotion: reduceMotion)
            }
        }
    }
}

// MARK: - Inline scenes for Ch.13

private struct SpeedFormulaLabScene: View {
    let onComplete: () -> Void
    @State private var distance: Double = 100
    @State private var time: Double = 10
    private var speed: Double { distance / time }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Speed = Distance ÷ Time").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            VStack(spacing: 4) {
                Text("\(Int(distance)) m").font(.title.monospacedDigit())
                Text("÷").font(.title2).foregroundColor(.secondary)
                Text("\(Int(time)) s").font(.title.monospacedDigit())
                Text("=").font(.title2).foregroundColor(.secondary)
                Text("\(String(format: "%.1f", speed)) m/s").font(.system(size: 50, weight: .bold).monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.primaryAction)
            }
            .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Distance (m)").font(.caption).foregroundColor(.secondary)
            Slider(value: $distance, in: 10...1000).frame(maxWidth: 340).padding(.horizontal, 24)
            Text("Time (s)").font(.caption).foregroundColor(.secondary)
            Slider(value: $time, in: 1...60).frame(maxWidth: 340).padding(.horizontal, 24)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct WorldRecordsAtlasScene: View {
    let onComplete: () -> Void
    @State private var tapped: Set<String> = []
    private struct R: Identifiable { let id: String; let emoji: String; let title: String; let detail: String }
    private let records: [R] = [
        R(id: "bolt", emoji: "🏃", title: "100 m sprint — Usain Bolt", detail: "9.58 seconds. Top speed ~44 km/h. Set 2009 Berlin."),
        R(id: "cheetah", emoji: "🐆", title: "Land speed — Cheetah", detail: "112 km/h in short bursts. Fastest land animal."),
        R(id: "falcon", emoji: "🦅", title: "Air speed — Peregrine Falcon", detail: "390 km/h diving. Fastest creature on Earth."),
        R(id: "snail", emoji: "🐌", title: "Slow record — Garden Snail", detail: "Top speed 1.3 cm/s. Reached 0.0476 km/h in a competitive race.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("World Speed Records").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(records) { r in
                Button { tapped.insert(r.id) } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack { Text(r.emoji).font(.title2)
                            Text(r.title).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText) }
                        if tapped.contains(r.id) {
                            Text(r.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            Text("Tap to reveal").font(.caption.italic())
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        }
                    }.padding(12).frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                }.buttonStyle(.plain).pointingCursor().padding(.horizontal, 24)
            }
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct AtomicClockStoryScene: View {
    let onComplete: () -> Void
    @State private var step: Int = 0
    private let steps = [
        ("⌛", "Ancient: water clocks + sundials — accurate to ~minutes per day."),
        ("⏰", "1500s: pendulum clocks — accurate to ~seconds per day."),
        ("⌚", "1969: quartz watches — accurate to ~1 second per month."),
        ("🔬", "Modern: atomic clocks — accurate to ~1 second in 100 million years!")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Atomic Clocks — Modern Timekeeping").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text(steps[step].0).font(.system(size: 100))
            Text(steps[step].1).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            Button { withAnimation { step = (step + 1) % steps.count } } label: {
                Text("Next").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct TimeZonesWheelScene: View {
    let onComplete: () -> Void
    @State private var offset: Double = 0
    private var time: String {
        let hour = (12 + Int(offset) + 24) % 24
        return String(format: "%02d:00", hour)
    }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("World Time Zones").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Earth rotates 360° in 24 hours = 15° per hour. Each 15° band is one hour different.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
            Text(time).font(.system(size: 80, weight: .bold).monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("\(offset >= 0 ? "+" : "")\(Int(offset)) hours from noon UTC")
                .font(.caption.monospacedDigit()).foregroundColor(.secondary)
            Slider(value: $offset, in: -12...12, step: 1).frame(maxWidth: 340).padding(.horizontal, 24)
            Text("India is +5:30 from UTC. China is +8. New York is -5. All decided by international agreement in 1884.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct GalileoPendulumScene: View {
    let onComplete: () -> Void
    @State private var step: Int = 0
    private let steps = [
        ("🏛", "1583: 19-year-old Galileo, bored in church, watched a chandelier sway."),
        ("⏱", "He timed the swings using his pulse — and discovered each swing took the same time, no matter how wide."),
        ("🎯", "This 'isochronism' inspired the first accurate pendulum clocks 75 years later."),
        ("🌍", "Now we know pendulum period depends only on length + gravity. Mass + amplitude don't matter much.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Galileo's Pendulum Discovery").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text(steps[step].0).font(.system(size: 100))
            Text(steps[step].1).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            Button { withAnimation { step = (step + 1) % steps.count } } label: {
                Text("Next").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct QuartzWatchScene: View {
    let onComplete: () -> Void
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("How a Quartz Watch Works").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("⌚").font(.system(size: 100))
            VStack(alignment: .leading, spacing: 8) {
                Text("1. Tiny battery sends electric current through a quartz crystal.").font(.callout)
                Text("2. Quartz crystal vibrates exactly 32,768 times per second.").font(.callout)
                Text("3. Electronic counter divides this down to 1 tick per second.").font(.callout)
                Text("4. Motor advances the second hand. Precise to seconds per year.").font(.callout)
            }
            .foregroundColor(DesignTokens.BrandColor.canvasText)
            .padding(14)
            .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
            .padding(.horizontal, 24)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct LapTimerScene: View {
    let onComplete: () -> Void
    @State private var elapsed: Double = 0
    @State private var laps: [Double] = []
    @State private var running: Bool = false
    /// Generation counter — bumped on stop() and onDisappear so any
    /// stale Task started by a previous start() exits its loop instead
    /// of ticking on after the scene is dismissed.
    @State private var generation: Int = 0
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Lap Timer Mini-Game").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text(String(format: "%.1f s", elapsed))
                .font(.system(size: 60, weight: .bold).monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            HStack(spacing: 14) {
                Button { running ? stop() : start() } label: {
                    Text(running ? "Stop" : "Start").font(.body.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(Capsule().fill((running ? DesignTokens.BrandColor.danger : DesignTokens.BrandColor.primaryAction).opacity(0.18)))
                        .overlay(Capsule().strokeBorder((running ? DesignTokens.BrandColor.danger : DesignTokens.BrandColor.primaryAction).opacity(0.5), lineWidth: 1))
                        .foregroundColor(running ? DesignTokens.BrandColor.danger : DesignTokens.BrandColor.primaryAction)
                }.buttonStyle(.plain).pointingCursor()
                Button { lap() } label: {
                    Text("Lap").font(.body.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(Capsule().fill(Color.compatIndigo.opacity(0.18)))
                        .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.5), lineWidth: 1))
                        .foregroundColor(Color.compatIndigo)
                }.buttonStyle(.plain).pointingCursor().disabled(!running)
            }
            ForEach(Array(laps.enumerated()), id: \.offset) { idx, lap in
                Text("Lap \(idx + 1): \(String(format: "%.1f", lap)) s")
                    .font(.caption.monospacedDigit()).foregroundColor(.secondary)
            }
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
        .onDisappear { running = false; generation += 1 }
    }
    private func start() {
        elapsed = 0; laps = []; running = true
        generation += 1
        let myGen = generation
        Task { @MainActor in
            while running && elapsed < 600 && myGen == generation {
                try? await Task.sleep(nanoseconds: 100_000_000)
                if myGen != generation || !running { break }
                elapsed += 0.1
            }
        }
    }
    private func stop() { running = false; generation += 1 }
    private func lap() { laps.append(elapsed) }
}

private struct RelativeMotionTrainScene: View {
    let onComplete: () -> Void
    @State private var inside: Bool = false
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Are You Moving? Depends on Who's Looking").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 14) {
                pickChip("Outside observer", on: !inside) { inside = false }
                pickChip("Inside the train", on: inside) { inside = true }
            }
            Text("🚂").font(.system(size: 90))
            Text(inside
                 ? "From inside the train: the seat next to you is stationary. The pole outside is racing backwards."
                 : "From the station platform: the train is moving forward at 80 km/h. The pole next to you is stationary.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            Text("Motion is RELATIVE — there's no absolute 'still' frame. Einstein built relativity on this idea.")
                .font(.caption.italic()).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .padding(.horizontal, 24).multilineTextAlignment(.center)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
    private func pickChip(_ label: String, on: Bool, tap: @escaping () -> Void) -> some View {
        Button(action: tap) {
            Text(label).font(.body.weight(on ? .bold : .regular))
                .padding(.horizontal, 14).padding(.vertical, 8)
                .background(Capsule().fill(on ? Color.compatIndigo.opacity(0.18) : Color.gray.opacity(0.08)))
                .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                .foregroundColor(Color.compatIndigo)
        }.buttonStyle(.plain).pointingCursor()
    }
}

private struct SpeedLimitsQuizScene: View {
    let onComplete: (Int) -> Void
    private struct Q: Identifiable {
        let id: String; let prompt: String; let opts: [String]; let correct: Int
    }
    private let qs: [Q] = [
        Q(id: "q1", prompt: "Typical speed limit on an Indian city road?",
          opts: ["10 km/h", "50 km/h", "200 km/h"], correct: 1),
        Q(id: "q2", prompt: "On a national highway, India allows up to:",
          opts: ["20 km/h", "100 km/h", "500 km/h"], correct: 1),
        Q(id: "q3", prompt: "Speed in school zones is typically capped at:",
          opts: ["25 km/h", "100 km/h", "150 km/h"], correct: 0),
        Q(id: "q4", prompt: "Vande Bharat express train top speed?",
          opts: ["50 km/h", "180 km/h", "1000 km/h"], correct: 1)
    ]
    @State private var picks: [String: Int] = [:]
    private var score: Int { qs.reduce(0) { $0 + ((picks[$1.id] == $1.correct) ? 1 : 0) } }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Speed Limits Quiz").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(qs) { q in qCard(q) }
            if picks.count == qs.count {
                Text("Score: \(score) / \(qs.count)").font(.headline)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            GotItButton(action: { onComplete(score) }).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
    @ViewBuilder
    private func qCard(_ q: Q) -> some View {
        let pick = picks[q.id]
        VStack(alignment: .leading, spacing: 8) {
            Text(q.prompt).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
            ForEach(0..<q.opts.count, id: \.self) { i in
                let isPicked = pick == i
                let tint: Color = pick == nil
                    ? Color.compatIndigo
                    : (isPicked ? (i == q.correct ? DesignTokens.BrandColor.primaryAction : DesignTokens.BrandColor.danger) : Color.gray)
                Button {
                    if picks[q.id] == nil { picks[q.id] = i }
                } label: {
                    Text(q.opts[i]).font(.caption.weight(.semibold))
                        .padding(.horizontal, 10).padding(.vertical, 6)
                        .background(Capsule().fill(tint.opacity(isPicked ? 0.22 : 0.10)))
                        .overlay(Capsule().strokeBorder(tint.opacity(0.5), lineWidth: 1))
                        .foregroundColor(tint)
                }.buttonStyle(.plain).pointingCursor().disabled(pick != nil)
            }
        }
        .padding(12).frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
        .padding(.horizontal, 24)
    }
}

private struct AvgVsInstantSpeedScene: View {
    let onComplete: () -> Void
    @State private var avg: Bool = true
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Average vs Instantaneous Speed").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 14) {
                pickChip("Average", on: avg) { avg = true }
                pickChip("Instantaneous", on: !avg) { avg = false }
            }
            Text(avg
                 ? "Average speed: total distance ÷ total time. Mumbai→Pune 150 km in 3 hours = 50 km/h average. You sat at traffic too, ate lunch, etc."
                 : "Instantaneous speed: what the speedometer reads RIGHT NOW. Could be 0 (stopped) or 100 (overtaking on highway) — varies moment to moment.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.leading).padding(14)
                .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                .padding(.horizontal, 24)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
    private func pickChip(_ label: String, on: Bool, tap: @escaping () -> Void) -> some View {
        Button(action: tap) {
            Text(label).font(.body.weight(on ? .bold : .regular))
                .padding(.horizontal, 14).padding(.vertical, 8)
                .background(Capsule().fill(on ? Color.compatIndigo.opacity(0.18) : Color.gray.opacity(0.08)))
                .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                .foregroundColor(Color.compatIndigo)
        }.buttonStyle(.plain).pointingCursor()
    }
}

private struct MotionQuizScene: View {
    let onComplete: (Int) -> Void
    private struct Q: Identifiable {
        let id: String; let prompt: String; let opts: [String]; let correct: Int
    }
    private let qs: [Q] = [
        Q(id: "q1", prompt: "If a car goes 60 km in 2 hours, speed is:",
          opts: ["30 km/h", "60 km/h", "120 km/h"], correct: 0),
        Q(id: "q2", prompt: "What instrument measures total distance driven?",
          opts: ["Speedometer", "Odometer", "Pedometer"], correct: 1),
        Q(id: "q3", prompt: "Pendulum period depends MOST on:",
          opts: ["Mass of bob", "Length of string", "Colour of string"], correct: 1),
        Q(id: "q4", prompt: "1 minute = how many seconds?",
          opts: ["10", "60", "100"], correct: 1)
    ]
    @State private var picks: [String: Int] = [:]
    private var score: Int { qs.reduce(0) { $0 + ((picks[$1.id] == $1.correct) ? 1 : 0) } }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Motion & Time Quiz").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(qs) { q in qCard(q) }
            if picks.count == qs.count {
                Text("Score: \(score) / \(qs.count)").font(.headline)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            GotItButton(action: { onComplete(score) }).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
    @ViewBuilder
    private func qCard(_ q: Q) -> some View {
        let pick = picks[q.id]
        VStack(alignment: .leading, spacing: 8) {
            Text(q.prompt).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
            ForEach(0..<q.opts.count, id: \.self) { i in
                let isPicked = pick == i
                let tint: Color = pick == nil
                    ? Color.compatIndigo
                    : (isPicked ? (i == q.correct ? DesignTokens.BrandColor.primaryAction : DesignTokens.BrandColor.danger) : Color.gray)
                Button {
                    if picks[q.id] == nil { picks[q.id] = i }
                } label: {
                    Text(q.opts[i]).font(.caption.weight(.semibold))
                        .padding(.horizontal, 10).padding(.vertical, 6)
                        .background(Capsule().fill(tint.opacity(isPicked ? 0.22 : 0.10)))
                        .overlay(Capsule().strokeBorder(tint.opacity(0.5), lineWidth: 1))
                        .foregroundColor(tint)
                }.buttonStyle(.plain).pointingCursor().disabled(pick != nil)
            }
        }
        .padding(12).frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
        .padding(.horizontal, 24)
    }
}
