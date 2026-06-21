import SwiftUI

// =============================================================================
// CHALLENGE — Structured Concurrency & Actors
//
// Build a small "metrics" panel: parallel computation with a TaskGroup, a fixed
// concurrent join with async let, and a thread-safe counter actor. The screen
// must compile at every step; replace each `// TODO:` with a real implementation.
//
// Compare against ConcurrencyReferenceScreen and the guide's solution reveal.
// =============================================================================

struct ConcurrencyChallengeScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                Task1_TaskGroup()
                Task2_AsyncLet()
                Task3_Actor()
            }
            .padding(Theme.Spacing.md)
        }
        .navigationTitle("Challenge")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// =============================================================================
// Task 1 — TaskGroup
//
// Write `func parallelMax(_ values: [Int]) async -> Int?` using withTaskGroup
// that returns the largest value, computing each child concurrently. Call it
// from the button below.
// =============================================================================

// TODO: func parallelMax(_ values: [Int]) async -> Int? { … }

private struct Task1_TaskGroup: View {
    @State private var result: Int?

    var body: some View {
        DemoSection(title: "1. TaskGroup — parallel max") {
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                Text(result.map { "max = \($0)" } ?? "—")
                Button("Compute") {
                    // TODO: Task { result = await parallelMax([3, 9, 2, 7, 5]) }
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

// =============================================================================
// Task 2 — async let
//
// Write `func loadProfile() async -> (name: String, posts: Int)` that runs two
// slow loads concurrently with async let and joins them.
// =============================================================================

// TODO: func loadProfile() async -> (name: String, posts: Int) { … }

private struct Task2_AsyncLet: View {
    @State private var text = "—"

    var body: some View {
        DemoSection(title: "2. async let — concurrent join") {
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                Text(text)
                Button("Load") {
                    // TODO: Task { let p = await loadProfile(); text = "\(p.name): \(p.posts)" }
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

// =============================================================================
// Task 3 — Actor
//
// Define `actor Counter` with `increment()` and a `value` accessor. Hammer it
// with 500 concurrent increments via a TaskGroup and show the (correct) total.
// =============================================================================

// TODO: actor Counter { … }

private struct Task3_Actor: View {
    @State private var total = 0

    var body: some View {
        DemoSection(title: "3. Actor — race-free counter") {
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                Text("total = \(total)")
                Button("Increment ×500 concurrently") {
                    // TODO: spin up a Counter, hammer it with a TaskGroup, read the value.
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

#Preview {
    NavigationStack { ConcurrencyChallengeScreen() }
}
