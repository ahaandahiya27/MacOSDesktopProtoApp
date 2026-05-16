import Testing
import Foundation
@testable import desktopAhaan

/// Tests for `SubjectRegistry` — guards the contract that bundled JSON packs
/// load successfully and the well-known pack ids resolve to non-empty content.
///
/// The registry runs `reload()` async on init. Tests wait until isLoading
/// flips to false before asserting.
@MainActor
struct SubjectRegistryTests {

    /// Spin a brand new registry and await its initial load.
    private func loadedRegistry() async -> SubjectRegistry {
        let r = SubjectRegistry()
        // The async init kicks off reload(); poll until loading completes.
        // Cap at 5 seconds so a regression doesn't hang CI forever.
        let deadline = Date().addingTimeInterval(5)
        while r.isLoading && Date() < deadline {
            try? await Task.sleep(nanoseconds: 50_000_000)
        }
        return r
    }

    // MARK: - Pack loading

    @Test func loadsAtLeastTwoPacks() async {
        let r = await loadedRegistry()
        // Project ships science_class7 and sanskrit_class7.
        #expect(r.packs.count >= 2)
    }

    @Test func loadingFlipsToFalse() async {
        let r = await loadedRegistry()
        #expect(!r.isLoading)
    }

    @Test func noLoadErrors() async {
        let r = await loadedRegistry()
        #expect(r.loadErrors.isEmpty)
    }

    // MARK: - pack(withId:)

    @Test func sciencePackLooksUpById() async {
        let r = await loadedRegistry()
        let science = r.pack(withId: "science_class7")
        #expect(science != nil)
        #expect(science?.id == "science_class7")
    }

    @Test func sanskritPackLooksUpById() async {
        let r = await loadedRegistry()
        let sanskrit = r.pack(withId: "sanskrit_class7")
        #expect(sanskrit != nil)
        #expect(sanskrit?.id == "sanskrit_class7")
    }

    @Test func unknownIdReturnsNil() async {
        let r = await loadedRegistry()
        #expect(r.pack(withId: "definitely_not_a_pack") == nil)
    }

    // MARK: - Pack contents

    @Test func sciencePackHasChapters() async {
        let r = await loadedRegistry()
        guard let science = r.pack(withId: "science_class7") else {
            Issue.record(Comment(rawValue: "science_class7 pack missing"))
            return
        }
        #expect(science.chapters.count > 0)
        #expect(science.questionCount > 0)
    }

    @Test func sanskritPackHasContent() async {
        let r = await loadedRegistry()
        guard let sanskrit = r.pack(withId: "sanskrit_class7") else {
            Issue.record(Comment(rawValue: "sanskrit_class7 pack missing"))
            return
        }
        // We added 154 MCQs to this pack as part of the backport work.
        #expect(sanskrit.questionCount >= 150)
        #expect(sanskrit.conceptCount > 0)
    }

    // MARK: - Ordering

    @Test func packsAreOrderedDeterministically() async {
        let r = await loadedRegistry()
        let firstLoadIds = r.packs.map(\.id)
        let r2 = await loadedRegistry()
        let secondLoadIds = r2.packs.map(\.id)
        #expect(firstLoadIds == secondLoadIds)
    }
}
