import SwiftUI
import UIKit


struct MyUIViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = MainVC
    func makeUIViewController(context: Context) -> MainVC {
        return MainVC()
    }
    func updateUIViewController(_ uiViewController: MainVC, context: Context) {
    }
}
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            MyUIViewControllerRepresentable()
        }
    }
}

