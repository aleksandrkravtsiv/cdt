//
//  CDTListView.swift
//  CDTest
//
//  Created by Aleksandr Kravtsiv on 30.10.2025.
//

import SwiftUI

struct CDTListView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel: CDTListViewModel = .init()
    
    // MARK: - Bindin UI
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach($viewModel.peripherals) { peripheral in
                        CDTListRowItemView(model: peripheral)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

extension CDTListView {
    
    private func configureUI() {
        
    }
}
