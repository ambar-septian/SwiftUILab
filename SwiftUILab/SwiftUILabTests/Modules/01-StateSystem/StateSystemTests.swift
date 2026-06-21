import Testing
@testable import SwiftUILab

/// Tests the observable models that back the State System reference. The views
/// themselves are exercised via previews; here we lock down the model logic that
/// the bindings drive.
@MainActor
@Suite("State System models")
struct StateSystemTests {

    @Test("CounterModel increments and resets")
    func counterIncrements() {
        let model = CounterModel()
        #expect(model.count == 0)

        model.increment()
        model.increment()
        #expect(model.count == 2)

        model.reset()
        #expect(model.count == 0)
    }

    @Test("Editing the label leaves the count untouched")
    func labelIsIndependentOfCount() {
        let model = CounterModel()
        model.increment()
        model.label = "Clicks"
        #expect(model.count == 1)
        #expect(model.label == "Clicks")
    }

    @Test("LegacyCounter increments like its modern twin")
    func legacyCounterIncrements() {
        let counter = LegacyCounter()
        counter.increment()
        #expect(counter.count == 1)
    }
}
