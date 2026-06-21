import SwiftUI

/// The per-module landing screen. Offers the Reference and Challenge entry
/// points (or a "coming soon" state) plus the concept checklist.
struct ModuleLandingView: View {
    let topic: ModuleTopic

    @Environment(AppContainer.self) private var container

    var body: some View {
        List {
            Section {
                if topic == .stateSystem {
                    NavigationLink(value: Route.reference(topic)) {
                        Label("Reference implementation", systemImage: "book.closed")
                    }
                    NavigationLink(value: Route.challenge(topic)) {
                        Label("Challenge", systemImage: "hammer")
                    }
                } else {
                    Label("Reference & Challenge coming in a future session",
                          systemImage: "clock.badge.questionmark")
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("Practice")
            }

            Section {
                ForEach(topic.plannedConcepts, id: \.self) { concept in
                    ConceptRow(text: concept)
                }
            } header: {
                Text("Concepts covered")
            }

            Section {
                Button {
                    container.progress.toggle(topic.id)
                } label: {
                    Label(container.progress.isComplete(topic.id) ? "Mark as not done" : "Mark as complete",
                          systemImage: container.progress.isComplete(topic.id) ? "xmark.circle" : "checkmark.circle")
                }
            }
        }
        .navigationTitle("\(topic.number). \(topic.title)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("Implemented") {
    NavigationStack {
        ModuleLandingView(topic: .stateSystem)
    }
    .environment(AppContainer.preview())
}

#Preview("Placeholder") {
    NavigationStack {
        ModuleLandingView(topic: .navigation)
    }
    .environment(AppContainer.preview())
}
