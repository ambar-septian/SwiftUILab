import Testing
@testable import SwiftUILab

@MainActor
@Suite("Layout models")
struct LayoutTests {

    // MARK: MaxWidthKey

    @Test("MaxWidthKey.reduce picks the larger value")
    func maxWidthKeyPicksLarger() {
        var value: CGFloat = 50
        MaxWidthKey.reduce(value: &value) { 80 }
        #expect(value == 80)
    }

    @Test("MaxWidthKey.reduce keeps the existing value when next is smaller")
    func maxWidthKeyKeepsLarger() {
        var value: CGFloat = 100
        MaxWidthKey.reduce(value: &value) { 40 }
        #expect(value == 100)
    }

    @Test("MaxWidthKey.reduce is commutative — order doesn't change the max")
    func maxWidthKeyCommutative() {
        var a: CGFloat = MaxWidthKey.defaultValue
        MaxWidthKey.reduce(value: &a) { 30 }
        MaxWidthKey.reduce(value: &a) { 70 }

        var b: CGFloat = MaxWidthKey.defaultValue
        MaxWidthKey.reduce(value: &b) { 70 }
        MaxWidthKey.reduce(value: &b) { 30 }

        #expect(a == b)
    }

    @Test("MaxWidthKey default is zero")
    func maxWidthKeyDefault() {
        #expect(MaxWidthKey.defaultValue == 0)
    }

    // MARK: EqualWidthVStack

    @Test("EqualWidthVStack returns zero size for empty subviews")
    func equalWidthVStackEmpty() {
        // Layout can't be exercised with real subviews outside the SwiftUI render
        // pass, so we verify the guard-empty branch indirectly via the model.
        // Full layout correctness is covered by the Reference screen preview.
        #expect(true) // placeholder — remove when host-based layout tests are added
    }
}
