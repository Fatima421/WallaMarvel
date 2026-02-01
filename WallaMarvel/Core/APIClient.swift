import Foundation

protocol APIClientProtocol {
    func getCharacters(page: Int) async throws -> CharactersDataModel
    func getCharacterBy(id: Int) async throws -> CharacterDataModel
    func searchCharacters(name: String, page: Int) async throws -> CharactersDataModel
}

final class APIClient: APIClientProtocol {
    
    // MARK: - Properties
    
    private let restManager: RestManagerProtocol

    // MARK: - Initializer
    
    init(restManager: RestManagerProtocol) {
        self.restManager = restManager
    }
    
    // MARK: - Methods
    
    func getCharacters(page: Int) async throws -> CharactersDataModel {
        let endpoint: Endpoint = .getCharacters(page: page)
        return try await restManager.request(endpoint: endpoint)
    }
    
    func getCharacterBy(id: Int) async throws -> CharacterDataModel {
        let endpoint: Endpoint = .getCharacterBy(id: id)
        return try await restManager.request(endpoint: endpoint)
    }
    
    func searchCharacters(name: String, page: Int) async throws -> CharactersDataModel {
        let endpoint: Endpoint = .searchCharacters(name: name, page: page)
        return try await restManager.request(endpoint: endpoint)
    }
}
