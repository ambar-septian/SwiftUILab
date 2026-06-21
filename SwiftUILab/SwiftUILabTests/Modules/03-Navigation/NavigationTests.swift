import Foundation
import Testing
@testable import SwiftUILab

@MainActor
@Suite("Navigation routing")
struct NavigationTests {

    // MARK: Deep-link parser

    @Test("Category URL maps to a single category route")
    func categoryDeepLink() {
        let routes = DeepLink.routes(from: URL(string: "swiftuilab://category/Phones")!)
        #expect(routes == [.category("Phones")])
    }

    @Test("Product URL synthesizes category + product")
    func productDeepLink() {
        let routes = DeepLink.routes(from: URL(string: "swiftuilab://product/macbook")!)
        #expect(routes == [.category("Laptops"), .product(Catalog.product(id: "macbook")!)])
    }

    @Test("Unknown host yields no routes")
    func unknownHost() {
        #expect(DeepLink.routes(from: URL(string: "swiftuilab://wishlist/1")!).isEmpty)
    }

    @Test("Unknown product id yields no routes")
    func unknownProduct() {
        #expect(DeepLink.routes(from: URL(string: "swiftuilab://product/nope")!).isEmpty)
    }

    @Test("Foreign scheme is rejected")
    func foreignScheme() {
        #expect(DeepLink.routes(from: URL(string: "https://product/macbook")!).isEmpty)
    }

    // MARK: Coordinator

    @Test("deepLink builds a category → product stack")
    func coordinatorDeepLink() {
        let c = ShopCoordinator()
        let macbook = Catalog.product(id: "macbook")!
        c.deepLink(to: macbook)
        #expect(c.path == [.category("Laptops"), .product(macbook)])
    }

    @Test("popToRoot clears the path")
    func coordinatorPopToRoot() {
        let c = ShopCoordinator()
        c.openCategory("Audio")
        c.openProduct(Catalog.product(id: "airpods")!)
        #expect(c.path.count == 2)
        c.popToRoot()
        #expect(c.path.isEmpty)
    }

    @Test("apply ignores an empty route list")
    func coordinatorApplyEmpty() {
        let c = ShopCoordinator()
        c.openCategory("Phones")
        c.apply([])
        #expect(c.path == [.category("Phones")])
    }
}
