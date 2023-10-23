//
//  BluetoothKeyfob.swift
//  carkey-app
//
//  Created by an on 10/23/23.
//

import Foundation
import UIKit
import SwiftUI
import CoreBluetooth


// No autoconnect on app launch,
// - setup connection if needed when user first clicks a button
// - the command is sent to the ESP32
// - wait about 250ms for the door lock motor to complete action, then check predicted lock state
//   - might add some error checking internal to the carthing later, if it fails we can tell by checking if predicted lock state is what we want
//   - return the predicted lock state
//
// buttons are 'disabled' based on locked state as an indicator but they still do the action when tapped



enum predicted_lock_state {
    case unlocked
    case locked
    case unknown
}



func bt_get_predicted_lock_state(lock_state_callback: ((predicted_lock_state) -> Void) ) {
    lock_state_callback(.unknown)
}

func bt_send_unlock_command(lock_state_callback: @escaping ((predicted_lock_state) -> Void)) {
    appvc.start()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
        lock_state_callback(.unlocked)
    }
}

func bt_send_lock_command(lock_state_callback: @escaping ((predicted_lock_state) -> Void)) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
        lock_state_callback(.locked)
    }
}



let appvc = ScannerViewController()


class ScannerViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    
    let targetServiceUUID = CBUUID(string: SERVICE_UUID)  // Replace with the actual service UUID of your ESP32
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func start() {
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
                peripheral.writeValue("hello".data(using: .utf8)!, for: characteristic, type: .withResponse)
            }
        }
    }
}




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
