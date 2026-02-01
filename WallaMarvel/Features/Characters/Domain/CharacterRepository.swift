import Foundation

protocol CharacterRepositoryProtocol {
    func getCharacters(page: Int) async throws -> Characters
    func getCharacterDetail(id: Int) async throws -> Character
}

final class CharacterRepository: CharacterRepositoryProtocol {
    
    // MARK: - Properties
    
    private let dataSource: CharacterDataSourceProtocol
    
    // MARK: - Initializer
    
    init(dataSource: CharacterDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    // MARK: - Methods
    
    func getCharacters(page: Int) async throws -> Characters {
        let response = try await dataSource.getCharacters(page: page)
        return Characters(from: response, currentPage: page)
    }
    
    func getCharacterDetail(id: Int) async throws -> Character {
        let response = try await dataSource.getCharacterBy(id: id)
        return Character(from: response)
    }
}
