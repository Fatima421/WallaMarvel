import Foundation

protocol CharacterDataSourceProtocol {
    func getCharacters(page: Int) async throws -> CharactersDataModel
    func getCharacterBy(id: Int) async throws -> CharacterDataModel
    func searchCharacters(name: String, page: Int) async throws -> CharactersDataModel
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
    
    func searchCharacters(name: String, page: Int) async throws -> CharactersDataModel {
        try await apiClient.searchCharacters(name: name, page: page)
    }
}
