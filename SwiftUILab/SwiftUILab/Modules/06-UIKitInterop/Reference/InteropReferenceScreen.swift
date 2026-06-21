import SwiftUI

/// Reference implementation for Topic 6 — UIKit Interop.
///
/// A `UIViewRepresentable` (UISlider) with a Coordinator and loop-safe updates, a
/// `UIViewControllerRepresentable`, and notes on `UIHostingController` sizing.
struct InteropReferenceScreen: View {
    @State private var rating = 3.0
    @State private var vcCount = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                DemoSection(
                    title: "UIViewRepresentable + Coordinator",
                    subtitle: "A UIKit UISlider with two-way SwiftUI binding"
                ) {
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        RatingSlider(value: $rating)
                        Text("Rating: \(rating, format: .number.precision(.fractionLength(1)))")
                            .font(.callout.monospacedDigit())
                        // Driving the binding from SwiftUI updates the UISlider via
                        // updateUIView — the guard prevents redundant writes.
                        Button("Set to 5 from SwiftUI") { rating = 5 }
                            .buttonStyle(.bordered)
                        Text("Coordinator forwards .valueChanged → binding; updateUIView guards the reverse path.")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                }

                DemoSection(
                    title: "UIViewControllerRepresentable",
                    subtitle: "A UIViewController hosted in the SwiftUI tree"
                ) {
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        CounterControllerView(count: $vcCount)
                            .frame(height: 44)
                            .background(Color.labMuted.opacity(0.15),
                                       in: RoundedRectangle(cornerRadius: Theme.Radius.card))
                        Stepper("SwiftUI count: \(vcCount)", value: $vcCount)
                        Text("updateUIViewController pushes SwiftUI state into the UIKit controller each render.")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                }

                DemoSection(
                    title: "UIHostingController sizing",
                    subtitle: "Going the other direction: SwiftUI inside UIKit"
                ) {
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        Text("`UIHostingController` hosts a SwiftUI view in UIKit. For self-sizing cells, set `view.invalidateIntrinsicContentSize()` or use the `sizingOptions = [.intrinsicContentSize]` API so Auto Layout reads the SwiftUI ideal size.")
                            .font(.callout)
                        Text("Common bug: a hosting controller in a UITableViewCell that reports a zero/too-small height because intrinsic sizing wasn't enabled.")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
            .padding(Theme.Spacing.md)
        }
        .navigationTitle("UIKit Interop")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { InteropReferenceScreen() }
}
