import SwiftUI

/// Stand-in for modules not yet implemented. Keeps the app compiling and
/// navigable while making the planned scope visible.
struct PlaceholderScreen: View {
    enum Kind {
        case reference, challenge
        var label: String { self == .reference ? "Reference" : "Challenge" }
        var icon: String { self == .reference ? "book.closed" : "hammer" }
    }

    let topic: ModuleTopic
    let kind: Kind

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Image(systemName: topic.systemImage)
                        .font(.largeTitle)
                        .foregroundStyle(.tint)
                    Text("\(kind.label) not implemented yet")
                        .font(.title2.bold())
                    Text("This module gets its `Reference/`, `Challenge/`, and `Tests/` in a focused session. The plan below is what it will cover.")
                        .foregroundStyle(.secondary)
                }

                DemoSection(title: "Planned concepts") {
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        ForEach(topic.plannedConcepts, id: \.self) { ConceptRow(text: $0) }
                    }
                }
            }
            .padding(Theme.Spacing.md)
        }
        .navigationTitle(kind.label)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PlaceholderScreen(topic: .navigation, kind: .reference)
    }
}
