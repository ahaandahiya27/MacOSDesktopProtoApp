// Fixture: LH004a should flag `.sink {}` without [weak self].
//          LH004b should flag Timer.scheduledTimer block without [weak self].
//          LH004c should flag `.assign(to: \.x, on: self)` keypath form.
import Combine
import Foundation

class Subscriber {
    var bag: Set<AnyCancellable> = []
    var x: Int = 0

    func wireA() {
        let pub = Just(1)
        pub.sink { value in
            self.x = value
        }.store(in: &bag)
    }

    func wireB() {
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.x += 1
        }
    }

    func wireC() {
        let pub = Just(1)
        _ = pub.assign(to: \.x, on: self)
    }
}
