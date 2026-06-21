import SwiftUI

/// Reference implementation for Topic 1 — the SwiftUI state system.
///
/// Each `DemoSection` isolates one concept so the runtime behavior is observable
/// in the simulator. Read the inline comments alongside the docs-site page.
struct StateSystemReferenceScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                stateAndBinding
                customBinding
                observableAndBindable
                legacyOwnership
                environmentValue
                minimizingInvalidations
            }
            .padding(Theme.Spacing.md)
        }
        .navigationTitle("State System")
        .navigationBarTitleDisplayMode(.inline)
        // Inject a custom environment value consumed by `EnvironmentReader` below.
        .environment(\.labAccentName, "Indigo")
    }

    // MARK: 1. @State + @Binding

    private var stateAndBinding: some View {
        DemoSection(
            title: "@State + @Binding",
            subtitle: "Parent owns the value; child mutates it through a binding"
        ) {
            StateBindingDemo()
        }
    }

    // MARK: 2. Custom Binding(get:set:)

    private var customBinding: some View {
        DemoSection(
            title: "Custom Binding(get:set:)",
            subtitle: "Derive a binding that transforms on read/write — here, clamping"
        ) {
            ClampingBindingDemo()
        }
    }

    // MARK: 3. @Observable + @Bindable

    private var observableAndBindable: some View {
        DemoSection(
            title: "@Observable + @Bindable",
            subtitle: "Field-granular observation; @Bindable projects bindings into a child"
        ) {
            ObservableBindableDemo()
        }
    }

    // MARK: 4. @StateObject vs @ObservedObject

    private var legacyOwnership: some View {
        DemoSection(
            title: "@StateObject ownership (legacy)",
            subtitle: "@StateObject creates & owns; @ObservedObject would reset on re-render"
        ) {
            LegacyOwnershipDemo()
        }
    }

    // MARK: 5. @Environment custom key

    private var environmentValue: some View {
        DemoSection(
            title: "@Environment custom key",
            subtitle: "Injected by an ancestor, read without prop-drilling"
        ) {
            EnvironmentReader()
        }
    }

    // MARK: 6. Minimizing invalidations

    private var minimizingInvalidations: some View {
        DemoSection(
            title: "Minimizing invalidations",
            subtitle: "Field-granular observation — only the view that read a changed property re-renders"
        ) {
            MinimizingInvalidationsDemo()
        }
    }
}

// MARK: - Demos

/// The parent owns `count` as value-typed `@State`. `$count` hands the child a
/// `Binding<Int>` — a reference into the parent's storage, not a copy. Mutating
/// it in the child writes straight back and invalidates the parent.
private struct StateBindingDemo: View {
    @State private var count = 0
			
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("Count: \(count)").font(.title3.monospacedDigit())
            StepperRow(value: $count)
            Text("`$count` is a Binding<Int> into this view's @State storage.")
                .font(.caption).foregroundStyle(.secondary)
        }
    }
}

/// Child receives a `@Binding`; it neither owns nor copies the value.
private struct StepperRow: View {
    @Binding var value: Int

    var body: some View {
        HStack {
            Button("–") { value -= 1 }.buttonStyle(.bordered)
            Button("+") { value += 1 }.buttonStyle(.borderedProminent)
        }
    }
}

/// Classic custom-binding use: a `Slider` over a `Double` that writes back into
/// an `Int` clamped to a range. The binding is the transform layer.
private struct ClampingBindingDemo: View {
    @State private var volume = 5

    var body: some View {
        let clamped = Binding<Double>(
            get: { Double(volume) },
            set: { volume = min(10, max(0, Int($0.rounded()))) }
        )
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Slider(value: clamped, in: 0...10, step: 1)
            Text("Volume: \(volume)  (clamped 0…10)").font(.callout.monospacedDigit())
        }
    }
}

/// `model` is owned here via `@State` (the modern home for `@Observable`
/// reference types). The child takes the same instance and uses `@Bindable` to
/// project a binding into `model.label`.
private struct ObservableBindableDemo: View {
    @State private var model = CounterModel()

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            // Reads `count` and `label`; only re-runs when those fields change.
            Text("\(model.label): \(model.count)").font(.title3.monospacedDigit())
            Button("Increment") { model.increment() }.buttonStyle(.bordered)
            LabelEditor(model: model)
        }
    }
}

/// Receives an `@Observable` instance and needs *two-way* access to a property.
/// `@Bindable` is what unlocks `$model.label` for a passed-in observable.
private struct LabelEditor: View {
    @Bindable var model: CounterModel

    var body: some View {
        TextField("Label", text: $model.label)
            .textFieldStyle(.roundedBorder)
    }
}

/// `@StateObject` ensures exactly one `LegacyCounter` survives across this view's
/// re-renders. The `tick` state below forces parent re-renders; the count
/// persists, proving ownership. Swap to `@ObservedObject private var counter =
/// LegacyCounter()` and the count resets every tick — the bug to recognize.
private struct LegacyOwnershipDemo: View {
    @StateObject private var counter = LegacyCounter()
    @State private var tick = 0

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("Counter: \(counter.count)").font(.title3.monospacedDigit())
            HStack {
                Button("Increment") { counter.increment() }.buttonStyle(.bordered)
                Button("Re-render parent (tick \(tick))") { tick += 1 }
                    .buttonStyle(.bordered)
            }
            Text("Count survives parent re-renders because @StateObject owns it.")
                .font(.caption).foregroundStyle(.secondary)
        }
    }
}

/// Reads the custom environment value injected by the screen root.
private struct EnvironmentReader: View {
    @Environment(\.labAccentName) private var accentName

    var body: some View {
        Label("Injected accent: \(accentName)", systemImage: "paintpalette")
            .font(.callout)
    }
}

/// Passes the same `@Observable` to two children that each read a *different*
/// field. The parent reads no properties itself, so its `body` runs only once.
/// Mutating one field only invalidates the child that observed it — the other
/// render counter stays frozen. This is the key win over `ObservableObject`,
/// which fires `objectWillChange` for the whole object on any mutation.
private struct MinimizingInvalidationsDemo: View {
    @State private var settings = DemoSettings()
    private let names = ["Ada", "Grace", "Alan", "Linus", "Margaret"]

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            // Each child holds the reference and reads only its own field.
            // If MinimizingInvalidationsDemo read settings.* here, it would
            // re-render on any mutation and drag both children with it.
            UsernameRow(settings: settings)
            NotificationsRow(settings: settings)
            HStack(spacing: Theme.Spacing.sm) {
                Button("Change name") {
                    settings.username = names.randomElement()!
                }.buttonStyle(.bordered)
                Button("Toggle notifications") {
                    settings.notificationsEnabled.toggle()
                }.buttonStyle(.bordered)
            }
            Text("×N = render count. Only the row whose field changed increments.")
                .font(.caption).foregroundStyle(.secondary)
        }
    }
}

/// Reads only `settings.username`. Re-renders (and increments ×N) only when
/// that field changes — not when `notificationsEnabled` changes.
private struct UsernameRow: View {
    let settings: DemoSettings
    @State private var renders = 0

    var body: some View {
        SettingsRowLayout(label: "username", value: settings.username, renders: renders)
            .task(id: settings.username) { renders += 1 }
    }
}

/// Reads only `settings.notificationsEnabled`. Mirror of `UsernameRow`.
private struct NotificationsRow: View {
    let settings: DemoSettings
    @State private var renders = 0

    var body: some View {
        SettingsRowLayout(
            label: "notifications",
            value: settings.notificationsEnabled ? "on" : "off",
            renders: renders
        )
        .task(id: settings.notificationsEnabled) { renders += 1 }
    }
}

/// Pure layout — no observation.
private struct SettingsRowLayout: View {
    let label: String
    let value: String
    let renders: Int

    var body: some View {
        HStack {
            Text(label).font(.callout).frame(width: 110, alignment: .leading)
            Text(value).font(.callout.monospacedDigit())
            Spacer()
            Text("×\(renders)").font(.caption.monospacedDigit()).foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        StateSystemReferenceScreen()
    }
}
