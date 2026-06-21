import Foundation

// MARK: - Systems under test
//
// These are deliberately small, pure-ish types that the module's *tests* exercise.
// In this module the test file is the real reference; these are the targets.

/// Pure value transform with an injectable locale, so currency tests are
/// deterministic across machines.
struct PriceFormatter {
    var locale = Locale(identifier: "en_US")

    func string(fromCents cents: Int) -> String {
        (Double(cents) / 100).formatted(.currency(code: "USD").locale(locale))
    }
}

/// A token-bucket actor — the target for testing actor-isolated async code.
actor RateLimiter {
    let capacity: Int
    private var tokens: Int

    init(capacity: Int) {
        self.capacity = capacity
        self.tokens = capacity
    }

    func allow() -> Bool {
        guard tokens > 0 else { return false }
        tokens -= 1
        return true
    }

    func refill() { tokens = capacity }
}

/// An `@Observable` model — the target for testing observation-driven state.
@Observable
final class Cart {
    private(set) var items: [String] = []
    var count: Int { items.count }
    var isEmpty: Bool { items.isEmpty }

    func add(_ item: String) { items.append(item) }
    func remove(_ item: String) { items.removeAll { $0 == item } }
    func clear() { items.removeAll() }
}

/// A finite async sequence — the target for testing `AsyncStream` consumers.
enum Pulse {
    static func stream(count: Int) -> AsyncStream<Int> {
        AsyncStream { continuation in
            Task {
                for i in 0..<count { continuation.yield(i) }
                continuation.finish()
            }
        }
    }
}

/// SUT for the challenge — you write the tests for this one.
struct ShippingCalculator {
    let freeThresholdCents: Int
    let flatFeeCents: Int

    func fee(forSubtotalCents subtotal: Int) -> Int {
        subtotal >= freeThresholdCents ? 0 : flatFeeCents
    }
}
