import Foundation
import Testing
@testable import SwiftUILab

@Suite("Architecture — unidirectional reducer")
struct ArchitectureTests {

    typealias State = CounterFeature.State

    // Pure reducer → no store, no UI, no async. The ideal unit test.

    @Test("increment bumps count and records history")
    func increment() {
        var state = State()
        CounterFeature.reduce(&state, .increment)
        CounterFeature.reduce(&state, .increment)
        #expect(state.count == 2)
        #expect(state.history == [1, 2])
    }

    @Test("decrement goes negative")
    func decrement() {
        var state = State()
        CounterFeature.reduce(&state, .decrement)
        #expect(state.count == -1)
        #expect(state.history == [-1])
    }

    @Test("reset clears count and history")
    func reset() {
        var state = State(count: 5, history: [1, 2, 3, 4, 5])
        CounterFeature.reduce(&state, .reset)
        #expect(state == State(count: 0, history: []))
    }

    @MainActor
    @Test("Store.send routes through the reducer")
    func storeSend() {
        let store = CounterFeature.store()
        store.send(.increment)
        store.send(.increment)
        store.send(.decrement)
        #expect(store.state.count == 1)
    }

    @MainActor
    @Test("MVVM search filters case-insensitively")
    func searchViewModel() {
        let vm = SearchViewModel()
        vm.query = "swift"
        vm.search()
        #expect(vm.results == ["SwiftUI", "Swift", "SwiftData"])
    }
}
