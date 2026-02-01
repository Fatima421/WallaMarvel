import Foundation
@testable import WallaMarvel

final class MockAPIClient: APIClientProtocol {
    
    // MARK: - Mock Properties
    
    var mockResponse: CharactersDataModel?
    var mockCharacterResponse: CharacterDataModel?
    var shouldFail = false
    var error: Error = NetworkError.unknown
    
    // MARK: - Protocol Implementation

    func getCharacters(page: Int) async throws -> CharactersDataModel {
        if shouldFail {
            throw error
        }
        
        guard let response = mockResponse else {
            throw NetworkError.unknown
        }
        
        return response
    }
    
    func getCharacterBy(id: Int) async throws -> CharacterDataModel {
        if shouldFail {
            throw error
        }
        
        guard let response = mockCharacterResponse else {
            throw NetworkError.unknown
        }
        
        return response
    }
}
