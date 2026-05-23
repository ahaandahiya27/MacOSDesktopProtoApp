// Fixture: LH005 should flag the indented `.animation(<X>)` modifier
// without a Reduce-Motion gate.
import SwiftUI

struct BadView: View {
    @State private var on = false
    var body: some View {
        Text("Hi")
            .scaleEffect(on ? 1.2 : 1.0)
            .animation(.easeInOut(duration: 0.3))
    }
}
