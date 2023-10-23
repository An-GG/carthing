//
//  BT.swift
//  carkey-app
//
//  Created by an on 10/23/23.
//

import Foundation
import CoreBluetooth
import UIKit
import SwiftUI


let bt_controller = BluetoothController()


func bt_read_value(sUUID: String, cUUID: String) -> Data? {
    return nil
}

func bt_write_value(sUUID: String, cUUID: String, data: Data) {
    
}




class BluetoothController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    
    private var centralManager: CBCentralManager!
    private var peripherals: [CBPeripheral] = []
    private var targetUUIDs: [(service: CBUUID, characteristic: CBUUID)] = []
    private var targets_indexFirstByServiceUUID_thenByCharacteristicUUID: [String: [String: (p: CBPeripheral, s: CBService, c: CBCharacteristic, unfinishedResultCallbacks: [(Data?)->Void], unfinishedWriteCallbacks:  [()->Void]) ]] = [:]
    private var logHandler: (String) -> Void = { s in
        print(s)
    }
    private var unfinishedAddTargetCallbacks: [(serviceUUID: CBUUID, characteristicUUID: CBUUID, handle: ()->Void )] = []
    
    public func setLogHandler(logHandler: @escaping (String) -> Void) {
        self.logHandler = logHandler
    }
    
    public func addTarget(serviceUUID: String, characteristicUUID: String, finishedAddingTargetCallback: @escaping (() -> Void)) {
        self.targetUUIDs.append((service: CBUUID(string: serviceUUID), characteristic: CBUUID(string: characteristicUUID)))
        
        if centralManager.state == .poweredOn {
            var serviceUUIDs: [CBUUID] = []
            for s in self.targetUUIDs {
                serviceUUIDs.append(s.service)
            }
            centralManager.scanForPeripherals(withServices: serviceUUIDs)
        }
        unfinishedAddTargetCallbacks.append((serviceUUID: CBUUID(string: serviceUUID), characteristicUUID: CBUUID(string: characteristicUUID), handle:finishedAddingTargetCallback ))
    }
    
    public func start() {
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        self.logHandler("Started.")
    }
    
    public func read(serviceUUID: String, characteristicUUID: String, resultCallback: @escaping ((Data?)->Void)) {
        let target = targets_indexFirstByServiceUUID_thenByCharacteristicUUID[serviceUUID]![characteristicUUID]!
        target.p.readValue(for: target.c)
        targets_indexFirstByServiceUUID_thenByCharacteristicUUID[serviceUUID]![characteristicUUID]!.unfinishedResultCallbacks.append(resultCallback)
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        
        var val = characteristic.value
        if (error != nil) {
            self.logHandler("    >< ")
            self.logHandler("    >< ERROR when reading value, returning nil. ")
            self.logHandler("    ><       Characteristic Object: " + String(describing: characteristic))
            self.logHandler("    ><       Error Object: " + String(describing: error))
            self.logHandler("    >< ")
            val = nil
        } else {
            self.logHandler("    -- Characteristic Value Updated: " + String(describing: characteristic))
        }
        
        
        while (targets_indexFirstByServiceUUID_thenByCharacteristicUUID[characteristic.service!.uuid.uuidString]![characteristic.uuid.uuidString]!.unfinishedResultCallbacks.count > 0) {
            let cb = targets_indexFirstByServiceUUID_thenByCharacteristicUUID[characteristic.service!.uuid.uuidString]![characteristic.uuid.uuidString]!.unfinishedResultCallbacks.popLast()!
            cb(val)
        }
    }
    
    public func write(serviceUUID: String, characteristicUUID: String, data: Data, finishedWritingCallback: @escaping (() -> Void)) {
        
        
        
        let target = targets_indexFirstByServiceUUID_thenByCharacteristicUUID[serviceUUID]![characteristicUUID]!
        target.p.writeValue(data, for: target.c, type: .withResponse)
        targets_indexFirstByServiceUUID_thenByCharacteristicUUID[serviceUUID]![characteristicUUID]!.unfinishedWriteCallbacks.append(finishedWritingCallback)
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if (error != nil) {
            self.logHandler("    >< ")
            self.logHandler("    >< ERROR when writing value. ")
            self.logHandler("    ><       Characteristic Object: " + String(describing: characteristic))
            self.logHandler("    ><       Error Object: " + String(describing: error))
            self.logHandler("    >< ")
        } else {
            self.logHandler("    -- Characteristic Value Write: " + String(describing: characteristic))
        }
        
        
        while (targets_indexFirstByServiceUUID_thenByCharacteristicUUID[characteristic.service!.uuid.uuidString]![characteristic.uuid.uuidString]!.unfinishedWriteCallbacks.count > 0) {
            let cb = targets_indexFirstByServiceUUID_thenByCharacteristicUUID[characteristic.service!.uuid.uuidString]![characteristic.uuid.uuidString]!.unfinishedWriteCallbacks.popLast()!
            cb()
        }
    }
    
    
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.logHandler("Powered On.")
            
            var serviceUUIDs: [CBUUID] = []
            for s in self.targetUUIDs {
                serviceUUIDs.append(s.service)
            }
            central.scanForPeripherals(withServices: serviceUUIDs)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.logHandler("UUID: " + peripheral.identifier.uuidString + " -- Peripheral Name: " + (peripheral.name ?? "undefined"))
        
        if let serviceUUIDs = advertisementData["kCBAdvDataServiceUUIDs"] as? [CBUUID] {
            for advertisedID in serviceUUIDs {
                self.logHandler("  > Advertised Service UUID: " + advertisedID.uuidString)
            }
            for id in targetUUIDs {
                if serviceUUIDs.contains(id.service) {
                    self.peripherals.append(peripheral) // just to prevent dealloc
                    peripheral.delegate = self
                    self.centralManager.connect(peripheral, options: nil)
                }
            }
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.logHandler("Connected: " + String(describing: peripheral))
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        self.logHandler("UUID: " + peripheral.identifier.uuidString + " -- Peripheral Name: " + (peripheral.name ?? "undefined") +
                        "\n" +
                        " -- Discovered Services: ")
        for service in peripheral.services! {
            self.logHandler("  > Service UUID: " + service.uuid.uuidString + " -- " + String(describing: service))
            for id in targetUUIDs {
                if service.uuid == id.service {
                    self.logHandler(" -> Discovering Characteristics for Service UUID: " + service.uuid.uuidString)
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        self.logHandler(" >> Characteristics for Service UUID: " + service.uuid.uuidString)
        for characteristic in service.characteristics! {
            self.logHandler("    -- Service Characteristic: " + String(describing: characteristic))
            for id in targetUUIDs {
                if id.characteristic == characteristic.uuid && id.service == service.uuid {
                    self.logHandler("    ++ ^ Target Characteristic ^ ")
                    let discoveredTarget = (p: peripheral, s: service, c: characteristic, unfinishedResultCallbacks: [] as [(Data?)->Void], unfinishedWriteCallbacks: [] as [()->Void])
                    
                    if (targets_indexFirstByServiceUUID_thenByCharacteristicUUID[id.service.uuidString] != nil) {
                        targets_indexFirstByServiceUUID_thenByCharacteristicUUID[id.service.uuidString]![id.characteristic.uuidString] = discoveredTarget
                    } else {
                        targets_indexFirstByServiceUUID_thenByCharacteristicUUID[id.service.uuidString] = [
                            id.characteristic.uuidString: discoveredTarget
                        ]
                    }
                    var stillUnfinishedTargets: [(serviceUUID: CBUUID, characteristicUUID: CBUUID, handle: ()->Void )] = []
                    for addTargetCallback in unfinishedAddTargetCallbacks {
                        print(String(describing: addTargetCallback) + "    ---    " + String(describing: discoveredTarget))
                        if (addTargetCallback.serviceUUID == discoveredTarget.s.uuid &&
                            addTargetCallback.characteristicUUID == discoveredTarget.c.uuid) {
                            addTargetCallback.handle()
                            
                        } else {
                            stillUnfinishedTargets.append(addTargetCallback)
                        }
                    }
                    unfinishedAddTargetCallbacks = stillUnfinishedTargets
                    
                }
            }
        }
    }
    
    
    
    
    
}


class MainVC : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bt_controller.view)
        bt_controller.view.frame = view.frame
    }
    override func viewDidLayoutSubviews() {
        bt_controller.view.frame = view.frame
    }
}

struct MyUIViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MainVC {
        return MainVC()
    }
    func updateUIViewController(_ uiViewController: MainVC, context: Context) {
    }
}
