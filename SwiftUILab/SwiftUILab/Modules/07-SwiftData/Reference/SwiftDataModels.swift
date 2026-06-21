import Foundation
import SwiftData

// MARK: - Models & relationships

/// A project owns many to-do items. The `@Relationship` declares the cascade
/// delete rule and the inverse key path, so deleting a project removes its items
/// and SwiftData keeps both sides of the relationship in sync.
@Model
final class TodoProject {
    var name: String
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \TodoItem.project)
    var items: [TodoItem]

    init(name: String, createdAt: Date = .now, items: [TodoItem] = []) {
        self.name = name
        self.createdAt = createdAt
        self.items = items
    }
}

/// A single task. Named `TodoItem` (not `Task`) to avoid colliding with Swift
/// Concurrency's `Task`.
@Model
final class TodoItem {
    var title: String
    var isDone: Bool
    var project: TodoProject?

    init(title: String, isDone: Bool = false) {
        self.title = title
        self.isDone = isDone
    }
}

// MARK: - Container/context factories

/// Centralizes container creation so the app, previews, and tests all build the
/// schema the same way. An in-memory configuration gives each test a clean,
/// disk-free store.
enum TodoStore {
    static func inMemoryContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: TodoProject.self, TodoItem.self, configurations: config)
    }

    /// Convenience for tests: a fresh context backed by an in-memory store.
    static func inMemoryContext() throws -> ModelContext {
        ModelContext(try inMemoryContainer())
    }

    /// A `#Predicate` is compiled to a store query (SQL) rather than evaluated in
    /// Swift — keeping the filter cost in the database. Exposed so a test can
    /// confirm the predicate selects the right rows.
    static func openItemsDescriptor() -> FetchDescriptor<TodoItem> {
        FetchDescriptor<TodoItem>(
            predicate: #Predicate { $0.isDone == false },
            sortBy: [SortDescriptor(\.title)]
        )
    }
}
