import SwiftUI

/// The "Progress" tab: a checklist of all modules backed by `ProgressStore`.
/// Demonstrates reading shared `@Observable` state from the container and
/// mutating it from a leaf view.
struct ProgressTab: View {
    @Environment(AppContainer.self) private var container

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(container.catalog.modules()) { module in
                        Button {
                            container.progress.toggle(module.id)
                        } label: {
                            HStack {
                                Label("\(module.number). \(module.title)", systemImage: module.systemImage)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Image(systemName: container.progress.isComplete(module.id)
                                      ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(container.progress.isComplete(module.id) ? .green : .secondary)
                            }
                        }
                    }
                } header: {
                    Text("\(container.progress.completedCount) of \(container.catalog.modules().count) complete")
                }
            }
            .navigationTitle("Progress")
        }
    }
}

#Preview {
    ProgressTab()
        .environment(AppContainer.preview())
}
