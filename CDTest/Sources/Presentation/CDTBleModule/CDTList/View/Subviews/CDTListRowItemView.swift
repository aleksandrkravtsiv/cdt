//
//  CDTListRowItemView.swift
//  CDTest
//
//  Created by Aleksandr Kravtsiv on 30.10.2025.
//

import SwiftUI

struct CDTListRowItemView: View {
    
    private enum Constants {
        static let bluetoothIconImage = "bluetoothIconImage"
    }
    
    @Binding private var model: BLEPeripheralModel
    
    init(model: Binding<BLEPeripheralModel>) {
        self._model = model
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                Image(Constants.bluetoothIconImage)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.gray.opacity(0.5))
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading,spacing: 5) {
                    Text("uuid: \n" + model.uuid.uuidString)
                        .font(.caption)
                    Text("rssi: " + model.rssi.stringValue)
                        .font(.caption)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
