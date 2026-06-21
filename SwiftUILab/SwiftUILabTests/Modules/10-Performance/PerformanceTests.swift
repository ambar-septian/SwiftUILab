import Foundation
import Testing
@testable import SwiftUILab

@MainActor
@Suite("Performance helpers")
struct PerformanceTests {

    // MARK: FrameMonitor

    @Test("Average within budget is not hitchy")
    func smoothFrames() {
        var monitor = FrameMonitor()
        for _ in 0..<5 { monitor.record(10) } // well under 16.67
        #expect(!monitor.isHitchy)
        #expect(monitor.average == 10)
    }

    @Test("Average over budget flags a hitch")
    func hitchyFrames() {
        var monitor = FrameMonitor()
        for _ in 0..<5 { monitor.record(25) }
        #expect(monitor.isHitchy)
    }

    @Test("Window only keeps the most recent N samples")
    func rollingWindow() {
        var monitor = FrameMonitor(window: 3)
        monitor.record(100) // should fall out of the window
        monitor.record(10)
        monitor.record(10)
        monitor.record(10)
        #expect(monitor.samples.count == 3)
        #expect(monitor.average == 10)
    }

    // MARK: Retain cycle

    @Test("safeSetup lets the node deallocate")
    func safeDeallocates() {
        var node: RetainNode? = RetainNode()
        weak var weakNode = node
        node?.safeSetup()
        node = nil
        #expect(weakNode == nil)
    }

    @Test("leakySetup keeps the node alive (the bug)")
    func leakyLeaks() {
        var node: RetainNode? = RetainNode()
        weak var weakNode = node
        node?.leakySetup()
        node = nil
        #expect(weakNode != nil)        // demonstrates the leak
        weakNode?.onChange = nil        // break the cycle so the test doesn't leak
    }
}
