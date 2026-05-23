// Fixture: LH002 should NOT flag — `weak` instead of `unowned`.
import Foundation

final class Holder {
    weak var parent: AnyObject?
}
