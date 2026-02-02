import Foundation
@testable import WallaMarvel

final class MockCharacterDataSource: CharacterDataSourceProtocol {
    
    // MARK: - Properties
    
    var mockCharactersResponse: CharactersDataModel?
    var mockCharacterResponse: CharacterDataModel?
    var shouldFail = false
    var error: Error = NetworkError.unknown
    
    // MARK: - Methods

    func getCharacters(page: Int) async throws -> CharactersDataModel {
        if shouldFail {
            throw error
        }
        
        guard let response = mockCharactersResponse else {
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
    
    func searchCharacters(name: String, page: Int) async throws -> CharactersDataModel {
        if shouldFail {
            throw error
        }
        
        guard let response = mockCharactersResponse else {
            throw NetworkError.unknown
        }
        
        return response
    }
}
