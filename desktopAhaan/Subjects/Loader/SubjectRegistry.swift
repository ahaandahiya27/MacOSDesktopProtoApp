import Foundation
import SwiftUI
import Combine

/// Loads every `*.json` file in the bundled `Subjects/Packs/` directory at
/// app launch and exposes them as decoded `SubjectPack` instances.
///
/// The Xcode project uses `PBXFileSystemSynchronizedRootGroup`. JSON resources
/// usually end up flat at the bundle root (Xcode strips nested folders for
/// non-source files by default). The loader tries three strategies:
///
/// 1. **Subdirectory lookup** in case Xcode preserved the `Subjects/Packs`
///    structure (it sometimes does for folder references).
/// 2. **Flat lookup** at the bundle root, filtering by a `*_class<digit>.json`
///    naming pattern that matches packs but EXCLUDES the dictionary file.
/// 3. **Source-tree fallback** during development — uses `#filePath` to
///    locate the SubjectRegistry.swift file and walks up to `Subjects/Packs/`.
///    This makes pack loading work even when the build phase hasn't bundled
///    the JSON files yet.
private func debugLog(_ items: Any...) {
    #if DEBUG
    print(items.map { "\($0)" }.joined(separator: " "))
    #endif
}

@MainActor
final class SubjectRegistry: ObservableObject {

    @Published private(set) var packs: [SubjectPack] = []
    @Published private(set) var loadErrors: [String] = []
    /// True while the initial pack decode is running off-thread.
    /// UI can use this to render a placeholder instead of an empty sidebar.
    @Published private(set) var isLoading: Bool = true

    init() {
        // Detached load is intentional and app-lifetime: the registry is
        // owned by the App via @StateObject and exists for the duration of
        // the process. We don't store the Task because there's nothing to
        // cancel against — the only consumer that matters (ContentView)
        // observes `isLoading` to render the placeholder. `[weak self]`
        // covers the theoretical case where the App scene is torn down
        // during the very first ~150 ms of launch.
        Task { [weak self] in await self?.reload() }
    }

    /// Re-scans the bundle for pack files and reloads.
    ///
    /// Heavy JSON decoding **is now actually moved off the main thread** via
    /// `Task.detached`. Before this fix, the comment claimed background
    /// decoding but the loop ran synchronously inside the `@MainActor`
    /// `reload()` body — every keystroke and animation stalled while
    /// ~28K lines of JSON parsed on the slow iMac AMD CPU at launch.
    ///
    /// Now: enumerate bundle URLs on MainActor (cheap), then hand the
    /// decode list to a detached, sendable Task, then come back to
    /// MainActor only to publish the results.
    func reload() async {
        isLoading = true
        let urls = Self.bundledPackURLs()
        debugLog("[SubjectRegistry] reload — found \(urls.count) candidate URL(s).")
        for url in urls {
            debugLog("  candidate: \(url.path)")
        }

        if urls.isEmpty {
            debugLog("[SubjectRegistry] No pack files were found. Sanskrit and " +
                  "Science subjects won't appear. Make sure the JSON files " +
                  "are inside Subjects/Packs/ in the source tree.")
            self.packs = []
            self.loadErrors = []
            self.isLoading = false
            return
        }

        // Decode every pack on a DETACHED task so the main thread stays
        // free to render the launch UI. Each (pack, error) tuple captures
        // success or failure separately so partial failures don't lose
        // other successful packs.
        let t0 = Date()
        let results: [(SubjectPack?, String?)] = await Task.detached(priority: .userInitiated) {
            return urls.map { url in
                do {
                    let pack = try PackDecoder.decode(from: url)
                    return (pack as SubjectPack?, nil as String?)
                } catch {
                    let msg = "\(url.lastPathComponent): \(error.localizedDescription)"
                    return (nil as SubjectPack?, msg as String?)
                }
            }
        }.value
        let elapsedMs = Int(Date().timeIntervalSince(t0) * 1000)
        debugLog("[SubjectRegistry] decoded \(urls.count) pack(s) off-thread in \(elapsedMs) ms")

        var loaded: [SubjectPack] = []
        var errors: [String] = []
        for (pack, err) in results {
            if let p = pack {
                loaded.append(p)
                debugLog("[SubjectRegistry] Loaded \(p.id): \(p.title) — " +
                      "\(p.chapters.count) chapters, \(p.conceptCount) concepts, " +
                      "\(p.questionCount) questions")
                // Surface relatedConceptIds / relatedQuestionIds refs that
                // don't resolve. Orphans are silently dropped by the UI's
                // compactMap, so this is the only place they become
                // visible to anyone investigating crashlogs.
                p.validateRelatedRefs()
            }
            if let e = err {
                errors.append(e)
                debugLog("[SubjectRegistry] FAILED to load \(e)")
                // Pipe pack-decode failures into the crashlog so the
                // parent / Claude can see them next session without
                // needing to dig through Settings. Non-fatal — other
                // packs still load.
                CrashReporter.shared.logDataIssue("SubjectPack decode failure: \(e)")
            }
        }

        // Stable ordering: by grade ascending, then title ascending.
        loaded.sort { lhs, rhs in
            if lhs.grade != rhs.grade { return lhs.grade < rhs.grade }
            return lhs.title < rhs.title
        }

        self.packs = loaded
        self.loadErrors = errors
        self.isLoading = false
    }

    /// Returns a pack by its id, or nil.
    func pack(withId id: String) -> SubjectPack? {
        packs.first { $0.id == id }
    }

    // MARK: - Bundle scanning

    /// True if the URL's filename should be treated as a SubjectPack file.
    /// Excludes the dictionary file which lives elsewhere but has a similar
    /// naming pattern.
    nonisolated private static func isPackFilename(_ url: URL) -> Bool {
        let name = url.lastPathComponent.lowercased()
        guard name.hasSuffix(".json") else { return false }
        guard name.contains("_class") else { return false }
        // Specific exclusions: things that look like packs but aren't.
        if name.contains("_dictionary") { return false }
        return true
    }

    nonisolated private static func bundledPackURLs() -> [URL] {
        // Strategy 1: subdirectory-aware lookup. Works only if the
        // synchronized group preserved the nested folder structure.
        if let urls = Bundle.main.urls(forResourcesWithExtension: "json",
                                       subdirectory: "Subjects/Packs"),
           !urls.isEmpty {
            debugLog("[SubjectRegistry] Using subdirectory lookup (\(urls.count) files).")
            return urls.filter(isPackFilename)
        }

        // Strategy 2: flat lookup at bundle root. Xcode usually flattens.
        if let urls = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: nil) {
            let filtered = urls.filter(isPackFilename)
            if !filtered.isEmpty {
                debugLog("[SubjectRegistry] Using flat-bundle lookup (\(filtered.count) files).")
                return filtered
            }
        }

        // Strategy 3: source-tree fallback for development. Uses #filePath at
        // compile time to find this very file's location, then walks up to
        // Subjects/Packs.
        return sourceTreePackURLs()
    }

    /// Compile-time absolute path of THIS Swift file. Used to locate the
    /// source-tree Subjects/Packs/ directory during development builds.
    nonisolated private static let thisFilePath: String = #filePath

    nonisolated private static func sourceTreePackURLs() -> [URL] {
        let fm = FileManager.default

        // SubjectRegistry.swift lives at:
        //   .../desktopAhaan/desktopAhaan/Subjects/Loader/SubjectRegistry.swift
        // We want:
        //   .../desktopAhaan/desktopAhaan/Subjects/Packs/
        // So: drop the filename, drop "Loader", append "Packs".
        let thisFile = URL(fileURLWithPath: thisFilePath)
        let packsDir = thisFile
            .deletingLastPathComponent()        // .../Subjects/Loader
            .deletingLastPathComponent()        // .../Subjects
            .appendingPathComponent("Packs", isDirectory: true)

        guard let files = try? fm.contentsOfDirectory(at: packsDir,
                                                       includingPropertiesForKeys: nil) else {
            debugLog("[SubjectRegistry] Source-tree fallback: directory not readable: \(packsDir.path)")
            return []
        }

        let packs = files.filter(isPackFilename)
        if packs.isEmpty {
            debugLog("[SubjectRegistry] Source-tree fallback: no pack files at \(packsDir.path)")
        } else {
            debugLog("[SubjectRegistry] Using source-tree fallback (\(packs.count) files at \(packsDir.path)).")
        }
        return packs
    }
}
