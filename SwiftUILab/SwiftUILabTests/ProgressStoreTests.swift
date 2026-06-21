import Testing
import Foundation
@testable import SwiftUILab

@MainActor
@Suite("Progress store")
struct ProgressStoreTests {

    /// Each test gets its own ephemeral defaults suite so state never leaks.
    private func makeStore() -> ProgressStore {
        ProgressStore(defaults: .ephemeral())
    }

    @Test("Toggle flips completion on and off")
    func toggleFlips() {
        let store = makeStore()
        #expect(store.isComplete("stateSystem") == false)

        store.toggle("stateSystem")
        #expect(store.isComplete("stateSystem"))
        #expect(store.completedCount == 1)

        store.toggle("stateSystem")
        #expect(store.isComplete("stateSystem") == false)
        #expect(store.completedCount == 0)
    }

    @Test("Completion persists across store instances on the same suite")
    func persistsAcrossInstances() {
        let suite = "test.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!

        let first = ProgressStore(defaults: defaults)
        first.toggle("navigation")

        let second = ProgressStore(defaults: defaults)
        #expect(second.isComplete("navigation"))
    }
}
