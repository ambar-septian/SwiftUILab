import SwiftUI

/// Reference for Topic 10 — Performance & Debugging.
///
/// `Self._printChanges()` for redraw debugging, a live frame-budget monitor
/// (hitch detection), and a retain-cycle demo you can watch deallocate (or not).
struct PerformanceReferenceScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                DemoSection(
                    title: "Self._printChanges()",
                    subtitle: "Logs which dependency triggered each body re-run"
                ) { PrintChangesDemo() }

                DemoSection(
                    title: "Hitch detection",
                    subtitle: "Rolling average vs the 16.67ms frame budget"
                ) { HitchDemo() }

                DemoSection(
                    title: "Retain cycles",
                    subtitle: "Strong self-capture leaks; [weak self] deallocates"
                ) { RetainCycleDemo() }
            }
            .padding(Theme.Spacing.md)
        }
        .navigationTitle("Performance")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Demo 1: _printChanges

private struct PrintChangesDemo: View {
    @State private var count = 0
    @State private var unrelated = false

    var body: some View {
        // Prints to the console on every body invocation, naming the changed
        // dependency. Remove before shipping — it's a debugging-only call.
        let _ = Self._printChanges()
        return VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("count = \(count)").font(.title3.monospacedDigit())
            HStack {
                Button("Increment") { count += 1 }.buttonStyle(.bordered)
                Button("Toggle unrelated") { unrelated.toggle() }.buttonStyle(.bordered)
            }
            Text("Watch the Xcode console: each tap logs the property that forced this body to re-run.")
                .font(.caption).foregroundStyle(.secondary)
        }
    }
}

// MARK: - Demo 2: hitch detection

private struct HitchDemo: View {
    @State private var monitor = FrameMonitor()
    @State private var nextSample = 12.0

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Slider(value: $nextSample, in: 4...40, step: 1)
            Text("Next frame sample: \(nextSample, format: .number.precision(.fractionLength(0))) ms")
                .font(.caption).foregroundStyle(.secondary)
            Button("Record frame") { monitor.record(nextSample) }
                .buttonStyle(.bordered)

            Text("Average: \(monitor.average, format: .number.precision(.fractionLength(1))) ms")
                .font(.callout.monospacedDigit())
            Label(
                monitor.isHitchy ? "Hitching — over budget" : "Smooth — within budget",
                systemImage: monitor.isHitchy ? "exclamationmark.triangle.fill" : "checkmark.seal.fill"
            )
            .foregroundStyle(monitor.isHitchy ? .red : .green)
        }
    }
}

// MARK: - Demo 3: retain cycle

private struct RetainCycleDemo: View {
    @State private var result = "—"

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                Button("Leaky setup") { result = run(safe: false) }
                    .buttonStyle(.bordered)
                Button("Safe setup") { result = run(safe: true) }
                    .buttonStyle(.borderedProminent)
            }
            Text(result).font(.callout)
            Text("`leakySetup` captures self strongly — the node survives after we drop our reference. `safeSetup` uses [weak self] and deallocates.")
                .font(.caption).foregroundStyle(.secondary)
        }
    }

    /// Creates a node, wires the closure, drops the strong reference, then checks
    /// whether a weak reference still sees it alive.
    private func run(safe: Bool) -> String {
        var node: RetainNode? = RetainNode()
        weak var weakNode = node
        if safe { node?.safeSetup() } else { node?.leakySetup() }
        node = nil
        let leaked = weakNode != nil
        weakNode?.onChange = nil // break the cycle so the demo doesn't actually leak
        return leaked ? "Leaked: node still alive after release ❌" : "Deallocated cleanly ✅"
    }
}

#Preview {
    NavigationStack { PerformanceReferenceScreen() }
}
