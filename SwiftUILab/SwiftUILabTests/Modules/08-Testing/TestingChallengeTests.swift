import Foundation
import Testing
@testable import SwiftUILab

// =============================================================================
// CHALLENGE — write these tests yourself.
// Replace each `// TODO:` with a real assertion. Compare against TestingTests.swift.
// =============================================================================
@Suite("Challenge — write the tests")
struct TestingChallengeTests {

    private let calc = ShippingCalculator(freeThresholdCents: 5000, flatFeeCents: 599)

    @Test("Fee is flat below the threshold")
    func feeBelowThreshold() {
        // TODO: #expect(calc.fee(forSubtotalCents: 4999) == 599)
    }

    @Test("Fee is free at and above the threshold (boundary)")
    func feeAtThreshold() {
        // TODO: assert fee is 0 at exactly 5000 and above.
    }

    // TODO: Add a parameterized @Test(arguments:) covering several subtotals.

    @MainActor
    @Test("Cart count reflects adds and removes")
    func cartCount() {
        // TODO: build a Cart, add/remove, and assert on count + items.
    }

    @Test("RateLimiter allows exactly `capacity` times")
    func limiterCapacity() async {
        // TODO: make a RateLimiter(capacity: 3); assert 3 allows then a deny.
    }
}
