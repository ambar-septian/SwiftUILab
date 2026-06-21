import Foundation

// MARK: - Domain

/// A product in the demo shop. `Hashable` + `Identifiable` so it can be both a
/// navigation value and a `ForEach` element.
struct Product: Hashable, Identifiable {
    let id: String
    let name: String
    let category: String
}

/// Static catalog used by the navigation demos.
enum Catalog {
    static let categories = ["Phones", "Laptops", "Audio"]

    static let products: [Product] = [
        Product(id: "iphone", name: "iPhone", category: "Phones"),
        Product(id: "pixel", name: "Pixel", category: "Phones"),
        Product(id: "macbook", name: "MacBook", category: "Laptops"),
        Product(id: "xps", name: "XPS 13", category: "Laptops"),
        Product(id: "airpods", name: "AirPods", category: "Audio"),
        Product(id: "qc", name: "QuietComfort", category: "Audio"),
    ]

    static func products(in category: String) -> [Product] {
        products.filter { $0.category == category }
    }

    static func product(id: String) -> Product? {
        products.first { $0.id == id }
    }
}

// MARK: - Type-safe route

/// The single, exhaustive description of every push destination in the shop flow.
/// Because it's an `enum`, the `navigationDestination(for:)` switch is checked by
/// the compiler — a new screen can't be forgotten.
enum ShopRoute: Hashable {
    case category(String)
    case product(Product)
}

/// Enum-driven modal presentation. `Identifiable` lets it back a `sheet(item:)`.
enum ShopSheet: String, Identifiable, CaseIterable {
    case cart
    case about
    var id: String { rawValue }
}

// MARK: - Coordinator

/// Owns navigation state for the flow. Putting `path` and `sheet` on one
/// `@Observable` object (placed in the environment) lets any descendant drive
/// navigation without prop-drilling bindings — the coordinator pattern.
@Observable
final class ShopCoordinator {
    var path: [ShopRoute] = []
    var sheet: ShopSheet?

    func openCategory(_ category: String) {
        path.append(.category(category))
    }

    func openProduct(_ product: Product) {
        path.append(.product(product))
    }

    func popToRoot() {
        path.removeAll()
    }

    /// Programmatic deep link: replaces the whole stack so the back button walks
    /// the synthesized hierarchy (category → product) as if the user had tapped in.
    func deepLink(to product: Product) {
        path = [.category(product.category), .product(product)]
    }

    /// Applies a parsed deep link, ignoring anything that doesn't resolve.
    func apply(_ routes: [ShopRoute]) {
        guard !routes.isEmpty else { return }
        path = routes
    }
}

// MARK: - Deep-link parser

/// Pure URL → routes mapping. Kept free of SwiftUI so it's trivially unit-testable.
///
/// Supported shapes:
///   swiftuilab://category/<name>
///   swiftuilab://product/<id>     (synthesizes the category above it)
enum DeepLink {
    static let scheme = "swiftuilab"

    static func routes(from url: URL) -> [ShopRoute] {
        guard url.scheme == scheme, let host = url.host else { return [] }
        let segments = url.pathComponents.filter { $0 != "/" }

        switch host {
        case "category":
            guard let name = segments.first,
                  Catalog.categories.contains(name) else { return [] }
            return [.category(name)]

        case "product":
            guard let id = segments.first,
                  let product = Catalog.product(id: id) else { return [] }
            return [.category(product.category), .product(product)]

        default:
            return []
        }
    }
}
