import Foundation

// MARK: - Unidirectional data flow

/// A minimal, TCA-flavored unidirectional store: state in, actions in, the
/// `reduce` function is the *only* place state changes. Pure reducers are trivial
/// to unit-test without any UI.
@Observable
final class Store<State, Action> {
    private(set) var state: State
    private let reduce: (inout State, Action) -> Void

    init(initial: State, reduce: @escaping (inout State, Action) -> Void) {
        self.state = initial
        self.reduce = reduce
    }

    /// The single entry point for change. Views send actions; they never mutate
    /// state directly. This is what makes the flow traceable and testable.
    func send(_ action: Action) {
        reduce(&state, action)
    }
}

/// A feature = State + Action + a pure reducer. Keeping `reduce` static and pure
/// (no `self`, no I/O) means tests call it directly with no store at all.
enum CounterFeature {
    struct State: Equatable {
        var count = 0
        var history: [Int] = []
    }

    enum Action: Equatable {
        case increment
        case decrement
        case reset
    }

    static func reduce(_ state: inout State, _ action: Action) {
        switch action {
        case .increment:
            state.count += 1
            state.history.append(state.count)
        case .decrement:
            state.count -= 1
            state.history.append(state.count)
        case .reset:
            state.count = 0
            state.history.removeAll()
        }
    }

    static func store() -> Store<State, Action> {
        Store(initial: State(), reduce: reduce)
    }
}

// MARK: - MVVM (for contrast)

/// Classic MVVM: the view model owns presentation state and talks to services.
/// Fine for screen-local state; the overhead (one class per screen, manual wiring)
/// is why unidirectional stores win once flows get complex and shared.
@Observable
@MainActor
final class SearchViewModel {
    var query = ""
    private(set) var results: [String] = []

    private let corpus: [String]
    init(corpus: [String] = ["SwiftUI", "Swift", "Combine", "UIKit", "SwiftData"]) {
        self.corpus = corpus
    }

    func search() {
        let q = query.trimmingCharacters(in: .whitespaces)
        results = q.isEmpty ? [] : corpus.filter { $0.localizedCaseInsensitiveContains(q) }
    }
}
