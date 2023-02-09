//
//  RTSensors.swift
//  RunTracker
//
//  Created by Anas Imtiaz on 06/12/2021.
//

import Foundation
import CoreBluetooth


enum RTSensorType {
    case speed
    case heart
    case environment
}

struct RTSensor {
    let peripheral: CBPeripheral
    let name: String
    let type: RTSensorType
    var isConnected: Bool
}


