import UIKit

class CarKeyViewController : UIViewController {
    
    let unlock = UIButton(configuration: .filled(), primaryAction: .none)
    let lock = UIButton(configuration: .filled(), primaryAction: .none)
    
    override func viewDidLoad() {
        
        unlock.frame = CGRect(origin: CGPoint(x:view.center.x, y: view.center.y - 200), size: CGSize(width: 150, height: 70))
        lock.frame = CGRect(origin: view.center, size: CGSize(width: 150, height: 70))
        
        unlock.setTitle("Unlock", for: .normal)
        lock.setTitle("Lock", for: .normal)
        
        self.view.addSubview(unlock)
        self.view.addSubview(lock)
        
    }
    
    override func viewDidLayoutSubviews() {
        unlock.frame = CGRect(origin: CGPoint(x:view.center.x, y: view.center.y - 200), size: CGSize(width: 150, height: 70))
        lock.frame = CGRect(origin: view.center, size: CGSize(width: 150, height: 70))
    }
    
}
