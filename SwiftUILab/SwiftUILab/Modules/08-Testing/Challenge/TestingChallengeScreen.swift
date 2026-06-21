import SwiftUI

// =============================================================================
// CHALLENGE — Unit Testing
//
// This module's challenge is in the TEST target, not the app. Open
//   SwiftUILabTests/Modules/08-Testing/TestingChallengeTests.swift
// and fill in the `// TODO:` tests for `ShippingCalculator` and `Cart`.
//
// This screen just runs the SUT so you can sanity-check expected values.
// =============================================================================

struct TestingChallengeScreen: View {
    private let calc = ShippingCalculator(freeThresholdCents: 5000, flatFeeCents: 599)
    @State private var subtotal = 30.0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                DemoSection(
                    title: "SUT: ShippingCalculator",
                    subtitle: "Free over $50, otherwise $5.99 flat"
                ) {
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        Slider(value: $subtotal, in: 0...80, step: 1)
                        let cents = Int(subtotal * 100)
                        Text("Subtotal $\(subtotal, format: .number.precision(.fractionLength(0)))  →  fee \(calc.fee(forSubtotalCents: cents))¢")
                            .font(.callout.monospacedDigit())
                        Text("Now assert these values in TestingChallengeTests.swift.")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                }

                DemoSection(title: "Your tasks") {
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        ConceptRow(text: "Parameterized test: fee across several subtotals")
                        ConceptRow(text: "Boundary test: exactly at the free threshold")
                        ConceptRow(text: "Cart: add/remove/clear change count correctly")
                        ConceptRow(text: "Async: RateLimiter denies after capacity")
                    }
                }
            }
            .padding(Theme.Spacing.md)
        }
        .navigationTitle("Challenge")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { TestingChallengeScreen() }
}
