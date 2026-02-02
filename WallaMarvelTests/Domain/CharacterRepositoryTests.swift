import XCTest
@testable import WallaMarvel

class CharacterRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    
    var sut: CharacterRepository!
    var mockDataSource: MockCharacterDataSource!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        mockDataSource = MockCharacterDataSource()
        sut = CharacterRepository(dataSource: mockDataSource)
    }
    
    override func tearDown() {
        sut = nil
        mockDataSource = nil
        super.tearDown()
    }
    
    // MARK: - Get Characters Tests
    
    func testGetCharactersSuccessMapsToCharacters() async throws {
        // Given
        let mockResponse = CharactersDataModel(
            info: PaginationInfo(count: 2, totalPages: 5, previousPage: nil, nextPage: "page=2"),
            data: [
                CharacterDataModel(id: 1, name: "Mickey Mouse", imageUrl: "url1", films: []),
                CharacterDataModel(id: 2, name: "Elsa", imageUrl: "url2", films: [])
            ]
        )
        mockDataSource.mockCharactersResponse = mockResponse
        
        // When
        let result = try await sut.getCharacters(page: 1)
        
        // Then
        XCTAssertEqual(result.data.count, 2)
        XCTAssertEqual(result.data[0].name, "Mickey Mouse")
        XCTAssertEqual(result.data[1].name, "Elsa")
        XCTAssertEqual(result.currentPage, 1)
        XCTAssertEqual(result.totalPages, 5)
    }
    
    func testGetCharactersDataSourceFailsThrowsError() async {
        // Given
        mockDataSource.shouldFail = true
        
        // When & Then
        do {
            _ = try await sut.getCharacters(page: 1)
            XCTFail("Should throw error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: - Get Character Detail Tests
    
    func testGetCharacterDetailSuccessMapsToCharacter() async throws {
        // Given
        let mockCharacter = CharacterDataModel(id: 1, name: "Mickey Mouse", imageUrl: "url", films: [])
        mockDataSource.mockCharacterResponse = mockCharacter
        
        // When
        let result = try await sut.getCharacterDetail(id: 1)
        
        // Then
        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.name, "Mickey Mouse")
        XCTAssertEqual(result.imageUrl, "url")
    }
    
    func testGetCharacterDetailDataSourceFailsThrowsError() async {
        // Given
        mockDataSource.shouldFail = true
        
        // When & Then
        do {
            _ = try await sut.getCharacterDetail(id: 1)
            XCTFail("Should throw error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
