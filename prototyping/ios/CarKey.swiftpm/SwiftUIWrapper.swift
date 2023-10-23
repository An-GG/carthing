import SwiftUI
import UIKit


let appvc = ScannerViewController()











class MainVC : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(appvc.view)
        appvc.view.frame = view.frame
    }
    override func viewDidLayoutSubviews() {
        appvc.view.frame = view.frame
    }
}

struct MyUIViewControllerRepresentable: UIViewControllerRepresentable {
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

