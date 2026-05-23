// Fixture: LH006 should flag top-level `print(` outside #if DEBUG.
import Foundation

func reportSomething() {
    print("this leaks to stdout in release builds")
}
