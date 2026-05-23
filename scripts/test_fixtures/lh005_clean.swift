// Fixture: LH005 should NOT flag — both forms are gated.
import SwiftUI

struct GoodView: View {
    @State private var on = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    var body: some View {
        VStack {
            Text("Via helper")
                .scaleEffect(on ? 1.2 : 1.0)
                .respectReduceMotion(animation: .easeInOut(duration: 0.3))
            Text("Via manual gate")
                .scaleEffect(on ? 1.2 : 1.0)
                .animation(reduceMotion ? .none : .easeInOut(duration: 0.3))
        }
    }
}
