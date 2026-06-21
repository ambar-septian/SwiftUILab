import Foundation
import Observation

/// Tracks which modules the user has marked complete, persisted to
/// `UserDefaults`. `@Observable` so SwiftUI re-renders the affected rows only
/// when `completed` actually changes (observation tracks the property read).
@Observable
final class ProgressStore {
    @ObservationIgnored private let defaults: UserDefaults
    @ObservationIgnored private let key = "completedModuleIDs"

    private(set) var completed: Set<String>

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let saved = defaults.stringArray(forKey: key) ?? []
        self.completed = Set(saved)
    }

    func isComplete(_ id: String) -> Bool {
        completed.contains(id)
    }

    func toggle(_ id: String) {
        if completed.contains(id) {
            completed.remove(id)
        } else {
            completed.insert(id)
        }
        defaults.set(Array(completed), forKey: key)
    }

    var completedCount: Int { completed.count }
}

extension UserDefaults {
    /// An isolated, throwaway defaults domain for previews and tests so they
    /// never read or mutate the user's real progress.
    static func ephemeral(_ suiteName: String = UUID().uuidString) -> UserDefaults {
        UserDefaults(suiteName: suiteName) ?? .standard
    }
}
