import Foundation

// MARK: - Protocol

protocol CharacterDataSourceProtocol {
    func getCharacters(page: Int) async throws -> CharactersDataModel
    func getCharacterBy(id: Int) async throws -> CharacterDataModel
}

// MARK: - CharacterDataSource

final class CharacterDataSource: CharacterDataSourceProtocol {
    
    // MARK: - Properties
    
    private let apiClient: APIClientProtocol
    
    // MARK: - Initializer
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    // MARK: - Methods
    
    func getCharacters(page: Int) async throws -> CharactersDataModel {
        try await apiClient.getCharacters(page: page)
    }
    
    func getCharacterBy(id: Int) async throws -> CharacterDataModel {
        try await apiClient.getCharacterBy(id: id)
    }
}
