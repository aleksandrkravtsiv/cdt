//
//  BluetoothService.swift
//  CDTest
//
//  Created by Aleksandr Kravtsiv on 30.10.2025.
//

import Foundation
import CoreBluetooth
import Combine

public class BluetoothService: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    @Published public var peripherals = [BLEPeripheralModel]()
    
    private var centralManager: CBCentralManager
    private var options = [CBConnectPeripheralOptionNotifyOnDisconnectionKey : NSNumber(booleanLiteral: true)]
    private var scanAllDevices = true

    
    // MARK: - Initializers
    public init(peripherals: [BLEPeripheralModel] = []) {
        self.centralManager = CBCentralManager()
        super.init()
        centralManager.delegate = self
    }
    
    // MARK: - Protocol methods
    
    public func startScanningOnlyUnique() {
        scanAllDevices.toggle()
        peripherals.removeAll()
    }
    
}

// MARK: - CBCentralManagerDelegate Methods

extension BluetoothService: CBCentralManagerDelegate {
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if scanAllDevices {
            updateDeviceList(peripheral: peripheral, rssi: RSSI)
        } else {
            
        }
    }
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is powered: On")
            startScanning()
        default:
            print("Bluetooth is powered: Off")
            centralManager.stopScan()
        }
    }
}

// MARK: - CBPeripheralDelegate Methods

extension BluetoothService: CBPeripheralDelegate {
    
}

// MARK: - Private Methods

extension BluetoothService {
    
    private func startScanning() {
        centralManager.scanForPeripherals(withServices: nil, options: options)
    }
    
    private func updateDeviceList(peripheral: CBPeripheral, rssi: NSNumber) {
        
        let peripheralUUID = peripheral.identifier
        
        if let index = peripherals.firstIndex(where: { $0.uuid == peripheralUUID }) {
            peripherals[index].rssi = rssi
        } else {
            let newPeripheral = BLEPeripheralModel(rssi: rssi, uuid: peripheralUUID)
            peripherals.append(newPeripheral)
            debugPrint("Added new peripheral with uuid: \(peripheralUUID)")
        }
    }
}
