import Combine
import SwiftUI

// =============================================================================
// CHALLENGE — SwiftUI State System
//
// Build an "Account Settings" panel that exercises every concept from the
// reference. The screen must compile at all times; replace each `Text("TODO …")`
// with a real implementation. The only hints are the `// TODO:` markers.
//
// When you're done, compare against StateSystemReferenceScreen and the docs-site
// "Solution reveal" section.
// =============================================================================


struct StateSystemChallengeScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                Task1_StateBinding()
                Task2_CustomBinding()
                Task3_ObservableBindable()
                Task4_LegacyOwnership()
                Task5_EnvironmentKey()
            }
            .padding(Theme.Spacing.md)
        }
        .navigationTitle("Challenge")
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.preferencesValue, "SomeDummy")
    }
}

private struct Task1_StateBinding: View {
    @State var quantity: Int = 1
    
    var body: some View {
        DemoSection(title: "1. @State + @Binding") {
            Stepper("Quantity \(quantity)", value: $quantity)
        }
    }
}

private struct Task2_CustomBinding: View {
    @State var text: String = ""
    
    var body: some View {
        let upperCasedBinding = Binding<String> {
            text
        } set: { newValue in
            text = newValue.uppercased()
        }
        
        DemoSection(title: "2. Custom Binding(get:set:)") {
            TextField("Custom text goes here", text: upperCasedBinding)
            Text("Uppercase text: \(text)")
        }
    }
}

@Observable
private class Account {
    var name: String = ""
    var age: Int = 0
}

private struct Task3_ObservableBindable: View {
    
    @State var model: Account = .init()
    
    var body: some View {
        DemoSection(title: "3. @Observable + @Bindable") {
            Button("Generate") {
                model.name = ["John", "Doe", "Frank", "Richard"].randomElement()!
            }
            Button("+") {
                model.age += 1
            }
            Task3_NestedObservableBindable(model: model)
        }
    }
}


private struct Task3_NestedObservableBindable: View {
    @Bindable var model: Account
    
    var body: some View {
        VStack {
            TextField("Your name", text: $model.name)
            Stepper("Your age \(model.age)", value: $model.age)
        }
        
    }
}

private struct Task4_LegacyOwnership: View {
    @StateObject var viewModel = Task4_legacyViewModel()
    @State var sliderNumber: Float = 0
    
    var body: some View {
        DemoSection(title: "4. @StateObject ownership") {
            Text("Current number \(viewModel.number)")
            Button("Increment") {
                viewModel.increment()
            }
            Text("Slider \(sliderNumber)")
            Slider(value: $sliderNumber)
        }
    }
}


private class Task4_legacyViewModel: ObservableObject {
    @Published var number: Int = 0
    
    func increment() {
        number += 1
    }
}

extension EnvironmentValues {
    @Entry var preferencesValue = ""
}

private struct Task5_EnvironmentKey: View {
    @Environment(\.preferencesValue) var preferenceValue: String
    
    var body: some View {
        DemoSection(title: "5. @Environment custom key") {
            Text("Preference Value \(preferenceValue)")
        }
    }
}

#Preview {
    NavigationStack {
        StateSystemChallengeScreen()
    }
}
