
import UIKit
import CoreBluetooth

class ScannerViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    
    let targetServiceUUID = CBUUID(string: "4fafc201-1fb5-459e-8fcc-c5c9c331914b")  // Replace with the actual service UUID of your ESP32
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        print("Loaded.")
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Powered On.")
            central.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    var peripherals: [CBPeripheral] = []
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if (peripherals.contains(peripheral)) { 
            return
        }
        peripherals.append(peripheral)
        if let name = peripheral.name as? String {
            print("UUID: " + peripheral.identifier.uuidString + " -- Peripheral Name: " + name)
        } else {
            print("UUID: " + peripheral.identifier.uuidString + " -- Peripheral Name: " + "")
        }
        
        
        if let serviceUUIDs = advertisementData["kCBAdvDataServiceUUIDs"] as? [CBUUID], serviceUUIDs.contains(targetServiceUUID) {
            
            //self.centralManager.stopScan()
            self.peripheral = peripheral
            self.peripheral.delegate = self
            self.centralManager.connect(self.peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // Discover services
        print("Connected: " + String(describing: peripheral))
        peripheral.discoverServices([targetServiceUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            if service.uuid == targetServiceUUID {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            if characteristic.properties.contains(.writeWithoutResponse) || characteristic.properties.contains(.write) {
                print(characteristic.uuid)
                //peripheral.writeValue("hello".data(using: .utf8)!, for: characteristic, type: .withoutResponse)
            }
        }
    }
}
