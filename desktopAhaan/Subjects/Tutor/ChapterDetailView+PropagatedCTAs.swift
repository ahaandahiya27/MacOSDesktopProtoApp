import SwiftUI
import AppKit

// MARK: - ChapterDetailView + propagated pilot CTAs
//
// Hosts every chapter-specific CTA the 2026-05-24 Surface 2 / 3
// propagation added (concept-map CTA + 6 tour CTAs + the Ch.1 pilot
// CTAs). Lifted out of ChapterDetailView during the coordinator
// refactor so the parent file lands back under the 600-LOC Big Sur
// type-checker ceiling.
//
// Pattern: every CTA is a free function returning `some View`,
// taking `(chapter, coordinator)`. The button's tap closure routes
// through `coordinator.presentDeferred(...)` — the same one-tick
// runloop defer that the inline implementation used to do via
// `DispatchQueue.main.async { presentedSheet = ... }`.
//
// All visuals share `Ch1PilotCTACard` (defined in
// `ChapterDetailView+Ch1Pilot.swift`). Each CTA defines its own
// gradient + title + subtitle + a11y strings — those stay close to
// the per-chapter editorial decisions they encode.
//
// Big Sur compat:
//   - Plain `Button { ... } label: { ... }` — macOS 10.15+ baseline.
//   - All animation paths are inherited from `Ch1PilotCTACard`
//     (static visual; no transitions on the card itself).
//   - No `.foregroundStyle`, no `@Observable`, no Canvas.
//   - SF Symbol literals are passed as strings to `Ch1PilotCTACard`
//     which routes them through `SFSymbolCompat.name(_:)`.

// MARK: - Subject gate (single source of truth)

/// The pilot Build-A-* sandboxes and Inside-the-* tours are hardcoded
/// SCIENCE content. Maths and Sanskrit packs reuse the same `chNN` chapter
/// ids, so the mount gate MUST key on the SUBJECT (pack id), not the chapter
/// id alone — otherwise e.g. Build-A-Plant (Science Ch.1) leaks into Maths
/// Ch.1. Pure + non-isolated so `PilotInteractiveSubjectGateTests` can pin it
/// across every (pack, chapter) pair, and the @ViewBuilder mounts below all
/// route through it so the gate can't silently diverge.
func pilotInteractivesAreEnabled(forPackId packId: String) -> Bool {
    packId == "science_class7"
}

// MARK: - Ch.1 pilot mounts

/// Ch.1 pilot — the original five-surface pilot. The gate is the
/// leak-prevention point: every other chapter sees `EmptyView` here,
/// preserving pixel + structural parity guarded by
/// `Ch2_19_StructuralRatchetTests`. These widgets are hardcoded SCIENCE
/// content, so the gate MUST check `pack.id` too — Maths/Sanskrit chapters
/// reuse the same `chNN` ids, and without the pack check the Build-A-Plant
/// sandbox + Inside-the-Leaf tour leaked into Maths Ch.1 / Sanskrit Ch.1.
/// The concept-map CTA used to mount here; it now lives in the
/// chapter-agnostic `conceptMapCTA` (commit 21d4d42).
@ViewBuilder
func ch1PilotInteractives(
    pack: SubjectPack,
    chapter: Chapter,
    coordinator: PilotInteractiveSheetCoordinator
) -> some View {
    if pilotInteractivesAreEnabled(forPackId: pack.id), chapter.id == "ch01" {
        BuildAPlantSandbox(chapterId: chapter.id)
        insideTheLeafTourCTA(coordinator: coordinator)
    }
}

// MARK: - Per-chapter propagated CTAs

/// Per-chapter Surface-2 / Surface-3 mounts propagated from the
/// Ch.1 pilot (2026-05-24). These are all hardcoded SCIENCE sandboxes /
/// tours, so they gate on `pack.id == "science_class7"` FIRST — the
/// `chNN` chapter ids collide across packs, so without the pack check
/// every sandbox/tour leaked into the matching Maths (and Sanskrit Ch.1)
/// chapter. Split into A/B sub-groups so each Group stays under the
/// 10-child @ViewBuilder cap on Big Sur.
@ViewBuilder
func propagatedPilotInteractives(
    pack: SubjectPack,
    chapter: Chapter,
    coordinator: PilotInteractiveSheetCoordinator
) -> some View {
    propagatedPilotInteractivesA(pack: pack, chapter: chapter, coordinator: coordinator)
    propagatedPilotInteractivesB(pack: pack, chapter: chapter, coordinator: coordinator)
}

@ViewBuilder
private func propagatedPilotInteractivesA(
    pack: SubjectPack,
    chapter: Chapter,
    coordinator: PilotInteractiveSheetCoordinator
) -> some View {
    if pilotInteractivesAreEnabled(forPackId: pack.id) {
        if chapter.id == "ch02" {
            insideTheDigestiveTourCTA(coordinator: coordinator)
        } else if chapter.id == "ch04" {
            BuildAHeatFlowSandbox(chapterId: chapter.id)
        } else if chapter.id == "ch05" {
            BuildAPHSandbox(chapterId: chapter.id)
        } else if chapter.id == "ch06" {
            BuildAReactionSandbox(chapterId: chapter.id)
        } else if chapter.id == "ch07" {
            BuildAClimateSandbox(chapterId: chapter.id)
        } else if chapter.id == "ch08" {
            BuildAWindSandbox(chapterId: chapter.id)
        } else if chapter.id == "ch09" {
            BuildASoilSandbox(chapterId: chapter.id)
        }
    }
}

@ViewBuilder
private func propagatedPilotInteractivesB(
    pack: SubjectPack,
    chapter: Chapter,
    coordinator: PilotInteractiveSheetCoordinator
) -> some View {
    if pilotInteractivesAreEnabled(forPackId: pack.id) {
        if chapter.id == "ch10" {
            insideTheAlveolusTourCTA(coordinator: coordinator)
        } else if chapter.id == "ch11" {
            insideTheXylemTourCTA(coordinator: coordinator)
        } else if chapter.id == "ch13" {
            BuildAMotionSandbox(chapterId: chapter.id)
        } else if chapter.id == "ch14" {
            insideTheWireTourCTA(coordinator: coordinator)
        } else if chapter.id == "ch15" {
            insideTheLensTourCTA(coordinator: coordinator)
        } else if chapter.id == "ch16" {
            BuildAWaterCycleSandbox(chapterId: chapter.id)
        }
    }
}

// MARK: - Chapter-agnostic CTA

/// Chapter-agnostic CTA card that opens ConceptMapView as a sheet.
/// Auto-hides when the chapter has no conceptMap authored. After the
/// 2026-05-24 content propagation every NCERT Class 7 chapter has a
/// concept map, so this CTA shows on all 19 chapters. The subtitle
/// quotes the actual node + edge count so the kid sees what they'll
/// get before tapping in.
@ViewBuilder
func conceptMapCTA(
    chapter: Chapter,
    coordinator: PilotInteractiveSheetCoordinator
) -> some View {
    if let map = chapter.conceptMap, !map.nodes.isEmpty {
        Button {
            coordinator.presentDeferred(.conceptMap)
        } label: {
            Ch1PilotCTACard(
                symbol: "point.3.connected.trianglepath.dotted",
                title: "See the connections",
                subtitle: "\(map.nodes.count) ideas, \(map.edges.count) links — visualise how this chapter's concepts connect, and where they reach into other chapters.",
                gradient: [
                    Color(red: 0.40, green: 0.30, blue: 0.70),
                    Color(red: 0.20, green: 0.45, blue: 0.65)
                ]
            )
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel("See the connections — concept map for this chapter")
        .accessibilityHint("Opens a sheet showing how the chapter's concepts link to each other and to other chapters.")
    }
}

// MARK: - Tour CTAs (per-chapter)

/// Ch.1 pilot — gate inside `ch1PilotInteractives` keeps this off
/// other chapters.
func insideTheLeafTourCTA(coordinator: PilotInteractiveSheetCoordinator) -> some View {
    Button {
        coordinator.presentDeferred(.insideTheLeafTour)
    } label: {
        Ch1PilotCTACard(
            symbol: "magnifyingglass.circle.fill",
            title: "Inside the Leaf",
            subtitle: "Shrink yourself to a stoma, then to a chloroplast, then to a thylakoid — five-stop guided journey.",
            gradient: [
                Color(red: 0.18, green: 0.50, blue: 0.42),
                Color(red: 0.10, green: 0.30, blue: 0.55)
            ]
        )
    }
    .buttonStyle(.plain)
    .pointingCursor()
    .accessibilityLabel("Inside the Leaf — five-stop guided tour")
    .accessibilityHint("Opens a sheet that walks you through a leaf from outside to inside a chloroplast.")
}

func insideTheDigestiveTourCTA(coordinator: PilotInteractiveSheetCoordinator) -> some View {
    Button {
        coordinator.presentDeferred(.insideTheDigestiveTour)
    } label: {
        Ch1PilotCTACard(
            symbol: "fork.knife",
            title: "Inside the digestive system",
            subtitle: "Follow a piece of chapati from mouth to colon — 24-hour journey, 5 organs, dozens of enzymes.",
            gradient: [
                Color(red: 0.65, green: 0.32, blue: 0.10),
                Color(red: 0.80, green: 0.45, blue: 0.20)
            ]
        )
    }
    .buttonStyle(.plain)
    .pointingCursor()
    .accessibilityLabel("Inside the digestive system — five-stop tour")
    .accessibilityHint("Opens a sheet that walks a piece of food from mouth through stomach, small intestine, liver, and large intestine.")
}

func insideTheAlveolusTourCTA(coordinator: PilotInteractiveSheetCoordinator) -> some View {
    Button {
        coordinator.presentDeferred(.insideTheAlveolusTour)
    } label: {
        Ch1PilotCTACard(
            symbol: "lungs.fill",
            title: "Inside an alveolus",
            subtitle: "From nostril to red blood cell — five-stop walk through the respiratory pipeline that loads O₂ onto haemoglobin.",
            gradient: [
                Color(red: 0.20, green: 0.55, blue: 0.55),
                Color(red: 0.80, green: 0.30, blue: 0.35)
            ]
        )
    }
    .buttonStyle(.plain)
    .pointingCursor()
    .accessibilityLabel("Inside an alveolus — five-stop respiratory tour")
    .accessibilityHint("Opens a sheet that walks you from the nostril through the trachea, bronchi, and into an alveolus where oxygen loads onto a red blood cell.")
}

func insideTheXylemTourCTA(coordinator: PilotInteractiveSheetCoordinator) -> some View {
    Button {
        coordinator.presentDeferred(.insideTheXylemTour)
    } label: {
        Ch1PilotCTACard(
            symbol: "drop.fill",
            title: "The xylem ascent",
            subtitle: "Follow one water molecule from a root hair, up a 100-metre tree, through a leaf vein, and out a stoma — no pump, just physics.",
            gradient: [
                Color(red: 0.20, green: 0.50, blue: 0.70),
                Color(red: 0.10, green: 0.65, blue: 0.55)
            ]
        )
    }
    .buttonStyle(.plain)
    .pointingCursor()
    .accessibilityLabel("The xylem ascent — five-stop tour of water rising up a plant")
    .accessibilityHint("Opens a sheet that walks one water molecule from a root hair, up the xylem, through a stem, into leaf veins, and out a stoma.")
}

func insideTheWireTourCTA(coordinator: PilotInteractiveSheetCoordinator) -> some View {
    Button {
        coordinator.presentDeferred(.insideTheWireTour)
    } label: {
        Ch1PilotCTACard(
            symbol: "bolt.fill",
            title: "Inside the wire",
            subtitle: "Shrink to electron-size and trace the chain from battery to glowing filament — five-stop guided journey.",
            gradient: [
                Color(red: 0.85, green: 0.65, blue: 0.10),
                Color(red: 0.60, green: 0.20, blue: 0.10)
            ]
        )
    }
    .buttonStyle(.plain)
    .pointingCursor()
    .accessibilityLabel("Inside the wire — five-stop electron-flow tour")
    .accessibilityHint("Opens a sheet that walks you from a battery's negative terminal through a copper lattice to a glowing bulb filament.")
}

func insideTheLensTourCTA(coordinator: PilotInteractiveSheetCoordinator) -> some View {
    Button {
        coordinator.presentDeferred(.insideTheLensTour)
    } label: {
        Ch1PilotCTACard(
            symbol: "eye.fill",
            title: "Inside the lens",
            subtitle: "Follow a ray of light from a distant star through a convex lens — when does it form a real image, when does it magnify?",
            gradient: [
                Color(red: 0.45, green: 0.30, blue: 0.70),
                Color(red: 0.20, green: 0.45, blue: 0.75)
            ]
        )
    }
    .buttonStyle(.plain)
    .pointingCursor()
    .accessibilityLabel("Inside the lens — five-stop refraction tour")
    .accessibilityHint("Opens a sheet that walks you through how a convex lens refracts light, forms a real inverted image, and acts as a magnifying glass.")
}
