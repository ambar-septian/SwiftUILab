import SwiftUI

/// The "Modules" tab: a catalog inside a type-safe `NavigationStack`.
///
/// The `Router` owns the path and is placed in the environment so any descendant
/// can push routes. `@Bindable` projects a binding to the `@Observable` router's
/// `path` for `NavigationStack(path:)`.
struct ModulesTab: View {
    @State private var router = Router()

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.path) {
            ModuleCatalogView()
                .navigationTitle("SwiftUI Lab")
                .navigationDestination(for: Route.self) { route in
                    destination(for: route)
                }
        }
        .environment(router)
    }

    /// Single switchboard mapping a `Route` to its screen. Keeping this
    /// exhaustive is what makes deep links and refactors safe.
    @ViewBuilder
    private func destination(for route: Route) -> some View {
        switch route {
        case .module(let topic):
            ModuleLandingView(topic: topic)
        case .reference(let topic):
            referenceScreen(for: topic)
        case .challenge(let topic):
            challengeScreen(for: topic)
        }
    }

    @ViewBuilder
    private func referenceScreen(for topic: ModuleTopic) -> some View {
        switch topic {
        case .stateSystem: StateSystemReferenceScreen()
        case .layout:      LayoutReferenceScreen()
        case .navigation:  NavigationReferenceScreen()
        case .asyncAwait:  AsyncReferenceScreen()
        case .concurrency: ConcurrencyReferenceScreen()
        case .uikitInterop: InteropReferenceScreen()
        case .swiftData:   SwiftDataReferenceScreen()
        case .testing:     TestingReferenceScreen()
        case .architecture: ArchitectureReferenceScreen()
        case .performance: PerformanceReferenceScreen()
        }
    }

    @ViewBuilder
    private func challengeScreen(for topic: ModuleTopic) -> some View {
        switch topic {
        case .stateSystem: StateSystemChallengeScreen()
        case .layout:      LayoutChallengeScreen()
        case .navigation:  NavigationChallengeScreen()
        case .asyncAwait:  AsyncChallengeScreen()
        case .concurrency: ConcurrencyChallengeScreen()
        case .uikitInterop: InteropChallengeScreen()
        case .swiftData:   SwiftDataChallengeScreen()
        case .testing:     TestingChallengeScreen()
        case .architecture: ArchitectureChallengeScreen()
        case .performance: PerformanceChallengeScreen()
        }
    }
}

#Preview {
    ModulesTab()
        .environment(AppContainer.preview())
}
