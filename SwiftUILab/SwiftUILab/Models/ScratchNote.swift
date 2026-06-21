import Foundation
import SwiftData

/// Minimal SwiftData model so the `ModelContainer` is wired into the app from
/// day one (see `SwiftUILabApp`). The SwiftData module (Topic 7) builds on this.
@Model
final class ScratchNote {
    var title: String
    var createdAt: Date

    init(title: String, createdAt: Date = .now) {
        self.title = title
        self.createdAt = createdAt
    }
}
