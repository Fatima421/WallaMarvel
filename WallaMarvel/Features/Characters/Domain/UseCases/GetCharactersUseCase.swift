import Foundation

protocol GetCharactersUseCaseProtocol {
    func execute(page: Int) async throws -> [Character]
}

final class GetCharactersUseCase: GetCharactersUseCaseProtocol {
    private let repository: CharacterRepositoryProtocol
    
    init(repository: CharacterRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(page: Int) async throws -> [Character] {
        try await repository.getCharacters(page: page)
    }
}
