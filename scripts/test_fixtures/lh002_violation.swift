// Fixture: LH002 should flag any use of `unowned`.
import Foundation

final class Holder {
    unowned let parent: AnyObject
    init(parent: AnyObject) { self.parent = parent }
}
