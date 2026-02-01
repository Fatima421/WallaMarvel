//
//  BaseViewModel.swift
//  WallaMarvel
//
//  Created by Fatima Syed on 1/2/26.
//

import Foundation

class BaseViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var state: ViewState = .none
    @Published var errorMessage: String?
}
