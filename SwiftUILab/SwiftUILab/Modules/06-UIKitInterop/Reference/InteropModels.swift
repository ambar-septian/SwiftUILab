import SwiftUI
import UIKit

// MARK: - Update guard (pure, testable)

/// Decides whether an incoming SwiftUI value differs enough from the UIKit view's
/// current value to be worth writing back. Extracted as a pure function so the
/// loop-avoidance logic can be unit-tested without a running view.
enum UpdateGuard {
    static func shouldApply(incoming: Double, current: Double, epsilon: Double = 0.0001) -> Bool {
        abs(incoming - current) > epsilon
    }
}

// MARK: - UIViewRepresentable + Coordinator

/// Wraps `UISlider` with two-way binding. The `Coordinator` is the bridge that
/// translates UIKit target-action callbacks back into SwiftUI state.
///
/// Loop avoidance: `updateUIView` runs on *every* SwiftUI render. If it wrote the
/// slider unconditionally, and the slider's action wrote the binding, you'd risk
/// an update cycle / fighting the user mid-drag. The `UpdateGuard` check applies
/// the value only when it actually differs.
struct RatingSlider: UIViewRepresentable {
    @Binding var value: Double

    func makeCoordinator() -> Coordinator { Coordinator(value: $value) }

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 5
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        guard UpdateGuard.shouldApply(incoming: value, current: Double(uiView.value)) else { return }
        uiView.setValue(Float(value), animated: false)
    }

    final class Coordinator: NSObject {
        let value: Binding<Double>
        init(value: Binding<Double>) { self.value = value }

        @objc func valueChanged(_ sender: UISlider) {
            value.wrappedValue = Double(sender.value)
        }
    }
}

// MARK: - UIViewControllerRepresentable

/// A plain UIKit controller that owns a label and renders an injected count.
final class CounterViewController: UIViewController {
    var count = 0 { didSet { label.text = "UIKit VC: \(count)" } }
    private let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "UIKit VC: \(count)"
        label.textAlignment = .center
        label.font = .monospacedDigitSystemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

/// Bridges `CounterViewController` into SwiftUI. `updateUIViewController` pushes
/// the latest SwiftUI state into the UIKit controller on each render.
struct CounterControllerView: UIViewControllerRepresentable {
    @Binding var count: Int

    func makeUIViewController(context: Context) -> CounterViewController {
        CounterViewController()
    }

    func updateUIViewController(_ controller: CounterViewController, context: Context) {
        controller.count = count
    }
}
