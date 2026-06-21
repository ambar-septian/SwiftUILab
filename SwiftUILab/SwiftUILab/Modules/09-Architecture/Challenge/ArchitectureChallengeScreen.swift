import SwiftUI

// =============================================================================
// CHALLENGE — Architecture Patterns
//
// Model a small "todo toggle" feature with a unidirectional Store + pure reducer,
// then drive a view from it. The screen must compile at every step; replace each
// `// TODO:` with a real implementation.
//
// Compare against ArchitectureReferenceScreen and the guide's solution reveal.
// =============================================================================

struct ArchitectureChallengeScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                Task1_Reducer()
            }
            .padding(Theme.Spacing.md)
        }
        .navigationTitle("Challenge")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// =============================================================================
// Task 1 — Define a feature
//
// Build `TodoFeature` with:
//   • State { var todos: [String]; var done: Set<Int> }
//   • Action { case add(String); case toggle(Int); case clearDone }
//   • static func reduce(_:_:) implementing each action purely.
// Then expose `static func store() -> Store<State, Action>` (reuse the Store from
// the reference module).
// =============================================================================

// TODO: enum TodoFeature { struct State…; enum Action…; static func reduce…; static func store… }

private struct Task1_Reducer: View {
    // TODO: @State private var store = TodoFeature.store()
    @State private var draft = ""

    var body: some View {
        DemoSection(title: "1. Unidirectional todo feature") {
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                HStack {
                    TextField("New todo", text: $draft).textFieldStyle(.roundedBorder)
                    Button("Add") {
                        // TODO: store.send(.add(draft)); draft = ""
                    }
                    .buttonStyle(.borderedProminent)
                }
                // TODO: ForEach over store.state.todos with a toggle that sends .toggle(index).
                Text("Send actions; never mutate state directly.")
                    .font(.caption).foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack { ArchitectureChallengeScreen() }
}
