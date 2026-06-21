import SwiftUI

// =============================================================================
// CHALLENGE — Performance & Debugging
//
// Instrument a small view: add _printChanges, scope a redraw so only the changed
// subview re-runs, and fix a retain cycle. The screen must compile at every step;
// replace each `// TODO:` with a real implementation.
//
// Compare against PerformanceReferenceScreen and the guide's solution reveal.
// =============================================================================

struct PerformanceChallengeScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                Task1_PrintChanges()
                Task2_ScopeRedraw()
                Task3_FixCycle()
            }
            .padding(Theme.Spacing.md)
        }
        .navigationTitle("Challenge")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// =============================================================================
// Task 1 — Add _printChanges
//
// Add `let _ = Self._printChanges()` at the top of this view's body and tap each
// button; read the console to see which dependency triggered the re-run.
// =============================================================================

private struct Task1_PrintChanges: View {
    @State private var a = 0
    @State private var b = 0

    var body: some View {
        // TODO: add `let _ = Self._printChanges()` here (and `return` the VStack).
        DemoSection(title: "1. _printChanges") {
            HStack {
                Button("Bump A (\(a))") { a += 1 }.buttonStyle(.bordered)
                Button("Bump B (\(b))") { b += 1 }.buttonStyle(.bordered)
            }
        }
    }
}

// =============================================================================
// Task 2 — Scope a redraw
//
// Right now bumping the counter re-runs this whole section. Extract the counter
// label into its own small subview so only it re-renders. (Prove it with a second
// _printChanges in the parent vs the child.)
// =============================================================================

private struct Task2_ScopeRedraw: View {
    @State private var count = 0

    var body: some View {
        DemoSection(title: "2. Scope the redraw") {
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                // TODO: move this Text into a dedicated CounterLabel subview.
                Text("count = \(count)").font(.title3.monospacedDigit())
                Button("Increment") { count += 1 }.buttonStyle(.bordered)
            }
        }
    }
}

// TODO: private struct CounterLabel: View { let count: Int; … }

// =============================================================================
// Task 3 — Fix a retain cycle
//
// `BrokenTimer` below leaks because its closure captures self strongly. Add a
// `fixed()` method that uses [weak self], and verify with the run() helper that
// the node deallocates.
// =============================================================================

private final class BrokenTimer {
    var tick: (() -> Void)?
    private(set) var ticks = 0
    func broken() { tick = { self.ticks += 1 } } // leaks
    // TODO: func fixed() { tick = { [weak self] in self?.ticks += 1 } }
}

private struct Task3_FixCycle: View {
    @State private var status = "—"

    var body: some View {
        DemoSection(title: "3. Fix the retain cycle") {
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                Button("Test deallocation") {
                    var t: BrokenTimer? = BrokenTimer()
                    weak var weakT = t
                    // TODO: call t?.fixed() instead of t?.broken()
                    t?.broken()
                    t = nil
                    status = weakT == nil ? "Deallocated ✅" : "Leaked ❌"
                    weakT?.tick = nil
                }
                .buttonStyle(.bordered)
                Text(status)
            }
        }
    }
}

#Preview {
    NavigationStack { PerformanceChallengeScreen() }
}
