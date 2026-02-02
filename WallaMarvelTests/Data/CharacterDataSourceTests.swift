import XCTest
@testable import WallaMarvel

class CharacterDataSourceTests: XCTestCase {
    
    // MARK: - Properties
    
    var sut: CharacterDataSource!
    var mockAPIClient: MockAPIClient!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        sut = CharacterDataSource(apiClient: mockAPIClient)
    }
    
    override func tearDown() {
        sut = nil
        mockAPIClient = nil
        super.tearDown()
    }
    
    // MARK: - Get Characters Tests
    
    func testGetCharactersSuccessReturnsCharacters() async throws {
        // Given
        let mockResponse = CharactersDataModel(
            info: PaginationInfo(count: 2, totalPages: 5, previousPage: nil, nextPage: "page=2"),
            data: [
                CharacterDataModel(id: 1, name: "Mickey Mouse", imageUrl: "url1", films: []),
                CharacterDataModel(id: 2, name: "Elsa", imageUrl: "url2", films: [])
            ]
        )
        mockAPIClient.mockResponse = mockResponse
        
        // When
        let result = try await sut.getCharacters(page: 1)
        
        // Then
        XCTAssertEqual(result.data.count, 2)
        XCTAssertEqual(result.data[0].name, "Mickey Mouse")
        XCTAssertEqual(result.info.totalPages, 5)
    }
    
    func testGetCharactersNetworkErrorThrowsError() async {
        // Given
        mockAPIClient.shouldFail = true
        mockAPIClient.error = NetworkError.serverError
        
        // When & Then
        do {
            _ = try await sut.getCharacters(page: 1)
            XCTFail("Should throw error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: - Get Character By ID Tests
    
    func testGetCharacterByIdSuccessReturnsCharacter() async throws {
        // Given
        let mockCharacter = CharacterDataModel(id: 1, name: "Mickey Mouse", imageUrl: "url", films: [])
        mockAPIClient.mockCharacterResponse = mockCharacter
        
        // When
        let result = try await sut.getCharacterBy(id: 1)
        
        // Then
        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.name, "Mickey Mouse")
    }
    
    func testGetCharacterByIdNetworkErrorThrowsError() async {
        // Given
        mockAPIClient.shouldFail = true
        mockAPIClient.error = NetworkError.serverError
        
        // When & Then
        do {
            _ = try await sut.getCharacterBy(id: 1)
            XCTFail("Should throw error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
