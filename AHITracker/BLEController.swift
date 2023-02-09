//
//  BLEController.swift
//  RunTracker
//
//  Created by Anas Imtiaz on 06/12/2021.
//

import Foundation
import CoreBluetooth


class BLEController: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var myCentral: CBCentralManager!
    
    @Published var runningSpeed: UInt16 = 0
    @Published var heartRate: UInt32 = 0
    @Published var heartRate2: UInt32 = 0
    @Published var temperature: Float = 0
    
    @Published var isSwitchedOn = false
    
    var sensorType: RTSensorType!
    @Published var sensors: [RTSensor] = []
    
    
    // let sleepApneaServiceUUID = CBUUID(string: "6e400001-b5a3-f393-e0a9-e50e24dcca9e")
    // let sleepApneaRXCharacteristicUUID = CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e")
    // let sleepApneaTXCharacteristicUUID = CBUUID(string: "6e400003-b5a3-f393-e0a9-e50e24dcca9e")
     let runningSpeedServiceUUID = CBUUID(string: "1814")
     let runningSpeedCharacteristicUUID = CBUUID(string: "2A53")
    // let runningSpeedServiceUUID = CBUUID(string: "6e400001-b5a3-f393-e0a9-e50e24dcca9e")
    // let runningSpeedCharacteristicUUID = CBUUID(string: "6e400003-b5a3-f393-e0a9-e50e24dcca9e")
    // let heartRateServiceUUID = CBUUID(string: "180D")
    // let heartRateCharacteristicUUID = CBUUID(string: "2A37")
    let heartRateServiceUUID = CBUUID(string: "6e400001-b5a3-f393-e0a9-e50e24dcca9e")
    let heartRateCharacteristicUUID = CBUUID(string:"6e400003-b5a3-f393-e0a9-e50e24dcca9e")
    let thingyServiceUUID = CBUUID(string: "EF680100-9B35-4933-9B10-52FFA9740042")
    let thingyWeatherStationServiceUUID = CBUUID(string: "EF680200-9B35-4933-9B10-52FFA9740042")
    let thingyTemperationCharacteristicUUID = CBUUID(string: "EF680201-9B35-4933-9B10-52FFA9740042")
    


    
    override init() {
        super.init()
        myCentral = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isSwitchedOn = true
        }
        else {
            isSwitchedOn = false
        }
    }
    
    func connectToSensor(type: RTSensorType) {
        sensorType = type
        var serviceUUIDs: [CBUUID] = []
        
        switch sensorType {
        case .speed:
            serviceUUIDs = [runningSpeedServiceUUID]
        case .heart:
            serviceUUIDs = [heartRateServiceUUID]
        case .environment:
            serviceUUIDs = [thingyServiceUUID]
        case .none:
            serviceUUIDs = []
        }
        
        myCentral.scanForPeripherals(withServices: serviceUUIDs, options: nil)
    }
    
    func disconnectFromSensor(type: RTSensorType) {
        if let index = sensors.firstIndex(where: { $0.type == type }) {
            myCentral.cancelPeripheralConnection(sensors[index].peripheral)
        }
    }
    
    func disconnectAllSensors() {
        for sensor in sensors {
            myCentral.cancelPeripheralConnection(sensor.peripheral)
        }
    }
    
    func sensorConnectionStatus(type: RTSensorType) -> Bool {
        if let index = sensors.firstIndex(where: { $0.type == type }) {
            return sensors[index].isConnected
        }
        return false
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        // add discovered sensor to list
        sensors.append(RTSensor(peripheral: peripheral, name: peripheral.name ?? "NoName", type: sensorType, isConnected: false))
        sensors.last!.peripheral.delegate = self
        central.stopScan()
        central.connect(sensors.last!.peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if let index = sensors.firstIndex(where: { $0.peripheral.identifier.uuidString == peripheral.identifier.uuidString }) {
            sensors[index].isConnected = true
        }
        
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    
        
        for service in peripheral.services! {
            
            if service.uuid == runningSpeedServiceUUID {
                peripheral.discoverCharacteristics([runningSpeedCharacteristicUUID], for: service)
            }
            else if service.uuid == heartRateServiceUUID {
                peripheral.discoverCharacteristics([heartRateCharacteristicUUID], for: service)
            }
            else if service.uuid == thingyWeatherStationServiceUUID {
                peripheral.discoverCharacteristics([thingyTemperationCharacteristicUUID], for: service)
            }
            
        }

    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        for characteristic in service.characteristics! {
            if characteristic.uuid == thingyTemperationCharacteristicUUID ||
                characteristic.uuid == heartRateCharacteristicUUID ||
                characteristic.uuid == runningSpeedCharacteristicUUID {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if characteristic.uuid == runningSpeedCharacteristicUUID {
            let data = characteristic.value!
            let runningSpeedData = data.subdata(in: 1..<3)
            runningSpeed = runningSpeedData.withUnsafeBytes { pointer in
                return pointer.load(as: UInt16.self)/256
            }
        }
        else if characteristic.uuid == heartRateCharacteristicUUID {
            let data = characteristic.value!
            
            
            print(data)
            print("Hello World")
            
            
//            let hrmFlag = data[0] as UInt8
            
//            if hrmFlag << 7 == 0 { // 8 bit
//                let heartRateData = data.subdata(in: 1..<2)
//                let hr8 = heartRateData.withUnsafeBytes { pointer in
//                    return pointer.load(as: UInt8.self)
//                }
//                heartRate = UInt32(hr8)
//                print("first")
//                print(heartRate)
//                print(heartRateData)            }
//            else { // 16 bit
                let heartRateData = data.subdata(in: 1..<5)
                let hr32 = heartRateData.withUnsafeBytes { pointer in
                    return pointer.load(as: UInt32.self)
                }
                heartRate = hr32
                print("second1")
                print(heartRate)
                print(heartRateData)
                
                let heartRateData2 = data.subdata(in: 5..<9)
                let hr322 = heartRateData2.withUnsafeBytes { pointer in
                    return pointer.load(as: UInt32.self)
                }
                heartRate2 = hr322
                print("second2")
                print(heartRate2)
                print(heartRateData2)
            
      
            let file = "file.txt" //this is the file. we will write to and read from it

            let text = String(heartRate) //just a text
            print("text  "  +   text)

            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

                let fileURL = dir.appendingPathComponent(file)

                //writing
                do {
                    try text.write(to: fileURL, atomically: false, encoding: .utf8)
                }
                catch {/* error handling here */}

                //reading
                do {
                    let text2 = try String(contentsOf: fileURL, encoding: .utf8)
                }
                catch {/* error handling here */}
            }
 //       }
        }
        else if characteristic.uuid == thingyTemperationCharacteristicUUID {
            let data = characteristic.value!
            temperature = Float(Int8(truncatingIfNeeded: Int(data[0]))) + Float(UInt8(data[1])/100)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let index = sensors.firstIndex(where: { $0.peripheral.identifier.uuidString == peripheral.identifier.uuidString }) {
            sensors[index].isConnected = false
            sensors.remove(at: index)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
    }
    
}
