
import UIKit

class MainVC: UIViewController {
    
    let custom_view_controller = CustomVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(custom_view_controller.view)
        custom_view_controller.view.frame = self.view.frame
    }
    
    override func viewDidLayoutSubviews() {
        custom_view_controller.view.frame = self.view.frame
    }
}
