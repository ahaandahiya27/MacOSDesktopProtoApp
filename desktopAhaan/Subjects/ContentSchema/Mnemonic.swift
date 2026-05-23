import Foundation

/// A memorable acronym or mnemonic phrase + a short unpack of what each
/// letter / word stands for. Chapter floor ≥ 3 per chapter.
struct Mnemonic: Codable, Hashable, Identifiable {
    let id: String                   // e.g. "ch01_mn01"
    let acronym: String              // "SLAP"
    let unpacking: String            // 2-line expansion of what each letter / word stands for
    /// Optional one-line "use case" so the UI can show when this
    /// mnemonic is most useful.
    let context: String?
    let relatedConceptIds: [String]?
}
