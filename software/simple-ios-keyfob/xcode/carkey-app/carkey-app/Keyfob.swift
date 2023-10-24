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


let UUID_CMD_WRITE_INPUT = (s: CBUUID(string: SERVICE_UUID).uuidString, c: CBUUID(string: COMMAND_INPUT_CHARACTERISTIC_UUID).uuidString)
let UUID_LOCK_STATE_OUTPUT = (s: CBUUID(string: SERVICE_UUID).uuidString, c: CBUUID(string: PREDICTED_LOCK_STATE_CHARACTERISTIC_UUID).uuidString)


func bt_get_predicted_lock_state(lock_state_callback: @escaping ((predicted_lock_state) -> Void) ) {
    bt_read_value(sUUID: UUID_LOCK_STATE_OUTPUT.s, cUUID: UUID_LOCK_STATE_OUTPUT.c) { data in
        let d = data!
        let state_string = String(bytes: d, encoding: .ascii)!
        var state: predicted_lock_state? = nil
        if (state_string == "locked") { state = .locked }
        if (state_string == "unlocked") { state = .unlocked }
        if (state_string == "unknown") { state = .unknown }
        lock_state_callback(state!)
    }
}

func bt_send_unlock_command(lock_state_callback: @escaping ((predicted_lock_state) -> Void)) {
    let data = String("unlock").data(using: .ascii)!
    bt_write_value(sUUID: UUID_CMD_WRITE_INPUT.s, cUUID: UUID_CMD_WRITE_INPUT.c, data: data) {
        lock_state_callback(.unlocked)
    }
}

func bt_send_lock_command(lock_state_callback: @escaping ((predicted_lock_state) -> Void)) {
    let data = String("lock").data(using: .ascii)!
    bt_write_value(sUUID: UUID_CMD_WRITE_INPUT.s, cUUID: UUID_CMD_WRITE_INPUT.c, data: data) {
        lock_state_callback(.locked)
    }
}
