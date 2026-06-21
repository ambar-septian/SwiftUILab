import SwiftUI

/// Design tokens. Centralizing spacing/typography keeps module screens visually
/// consistent and lets the docs site mirror the same scale.
enum Theme {
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
    }

    enum Radius {
        static let card: CGFloat = 16
        static let pill: CGFloat = 999
    }
}

extension Color {
    /// Accent used for "implemented" affordances.
    static let labAccent = Color.accentColor
    static let labMuted = Color.secondary
}
