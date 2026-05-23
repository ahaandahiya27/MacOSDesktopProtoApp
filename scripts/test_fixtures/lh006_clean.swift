// Fixture: LH006 should NOT flag — print() inside #if DEBUG is allowed.
import Foundation

func debugReport() {
    #if DEBUG
    print("only in debug builds")
    #endif
}
