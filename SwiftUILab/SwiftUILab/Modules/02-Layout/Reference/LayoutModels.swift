import SwiftUI

// MARK: - Custom Layout

/// Sizes all subviews to the widest child's natural width, then stacks them
/// vertically. The two required methods — `sizeThatFits` and `placeSubviews` —
/// are the complete Layout protocol surface.
struct EqualWidthVStack: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        guard !subviews.isEmpty else { return .zero }
        let w = maxNaturalWidth(subviews)
        let heights = subviews.map { $0.sizeThatFits(ProposedViewSize(width: w, height: nil)).height }
        let totalH = heights.reduce(0, +) + spacing * CGFloat(subviews.count - 1)
        return CGSize(width: proposal.width ?? w, height: totalH)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        guard !subviews.isEmpty else { return }
        let w = maxNaturalWidth(subviews)
        var y = bounds.minY
        for subview in subviews {
            let h = subview.sizeThatFits(ProposedViewSize(width: w, height: nil)).height
            subview.place(
                at: CGPoint(x: bounds.midX, y: y + h / 2),
                anchor: .center,
                proposal: ProposedViewSize(width: w, height: h)
            )
            y += h + spacing
        }
    }

    private func maxNaturalWidth(_ subviews: Subviews) -> CGFloat {
        subviews.map { $0.sizeThatFits(.unspecified).width }.max() ?? 0
    }
}

// MARK: - PreferenceKey

/// Bubbles the maximum child width from a subtree up to the nearest ancestor
/// that calls `.onPreferenceChange(MaxWidthKey.self)`.
struct MaxWidthKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

// MARK: - Custom alignment

extension VerticalAlignment {
    private enum IconMidID: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[VerticalAlignment.center]
        }
    }

    /// Shared vertical guide for aligning an icon's center with the first line
    /// of a multi-line text block — without hardcoded offsets.
    static let iconMid = VerticalAlignment(IconMidID.self)
}
