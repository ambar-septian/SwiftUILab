import Foundation
import Testing
@testable import SwiftUILab

@Suite("Structured concurrency & actors")
struct ConcurrencyTests {

    // MARK: TaskGroup

    @Test("parallelSum squares and sums every element")
    func parallelSumWorks() async {
        let sum = await parallelSum([1, 2, 3, 4]) // 1+4+9+16
        #expect(sum == 30)
    }

    @Test("parallelSum of empty is zero")
    func parallelSumEmpty() async {
        #expect(await parallelSum([]) == 0)
    }

    // MARK: async let

    @Test("loadDashboard joins three concurrent loads")
    func dashboardJoins() async {
        let snapshot = await loadDashboard()
        #expect(snapshot == DashboardSnapshot(users: 42, revenue: 1000, errors: 3))
    }

    // MARK: Actor

    @Test("Actor serializes 1,000 concurrent deposits without losing updates")
    func actorNoRace() async {
        let account = BankAccount()
        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<1000 { group.addTask { await account.deposit(1) } }
        }
        #expect(await account.balance == 1000)
    }

    @Test("Reentrant withdraw re-checks balance after the await")
    func actorReentrancy() async {
        let account = BankAccount(balance: 100)
        let ok = await account.withdrawSlowly(40)
        #expect(ok)
        #expect(await account.balance == 60)
    }

    // MARK: Global actor

    @Test("Global-actor isolated type records events")
    func globalActorLog() async {
        let log = AuditLog()
        await log.record("launch")
        await log.record("tap")
        #expect(await log.entries == ["launch", "tap"])
    }
}
