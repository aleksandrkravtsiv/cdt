//
//  CDTListRowItemView.swift
//  CDTest
//
//  Created by Aleksandr Kravtsiv on 30.10.2025.
//

import SwiftUI

typealias Callback = () -> ()

struct CDTListRowItemView: View {
    
    private enum Constants {
        static let bluetoothIconImage = "bluetoothIconImage"
    }
    
    @Binding private var model: BLEPeripheralDisplayModel
    private var didConnect: Callback?
    
    init(model: Binding<BLEPeripheralDisplayModel>, callBack: Callback?) {
        self._model = model
        self.didConnect = callBack
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 5) {
                Image(Constants.bluetoothIconImage)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(model.connectionState == .connectedState ? Color.blue : Color.gray.opacity(0.5))
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("uuid:")
                        .font(.caption)
                    Text(model.uuid.uuidString)
                        .font(.caption2)
                        .multilineTextAlignment(.leading)
                    if !model.name.isEmpty {
                        Text("Name:")
                            .font(.subheadline)
                        Text(model.name)
                            .font(.subheadline)
                    }
                    Text("rssi: " + model.rssi.stringValue)
                        .font(.caption)
                }
                
                Spacer()
                if model.isAvailableConnection {
                    switch model.connectionState {
                    case .connectedState, .disconnectedState:
                        Button {
                            didConnect?()
                        } label: {
                            Text(model.connectionState == .connectedState ? "Disconnect" : "Connect")
                                .font(.caption)
                        }
                        .frame(height: 44)
                    case .processingState:
                        ProgressView("")
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(height: 24)
                        
                    case .unknownState:
                        EmptyView()
                    }
                }
            }
            
            Divider().frame(height: 0.5)
                .padding(.leading, 50)
        }
        .padding(.horizontal, 16)
    }
}
