import Foundation
import Testing
@testable import SwiftUILab

@Suite("UIKit interop")
struct InteropTests {

    @Test("Guard applies an update when values differ beyond epsilon")
    func guardAppliesWhenDifferent() {
        #expect(UpdateGuard.shouldApply(incoming: 4.0, current: 3.0))
    }

    @Test("Guard skips an update within epsilon — the loop breaker")
    func guardSkipsWhenEqual() {
        #expect(!UpdateGuard.shouldApply(incoming: 3.00001, current: 3.0))
    }

    @Test("Guard respects a custom epsilon")
    func guardCustomEpsilon() {
        #expect(!UpdateGuard.shouldApply(incoming: 3.4, current: 3.0, epsilon: 0.5))
        #expect(UpdateGuard.shouldApply(incoming: 3.6, current: 3.0, epsilon: 0.5))
    }
}
