import Foundation
import Observation

/// Type-safe navigation targets within a module stack.
///
/// Using a value-typed `enum` as the path element (rather than untyped
/// `NavigationPath`) keeps deep links and programmatic navigation exhaustive and
/// refactor-safe. The Navigation module (Topic 3) expands this into a full
/// coordinator.
enum Route: Hashable {
    case module(ModuleTopic)
    case reference(ModuleTopic)
    case challenge(ModuleTopic)
}

/// Owns the navigation path for a stack. Injected into the environment so deep
/// children can drive navigation without prop-drilling bindings.
@Observable
final class Router {
    var path: [Route] = []

    func push(_ route: Route) { path.append(route) }
    func pop() { _ = path.popLast() }
    func popToRoot() { path.removeAll() }
}
