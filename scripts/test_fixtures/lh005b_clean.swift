// Fixture: LH005b should NOT flag — every `withAnimation` is gated.
// Four flavours of gate are exercised so a regex change can't quietly
// drop one of them:
//   1. Inline ternary inside the call arg.
//   2. The withAnimationRespectingReduceMotion helper.
//   3. Outer-block `if !reduceMotion { ... }` guard.
//   4. Same-line `// lh005-ok: …` escape comment.
import SwiftUI

struct GoodView: View {
    @State private var on = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack {
            Button("Inline gate") {
                withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
                    on.toggle()
                }
            }
            Button("Helper") {
                withAnimationRespectingReduceMotion(.spring()) {
                    on.toggle()
                }
            }
            Button("Outer block") {
                if !reduceMotion {
                    withAnimation(.spring()) {
                        on.toggle()
                    }
                }
            }
            Button("Escape comment") {
                withAnimation(.linear) { on.toggle() } // lh005-ok: scroll-only, no visual motion
            }
        }
    }
}

// Stub so the fixture compiles without the actual helper.
func withAnimationRespectingReduceMotion<R>(
    _ animation: Animation? = .default,
    _ body: () -> R
) -> R { body() }
