import Foundation

/// The ten learning topics covered by SwiftUILab.
///
/// `ModuleTopic` is the single source of truth for module metadata. The app's
/// catalog, routing, and the documentation site all key off the `id` here, so a
/// new topic only needs to be added in one place.
enum ModuleTopic: String, CaseIterable, Identifiable, Hashable, Codable {
    case stateSystem
    case layout
    case navigation
    case asyncAwait
    case concurrency
    case uikitInterop
    case swiftData
    case testing
    case architecture
    case performance

    var id: String { rawValue }

    /// 1-based position used for display and for matching the docs-site page slug.
    var number: Int { (Self.allCases.firstIndex(of: self) ?? 0) + 1 }

    var title: String {
        switch self {
        case .stateSystem:   "SwiftUI State System"
        case .layout:        "Layout & Rendering"
        case .navigation:    "Navigation"
        case .asyncAwait:    "Async / Await"
        case .concurrency:   "Structured Concurrency & Actors"
        case .uikitInterop:  "UIKit Interop"
        case .swiftData:     "SwiftData & Persistence"
        case .testing:       "Unit Testing"
        case .architecture:  "Architecture Patterns"
        case .performance:   "Performance & Debugging"
        }
    }

    var subtitle: String {
        switch self {
        case .stateSystem:   "Ownership, value semantics, and observation"
        case .layout:        "Layout protocol, PreferenceKey, alignment, identity"
        case .navigation:    "Type-safe routing and presentation state"
        case .asyncAwait:    "Suspension, tasks, cancellation, AsyncSequence"
        case .concurrency:   "TaskGroup, actors, @MainActor, Sendable"
        case .uikitInterop:  "Representables, hosting, coordinators"
        case .swiftData:     "@Model, @Query, ModelContext, migrations"
        case .testing:       "Swift Testing, async, actors, doubles"
        case .architecture:  "MVVM, TCA, modularization, unidirectional flow"
        case .performance:   "Instruments, redraw debugging, leaks"
        }
    }

    /// SF Symbol used by the catalog row and module header.
    var systemImage: String {
        switch self {
        case .stateSystem:   "switch.2"
        case .layout:        "square.grid.3x3"
        case .navigation:    "arrow.triangle.turn.up.right.diamond"
        case .asyncAwait:    "clock.arrow.circlepath"
        case .concurrency:   "arrow.triangle.branch"
        case .uikitInterop:  "rectangle.on.rectangle.angled"
        case .swiftData:     "cylinder.split.1x2"
        case .testing:       "checklist"
        case .architecture:  "building.columns"
        case .performance:   "gauge.with.dots.needle.67percent"
        }
    }

    /// The concepts this module drills into. Drives the placeholder screens and
    /// the docs-site stub pages so the syllabus is visible from day one.
    var plannedConcepts: [String] {
        switch self {
        case .stateSystem:
            ["@State vs @Binding value semantics",
             "Custom Binding(get:set:)",
             "@StateObject vs @ObservedObject ownership",
             "@Observable vs ObservableObject",
             "@Bindable",
             "Minimizing view invalidations"]
        case .layout:
            ["Layout protocol vs GeometryReader",
             "PreferenceKey child-to-parent",
             "alignmentGuide & custom alignments",
             "Structural vs explicit identity",
             "@ViewBuilder & AnyView trade-offs"]
        case .navigation:
            ["NavigationStack + NavigationPath",
             "Type-safe routes",
             "Programmatic deep linking",
             "Coordinator pattern",
             "Sheet / fullScreenCover / popover state"]
        case .asyncAwait:
            ["Continuations & suspension points",
             "Task lifecycle & priorities",
             "Cooperative cancellation",
             "AsyncSequence / AsyncStream",
             "withCheckedContinuation bridging",
             ".task vs Task { } in views"]
        case .concurrency:
            ["TaskGroup vs async let",
             "Actor reentrancy",
             "@MainActor isolation",
             "Global actors",
             "Sendable & @unchecked Sendable",
             "Swift 6 strict concurrency"]
        case .uikitInterop:
            ["UIViewRepresentable + Coordinator",
             "Avoiding infinite update loops",
             "UIViewControllerRepresentable lifecycle",
             "UIHostingController sizing",
             "Migration strategies"]
        case .swiftData:
            ["@Model & relationships",
             "@Query fetching",
             "ModelContext / ModelContainer DI",
             "Migrations & schema versions",
             "Batch ops & predicate cost"]
        case .testing:
            ["Swift Testing: @Test, #expect, traits",
             "Testing async/await",
             "Testing actors & @MainActor",
             "Testing @Observable",
             "Protocol-based test doubles",
             "Testing AsyncStream"]
        case .architecture:
            ["MVVM: fit vs overhead",
             "TCA overview",
             "SPM feature modules",
             "DI without a framework",
             "Unidirectional data flow"]
        case .performance:
            ["SwiftUI Instruments template",
             "Self._printChanges()",
             "Task & closure leaks",
             "Hitches & hang detection",
             "Launch time"]
        }
    }
}
