//
//  BluetoothServiceModels.swift
//  CDTest
//
//  Created by Aleksandr Kravtsiv on 30.10.2025.
//

import Foundation
import CoreBluetooth

public struct BLEPeripheralDisplayModel: Identifiable {
    
    // MARK: - Properties
    public var id: String {
        return uuid.uuidString
    }
    
    var peripheral: CBPeripheral
    var name: String
    var rssi: NSNumber
    var isAvailableConnection: Bool
    
    var uuid: UUID {
        return peripheral.identifier
    }
    
    public var connectionState: BLEPeripheralState {
        switch peripheral.state {
        case .connected:
            return .connectedState
        case .disconnected:
            return .disconnectedState
        case .connecting, .disconnecting:
            return .processingState
        @unknown default:
            return .unknownState
        }
    }
}

public enum BLEPeripheralState {
    case connectedState
    case disconnectedState
    case processingState
    case unknownState
}

