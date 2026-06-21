import Foundation
import Testing
@testable import SwiftUILab

@Suite("Async / Await")
struct AsyncTests {

    // MARK: LoadPhase

    @Test("isLoading is true only in the loading case")
    func loadPhaseIsLoading() {
        #expect(LoadPhase<[Article]>.loading.isLoading)
        #expect(!LoadPhase<[Article]>.idle.isLoading)
        #expect(!LoadPhase<[Article]>.loaded([]).isLoading)
    }

    @Test("value is non-nil only when loaded")
    func loadPhaseValue() {
        let articles = [Article(id: 1, title: "A")]
        #expect(LoadPhase.loaded(articles).value == articles)
        #expect(LoadPhase<[Article]>.failed("x").value == nil)
    }

    // MARK: Service

    @Test("Live service returns five articles")
    func liveServiceFetches() async throws {
        let articles = try await LiveArticleService().fetch()
        #expect(articles.count == 5)
    }

    @Test("Failing service throws")
    func failingServiceThrows() async {
        await #expect(throws: (any Error).self) {
            try await FailingArticleService().fetch()
        }
    }

    // MARK: Continuation bridge

    @Test("geocode bridge resolves to the query length")
    func geocodeBridge() async throws {
        let value = try await geocode("Cupertino")
        #expect(value == 9)
    }

    // MARK: AsyncStream

    @Test("Countdown stream yields start…0 inclusive")
    func countdownStream() async {
        var received: [Int] = []
        for await n in Countdown.stream(from: 3, interval: .milliseconds(1)) {
            received.append(n)
        }
        #expect(received == [3, 2, 1, 0])
    }
}
