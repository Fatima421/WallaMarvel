import Foundation
@testable import WallaMarvel

final class MockSearchCharactersUseCase: SearchCharactersUseCaseProtocol {
    
    // MARK: - Properties

    var mockResult: Characters?
    var shouldFail = false
    var error: Error = NetworkError.unknown
    
    var executeCallCount = 0
    var lastNameSearched: String?
    
    // MARK: - Methods

    func execute(name: String, page: Int) async throws -> Characters {
        executeCallCount += 1
        lastNameSearched = name
        
        if shouldFail {
            throw error
        }
        
        guard let result = mockResult else {
            throw NetworkError.unknown
        }
        
        return result
    }
}
