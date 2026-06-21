import SwiftUI

/// Reference for Topic 9 — Architecture Patterns.
///
/// A counter built on a unidirectional `Store` (send actions, never mutate state
/// directly) next to a classic MVVM search, so the trade-offs are visible.
struct ArchitectureReferenceScreen: View {
    @State private var counter = CounterFeature.store()
    @State private var search = SearchViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                DemoSection(
                    title: "Unidirectional flow (Store + reducer)",
                    subtitle: "Views send actions; the pure reducer owns every change"
                ) {
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        Text("count = \(counter.state.count)")
                            .font(.title3.monospacedDigit())
                        HStack {
                            Button("–") { counter.send(.decrement) }.buttonStyle(.bordered)
                            Button("+") { counter.send(.increment) }.buttonStyle(.borderedProminent)
                            Button("Reset") { counter.send(.reset) }.buttonStyle(.bordered)
                        }
                        Text("history: \(counter.state.history.map(String.init).joined(separator: ", "))")
                            .font(.caption.monospacedDigit()).foregroundStyle(.secondary)
                    }
                }

                DemoSection(
                    title: "MVVM (for contrast)",
                    subtitle: "A view model owns state + talks to a service"
                ) {
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        HStack {
                            TextField("Search frameworks", text: $search.query)
                                .textFieldStyle(.roundedBorder)
                                .onSubmit { search.search() }
                            Button("Go") { search.search() }.buttonStyle(.bordered)
                        }
                        ForEach(search.results, id: \.self) { Text("• \($0)").font(.callout) }
                    }
                }

                DemoSection(
                    title: "Choosing an approach",
                    subtitle: "Fit vs overhead"
                ) {
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        ConceptRow(text: "Plain @State/@Observable: most screens")
                        ConceptRow(text: "MVVM: screen-local state + service calls")
                        ConceptRow(text: "Unidirectional store: shared, complex, testable flows")
                        ConceptRow(text: "SPM feature modules: enforce boundaries at scale")
                    }
                }
            }
            .padding(Theme.Spacing.md)
        }
        .navigationTitle("Architecture")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { ArchitectureReferenceScreen() }
}
