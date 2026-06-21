import Testing
@testable import SwiftUILab

/// Demonstrates the protocol-double pattern: we assert against the live service
/// and a configurable mock, no runtime mocking framework required.
@MainActor
@Suite("Catalog service")
struct CatalogServiceTests {

    @Test("Live catalog exposes every topic")
    func liveCatalogHasAllTopics() {
        let modules = LiveCatalogService().modules()
        #expect(modules.count == ModuleTopic.allCases.count)
        #expect(modules.first?.topic == .stateSystem)
    }

    @Test("Mock catalog returns its injected stub verbatim")
    func mockReturnsStub() {
        let stub = [LearningModule(topic: .navigation), LearningModule(topic: .testing)]
        let service = MockCatalogService(stub: stub)
        #expect(service.modules() == stub)
    }

    /// Parameterized test: every topic carries non-empty display metadata.
    @Test("Topics have complete metadata", arguments: ModuleTopic.allCases)
    func topicMetadataIsComplete(_ topic: ModuleTopic) {
        #expect(!topic.title.isEmpty)
        #expect(!topic.subtitle.isEmpty)
        #expect(!topic.systemImage.isEmpty)
        #expect(!topic.plannedConcepts.isEmpty)
    }
}
