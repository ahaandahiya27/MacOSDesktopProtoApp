// Fixture: LH003 should NOT flag — Sendable without `@unchecked`.
import Foundation

struct Bag: Sendable {
    let contents: [String]
}
