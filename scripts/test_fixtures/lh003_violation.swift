// Fixture: LH003 should flag any `@unchecked Sendable` conformance.
import Foundation

final class Bag: @unchecked Sendable {
    var contents: [String] = []
}
