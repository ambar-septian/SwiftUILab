import SwiftUI

// =============================================================================
// CHALLENGE — Navigation
//
// Build a type-safe Settings flow: a root list that drills into detail screens,
// a programmatic deep link, and an enum-driven sheet. The screen must compile at
// every step; replace each `// TODO:` with a real implementation.
//
// Compare against NavigationReferenceScreen and the guide's solution reveal.
// =============================================================================

struct NavigationChallengeScreen: View {
    // TODO: Add @State for a SettingsCoordinator (you define it below), then bind
    // NavigationStack(path:) to its path with @Bindable.

    var body: some View {
        // TODO: Wrap this List in a NavigationStack(path:) driven by your coordinator.
        List {
            Section("Settings") {
                // TODO: Replace these rows with NavigationLink(value: SettingsRoute…)
                // so tapping pushes the matching detail screen.
                Text("Account")
                Text("Notifications")
                Text("Privacy")
            }

            Section("Programmatic") {
                // TODO: Add a button that deep links straight to the Privacy detail
                // (path = [.section("Privacy"), .detail(...)] or similar).
                Button("Deep link to Privacy") { /* TODO */ }

                // TODO: Add a button that presents an enum-driven sheet (e.g. .about).
                Button("Show About sheet") { /* TODO */ }
            }
        }
        .navigationTitle("Settings")
        // TODO: Add .navigationDestination(for: SettingsRoute.self) { … } with an
        // exhaustive switch.
        // TODO: Add .sheet(item:) driven by the coordinator's optional sheet enum.
    }
}

// =============================================================================
// Task A — Define the route + sheet enums
//
// Model every push destination as a single Hashable enum, and the modal as an
// Identifiable enum. Keep them exhaustive.
// =============================================================================

// TODO: enum SettingsRoute: Hashable { case section(String); case detail(String) }
// TODO: enum SettingsSheet: String, Identifiable, CaseIterable { case about; var id … }

// =============================================================================
// Task B — Coordinator
//
// An @Observable object holding `path: [SettingsRoute]` and `sheet: SettingsSheet?`,
// with push / popToRoot / deepLink helpers.
// =============================================================================

// TODO: @Observable final class SettingsCoordinator { … }

// =============================================================================
// Task C — Deep-link parser (pure, unit-tested)
//
// Map swiftuilab://settings/<section> to the route stack that opens that section.
// Keep it free of SwiftUI so the tests can call it directly.
// =============================================================================

// TODO: enum SettingsDeepLink { static func routes(from url: URL) -> [SettingsRoute] }

#Preview {
    NavigationStack {
        NavigationChallengeScreen()
    }
}
