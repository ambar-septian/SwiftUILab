import Foundation

// MARK: - Domain

struct Article: Identifiable, Hashable {
    let id: Int
    let title: String
}

/// A generic four-state load phase. Generic + pure, so it's unit-testable and
/// reusable across screens. The view switches over it exhaustively.
enum LoadPhase<Value>: Equatable where Value: Equatable {
    case idle
    case loading
    case loaded(Value)
    case failed(String)

    var isLoading: Bool { if case .loading = self { true } else { false } }

    var value: Value? { if case .loaded(let v) = self { v } else { nil } }
}

// MARK: - Service (protocol-fronted, Sendable)

/// `Sendable` so instances can cross actor boundaries safely when injected.
protocol ArticleService: Sendable {
    func fetch() async throws -> [Article]
}

struct LiveArticleService: ArticleService {
    /// Simulated latency via cooperative sleep — `Task.sleep` is a suspension
    /// point, so the calling task yields the thread instead of blocking it.
    func fetch() async throws -> [Article] {
        try await Task.sleep(for: .milliseconds(600))
        return (1...5).map { Article(id: $0, title: "Article #\($0)") }
    }
}

struct FailingArticleService: ArticleService {
    struct Offline: LocalizedError {
        var errorDescription: String? { "Network offline" }
    }
    func fetch() async throws -> [Article] {
        try await Task.sleep(for: .milliseconds(400))
        throw Offline()
    }
}

// MARK: - Continuation bridge

/// A legacy, callback-based API — the kind you can't change but must consume.
enum LegacyGeocoder {
    static func lookup(_ query: String, completion: @escaping (Result<Int, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
            completion(.success(query.count)) // pretend "coordinate"
        }
    }
}

/// Bridges the callback API into async/await with a checked continuation.
/// `withCheckedThrowingContinuation` adds runtime checks that the continuation is
/// resumed exactly once — the #1 bridging bug. Use `withUnsafe…` only after the
/// code is proven correct and the checks show up in profiling.
func geocode(_ query: String) async throws -> Int {
    try await withCheckedThrowingContinuation { continuation in
        LegacyGeocoder.lookup(query) { result in
            continuation.resume(with: result)
        }
    }
}

// MARK: - AsyncSequence

/// A finite `AsyncStream` countdown. Pure factory → easy to drain in a test.
enum Countdown {
    static func stream(from start: Int, interval: Duration = .milliseconds(300)) -> AsyncStream<Int> {
        AsyncStream { continuation in
            let task = Task {
                var n = start
                while n >= 0 {
                    if Task.isCancelled { break }
                    continuation.yield(n)
                    if n > 0 { try? await Task.sleep(for: interval) }
                    n -= 1
                }
                continuation.finish()
            }
            // Propagate consumer cancellation back into the producer task.
            continuation.onTermination = { _ in task.cancel() }
        }
    }
}
