import Foundation

// MARK: - Actor: serialized mutable state

/// An `actor` serializes access to its mutable state. Concurrent callers can't
/// race on `balance` — the actor processes one message at a time. This is the
/// data-race-free replacement for a lock around shared state.
actor BankAccount {
    private(set) var balance: Int

    init(balance: Int = 0) { self.balance = balance }

    func deposit(_ amount: Int) {
        balance += amount
    }

    /// Demonstrates *reentrancy*: an actor method that suspends (`await`) lets
    /// other messages run before it resumes. Any invariant assumed across the
    /// `await` must be re-checked afterwards — state may have changed.
    func withdrawSlowly(_ amount: Int) async -> Bool {
        guard balance >= amount else { return false }
        await Task.yield() // suspension point — other deposits/withdrawals may run
        guard balance >= amount else { return false } // re-check after the await
        balance -= amount
        return true
    }
}

// MARK: - Sendable value type

/// A `Sendable` snapshot safe to pass across isolation domains. Value types of
/// `Sendable` members are automatically `Sendable`.
struct DashboardSnapshot: Sendable, Equatable {
    let users: Int
    let revenue: Int
    let errors: Int
}

// MARK: - TaskGroup

/// Fans work out across a `TaskGroup` and reduces the results. The group awaits
/// all children (structured concurrency: no child outlives the scope). Order of
/// completion is non-deterministic, so we reduce commutatively.
func parallelSum(_ values: [Int]) async -> Int {
    await withTaskGroup(of: Int.self) { group in
        for v in values {
            group.addTask { v * v } // each child squares one value
        }
        var total = 0
        for await partial in group {
            total += partial
        }
        return total
    }
}

// MARK: - async let

/// `async let` binds three child tasks that run concurrently; awaiting the tuple
/// joins them. Best when the number of parallel jobs is small and fixed (vs a
/// `TaskGroup` for a dynamic collection).
func loadDashboard() async -> DashboardSnapshot {
    async let users = slowCount(42)
    async let revenue = slowCount(1000)
    async let errors = slowCount(3)
    return await DashboardSnapshot(users: users, revenue: revenue, errors: errors)
}

private func slowCount(_ value: Int) async -> Int {
    try? await Task.sleep(for: .milliseconds(200))
    return value
}

// MARK: - Global actor

/// A custom global actor: any declaration annotated `@DataActor` shares this
/// single serial executor, the same way `@MainActor` shares the main thread.
@globalActor
actor DataActor {
    static let shared = DataActor()
}

/// Isolated to `DataActor` — all calls run on its executor regardless of caller.
@DataActor
final class AuditLog {
    private(set) var entries: [String] = []
    func record(_ event: String) { entries.append(event) }
}
