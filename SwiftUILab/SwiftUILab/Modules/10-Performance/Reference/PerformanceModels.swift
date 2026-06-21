import Foundation

// MARK: - Hitch detection (pure, testable)

/// A rolling average of recent frame durations. The 60fps budget is ~16.67ms;
/// a sustained average above it means the UI is dropping frames (a "hitch").
/// Pure value type, so the threshold logic is unit-testable without Instruments.
struct FrameMonitor {
    let window: Int
    let budgetMs: Double
    private(set) var samples: [Double] = []

    init(window: Int = 10, budgetMs: Double = 1000.0 / 60.0) {
        self.window = window
        self.budgetMs = budgetMs
    }

    mutating func record(_ ms: Double) {
        samples.append(ms)
        if samples.count > window {
            samples.removeFirst(samples.count - window)
        }
    }

    var average: Double {
        samples.isEmpty ? 0 : samples.reduce(0, +) / Double(samples.count)
    }

    /// True when the recent average blows the frame budget.
    var isHitchy: Bool { average > budgetMs }
}

// MARK: - Retain cycle (and its fix)

/// A node that stores a closure. If the closure captures `self` strongly, the
/// node keeps itself alive forever — a retain cycle / leak. `[weak self]` at the
/// capture site is the fix.
final class RetainNode {
    private(set) var value = 0
    var onChange: (() -> Void)?

    /// LEAKS: `self → onChange → self`. The node never deallocates.
    func leakySetup() {
        onChange = { self.value += 1 }
    }

    /// SAFE: the closure holds only a weak reference, so no cycle forms.
    func safeSetup() {
        onChange = { [weak self] in self?.value += 1 }
    }

    func fire() { onChange?() }
}
