// Fixture: LH001 should NOT flag this — `weak var delegate:` is correct.
import AppKit

class GoodManager: NSObject {
    weak var delegate: NSWindowDelegate?
}
