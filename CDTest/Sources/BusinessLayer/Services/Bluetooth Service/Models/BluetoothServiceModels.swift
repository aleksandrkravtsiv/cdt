//
//  BluetoothServiceModels.swift
//  CDTest
//
//  Created by Aleksandr Kravtsiv on 30.10.2025.
//

import Foundation

public struct BLEPeripheralModel: Identifiable {
    
    // MARK: - Properties
    
    public var id: String {
        return uuid.uuidString
    }
    var rssi: NSNumber
    var uuid: UUID
    
    
}
