import SwiftUI
import Observation
import Combine // ObservableObject/@Published are no longer re-exported by SwiftUI
              // under MEMBER_IMPORT_VISIBILITY; import the defining module directly.

// MARK: - Modern observation (@Observable)

/// `@Observable` replaces `ObservableObject` + `@Published`. The macro rewrites
/// stored properties so that *reads* are tracked per-property at the point of
/// use. A view that reads only `count` is not invalidated when `label` changes —
/// observation is field-granular, unlike `@Published` which fires
/// `objectWillChange` for the whole object.
@Observable
final class CounterModel {
    var count = 0
    var label = "Taps"

    func increment() { count += 1 }
    func reset() { count = 0 }
}

/// Used to demonstrate `@Bindable`: a plain `@Observable` settings object whose
/// properties we want two-way bindings into from a child view.
@Observable
final class DemoSettings {
    var username = ""
    var notificationsEnabled = true
}

// MARK: - Legacy observation (ObservableObject)

/// The pre-iOS-17 model type. Kept to contrast ownership semantics:
/// `@StateObject` *creates and owns* one instance for the view's lifetime, while
/// `@ObservedObject` merely *observes* one passed in. Using `@ObservedObject`
/// where you mean `@StateObject` recreates the object on each parent re-render,
/// silently resetting its state — the classic bug.
final class LegacyCounter: ObservableObject {
    @Published var count = 0
    func increment() { count += 1 }
}

// MARK: - Custom environment key

extension EnvironmentValues {
    /// A custom environment value injected from an ancestor and read by any
    /// descendant — dependency injection through the view tree without bindings.
    /// `@Entry` (Xcode 16+) generates the key boilerplate.
    @Entry var labAccentName: String = "System"
}
