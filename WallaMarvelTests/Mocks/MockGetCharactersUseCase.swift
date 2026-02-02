import Foundation
@testable import WallaMarvel

final class MockGetCharactersUseCase: GetCharactersUseCaseProtocol {
    // MARK: - Properties

    var mockResult: Characters?
    var shouldFail = false
    var error: Error = NetworkError.unknown

    var executeCallCount = 0

    // MARK: - Methods

    func execute(page _: Int) async throws -> Characters {
        executeCallCount += 1

        if shouldFail {
            throw error
        }

        guard let result = mockResult else {
            throw NetworkError.unknown
        }

        return result
    }
}
