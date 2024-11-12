//
//  BluethootService.swift
//  AnimatedApp
//
//  Created by Jaime Leon Parada on 21/05/24.
//

import Foundation
import CoreBluetooth

enum ConnectionStatus {
    case connected
    case disconnected
    case scanning
    case connecting
    case error
    case receiving
}

let hallSensorService: CBUUID = CBUUID(string: "4fafc201-1fb5-459e-8fcc-c5c9c331914b")
let hallSensorCharacteristic: CBUUID = CBUUID(string: "beb5483e-36e1-4688-b7f5-ea07361b26a8")

class  BluethootService: NSObject, ObservableObject {
    private var centralManager: CBCentralManager!
    var hallSensorPeripheral: CBPeripheral?
    
    @Published var peripheralStatus: ConnectionStatus = .disconnected
    @Published var containerStatus: String = "Cerrado"
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func scanForPeripherals() {
        peripheralStatus = .scanning
        centralManager.scanForPeripherals(withServices: [hallSensorService])
    }
}

extension BluethootService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            scanForPeripherals()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered \(peripheral.name ?? "name")")
        hallSensorPeripheral = peripheral
        centralManager.connect(hallSensorPeripheral!)
        peripheralStatus = .connecting
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheralStatus = .connected
        peripheral.delegate = self
        peripheral.discoverServices([hallSensorService])
        centralManager.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?) {
        peripheralStatus = .error
        print(error?.localizedDescription ?? "no error")
    }
}

extension BluethootService: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        for service in peripheral.services ?? [] {
            if service.uuid == hallSensorService {
                peripheral.discoverCharacteristics([hallSensorCharacteristic], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        for characterisctic in service.characteristics ?? [] {
            peripheral.setNotifyValue(true, for: characterisctic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        if characteristic.uuid == hallSensorCharacteristic {
            guard let data = characteristic.value else {
                print("No data received for \(characteristic.uuid.uuidString)")
                return
            }
            
            if let str = String(data: data, encoding: .utf8) {
                print("Successfully decoded: \(str)")
                containerStatus = str
                peripheralStatus = .receiving
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    self.peripheralStatus = .connected
                }
            }
        }
    }
}
