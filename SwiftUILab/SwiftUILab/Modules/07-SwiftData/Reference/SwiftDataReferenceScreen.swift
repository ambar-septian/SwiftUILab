import SwiftUI
import SwiftData

/// Reference implementation for Topic 7 — SwiftData & Persistence.
///
/// The screen attaches its *own* in-memory container so it's self-contained and
/// never touches the app's real store. The inner view reads with `@Query` and
/// writes through the `ModelContext` from the environment.
struct SwiftDataReferenceScreen: View {
    var body: some View {
        TodoDemoView()
            // Overrides the container for this subtree only. inMemory keeps the
            // demo disposable; @Query below resolves against this container.
            .modelContainer(for: [TodoProject.self, TodoItem.self], inMemory: true)
            .navigationTitle("SwiftData")
            .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TodoDemoView: View {
    @Environment(\.modelContext) private var context

    // @Query is a view-driven fetch: it re-runs and re-renders automatically when
    // the underlying store changes. Sorting is pushed into the fetch.
    @Query(sort: \TodoItem.title) private var items: [TodoItem]

    @State private var newTitle = ""
    @State private var showOpenOnly = false

    private var visible: [TodoItem] {
        showOpenOnly ? items.filter { !$0.isDone } : items
    }

    var body: some View {
        List {
            Section {
                HStack {
                    TextField("New task", text: $newTitle)
                        .textFieldStyle(.roundedBorder)
                    Button("Add") { add() }
                        .buttonStyle(.borderedProminent)
                        .disabled(newTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                Toggle("Show open only", isOn: $showOpenOnly)
            }

            Section("Items (\(visible.count))") {
                ForEach(visible) { item in
                    Button {
                        item.isDone.toggle() // mutating a @Model is autosaved
                    } label: {
                        Label(item.title, systemImage: item.isDone ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(item.isDone ? .secondary : .primary)
                    }
                }
                .onDelete(perform: delete)
            }
        }
        .task { seedIfEmpty() }
    }

    private func add() {
        let item = TodoItem(title: newTitle.trimmingCharacters(in: .whitespaces))
        context.insert(item)
        newTitle = ""
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets { context.delete(visible[index]) }
    }

    private func seedIfEmpty() {
        guard items.isEmpty else { return }
        for title in ["Buy milk", "Ship build", "Review PR"] {
            context.insert(TodoItem(title: title))
        }
    }
}

#Preview {
    NavigationStack { SwiftDataReferenceScreen() }
}
