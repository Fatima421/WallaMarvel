import XCTest
@testable import WallaMarvel

@MainActor
class CharacterListViewModelTests: XCTestCase {
    
    var sut: CharacterListViewModel!
    var mockGetCharactersUseCase: MockGetCharactersUseCase!
    var mockSearchCharactersUseCase: MockSearchCharactersUseCase!
    
    override func setUp() {
        super.setUp()
        mockGetCharactersUseCase = MockGetCharactersUseCase()
        mockSearchCharactersUseCase = MockSearchCharactersUseCase()
    }
    
    override func tearDown() {
        sut = nil
        mockGetCharactersUseCase = nil
        mockSearchCharactersUseCase = nil
        super.tearDown()
    }
    
    // MARK: - Helper
    
    private func waitForState(_ expectedState: ViewState, timeout: TimeInterval = 1.0) async {
        let deadline = Date().addingTimeInterval(timeout)
        while sut.state != expectedState && Date() < deadline {
            try? await Task.sleep(nanoseconds: 10_000_000)
        }
    }
    
    private func makeMockCharacters(count: Int, hasNextPage: Bool = false) -> Characters {
        let response = CharactersDataModel(
            info: PaginationInfo(count: count, totalPages: 2, previousPage: nil, nextPage: hasNextPage ? "page=2" : nil),
            data: (1...count).map { CharacterDataModel(id: $0, name: "Character \($0)", imageUrl: nil, films: []) }
        )
        return Characters(from: response, currentPage: 1)
    }
    
    // MARK: - Tests
    
    func testInitLoadsCharacters() async {
        // Given
        mockGetCharactersUseCase.mockResult = makeMockCharacters(count: 3)
        
        // When
        sut = CharacterListViewModel(
            getCharactersUseCase: mockGetCharactersUseCase,
            searchCharactersUseCase: mockSearchCharactersUseCase
        )
        await waitForState(.success)
        
        // Then
        XCTAssertEqual(sut.characters.count, 3)
        XCTAssertEqual(sut.state, .success)
    }
    
    func testInitWithErrorShowsFailure() async {
        // Given
        mockGetCharactersUseCase.shouldFail = true
        
        // When
        sut = CharacterListViewModel(
            getCharactersUseCase: mockGetCharactersUseCase,
            searchCharactersUseCase: mockSearchCharactersUseCase
        )
        await waitForState(.failure)
        
        // Then
        XCTAssertTrue(sut.characters.isEmpty)
        XCTAssertEqual(sut.state, .failure)
    }
    
    func testLoadMoreAppendsCharacters() async {
        // Given
        mockGetCharactersUseCase.mockResult = makeMockCharacters(count: 2, hasNextPage: true)
        sut = CharacterListViewModel(
            getCharactersUseCase: mockGetCharactersUseCase,
            searchCharactersUseCase: mockSearchCharactersUseCase
        )
        await waitForState(.success)
        
        // When
        await sut.loadMoreCharacters()
        
        // Then
        XCTAssertEqual(sut.characters.count, 4)
        XCTAssertEqual(mockGetCharactersUseCase.executeCallCount, 2)
    }
    
    func testRefreshReloadsData() async {
        // Given
        mockGetCharactersUseCase.mockResult = makeMockCharacters(count: 2)
        sut = CharacterListViewModel(
            getCharactersUseCase: mockGetCharactersUseCase,
            searchCharactersUseCase: mockSearchCharactersUseCase
        )
        await waitForState(.success)
        
        // When
        await sut.refresh()
        
        // Then
        XCTAssertEqual(sut.characters.count, 2)
        XCTAssertEqual(mockGetCharactersUseCase.executeCallCount, 2)
    }
    
    func testSearchTriggersSearchUseCase() async {
        // Given
        mockGetCharactersUseCase.mockResult = makeMockCharacters(count: 1)
        mockSearchCharactersUseCase.mockResult = makeMockCharacters(count: 1)
        
        sut = CharacterListViewModel(
            getCharactersUseCase: mockGetCharactersUseCase,
            searchCharactersUseCase: mockSearchCharactersUseCase
        )
        await waitForState(.success)
        
        // When
        sut.searchText = "Mickey"
        sut.onSearchTextChanged()
        try? await Task.sleep(nanoseconds: 400_000_000) // debounce
        await waitForState(.success)
        
        // Then
        XCTAssertEqual(mockSearchCharactersUseCase.executeCallCount, 1)
        XCTAssertEqual(mockSearchCharactersUseCase.lastNameSearched, "Mickey")
    }
}
