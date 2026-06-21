import SwiftUI
import SwiftData

/// Top-level shell. A `TabView` for the two top-level destinations, each owning
/// its own `NavigationStack` so navigation state is per-tab (UIKit equivalent:
/// a `UITabBarController` with a `UINavigationController` per tab).
struct RootView: View {
    var body: some View {
        TabView {
            Tab("Modules", systemImage: "books.vertical") {
                ModulesTab()
            }
            Tab("Progress", systemImage: "chart.bar.fill") {
                ProgressTab()
            }
        }
    }
}

#Preview {
    RootView()
        .environment(AppContainer.preview())
        .modelContainer(for: ScratchNote.self, inMemory: true)
}
