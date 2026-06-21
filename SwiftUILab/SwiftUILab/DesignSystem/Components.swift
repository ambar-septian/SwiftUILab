import SwiftUI

/// A rounded surface used to group content on module screens.
struct Card<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(Theme.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.background.secondary, in: RoundedRectangle(cornerRadius: Theme.Radius.card))
    }
}

/// Small capsule label, e.g. a concept tag or a status chip.
struct Pill: View {
    let text: String
    var systemImage: String?
    var tint: Color = .accentColor

    init(_ text: String, systemImage: String? = nil, tint: Color = .accentColor) {
        self.text = text
        self.systemImage = systemImage
        self.tint = tint
    }

    var body: some View {
        Label {
            Text(text)
        } icon: {
            if let systemImage { Image(systemName: systemImage) }
        }
        .labelStyle(.titleAndIcon)
        .font(.caption.weight(.medium))
        .padding(.horizontal, Theme.Spacing.sm)
        .padding(.vertical, Theme.Spacing.xs)
        .background(tint.opacity(0.15), in: Capsule())
        .foregroundStyle(tint)
    }
}

/// A titled section block with optional subtitle, used to frame each demo on a
/// module screen.
struct DemoSection<Content: View>: View {
    let title: String
    var subtitle: String?
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                if let subtitle {
                    Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
                }
            }
            Card { content }
        }
    }
}

/// A single concept row used by placeholder screens and module headers.
struct ConceptRow: View {
    let text: String

    var body: some View {
        Label(text, systemImage: "circle.dashed")
            .font(.callout)
            .foregroundStyle(.secondary)
    }
}
