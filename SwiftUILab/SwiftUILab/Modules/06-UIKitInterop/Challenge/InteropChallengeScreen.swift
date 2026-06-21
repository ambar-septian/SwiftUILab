import SwiftUI
import UIKit

// =============================================================================
// CHALLENGE — UIKit Interop
//
// Wrap a UIKit control and a UIKit controller for SwiftUI. The screen must
// compile at every step; replace each `// TODO:` with a real implementation.
//
// Compare against InteropReferenceScreen and the guide's solution reveal.
// =============================================================================

struct InteropChallengeScreen: View {
    @State private var text = ""
    @State private var page = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                DemoSection(title: "1. UIViewRepresentable — UITextField") {
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        // TODO: Replace with your WrappedTextField(text: $text).
                        Text("Bound text: \(text)").foregroundStyle(.secondary)
                    }
                }

                DemoSection(title: "2. UIViewControllerRepresentable — paged VC") {
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        // TODO: Host a UIViewController that displays `page`.
                        Stepper("Page: \(page)", value: $page, in: 0...4)
                    }
                }
            }
            .padding(Theme.Spacing.md)
        }
        .navigationTitle("Challenge")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// =============================================================================
// Task 1 — Wrap UITextField
//
// Build `WrappedTextField: UIViewRepresentable` with a `@Binding var text`. Use a
// Coordinator conforming to UITextFieldDelegate (or a target-action on
// .editingChanged) to push edits back into the binding. Guard updateUIView so you
// don't overwrite the field while the user is typing.
// =============================================================================

// TODO: struct WrappedTextField: UIViewRepresentable { … }

// =============================================================================
// Task 2 — Wrap a UIViewController
//
// Build a `PageViewController: UIViewController` that shows a big "Page N" label,
// then `PageControllerView: UIViewControllerRepresentable` with a `@Binding var
// page` that pushes the value in via updateUIViewController.
// =============================================================================

// TODO: final class PageViewController: UIViewController { … }
// TODO: struct PageControllerView: UIViewControllerRepresentable { … }

#Preview {
    NavigationStack { InteropChallengeScreen() }
}
