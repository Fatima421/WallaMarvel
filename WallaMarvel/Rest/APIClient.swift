import Foundation

protocol APIClientProtocol {
    func getCharacters(page: Int) async throws -> CharacterDataContainer
    func getCharacterBy(id: Int) async throws -> CharacterDataModel
}

final class APIClient: APIClientProtocol {
    // MARK: - Properties
    private let restManager: RestManagerProtocol

    // MARK: - Initializer
    init(restManager: RestManagerProtocol) {
        self.restManager = restManager
    }
    
    func getCharacters(page: Int) async throws -> CharacterDataContainer {
        let endpoint: Endpoint = .getCharacters(page: page)
        return try await restManager.request(endpoint: endpoint)
    }
    
    func getCharacterBy(id: Int) async throws -> CharacterDataModel {
        let endpoint: Endpoint = .getCharacterBy(id: id)
        return try await restManager.request(endpoint: endpoint)
    }
}
