import SwiftUI

struct DiscoverChapter15View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(15)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Mirror Mirror",
        "Concave & Convex",
        "Refraction Pool",
        "Prism & Rainbow",
        "Lens Workshop",
        "Periscope Builder",
        "Mirrors in Real Life",
        "Kaleidoscope",
        "Light Travels in Straight Lines",
        "Pinhole Camera Builder",
        "Eye Anatomy Map",
        "Colour Wheel Mix",
        "Why Sky is Blue",
        "Lunar & Solar Eclipse",
        "Reflection Angle Slider",
        "Mirror Image Symmetry",
        "Fibre Optic Light Pipe",
        "Camera vs Eye",
        "Light Quiz",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 15 — Light",
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
            { AnyView(Scene1_MirrorMirror(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(0) })) },
            { AnyView(Scene2_ConcaveConvex(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(1) })) },
            { AnyView(Scene3_RefractionPool(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(2) })) },
            { AnyView(Scene4_PrismRainbow(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(3) })) },
            { AnyView(Scene5_LensWorkshop(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(4) })) },
            { AnyView(Scene6_PeriscopeBuilder(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(5) })) },
            { AnyView(Scene7_MirrorsInRealLife(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(6, score: score, max: 3) })) },
            { AnyView(Scene8_Kaleidoscope(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(7) })) },
            { AnyView(LightStraightLinesScene(onComplete: { self.markComplete(8) })) },
            { AnyView(PinholeCameraScene(onComplete: { self.markComplete(9) })) },
            { AnyView(EyeAnatomyScene(onComplete: { self.markComplete(10) })) },
            { AnyView(ColourWheelMixScene(onComplete: { self.markComplete(11) })) },
            { AnyView(WhySkyBlueScene(onComplete: { self.markComplete(12) })) },
            { AnyView(EclipseScene(onComplete: { self.markComplete(13) })) },
            { AnyView(ReflectionAngleScene(onComplete: { self.markComplete(14) })) },
            { AnyView(MirrorSymmetryScene(onComplete: { self.markComplete(15) })) },
            { AnyView(FibreOpticScene(onComplete: { self.markComplete(16) })) },
            { AnyView(CameraVsEyeScene(onComplete: { self.markComplete(17) })) },
            { AnyView(QuickCheckQuizScene(
                title: "Light Quiz",
                questions: Array(self.chapter.quickCheckQuestionsList.prefix(4)),
                onComplete: { score in self.markComplete(18, score: score, max: 4) }
            )) },
            { AnyView(Scene9_BossQuiz_Ch15(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(19, score: score, max: 10) })) }
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

// MARK: - Inline scenes for Ch.15

private struct LightStraightLinesScene: View {
    let onComplete: () -> Void
    @State private var blocked: Bool = false
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Light Travels in Straight Lines").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ZStack {
                Image(systemName: "lightbulb.fill").font(.system(size: 40))
                    .foregroundColor(DesignTokens.BrandColor.mnemonicAccent).offset(x: -120)
                if !blocked {
                    Rectangle().fill(DesignTokens.BrandColor.mnemonicAccent.opacity(0.4))
                        .frame(width: 200, height: 6)
                }
                if blocked {
                    Rectangle().fill(Color.gray).frame(width: 8, height: 80).offset(x: 0)
                    Rectangle().fill(DesignTokens.BrandColor.mnemonicAccent.opacity(0.4))
                        .frame(width: 80, height: 6).offset(x: -50)
                }
                Image(systemName: "eye").font(.system(size: 30))
                    .foregroundColor(DesignTokens.BrandColor.canvasText).offset(x: 120)
            }
            .frame(height: 100)
            Button { withAnimation { blocked.toggle() } } label: {
                Text(blocked ? "Remove block" : "Put a block").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            Text(blocked
                 ? "Light can't bend around — it's stopped. That's how shadows form."
                 : "Light from source reaches eye unobstructed.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct PinholeCameraScene: View {
    let onComplete: () -> Void
    @State private var step: Int = 0
    private let steps = [
        ("📦", "Take a cardboard box. Make a tiny hole on one wall."),
        ("🕯", "Put a bright candle in front of the hole."),
        ("📸", "On the back wall (translucent paper), you see an INVERTED image."),
        ("🔄", "Light from candle's top reaches paper's bottom. From bottom reaches top. Hence upside down.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Build a Pinhole Camera").font(.largeTitle.bold())
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

private struct EyeAnatomyScene: View {
    let onComplete: () -> Void
    @State private var part: String? = nil
    private struct E: Identifiable { let id: String; let name: String; let detail: String }
    private let parts: [E] = [
        E(id: "cornea", name: "Cornea", detail: "Clear dome at the front. Does 80% of the focusing work."),
        E(id: "iris", name: "Iris", detail: "Coloured ring. Muscle that adjusts pupil size."),
        E(id: "pupil", name: "Pupil", detail: "Black hole — actually just the opening. Bigger in dim light."),
        E(id: "lens", name: "Lens", detail: "Adjustable focus. Squishes flat for far, fattens for near."),
        E(id: "retina", name: "Retina", detail: "Light-sensitive screen at the back. Sends signal to brain."),
        E(id: "optic", name: "Optic nerve", detail: "Cable carrying signals to the visual cortex.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Eye Anatomy Map").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("👁").font(.system(size: 90))
            ForEach(parts) { p in
                Button { part = p.id } label: {
                    HStack {
                        Text(p.name).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                        Spacer()
                    }
                    .padding(12).frame(maxWidth: DesignTokens.contentMaxWidth)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(part == p.id ? Color.compatIndigo.opacity(0.12) : Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                }.buttonStyle(.plain).pointingCursor().padding(.horizontal, 24)
            }
            if let s = part, let p = parts.first(where: { $0.id == s }) {
                Text(p.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
            }
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct ColourWheelMixScene: View {
    let onComplete: () -> Void
    @State private var red: Double = 1
    @State private var green: Double = 1
    @State private var blue: Double = 1
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Mix the Light, Get the Colour").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Circle().fill(Color(red: red, green: green, blue: blue))
                .frame(width: 140, height: 140)
                .overlay(Circle().strokeBorder(Color.gray, lineWidth: 1))
            Text("Red").font(.caption).foregroundColor(.secondary)
            Slider(value: $red, in: 0...1).frame(maxWidth: 340).padding(.horizontal, 24)
            Text("Green").font(.caption).foregroundColor(.secondary)
            Slider(value: $green, in: 0...1).frame(maxWidth: 340).padding(.horizontal, 24)
            Text("Blue").font(.caption).foregroundColor(.secondary)
            Slider(value: $blue, in: 0...1).frame(maxWidth: 340).padding(.horizontal, 24)
            Text("Red + Green + Blue = White light. Your screen makes every colour by mixing just these three.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct WhySkyBlueScene: View {
    let onComplete: () -> Void
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Why is the Sky Blue?").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            LinearGradient(colors: [Color.compatIndigo.opacity(0.5), Color.compatIndigo.opacity(0.9)],
                          startPoint: .top, endPoint: .bottom)
                .frame(width: 220, height: 140).cornerRadius(14)
            Text("Sunlight is white = all colours mixed. When it hits Earth's atmosphere, blue light scatters in all directions more than red does (because blue's shorter wavelength). Whichever direction you look, blue light is bouncing toward you.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            Text("At sunrise/sunset, the path through air is longer — blue scatters away, red+orange make it through. That's why sunsets glow orange.")
                .font(.caption.italic()).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .padding(.horizontal, 24).multilineTextAlignment(.center)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct EclipseScene: View {
    let onComplete: () -> Void
    @State private var solar: Bool = true
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Solar & Lunar Eclipses").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 14) {
                pickChip("Solar", on: solar) { solar = true }
                pickChip("Lunar", on: !solar) { solar = false }
            }
            Text(solar ? "🌑☀️" : "🌍🌑").font(.system(size: 80))
            Text(solar
                 ? "Solar eclipse: Moon comes between Sun and Earth. Moon's shadow falls on Earth. Daytime sky goes dark. Happens at new moon."
                 : "Lunar eclipse: Earth comes between Sun and Moon. Earth's shadow falls on the Moon. Moon turns dim red. Happens at full moon.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
    private func pickChip(_ label: String, on: Bool, tap: @escaping () -> Void) -> some View {
        Button(action: tap) {
            Text(label).font(.body.weight(on ? .bold : .regular))
                .padding(.horizontal, 18).padding(.vertical, 9)
                .background(Capsule().fill(on ? Color.compatIndigo.opacity(0.18) : Color.gray.opacity(0.08)))
                .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                .foregroundColor(Color.compatIndigo)
        }.buttonStyle(.plain).pointingCursor()
    }
}

private struct ReflectionAngleScene: View {
    let onComplete: () -> Void
    @State private var angle: Double = 45
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Reflection — Angle In = Angle Out").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            let incomingAngle: Double = -(90 - angle)
            let outgoingAngle: Double = 90 - angle
            ZStack {
                Rectangle().fill(Color.gray).frame(width: 240, height: 4).offset(y: 80)
                Rectangle().fill(DesignTokens.BrandColor.mnemonicAccent.opacity(0.6))
                    .frame(width: 140, height: 3)
                    .rotationEffect(.degrees(incomingAngle), anchor: .trailing)
                    .offset(x: -40, y: 30)
                Rectangle().fill(DesignTokens.BrandColor.danger.opacity(0.6))
                    .frame(width: 140, height: 3)
                    .rotationEffect(.degrees(outgoingAngle), anchor: .leading)
                    .offset(x: 40, y: 30)
            }
            .frame(height: 180)
            Text("\(Int(angle))°").font(.title2.monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Slider(value: $angle, in: 10...80).frame(maxWidth: 340).padding(.horizontal, 24)
            Text("Whatever angle the light comes in at (yellow), it bounces off at the same angle on the other side (red). Law of reflection.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct MirrorSymmetryScene: View {
    let onComplete: () -> Void
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Mirror Image — Left ↔ Right Swap").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 0) {
                Text("AMBULANCE").font(.system(size: 28, weight: .bold))
                Rectangle().fill(Color.gray).frame(width: 2)
                Text("AMBULANCE").font(.system(size: 28, weight: .bold))
                    .scaleEffect(x: -1, y: 1)
            }
            .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("The word AMBULANCE on the front of ambulances is mirror-written so when drivers see it in their rear-view mirror, they read it correctly and pull over.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct FibreOpticScene: View {
    let onComplete: () -> Void
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Fibre Optics — Light in a Pipe").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("💡→🌐").font(.system(size: 100))
            Text("Thin glass strands carry light by total internal reflection. The light bounces along the inside walls without escaping. Used for internet cables — your YouTube videos travel as flashes of light through ocean-floor fibres.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct CameraVsEyeScene: View {
    let onComplete: () -> Void
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Camera vs Human Eye").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 30) {
                VStack { Text("📷").font(.system(size: 70)); Text("Camera").font(.caption) }
                VStack { Text("👁").font(.system(size: 70)); Text("Eye").font(.caption) }
            }
            .foregroundColor(DesignTokens.BrandColor.canvasText)
            VStack(alignment: .leading, spacing: 6) {
                Text("Lens → focuses light on a sensor / retina.").font(.callout)
                Text("Aperture / pupil → controls how much light enters.").font(.callout)
                Text("Shutter / eyelid → opens to expose, closes to rest.").font(.callout)
                Text("Memory card / brain → stores the image.").font(.callout)
            }
            .foregroundColor(DesignTokens.BrandColor.canvasText)
            .padding(14).frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
            .padding(.horizontal, 24)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

