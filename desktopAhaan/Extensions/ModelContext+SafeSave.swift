import Foundation
import SwiftData

extension ModelContext {
    /// Saves the context, logging any error to the console rather than
    /// silently swallowing it (which `try?` would).
    /// Use this in place of `try? save()` everywhere in the app — it makes
    /// debugging SwiftData schema/migration issues 10x easier.
    func safeSave(_ caller: String = #function) {
        do { try save() }
        catch { print("[ModelContext.safeSave] \(caller) failed: \(error)") }
    }
}
