import SwiftUI

/// The module list. Data-driven from the injected `CatalogService`, so tests and
/// previews can supply any catalog shape.
struct ModuleCatalogView: View {
    @Environment(AppContainer.self) private var container

    var body: some View {
        List(container.catalog.modules()) { module in
            NavigationLink(value: Route.module(module.topic)) {
                ModuleRow(module: module,
                          isComplete: container.progress.isComplete(module.id))
            }
        }
        .listStyle(.insetGrouped)
    }
}

private struct ModuleRow: View {
    let module: LearningModule
    let isComplete: Bool

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            Image(systemName: module.systemImage)
                .font(.title2)
                .frame(width: 32)
                .foregroundStyle(.tint)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(module.number). \(module.title)").font(.headline)
                Text(module.subtitle).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
            if isComplete {
                Image(systemName: "checkmark.seal.fill").foregroundStyle(.green)
            } else if !module.isImplemented {
                Pill("Soon", tint: .secondary)
            }
        }
        .padding(.vertical, Theme.Spacing.xs)
    }
}

#Preview {
    NavigationStack {
        ModuleCatalogView()
            .navigationTitle("SwiftUI Lab")
    }
    .environment(AppContainer.preview())
}
