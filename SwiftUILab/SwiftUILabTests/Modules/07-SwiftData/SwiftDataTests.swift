import Foundation
import SwiftData
import Testing
@testable import SwiftUILab

@MainActor
@Suite("SwiftData")
struct SwiftDataTests {

    @Test("Insert and fetch round-trips through the store")
    func insertAndFetch() throws {
        let context = try TodoStore.inMemoryContext()
        context.insert(TodoItem(title: "Alpha"))
        context.insert(TodoItem(title: "Beta"))
        try context.save()

        let items = try context.fetch(FetchDescriptor<TodoItem>())
        #expect(items.count == 2)
    }

    @Test("#Predicate selects only open items, in the store")
    func openItemsPredicate() throws {
        let context = try TodoStore.inMemoryContext()
        context.insert(TodoItem(title: "Open", isDone: false))
        context.insert(TodoItem(title: "Done", isDone: true))
        try context.save()

        let open = try context.fetch(TodoStore.openItemsDescriptor())
        #expect(open.map(\.title) == ["Open"])
    }

    @Test("Cascade delete removes a project's items")
    func cascadeDelete() throws {
        let context = try TodoStore.inMemoryContext()
        let project = TodoProject(name: "Release")
        context.insert(project)
        project.items.append(TodoItem(title: "Cut tag"))
        project.items.append(TodoItem(title: "Notarize"))
        try context.save()
        #expect(try context.fetch(FetchDescriptor<TodoItem>()).count == 2)

        context.delete(project)
        try context.save()
        #expect(try context.fetch(FetchDescriptor<TodoItem>()).isEmpty)
    }
}
