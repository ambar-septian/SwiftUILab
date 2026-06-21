import Foundation
import Testing
@testable import SwiftUILab

// The reference test suite for Topic 8 — each test demonstrates one Swift Testing
// technique against the SUTs in TestingModels.swift.
@Suite("Testing techniques")
struct TestingTests {

    // MARK: #expect & #require

    @Test("PriceFormatter formats cents as USD")
    func formatsCurrency() {
        let f = PriceFormatter()
        #expect(f.string(fromCents: 150) == "$1.50")
        #expect(f.string(fromCents: 0) == "$0.00")
    }

    // MARK: Parameterized

    @Test("Formatter across several inputs", arguments: [
        (0, "$0.00"), (5, "$0.05"), (199, "$1.99"), (100_00, "$100.00"),
    ])
    func formatsMany(cents: Int, expected: String) {
        #expect(PriceFormatter().string(fromCents: cents) == expected)
    }

    // MARK: Async + actor isolation

    @Test("RateLimiter denies once the bucket is empty")
    func rateLimiterDenies() async {
        let limiter = RateLimiter(capacity: 2)
        #expect(await limiter.allow())
        #expect(await limiter.allow())
        #expect(await limiter.allow() == false) // bucket empty
        await limiter.refill()
        #expect(await limiter.allow())
    }

    // MARK: @Observable state

    @MainActor
    @Test("Cart add / remove / clear update count")
    func cartMutations() {
        let cart = Cart()
        #expect(cart.isEmpty)
        cart.add("Apple")
        cart.add("Pear")
        #expect(cart.count == 2)
        cart.remove("Apple")
        #expect(cart.items == ["Pear"])
        cart.clear()
        #expect(cart.isEmpty)
    }

    // MARK: throws

    @Test("Decoding bad JSON throws")
    func decodingThrows() {
        #expect(throws: (any Error).self) {
            try JSONDecoder().decode(Int.self, from: Data("not-json".utf8))
        }
    }

    // MARK: AsyncStream

    @Test("Pulse stream yields 0..<count in order")
    func pulseStream() async {
        var received: [Int] = []
        for await n in Pulse.stream(count: 4) { received.append(n) }
        #expect(received == [0, 1, 2, 3])
    }
}
