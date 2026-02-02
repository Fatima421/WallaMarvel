import Foundation

protocol SearchCharactersUseCaseProtocol {
    func execute(name: String, page: Int) async throws -> Characters
}

final class SearchCharactersUseCase: SearchCharactersUseCaseProtocol {
    // MARK: - Properties

    private let repository: CharacterRepositoryProtocol

    // MARK: - Initializer

    init(repository: CharacterRepositoryProtocol) {
        self.repository = repository
    }

    func execute(name: String, page: Int) async throws -> Characters {
        try await repository.searchCharacters(name: name, page: page)
    }
}
