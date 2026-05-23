// Fixture: LH001 should flag this — `var delegate:` without `weak`.
import AppKit

class BrokenManager: NSObject {
    var delegate: NSWindowDelegate?
}
