//
//  CharacterListViewModel.swift
//  WallaMarvel
//
//  Created by Fatima Syed on 30/1/26.
//

import Foundation

final class CharacterListViewModel: ObservableObject {
    // MARK: - Properties
    @Published var characters: [Character] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let getCharactersUseCase: GetCharactersUseCaseProtocol
    private var currentPage = 1
    
    // MARK: - Initializer
    
    init(getCharactersUseCase: GetCharactersUseCaseProtocol = AppContainer.shared.makeGetCharactersUseCase()) {
        self.getCharactersUseCase = getCharactersUseCase
    }
    
    // MARK: - Load data
    func loadCharacters() async {
        isLoading = true
        errorMessage = nil
        
        do {
            characters = try await getCharactersUseCase.execute(page: currentPage)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
