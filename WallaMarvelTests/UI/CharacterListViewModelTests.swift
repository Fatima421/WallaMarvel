@testable import WallaMarvel
import XCTest

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

    private func waitForState(_ expectedState: ViewState, timeout: TimeInterval = 1.0) async {
        let deadline = Date().addingTimeInterval(timeout)
        while sut.state != expectedState, Date() < deadline {
            try? await Task.sleep(nanoseconds: 10_000_000)
        }
    }

    // MARK: - Init Tests

    func testInitLoadsCharactersSuccessfully() async {
        // Given
        mockGetCharactersUseCase.mockResult = MockData.characters

        // When
        sut = CharacterListViewModel(
            getCharactersUseCase: mockGetCharactersUseCase,
            searchCharactersUseCase: mockSearchCharactersUseCase
        )
        await waitForState(.success)

        // Then
        XCTAssertEqual(sut.characters.count, 2)
        XCTAssertEqual(sut.state, .success)
        XCTAssertEqual(mockGetCharactersUseCase.executeCallCount, 1)
    }

    func testInitWithErrorShowsFailureState() async {
        // Given
        mockGetCharactersUseCase.shouldFail = true
        mockGetCharactersUseCase.error = NetworkError.serverError

        // When
        sut = CharacterListViewModel(
            getCharactersUseCase: mockGetCharactersUseCase,
            searchCharactersUseCase: mockSearchCharactersUseCase
        )
        await waitForState(.failure)

        // Then
        XCTAssertTrue(sut.characters.isEmpty)
        XCTAssertEqual(sut.state, .failure)
        XCTAssertNotNil(sut.errorMessage)
    }

    func testInitWithEmptyDataShowsEmptyState() async {
        // Given
        mockGetCharactersUseCase.mockResult = MockData.charactersEmpty

        // When
        sut = CharacterListViewModel(
            getCharactersUseCase: mockGetCharactersUseCase,
            searchCharactersUseCase: mockSearchCharactersUseCase
        )
        await waitForState(.empty)

        // Then
        XCTAssertTrue(sut.characters.isEmpty)
        XCTAssertEqual(sut.state, .empty)
    }

    // MARK: - Load data Tests

    func testLoadMoreAppendsCharacters() async {
        // Given
        mockGetCharactersUseCase.mockResult = MockData.characters

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
        XCTAssertFalse(sut.isLoadingMore)
    }

    func testLoadMoreDoesNotLoadWhenCanLoadMoreIsFalse() async {
        // Given
        mockGetCharactersUseCase.mockResult = MockData.charactersWithNoNextPage

        sut = CharacterListViewModel(
            getCharactersUseCase: mockGetCharactersUseCase,
            searchCharactersUseCase: mockSearchCharactersUseCase
        )
        await waitForState(.success)

        // When
        await sut.loadMoreCharacters()

        // Then
        XCTAssertEqual(mockGetCharactersUseCase.executeCallCount, 1)
        XCTAssertEqual(sut.characters.count, 2)
    }

    func testLoadMoreWithErrorKeepsExistingCharacters() async {
        // Given
        mockGetCharactersUseCase.mockResult = MockData.characters

        sut = CharacterListViewModel(
            getCharactersUseCase: mockGetCharactersUseCase,
            searchCharactersUseCase: mockSearchCharactersUseCase
        )
        await waitForState(.success)

        mockGetCharactersUseCase.shouldFail = true

        // When
        await sut.loadMoreCharacters()

        // Then
        XCTAssertEqual(sut.characters.count, 2)
        XCTAssertNotNil(sut.errorMessage)
    }

    // MARK: - Refresh Tests

    func testRefreshResetsAndReloadsData() async {
        // Given
        mockGetCharactersUseCase.mockResult = MockData.characters

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
        XCTAssertEqual(sut.state, .success)
    }

    func testRefreshClearsExistingCharacters() async {
        // Given
        mockGetCharactersUseCase.mockResult = MockData.characters

        sut = CharacterListViewModel(
            getCharactersUseCase: mockGetCharactersUseCase,
            searchCharactersUseCase: mockSearchCharactersUseCase
        )
        await waitForState(.success)
        await sut.loadMoreCharacters()

        XCTAssertEqual(sut.characters.count, 4)

        mockGetCharactersUseCase.mockResult = MockData.singleCharacter

        // When
        await sut.refresh()

        // Then
        XCTAssertEqual(sut.characters.count, 1)
    }

    // MARK: - Search Tests

    func testSearchTriggersSearchUseCase() async {
        // Given
        mockGetCharactersUseCase.mockResult = MockData.singleCharacter
        mockSearchCharactersUseCase.mockResult = MockData.singleCharacter

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

    func testSearchWithEmptyTextDoesNotTriggerSearch() async {
        // Given
        mockGetCharactersUseCase.mockResult = MockData.characters

        sut = CharacterListViewModel(
            getCharactersUseCase: mockGetCharactersUseCase,
            searchCharactersUseCase: mockSearchCharactersUseCase
        )
        await waitForState(.success)

        // When
        sut.searchText = ""
        sut.onSearchTextChanged()
        try? await Task.sleep(nanoseconds: 400_000_000)

        // Then
        XCTAssertEqual(mockSearchCharactersUseCase.executeCallCount, 0)
    }

    func testSearchWithWhitespaceOnlyDoesNotTriggerSearch() async {
        // Given
        mockGetCharactersUseCase.mockResult = MockData.characters

        sut = CharacterListViewModel(
            getCharactersUseCase: mockGetCharactersUseCase,
            searchCharactersUseCase: mockSearchCharactersUseCase
        )
        await waitForState(.success)

        // When
        sut.searchText = "   "
        sut.onSearchTextChanged()
        try? await Task.sleep(nanoseconds: 400_000_000)

        // Then
        XCTAssertEqual(mockSearchCharactersUseCase.executeCallCount, 0)
    }

    func testClearingSearchRestoresCachedCharacters() async {
        // Given
        mockGetCharactersUseCase.mockResult = MockData.characters
        mockSearchCharactersUseCase.mockResult = MockData.singleCharacter

        sut = CharacterListViewModel(
            getCharactersUseCase: mockGetCharactersUseCase,
            searchCharactersUseCase: mockSearchCharactersUseCase
        )
        await waitForState(.success)

        // Search
        sut.searchText = "Mickey"
        sut.onSearchTextChanged()
        try? await Task.sleep(nanoseconds: 400_000_000)
        await waitForState(.success)

        // When
        sut.searchText = ""
        sut.onSearchTextChanged()

        // Then
        XCTAssertEqual(sut.characters.count, 2)
        XCTAssertEqual(sut.state, .success)
    }
}
