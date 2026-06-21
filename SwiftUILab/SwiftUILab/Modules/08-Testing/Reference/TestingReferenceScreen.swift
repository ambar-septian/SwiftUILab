import SwiftUI

/// Reference for Topic 8 — Unit Testing with Swift Testing.
///
/// This screen shows the systems-under-test running live; the *actual* reference
/// is the test file `SwiftUILabTests/Modules/08-Testing/TestingTests.swift`,
/// which demonstrates each technique. Read them side by side.
struct TestingReferenceScreen: View {
    @State private var cart = Cart()
    private let formatter = PriceFormatter()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                DemoSection(
                    title: "SUT: PriceFormatter",
                    subtitle: "Pure transform — the easiest thing to test"
                ) {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach([0, 150, 99_99], id: \.self) { cents in
                            Text("\(cents)¢ → \(formatter.string(fromCents: cents))")
                                .font(.callout.monospacedDigit())
                        }
                    }
                }

                DemoSection(
                    title: "SUT: Cart (@Observable)",
                    subtitle: "Drive it here; assert on it in the tests"
                ) {
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        Text("Items: \(cart.items.joined(separator: ", "))")
                            .font(.callout)
                        HStack {
                            Button("Add Apple") { cart.add("Apple") }.buttonStyle(.bordered)
                            Button("Clear") { cart.clear() }.buttonStyle(.bordered)
                        }
                        Text("count = \(cart.count)").font(.caption).foregroundStyle(.secondary)
                    }
                }

                DemoSection(
                    title: "Techniques in the test file",
                    subtitle: "What TestingTests.swift demonstrates"
                ) {
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        ConceptRow(text: "@Suite / @Test / #expect & #require")
                        ConceptRow(text: "Parameterized tests via arguments:")
                        ConceptRow(text: "Async tests (await the SUT directly)")
                        ConceptRow(text: "Actor isolation (await actor methods)")
                        ConceptRow(text: "@Observable state assertions")
                        ConceptRow(text: "#expect(throws:) for error paths")
                        ConceptRow(text: "Draining an AsyncStream")
                    }
                }
            }
            .padding(Theme.Spacing.md)
        }
        .navigationTitle("Unit Testing")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { TestingReferenceScreen() }
}
