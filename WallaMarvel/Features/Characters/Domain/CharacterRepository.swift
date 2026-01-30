import Foundation

protocol CharacterRepositoryProtocol {
    func getCharacters(page: Int) async throws -> [Character]
    func getCharacterDetail(id: Int) async throws -> Character
}

final class CharacterRepository: CharacterRepositoryProtocol {
    private let dataSource: CharacterDataSource
    
    init(dataSource: CharacterDataSource) {
        self.dataSource = dataSource
    }
    
    func getCharacters(page: Int) async throws -> [Character] {
        let response = try await dataSource.getCharacters(page: page)
        return response.data.map { Character(from: $0) }
    }
    
    func getCharacterDetail(id: Int) async throws -> Character {
        let response = try await dataSource.getCharacterBy(id: id)
        return Character(from: response)
    }
}
