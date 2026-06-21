import SwiftUI

// =============================================================================
// CHALLENGE — Layout & Rendering
//
// Build a "Device Info" panel that exercises every concept from the reference.
// The screen must compile at all times; replace each `// TODO:` with a real
// implementation. Only the TODO markers are hints — no other guidance.
//
// When done, compare against LayoutReferenceScreen and the guide's solution reveal.
// =============================================================================

struct LayoutChallengeScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                Task1_EqualWidthHStack()
                Task2_PreferenceKey()
                Task3_AlignmentGuide()
                Task4_ExplicitIdentity()
                Task5_ViewBuilder()
            }
            .padding(Theme.Spacing.md)
        }
        .navigationTitle("Challenge")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// =============================================================================
// Task 1 — Layout protocol
//
// Build an `EqualHeightHStack: Layout` that arranges children horizontally and
// sizes every child to the tallest child's height. Use it below instead of the
// plain HStack.
// =============================================================================

// TODO: Define EqualHeightHStack: Layout here.

private struct Task1_EqualWidthHStack: View {
    var body: some View {
        DemoSection(title: "1. Layout protocol — EqualHeightHStack") {
            // TODO: Replace HStack with your EqualHeightHStack.
            // Each colored tile should expand to match the tallest sibling.
            HStack(spacing: 8) {
                Text("Short")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.blue.opacity(0.2), in: RoundedRectangle(cornerRadius: 8))
                Text("Taller\ncontent")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.green.opacity(0.2), in: RoundedRectangle(cornerRadius: 8))
                Text("Mid")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.orange.opacity(0.2), in: RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}

// =============================================================================
// Task 2 — PreferenceKey
//
// Define a `MaxHeightKey: PreferenceKey` and use it to make all rows in the
// table below the same height as the tallest row.
// =============================================================================

// TODO: Define MaxHeightKey: PreferenceKey here.

private struct Task2_PreferenceKey: View {
    // TODO: Add @State to hold the collected max height.

    private let specs = [
        ("Chip", "A18 Pro"),
        ("RAM", "8 GB"),
        ("Display", "Super Retina XDR\n6.1\" OLED"),
    ]

    var body: some View {
        DemoSection(title: "2. PreferenceKey — matched row height") {
            VStack(spacing: 4) {
                ForEach(specs, id: \.0) { label, value in
                    HStack {
                        Text(label).font(.caption).foregroundStyle(.secondary)
                            .frame(width: 60, alignment: .leading)
                        Text(value).font(.callout)
                        Spacer()
                    }
                    // TODO: Report this row's height via MaxHeightKey.
                    // TODO: Apply the collected height as frame(minHeight:).
                }
            }
            // TODO: Collect the preference here.
        }
    }
}

// =============================================================================
// Task 3 — alignmentGuide & custom alignment
//
// Define a custom `HorizontalAlignment` called `.trailingLabel`. Use it in the
// HStack below so that the trailing edges of all labels align, regardless of
// whether each label has an icon prefix.
// =============================================================================

// TODO: Extend HorizontalAlignment with .trailingLabel here.

private struct Task3_AlignmentGuide: View {
    var body: some View {
        DemoSection(title: "3. alignmentGuide — shared trailing-label axis") {
            // TODO: Replace VStack with an HStack (or VStack of HStacks) that uses
            // .trailingLabel alignment so labels line up on their trailing edge.
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                HStack { Image(systemName: "wifi"); Text("Wi-Fi") }
                HStack { Text("Bluetooth") }
                HStack { Image(systemName: "antenna.radiowaves.left.and.right"); Text("5G") }
            }
        }
    }
}

// =============================================================================
// Task 4 — Structural vs explicit identity
//
// The TextField below does NOT reset when "New entry" is tapped, because it
// shares structural identity across renders. Use `.id()` to force a fresh view
// (and empty field) on each tap.
// =============================================================================

private struct Task4_ExplicitIdentity: View {
    @State private var entryKey = 0
    @State private var note = ""

    var body: some View {
        DemoSection(title: "4. Explicit .id() — reset TextField on demand") {
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                TextField("Type something…", text: $note)
                    .textFieldStyle(.roundedBorder)
                // TODO: Add .id(entryKey) so the field resets when entryKey changes.
                Button("New entry") { entryKey += 1 }
                    .buttonStyle(.bordered)
                Text("Tap 'New entry' — the field should clear.")
                    .font(.caption).foregroundStyle(.secondary)
            }
        }
    }
}

// =============================================================================
// Task 5 — @ViewBuilder
//
// Build a `SignalStrength` view using `@ViewBuilder` that renders a different
// SF Symbol based on the `bars` value (0, 1, 2, 3). Do NOT use AnyView.
// =============================================================================

private struct Task5_ViewBuilder: View {
    @State private var bars = 2

    var body: some View {
        DemoSection(title: "5. @ViewBuilder — conditional icon without AnyView") {
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                // TODO: Replace this placeholder with your SignalStrength(bars:) view.
                Text("Signal bars: \(bars) (replace me)")
                    .font(.title2)
                Stepper("Bars: \(bars)", value: $bars, in: 0...3)
            }
        }
    }
}

// TODO: Define SignalStrength: View using @ViewBuilder here.

#Preview {
    NavigationStack {
        LayoutChallengeScreen()
    }
}
