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


let UUID = (s: CBUUID(string: SERVICE_UUID).uuidString, c: CBUUID(string: PREDICTED_LOCK_STATE_CHARACTERISTIC_UUID).uuidString)


func bt_get_predicted_lock_state(lock_state_callback: ((predicted_lock_state) -> Void) ) {
    lock_state_callback(.unknown)
}

func bt_send_unlock_command(lock_state_callback: @escaping ((predicted_lock_state) -> Void)) {
    bt_controller.start()
    bt_controller.addTarget(serviceUUID: UUID.s, characteristicUUID: UUID.c) {
        print("Finished adding target")
        bt_controller.read(serviceUUID: UUID.s, characteristicUUID: UUID.c) { d in
            print(d)
        }
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
        lock_state_callback(.unlocked)
    }
}

func bt_send_lock_command(lock_state_callback: @escaping ((predicted_lock_state) -> Void)) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
        lock_state_callback(.locked)
    }
}
