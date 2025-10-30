//
//  CDTListView.swift
//  CDTest
//
//  Created by Aleksandr Kravtsiv on 30.10.2025.
//

import SwiftUI

struct CDTListView: View {
    
    private enum Constants {
        static let scanningAllDevicesDescription = "All devices scanning"
        static let scanningUniqueDevicesDescription = "Unique devices scanning"
    }
    
    // MARK: - Properties
    
    @StateObject private var viewModel: CDTListViewModel = .init()
    @State private var scanAllDevices: Bool = false
    
    // MARK: - Bindin UI
    
    var body: some View {
        NavigationView {
            VStack {
                Toggle(isOn: $scanAllDevices) {
                    Text(!scanAllDevices ? Constants.scanningAllDevicesDescription : Constants.scanningUniqueDevicesDescription)
                        .font(.title3)
                }
                .padding(.horizontal, 16)
                .onChange(of: scanAllDevices) { _ in
                    viewModel.changeScanningType()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach($viewModel.peripherals) { peripheral in
                            CDTListRowItemView(model: peripheral, callBack: {
                                viewModel.connect(to: peripheral.wrappedValue)
                            })
                        }
                    }
                }
                .scrollIndicators(.hidden)
                
            }
            .navigationTitle("Device List")
        }
    }
}
