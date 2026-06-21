import SwiftUI

// =============================================================================
// CHALLENGE — Async / Await
//
// Build a "search" screen that loads results with .task, supports cancellation,
// and bridges a callback API. The screen must compile at every step; replace each
// `// TODO:` with a real implementation.
//
// Compare against AsyncReferenceScreen and the guide's solution reveal.
// =============================================================================

struct AsyncChallengeScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                Task1_Loading()
                Task2_Cancellation()
                Task3_Stream()
                Task4_Continuation()
            }
            .padding(Theme.Spacing.md)
        }
        .navigationTitle("Challenge")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// =============================================================================
// Task 1 — .task loading with a typed phase
//
// Drive this view from a LoadPhase<[Article]>. Load with .task; render a spinner
// while loading, the rows when loaded, and the message when failed.
// =============================================================================

private struct Task1_Loading: View {
    // TODO: @State private var phase: LoadPhase<[Article]> = .idle

    var body: some View {
        DemoSection(title: "1. .task loading") {
            // TODO: switch over phase and render ProgressView / rows / error.
            Text("Wire me to a LoadPhase via .task { … }")
                .foregroundStyle(.secondary)
        }
        // TODO: .task { await load() } — call LiveArticleService().fetch().
    }
}

// =============================================================================
// Task 2 — Cooperative cancellation
//
// Start a Task that counts 1…100 with a Task.sleep each step. Add a Cancel button
// that calls .cancel(); the loop must check Task.isCancelled and stop.
// =============================================================================

private struct Task2_Cancellation: View {
    // TODO: @State for progress and the stored Task<Void, Never>?

    var body: some View {
        DemoSection(title: "2. Cooperative cancellation") {
            // TODO: progress bar + Start / Cancel buttons.
            Text("Start a cancellable counting Task")
                .foregroundStyle(.secondary)
        }
    }
}

// =============================================================================
// Task 3 — Consume an AsyncStream
//
// Use Countdown.stream(from:) and a for-await loop inside .task to drive a label.
// =============================================================================

private struct Task3_Stream: View {
    // TODO: @State private var current: Int?

    var body: some View {
        DemoSection(title: "3. AsyncStream") {
            // TODO: show `current`; .task { for await n in Countdown.stream(from: 5) { … } }
            Text("Drive a label from Countdown.stream(from:)")
                .foregroundStyle(.secondary)
        }
    }
}

// =============================================================================
// Task 4 — Bridge a callback API
//
// Call the async `geocode(_:)` bridge from a button and show the result.
// Then write your OWN bridge: wrap LegacyGeocoder.lookup in
// withCheckedThrowingContinuation in a new function and use it instead.
// =============================================================================

private struct Task4_Continuation: View {
    // TODO: @State for the query and result.

    var body: some View {
        DemoSection(title: "4. Continuation bridge") {
            // TODO: TextField + button calling your async bridge; show the result.
            Text("Bridge LegacyGeocoder.lookup with a continuation")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack { AsyncChallengeScreen() }
}
