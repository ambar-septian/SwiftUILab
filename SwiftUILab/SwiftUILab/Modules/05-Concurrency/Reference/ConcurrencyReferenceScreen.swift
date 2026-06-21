import SwiftUI

/// Reference implementation for Topic 5 — Structured Concurrency & Actors.
///
/// Demonstrates a `TaskGroup` fan-out, `async let` joins, hammering an `actor`
/// from many tasks without a data race, and `@MainActor` UI updates.
struct ConcurrencyReferenceScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                DemoSection(
                    title: "TaskGroup fan-out",
                    subtitle: "Square 1…N in parallel, reduce the results"
                ) { TaskGroupDemo() }

                DemoSection(
                    title: "async let",
                    subtitle: "Three concurrent loads joined into one snapshot"
                ) { AsyncLetDemo() }

                DemoSection(
                    title: "Actor (no data race)",
                    subtitle: "1,000 concurrent deposits — the actor serializes them"
                ) { ActorDemo() }
            }
            .padding(Theme.Spacing.md)
        }
        .navigationTitle("Concurrency")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Demo 1: TaskGroup

private struct TaskGroupDemo: View {
    @State private var n = 8
    @State private var result: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Stepper("Square & sum 1…\(n)", value: $n, in: 1...20)
            Text(result.map { "Σ = \($0)" } ?? "—").font(.title3.monospacedDigit())
            Button("Run in parallel") {
                Task { result = await parallelSum(Array(1...n)) }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - Demo 2: async let

private struct AsyncLetDemo: View {
    @State private var snapshot: DashboardSnapshot?
    @State private var elapsed: Double?

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            if let s = snapshot {
                Text("Users \(s.users) · Revenue \(s.revenue) · Errors \(s.errors)")
                    .font(.callout.monospacedDigit())
            } else {
                Text("—").font(.callout)
            }
            if let e = elapsed {
                Text(String(format: "Joined in %.0f ms (≈ one load, not three)", e * 1000))
                    .font(.caption).foregroundStyle(.secondary)
            }
            Button("Load concurrently") {
                Task {
                    let start = ContinuousClock.now
                    snapshot = await loadDashboard()
                    elapsed = Double(start.duration(to: .now).components.attoseconds) / 1e18
                }
            }
            .buttonStyle(.bordered)
        }
    }
}

// MARK: - Demo 3: actor

/// Spawns 1,000 concurrent deposits into one `actor`. With a plain class this
/// would lose updates to a data race; the actor guarantees the final balance is
/// exactly 1,000. The UI update is hopped back to `@MainActor` implicitly because
/// this view (and its `@State`) is main-actor isolated.
private struct ActorDemo: View {
    @State private var balance = 0
    @State private var running = false

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("Final balance: \(balance)").font(.title3.monospacedDigit())
            Button(running ? "Running…" : "Deposit ×1000 concurrently") {
                hammer()
            }
            .buttonStyle(.borderedProminent)
            .disabled(running)
            Text("Always lands on 1000 — the actor serializes every deposit.")
                .font(.caption).foregroundStyle(.secondary)
        }
    }

    private func hammer() {
        running = true
        Task {
            let account = BankAccount()
            await withTaskGroup(of: Void.self) { group in
                for _ in 0..<1000 {
                    group.addTask { await account.deposit(1) }
                }
            }
            balance = await account.balance
            running = false
        }
    }
}

#Preview {
    NavigationStack { ConcurrencyReferenceScreen() }
}
