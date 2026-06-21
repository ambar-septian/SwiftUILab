import SwiftUI

/// Reference implementation for Topic 2 — Layout & Rendering.
///
/// Five focused demos, one per planned concept. Run on a simulator and interact
/// with each section to see the layout behavior live.
struct LayoutReferenceScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                layoutProtocol
                preferenceKey
                alignmentGuides
                viewIdentity
                viewBuilderVsAnyView
            }
            .padding(Theme.Spacing.md)
        }
        .navigationTitle("Layout & Rendering")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: 1. Layout protocol vs GeometryReader

    private var layoutProtocol: some View {
        DemoSection(
            title: "Layout protocol",
            subtitle: "Custom algorithm: equal-width children without GeometryReader"
        ) {
            LayoutProtocolDemo()
        }
    }

    // MARK: 2. PreferenceKey child-to-parent

    private var preferenceKey: some View {
        DemoSection(
            title: "PreferenceKey",
            subtitle: "Children report their natural width; parent syncs the column"
        ) {
            PreferenceKeyDemo()
        }
    }

    // MARK: 3. alignmentGuide & custom alignments

    private var alignmentGuides: some View {
        DemoSection(
            title: "alignmentGuide & custom alignments",
            subtitle: "Override the guide a view contributes; define a shared axis"
        ) {
            AlignmentGuideDemo()
        }
    }

    // MARK: 4. Structural vs explicit identity

    private var viewIdentity: some View {
        DemoSection(
            title: "Structural vs explicit identity",
            subtitle: "Same structural position preserves @State; .id() resets it"
        ) {
            ViewIdentityDemo()
        }
    }

    // MARK: 5. @ViewBuilder & AnyView trade-offs

    private var viewBuilderVsAnyView: some View {
        DemoSection(
            title: "@ViewBuilder vs AnyView",
            subtitle: "@ViewBuilder preserves the type tree; AnyView erases it"
        ) {
            ViewBuilderDemo()
        }
    }
}

// MARK: - Demo 1: Layout protocol

/// `EqualWidthVStack` (see `LayoutModels`) is a custom `Layout` that makes every
/// child as wide as the widest sibling. Compare: `VStack` would leave each button
/// at its natural width; `EqualWidthVStack` promotes the narrower ones.
///
/// GeometryReader anti-pattern contrast: measuring sibling widths with
/// GeometryReader requires a two-pass layout (measure, then re-render at a fixed
/// size), leaks coordinate spaces into the view graph, and can loop. The Layout
/// protocol gets the right answer in a single pass.
private struct LayoutProtocolDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("All buttons sized to the widest child:")
                .font(.caption).foregroundStyle(.secondary)
            EqualWidthVStack(spacing: Theme.Spacing.sm) {
                Button("Short") {}.buttonStyle(.bordered)
                Button("Much longer label") {}.buttonStyle(.bordered)
                Button("OK") {}.buttonStyle(.bordered)
            }
        }
    }
}

// MARK: - Demo 2: PreferenceKey

/// Each `KeyRow` reports its label's natural width via `MaxWidthKey`. The parent
/// collects the maximum with `.onPreferenceChange` and feeds it back as a minimum
/// width — aligning all value columns without a shared `@State` binding or a
/// `GeometryReader` ancestor.
private struct PreferenceKeyDemo: View {
    @State private var labelWidth: CGFloat = 0
    private let rows = [("Name", "SwiftUILab"), ("Version", "2.0"), ("Build", "2025.06")]

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
            ForEach(rows, id: \.0) { key, val in
                KeyRow(key: key, value: val, minWidth: labelWidth)
            }
            Text("Label column: \(Int(labelWidth))pt — set by the widest sibling via MaxWidthKey.")
                .font(.caption).foregroundStyle(.secondary)
                .padding(.top, Theme.Spacing.xs)
        }
        .onPreferenceChange(MaxWidthKey.self) { labelWidth = $0 }
    }
}

private struct KeyRow: View {
    let key: String
    let value: String
    let minWidth: CGFloat

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            Text(key)
                .font(.callout)
                .fixedSize()
                .frame(minWidth: minWidth, alignment: .leading)
                .background(
                    // GeometryReader is fine here — it's reading, not laying out.
                    GeometryReader { geo in
                        Color.clear.preference(key: MaxWidthKey.self, value: geo.size.width)
                    }
                )
            Text(value).font(.callout).foregroundStyle(.secondary)
            Spacer()
        }
    }
}

// MARK: - Demo 3: alignmentGuide & custom alignments

/// Three patterns in one section:
/// • Default HStack(.top) — icon pinned to top edge regardless of text height
/// • .firstTextBaseline override — icon aligned to text baseline (built-in guide)
/// • Custom .iconMid — icon centered with the first line of multi-line text,
///   using a custom `VerticalAlignment` defined in `LayoutModels`.
private struct AlignmentGuideDemo: View {
    private let body2 = "A long description that wraps\nonto a second line."

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            // Built-in: override how an icon contributes to .firstTextBaseline
            Divider()
            Text("alignmentGuide(.firstTextBaseline)").font(.caption).foregroundStyle(.secondary)
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                    // Without this, icon aligns on its own baseline (bottom edge).
                    // With this, icon center lines up with the first text baseline.
                    .alignmentGuide(.firstTextBaseline) { d in d[VerticalAlignment.center] }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Title").font(.headline)
                    Text("Subtitle").font(.caption).foregroundStyle(.secondary)
                }
            }

            // Custom: .iconMid shared between icon and first caption baseline
            Divider()
            Text("Custom .iconMid alignment").font(.caption).foregroundStyle(.secondary)
            HStack(alignment: .iconMid) {
                Image(systemName: "bell.badge.fill")
                    .font(.title2)
                    .foregroundStyle(.tint)
                    .alignmentGuide(.iconMid) { d in d[VerticalAlignment.center] }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Notifications").font(.headline)
                    Text(body2).font(.caption).foregroundStyle(.secondary)
                        .alignmentGuide(.iconMid) { d in d[VerticalAlignment.center] }
                }
            }
        }
    }
}

// MARK: - Demo 4: Structural vs explicit identity

/// Two `CounterTile` views at the same structural position in `body`.
///
/// Top tile — no `.id()`: toggling the label changes props but SwiftUI keeps the
/// same view instance alive, so the internal `@State` count is preserved.
///
/// Bottom tile — `.id(labelVariant)`: the identity changes on every toggle,
/// SwiftUI discards the old view and inserts a fresh one, resetting `@State`.
private struct ViewIdentityDemo: View {
    @State private var labelVariant = false

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("Structural identity — same position, state preserved:")
                .font(.caption).foregroundStyle(.secondary)
            CounterTile(label: labelVariant ? "Variant" : "Default")

            Text("Explicit .id() — identity changes, state resets:")
                .font(.caption).foregroundStyle(.secondary)
            CounterTile(label: labelVariant ? "Variant" : "Default")
                .id(labelVariant)

            Button("Toggle label") { labelVariant.toggle() }
                .buttonStyle(.bordered)
        }
    }
}

/// A small interactive tile that owns its own `@State` count — used to make
/// view identity differences visible.
private struct CounterTile: View {
    let label: String
    @State private var count = 0

    var body: some View {
        HStack {
            Text("\(label): \(count)").font(.callout.monospacedDigit())
            Spacer()
            Button("+") { count += 1 }.buttonStyle(.bordered)
        }
    }
}

// MARK: - Demo 5: @ViewBuilder vs AnyView

/// `@ViewBuilder` is a result-builder that produces a statically-typed composite
/// view. SwiftUI knows the exact branch at compile time, enabling structural
/// diffing and animation between concrete types.
///
/// `AnyView` type-erases the wrapped view. SwiftUI can't see inside it, so it
/// must replace the whole subtree on every change — no structural diffing, and
/// animations across `AnyView` boundaries don't interpolate.
///
/// Rule: use `@ViewBuilder` for all conditional / parameterized view composition.
/// Only reach for `AnyView` at genuine type-erasure boundaries (e.g. storing
/// heterogeneous views in a collection, or crossing a function signature that
/// can't be generic).
private struct ViewBuilderDemo: View {
    @State private var isActive = false

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Toggle("Active", isOn: $isActive)

            HStack(spacing: Theme.Spacing.md) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("@ViewBuilder").font(.caption).foregroundStyle(.secondary)
                    // SwiftUI sees: `if isActive → Image(...) else → Image(...)`.
                    // Transition animates between the two concrete Image values.
                    statusIcon(active: isActive)
                        .transition(.scale.combined(with: .opacity))
                }
                .animation(.easeInOut, value: isActive)

                Divider().frame(height: 40)

                VStack(alignment: .leading, spacing: 4) {
                    Text("AnyView").font(.caption).foregroundStyle(.secondary)
                    // SwiftUI sees an opaque box. Transition doesn't interpolate —
                    // it replaces the box wholesale.
                    statusIconErased(active: isActive)
                        .transition(.scale.combined(with: .opacity))
                }
                .animation(.easeInOut, value: isActive)
            }
            Text("Toggle 'Active' and watch — @ViewBuilder animates smoothly; AnyView pops.")
                .font(.caption).foregroundStyle(.secondary)
        }
    }

    // Preferred: exact type visible to SwiftUI's differ.
    @ViewBuilder
    private func statusIcon(active: Bool) -> some View {
        if active {
            Image(systemName: "checkmark.circle.fill")
                .font(.title2).foregroundStyle(.green)
        } else {
            Image(systemName: "circle")
                .font(.title2).foregroundStyle(.secondary)
        }
    }

    // Avoid: type-erased, no structural diffing.
    private func statusIconErased(active: Bool) -> AnyView {
        active
            ? AnyView(Image(systemName: "checkmark.circle.fill").font(.title2).foregroundStyle(.green))
            : AnyView(Image(systemName: "circle").font(.title2).foregroundStyle(.secondary))
    }
}

#Preview {
    NavigationStack {
        LayoutReferenceScreen()
    }
}
