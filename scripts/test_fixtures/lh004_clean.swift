// Fixture: LH004a/b should NOT flag — both capture [weak self].
//          LH004c should NOT flag — uses .assign(to: &$x) instead.
import Combine
import Foundation

class Subscriber {
    var bag: Set<AnyCancellable> = []
    @Published var x: Int = 0

    func wireA() {
        let pub = Just(1)
        pub.sink { [weak self] value in
            self?.x = value
        }.store(in: &bag)
    }

    func wireB() {
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.x += 1
        }
    }

    func wireC() {
        let pub = Just(1)
        pub.assign(to: &$x)
    }
}
