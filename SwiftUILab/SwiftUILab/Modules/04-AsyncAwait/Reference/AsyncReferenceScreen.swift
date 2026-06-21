import SwiftUI

/// Reference implementation for Topic 4 — Async / Await.
///
/// Five demos: `.task`-driven loading with a typed phase, cooperative
/// cancellation, an `AsyncStream` consumed by a view, and a checked-continuation
/// bridge over a callback API.
struct AsyncReferenceScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                DemoSection(
                    title: ".task loading",
                    subtitle: "Tied to view lifetime — auto-cancels when the view disappears"
                ) { TaskLoadingDemo() }

                DemoSection(
                    title: "Cooperative cancellation",
                    subtitle: "A long Task that checks Task.isCancelled and bails out"
                ) { CancellationDemo() }

                DemoSection(
                    title: "AsyncStream",
                    subtitle: "A view consuming an async sequence with for-await"
                ) { StreamDemo() }

                DemoSection(
                    title: "Continuation bridge",
                    subtitle: "withCheckedThrowingContinuation over a callback API"
                ) { ContinuationDemo() }
            }
            .padding(Theme.Spacing.md)
        }
        .navigationTitle("Async / Await")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Demo 1: .task loading

/// `.task(id:)` starts when the view appears (or `id` changes) and is *cancelled
/// automatically* when the view disappears — the key difference from `Task { }`,
/// which is detached from the view's lifetime and must be cancelled by hand.
private struct TaskLoadingDemo: View {
    @State private var phase: LoadPhase<[Article]> = .idle
    @State private var useFailing = false

    private var service: any ArticleService {
        useFailing ? FailingArticleService() : LiveArticleService()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Toggle("Simulate offline", isOn: $useFailing)

            switch phase {
            case .idle, .loading:
                ProgressView().frame(maxWidth: .infinity)
            case .loaded(let articles):
                ForEach(articles) { Text("• \($0.title)").font(.callout) }
            case .failed(let message):
                Label(message, systemImage: "wifi.slash").foregroundStyle(.red)
            }

            Button("Reload") { phase = .idle }
                .buttonStyle(.bordered)
        }
        // Re-runs whenever `useFailing` flips (id changes) or on first appear.
        .task(id: useFailing) { await load() }
    }

    private func load() async {
        phase = .loading
        do {
            phase = .loaded(try await service.fetch())
        } catch is CancellationError {
            // Expected when the view goes away mid-flight — leave state alone.
        } catch {
            phase = .failed(error.localizedDescription)
        }
    }
}

// MARK: - Demo 2: cooperative cancellation

/// Cancellation in Swift is *cooperative*: cancelling a task only sets a flag.
/// Long-running work must poll `Task.isCancelled` (or call `try
/// Task.checkCancellation()`) and stop voluntarily.
private struct CancellationDemo: View {
    @State private var progress = 0
    @State private var work: Task<Void, Never>?
    @State private var status = "Idle"

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            ProgressView(value: Double(progress), total: 100)
            Text("\(status) — \(progress)%").font(.callout.monospacedDigit())
            HStack {
                Button("Start") { start() }
                    .buttonStyle(.borderedProminent)
                    .disabled(work != nil)
                Button("Cancel") { work?.cancel() }
                    .buttonStyle(.bordered)
                    .disabled(work == nil)
            }
        }
    }

    private func start() {
        progress = 0
        status = "Running"
        work = Task {
            for step in 1...100 {
                if Task.isCancelled { status = "Cancelled"; work = nil; return }
                try? await Task.sleep(for: .milliseconds(40))
                progress = step
            }
            status = "Done"
            work = nil
        }
    }
}

// MARK: - Demo 3: AsyncStream

private struct StreamDemo: View {
    @State private var current: Int?
    @State private var restartToken = 0

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text(current.map { "Countdown: \($0)" } ?? "Tap restart")
                .font(.title3.monospacedDigit())
            Button("Restart") { restartToken += 1 }
                .buttonStyle(.bordered)
        }
        // for-await drives the stream; .task cancels it on disappear or restart.
        .task(id: restartToken) {
            for await n in Countdown.stream(from: 5) {
                current = n
            }
        }
    }
}

// MARK: - Demo 4: continuation bridge

private struct ContinuationDemo: View {
    @State private var query = "Cupertino"
    @State private var result: String = "—"

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            TextField("Query", text: $query).textFieldStyle(.roundedBorder)
            Text("Bridged result: \(result)").font(.callout.monospacedDigit())
            Button("Geocode (async over callback)") {
                Task { result = "\((try? await geocode(query)) ?? -1)" }
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    NavigationStack { AsyncReferenceScreen() }
}
