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
    
    private enum Constants {
        static let serviceUIID = "3333"
    }
    
    // MARK: - Properties
    
    @Published public var peripherals = [BLEPeripheralDisplayModel]()
    
    private var centralManager: CBCentralManager
    private var options = [CBConnectPeripheralOptionNotifyOnDisconnectionKey : NSNumber(booleanLiteral: true)]
    private var rssiTimer: Timer?
    private var scanAllDevices = true {
        didSet {
            disconnectAllPeripherals()
            peripherals.removeAll()
            startScanning()
        }
    }

    // MARK: - Initializers
    
    public init(peripherals: [BLEPeripheralDisplayModel] = []) {
        self.centralManager = CBCentralManager()
        super.init()
        centralManager.delegate = self
    }
    
    // MARK: - Public methods
    
    public func startScanningOnlyUnique() {
        scanAllDevices.toggle()
    }
    
    public func changeRephiralConnectionStatus(peripheral: CBPeripheral) {
        guard let selectedPeripheralIndex = obtainPeriphiralIndex(peripheral) else { return }
        let peripheralForConnection = peripherals[selectedPeripheralIndex].peripheral
        
        if peripheralForConnection.state == .connected {
            centralManager.cancelPeripheralConnection(peripheralForConnection)
        } else {
            centralManager.connect(peripheralForConnection, options: options)
        }
        
        peripherals[selectedPeripheralIndex].peripheral = peripheralForConnection
    }
}

// MARK: - CBCentralManagerDelegate Methods

extension BluetoothService: CBCentralManagerDelegate {
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        updateDeviceList(peripheral: peripheral, advertisementData: advertisementData, rssi: RSSI)
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        
        if let selectedPeripheralIndex = obtainPeriphiralIndex(peripheral) {
            peripherals[selectedPeripheralIndex].peripheral = peripheral
        }
        
        updateConnectedPeripheralRSSI(peripheral: peripheral)
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {
        if let selectedPeripheralIndex = obtainPeriphiralIndex(peripheral) {
            peripherals[selectedPeripheralIndex].peripheral = peripheral
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
    
    public func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: (any Error)?) {
        if let index = peripherals.firstIndex(where: { $0.uuid == peripheral.identifier }) {
            peripherals[index].rssi = RSSI
        }
    }
    
    public func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        if let selectedPeripheralIndex = obtainPeriphiralIndex(peripheral), let name = peripheral.name {
            peripherals[selectedPeripheralIndex].name = name
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            peripheral.readValue(for: characteristic)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        guard error == nil else { return }
        guard let inputData = characteristic.value else { return }
        
        if let value = String(data: inputData, encoding: .utf8) {
            if let index = peripherals.firstIndex(where: { $0.uuid == peripheral.identifier }) {
                peripherals[index].characteristicList.append(BLEPeripheralCaharcteristicDisplayModel(id: characteristic.uuid.uuidString, characterisiticValue: value))
            }
        }
        
    }
}

// MARK: - Private Methods

extension BluetoothService {
    
    private func startScanning() {
        centralManager.stopScan()
        centralManager.scanForPeripherals(withServices: scanAllDevices ? nil : [CBUUID(string: Constants.serviceUIID)], options: nil)
    }
    
    private func updateDeviceList(peripheral: CBPeripheral, advertisementData: [String : Any], rssi: NSNumber) {
        let peripheralUUID = peripheral.identifier
        let isAvailableConnection = isAvailableConnection(advertisementData: advertisementData)
        
        if let index = peripherals.firstIndex(where: { $0.uuid == peripheralUUID }) {
            peripherals[index].rssi = rssi
        } else {
            let newPeripheral = BLEPeripheralDisplayModel(peripheral: peripheral, name: peripheral.name ?? "", rssi: rssi, isAvailableConnection: isAvailableConnection)
            peripherals.append(newPeripheral)
        }
    }
    
    private func isAvailableConnection(advertisementData: [String : Any]) -> Bool {
        guard let kCBAdvDataIsConnectable = advertisementData["kCBAdvDataIsConnectable"] as? Int, kCBAdvDataIsConnectable > 0 else { return false }
        return true
    }
    
    private func obtainPeriphiralIndex(_ peripheral: CBPeripheral) -> Int? {
        peripherals.firstIndex(where: {$0.uuid == peripheral.identifier})
    }
    
    func disconnectAllPeripherals() {
        for peripheral in peripherals {
            centralManager.cancelPeripheralConnection(peripheral.peripheral)
        }
    }
    
    private func updateConnectedPeripheralRSSI(peripheral: CBPeripheral) {
        guard peripheral.state == .connected else {
            rssiTimer?.invalidate()
            return
        }
        rssiTimer?.invalidate()
        rssiTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (_) in
            peripheral.readRSSI()
        })
    }
}
