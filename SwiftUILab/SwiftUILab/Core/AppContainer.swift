import Foundation
import Observation

/// The app's dependency container — plain composition root, no framework.
///
/// Holding services here (rather than as singletons) means every dependency is
/// explicit and swappable. It's injected once at the root via `.environment(_:)`
/// and read by features with `@Environment(AppContainer.self)`.
@Observable
final class AppContainer {
    let catalog: any CatalogService
    let progress: ProgressStore

    init(catalog: any CatalogService, progress: ProgressStore) {
        self.catalog = catalog
        self.progress = progress
    }

    /// Production wiring.
    static func live() -> AppContainer {
        AppContainer(catalog: LiveCatalogService(), progress: ProgressStore())
    }

    /// Preview/test wiring against ephemeral state.
    static func preview() -> AppContainer {
        AppContainer(
            catalog: MockCatalogService(),
            progress: ProgressStore(defaults: .ephemeral())
        )
    }
}
