import SwiftUI
import SwiftData

// =============================================================================
// CHALLENGE — SwiftData & Persistence
//
// Build a "Notebook" of notes backed by SwiftData: a @Model, an in-memory
// container, @Query-driven list, insert/delete, and a #Predicate filter. The
// screen must compile at every step; replace each `// TODO:` with a real impl.
//
// Compare against SwiftDataReferenceScreen and the guide's solution reveal.
// =============================================================================

struct SwiftDataChallengeScreen: View {
    var body: some View {
        // TODO: Attach .modelContainer(for: [Note.self], inMemory: true) once you
        // define the Note model below, then render NotebookView().
        NotebookView()
            .navigationTitle("Challenge")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// =============================================================================
// Task 1 — Define the model
//
// A `Note` @Model with `body: String`, `pinned: Bool`, and a `createdAt: Date`.
// =============================================================================

// TODO: @Model final class Note { … }

// =============================================================================
// Task 2 — Query-driven list
//
// Read notes with @Query (sort by createdAt, newest first). Insert via the
// ModelContext from the environment; support swipe-to-delete.
//
// Task 3 — #Predicate filter
//
// Add a "pinned only" toggle. Bonus: drive it with a FetchDescriptor whose
// #Predicate filters pinned == true, instead of filtering in Swift.
// =============================================================================

private struct NotebookView: View {
    // TODO: @Environment(\.modelContext) private var context
    // TODO: @Query private var notes: [Note]
    @State private var draft = ""

    var body: some View {
        List {
            Section {
                HStack {
                    TextField("New note", text: $draft).textFieldStyle(.roundedBorder)
                    Button("Add") { /* TODO: insert a Note */ }
                        .buttonStyle(.borderedProminent)
                }
            }
            Section("Notes") {
                // TODO: ForEach over your notes; show body + a pin toggle; onDelete.
                Text("Wire @Query to list notes here").foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack { SwiftDataChallengeScreen() }
}
