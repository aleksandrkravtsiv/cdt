//
//  CDTListViewModel.swift
//  CDTest
//
//  Created by Aleksandr Kravtsiv on 30.10.2025.
//

import Foundation
import Combine

final public class CDTListViewModel: ObservableObject {
    
    // MARK: - Properties
    private var bluetoothService: BluetoothService
    private var cancellables = Set<AnyCancellable>()
    @Published public var peripherals: [BLEPeripheralDisplayModel] = []
    
    // MARK: - Initializers
    
    init() {
        self.bluetoothService = BluetoothService()
        startScanning()
    }
    
    // MARK: - Public methods
    
    func startScanning() {
        bluetoothService.$peripherals
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedPeripherals in
                self?.peripherals = updatedPeripherals
            }
            .store(in: &cancellables)
    }
    
    func changeScanningType() {
        self.bluetoothService.startScanningOnlyUnique()
    }
    
    func connect(to displayModel: BLEPeripheralDisplayModel) {
        bluetoothService.changeRephiralConnectionStatus(peripheral: displayModel.peripheral)
    }
}
