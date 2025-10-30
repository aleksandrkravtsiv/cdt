//
//  CDTDetailView.swift
//  CDTest
//
//  Created by Aleksandr Kravtsiv on 30.10.2025.
//

import SwiftUI

struct CDTDetailView: View {
    
    @Binding var model: BLEPeripheralDisplayModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            VStack(alignment: .leading) {
                if !model.name.isEmpty {
                    Text(model.name)
                        .font(.title3)
                }
                
                Text(model.uuid.uuidString)
                    .font(.caption2)
                    .multilineTextAlignment(.leading)
                
                Text("rssi: " + model.rssi.stringValue)
                    .font(.caption)
                
                let connectionStateValue = model.connectionState == .connectedState ? "Connected" : "Disconnected"
                Text("Conection: " + connectionStateValue)
                    .font(.caption)
                    .foregroundStyle(model.connectionState == .connectedState ? Color.green : Color.red)
                
                VStack(alignment: .leading) {
                    Text("Characteristic values")
                        .font(.title3)
                    ForEach(model.characteristicList) { characteristic in
                        VStack(alignment: .leading) {
                            Text(characteristic.id)
                                .font(.caption2)
                                .multilineTextAlignment(.leading)
                            Text(characteristic.characterisiticValue)
                                .font(.caption2)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
            }
        }
    }
}
