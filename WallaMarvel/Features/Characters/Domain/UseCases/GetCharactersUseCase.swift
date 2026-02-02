import Foundation

protocol GetCharactersUseCaseProtocol {
    func execute(page: Int) async throws -> Characters
}

final class GetCharactersUseCase: GetCharactersUseCaseProtocol {
    // MARK: - Properties

    private let repository: CharacterRepositoryProtocol

    // MARK: - Initializer

    init(repository: CharacterRepositoryProtocol) {
        self.repository = repository
    }

    func execute(page: Int) async throws -> Characters {
        try await repository.getCharacters(page: page)
    }
}
