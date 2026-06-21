import SwiftUI
import SwiftData

@main
struct SwiftUILabApp: App {
    /// The composition root. `@State` gives the container a stable identity for
    /// the app's lifetime; it's injected into the environment for all features.
    @State private var container = AppContainer.live()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(container)
        }
        // Wires a SwiftData stack from day one; Topic 7 builds on `ScratchNote`.
        .modelContainer(for: ScratchNote.self)
    }
}
