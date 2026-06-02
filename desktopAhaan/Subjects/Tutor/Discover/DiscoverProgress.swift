import Foundation

final class DiscoverProgress: Identifiable, Codable {
    var id: String
    var chapterId: String
    var sceneId: String
    var completedAt: Date
    var score: Int?
    var maxScore: Int?
    /// Owning subject pack id (`science_class7`, `maths_class7`, …), captured at
    /// completion time so the Weekly dashboard can split Discover activity by
    /// subject exactly. Optional because (a) `discover.json` rows written before
    /// this field existed decode it as `nil` (forward-compatible migration), and
    /// (b) it can always be recovered from `chapterId` via `inferredPackId(...)`
    /// since the recording convention already prefixes each subject's Discover
    /// chapter ids uniquely (Science `chNN`, Maths `mchNN`, Sanskrit `schNN`,
    /// Social Science `sschNN`). v8 Longitudinal Insights · Phase 4.
    var packId: String?

    init(chapterId: String, sceneId: String, packId: String? = nil,
         score: Int? = nil, maxScore: Int? = nil) {
        self.id = "\(chapterId)::\(sceneId)"
        self.chapterId = chapterId
        self.sceneId = sceneId
        self.completedAt = Date()
        self.score = score
        self.maxScore = maxScore
        // Prefer the explicit pack; otherwise recover it from the (uniquely
        // subject-prefixed) chapter id so every freshly-recorded row is
        // attributed even when the caller doesn't pass one.
        self.packId = packId ?? Self.inferredPackId(fromChapterId: chapterId)
    }

    /// Recover the owning subject pack id from a Discover `chapterId`, relying on
    /// the recording convention that gives each subject a unique prefix. Pure +
    /// unit-testable. Returns `nil` for an unrecognised id (kept honest rather
    /// than guessing). Order matters: the longer prefixes are tested first so
    /// `ssch…` isn't swallowed by `sch…`, and `mch…`/`sch…` aren't by `ch…`.
    static func inferredPackId(fromChapterId chapterId: String) -> String? {
        if chapterId.hasPrefix("ssch") { return "socialscience_class7" }
        if chapterId.hasPrefix("sch")  { return "sanskrit_class7" }
        if chapterId.hasPrefix("mch")  { return "maths_class7" }
        if chapterId.hasPrefix("ch")   { return "science_class7" }
        return nil
    }

    /// The best-known owning pack id: the stored `packId`, falling back to the
    /// id-prefix inference for legacy rows that predate the field.
    var resolvedPackId: String? {
        packId ?? Self.inferredPackId(fromChapterId: chapterId)
    }
}
