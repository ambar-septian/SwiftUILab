import Foundation

/// Supplies the list of learning modules.
///
/// A protocol-fronted service is the seam we inject and replace in tests — the
/// Swift idiom that stands in for runtime mocking frameworks. `Sendable` so it
/// can cross isolation boundaries cleanly under approachable concurrency.
protocol CatalogService: Sendable {
    func modules() -> [LearningModule]
}

/// Production implementation: the static syllabus.
struct LiveCatalogService: CatalogService {
    func modules() -> [LearningModule] { LearningModule.all }
}

/// Test/preview double. The stub is injectable so individual tests can shape the
/// catalog (empty, single-item, reordered) without touching the live data.
struct MockCatalogService: CatalogService {
    var stub: [LearningModule]

    init(stub: [LearningModule] = LearningModule.all) {
        self.stub = stub
    }

    func modules() -> [LearningModule] { stub }
}
