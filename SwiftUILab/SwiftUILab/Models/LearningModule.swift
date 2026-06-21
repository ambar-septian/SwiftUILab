import Foundation

/// A catalog entry wrapping a `ModuleTopic`.
///
/// Kept as a thin value type so the catalog list is `Identifiable`/`Hashable`
/// for `List` and `NavigationLink(value:)` without leaking the enum everywhere.
struct LearningModule: Identifiable, Hashable {
    let topic: ModuleTopic

    var id: String { topic.id }
    var number: Int { topic.number }
    var title: String { topic.title }
    var subtitle: String { topic.subtitle }
    var systemImage: String { topic.systemImage }

    /// Modules with a Reference/Challenge implementation. All ten are now built.
    var isImplemented: Bool { true }

    static let all: [LearningModule] = ModuleTopic.allCases.map(LearningModule.init)
}
