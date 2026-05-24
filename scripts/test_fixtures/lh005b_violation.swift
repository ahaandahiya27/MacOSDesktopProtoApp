// Fixture: LH005b should flag every unguarded `withAnimation(<X>) { ... }`.
// Both spring + easeInOut calls lack a Reduce-Motion gate. The
// surrounding lines do not mention `reduceMotion` so the 8-line
// lookback does not save them.
import SwiftUI

struct BadView: View {
    @State private var on = false
    @State private var counter: Int = 0

    var body: some View {
        VStack {
            Button("Toggle") {
                withAnimation(.spring()) {
                    on.toggle()
                }
            }
            Button("Tick") {
                withAnimation(.easeInOut(duration: 0.2)) {
                    counter += 1
                }
            }
        }
    }
}
