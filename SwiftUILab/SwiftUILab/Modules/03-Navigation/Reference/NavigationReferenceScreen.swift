import SwiftUI

/// Reference implementation for Topic 3 — Navigation.
///
/// The screen hosts its *own* `NavigationStack` so every navigation concept is
/// demonstrable in isolation: a type-safe path, an exhaustive destination switch,
/// programmatic deep linking, the coordinator pattern, and enum-driven modals.
struct NavigationReferenceScreen: View {
    @State private var coordinator = ShopCoordinator()

    var body: some View {
        @Bindable var coordinator = coordinator
        NavigationStack(path: $coordinator.path) {
            List {
                Section("NavigationPath depth: \(coordinator.path.count)") {
                    ForEach(Catalog.categories, id: \.self) { category in
                        // value-based link: pushes ShopRoute.category onto the path
                        NavigationLink(value: ShopRoute.category(category)) {
                            Label(category, systemImage: "square.grid.2x2")
                        }
                    }
                }

                Section("Programmatic") {
                    Button {
                        // Deep link: build the whole stack in one assignment.
                        if let macbook = Catalog.product(id: "macbook") {
                            coordinator.deepLink(to: macbook)
                        }
                    } label: {
                        Label("Deep link to MacBook", systemImage: "arrow.uturn.forward")
                    }

                    Button {
                        coordinator.apply(
                            DeepLink.routes(from: URL(string: "swiftuilab://product/airpods")!)
                        )
                    } label: {
                        Label("Open URL: …//product/airpods", systemImage: "link")
                    }

                    Button(role: .destructive) {
                        coordinator.popToRoot()
                    } label: {
                        Label("Pop to root", systemImage: "arrow.up.to.line")
                    }
                    .disabled(coordinator.path.isEmpty)
                }

                Section("Modals (enum-driven)") {
                    ForEach(ShopSheet.allCases) { sheet in
                        Button {
                            coordinator.sheet = sheet
                        } label: {
                            Label("Present \(sheet.rawValue)", systemImage: "rectangle.portrait")
                        }
                    }
                }
            }
            .navigationTitle("Shop")
            // Exhaustive, compiler-checked destination switch — the heart of
            // type-safe navigation.
            .navigationDestination(for: ShopRoute.self) { route in
                destination(for: route)
            }
            // sheet(item:) is driven by an optional Identifiable — assigning the
            // enum presents, setting nil dismisses. No stray boolean to keep in sync.
            .sheet(item: $coordinator.sheet) { sheet in
                SheetContent(sheet: sheet)
                    .presentationDetents([.medium])
            }
        }
        .environment(coordinator)
    }

    @ViewBuilder
    private func destination(for route: ShopRoute) -> some View {
        switch route {
        case .category(let name):
            CategoryScreen(category: name)
        case .product(let product):
            ProductScreen(product: product)
        }
    }
}

// MARK: - Pushed screens

/// Reads the coordinator from the environment to push further — no bindings passed.
private struct CategoryScreen: View {
    let category: String
    @Environment(ShopCoordinator.self) private var coordinator

    var body: some View {
        List(Catalog.products(in: category)) { product in
            NavigationLink(value: ShopRoute.product(product)) {
                Text(product.name)
            }
        }
        .navigationTitle(category)
    }
}

private struct ProductScreen: View {
    let product: Product
    @Environment(ShopCoordinator.self) private var coordinator

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Image(systemName: "shippingbox.fill")
                .font(.system(size: 64))
                .foregroundStyle(.tint)
            Text(product.name).font(.largeTitle.bold())
            Text(product.category).foregroundStyle(.secondary)

            Button("Back to root") { coordinator.popToRoot() }
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Modal

private struct SheetContent: View {
    let sheet: ShopSheet
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: Theme.Spacing.md) {
                Image(systemName: sheet == .cart ? "cart" : "info.circle")
                    .font(.largeTitle).foregroundStyle(.tint)
                Text(sheet == .cart ? "Your cart is empty." : "SwiftUILab demo shop.")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle(sheet.rawValue.capitalized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    NavigationReferenceScreen()
}
