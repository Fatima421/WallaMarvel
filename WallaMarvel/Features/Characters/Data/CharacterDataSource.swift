import Foundation

protocol CharacterDataSourceProtocol {
    func getCharacters(page: Int) async throws -> CharactersDataModel
    func getCharacterBy(id: Int) async throws -> CharacterDataModel
}

final class CharacterDataSource: CharacterDataSourceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getCharacters(page: Int) async throws -> CharactersDataModel {
        try await apiClient.getCharacters(page: page)

    }
    
    func getCharacterBy(id: Int) async throws -> CharacterDataModel {
        try await apiClient.getCharacterBy(id: id)
    }
}
