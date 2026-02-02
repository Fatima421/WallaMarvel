import Foundation

protocol GetCharacterUseCaseProtocol {
    func execute(id: Int) async throws -> Character
}

final class GetCharacterUseCase: GetCharacterUseCaseProtocol {
    // MARK: - Properties

    private let repository: CharacterRepositoryProtocol

    // MARK: - Initializer

    init(repository: CharacterRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: Int) async throws -> Character {
        try await repository.getCharacterDetail(id: id)
    }
}
