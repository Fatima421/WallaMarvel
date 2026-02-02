import XCTest

final class WallaMarvelUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Launch

    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }

    // MARK: - List Interaction Tests

    func testCharacterListLoads() throws {
        // Given
        let characterList = app.collectionViews.firstMatch

        // When
        XCTAssertTrue(characterList.waitForExistence(timeout: 5))

        // Then
        let cells = characterList.cells
        XCTAssertGreaterThan(cells.count, 0)
    }

    func testNavigationToCharacterDetail() throws {
        // Given
        let characterList = app.collectionViews.firstMatch
        XCTAssertTrue(characterList.waitForExistence(timeout: 5))
        let firstCharacter = characterList.buttons.firstMatch
        XCTAssertTrue(firstCharacter.exists)

        // When
        firstCharacter.tap()

        // Then
        let detailView = app.navigationBars.firstMatch
        XCTAssertTrue(detailView.waitForExistence(timeout: 3))
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.exists)
    }

    // MARK: - Search Tests

    func testSearchFieldAppears() throws {
        // When
        let searchField = app.searchFields["Search characters..."]

        // Then
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
    }

    func testSearchFunctionality() throws {
        // Given
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))

        // When
        searchField.tap()
        searchField.typeText("Mickey")
        sleep(2)

        // Then
        let characterList = app.collectionViews.firstMatch
        XCTAssertTrue(characterList.exists)
    }

    func testSearchSuggestions() throws {
        // Given
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))

        // When
        searchField.tap()

        // Then
        let suggestionsList = app.collectionViews.firstMatch
        XCTAssertTrue(suggestionsList.waitForExistence(timeout: 2))
    }

    // MARK: - Detail View Tests

    func testDetailViewDisplaysContent() throws {
        // Given
        let characterList = app.collectionViews.firstMatch

        // When
        characterList.buttons.firstMatch.tap()
        sleep(1)

        // Then
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists)

        let image = app.images.firstMatch
        XCTAssertTrue(image.exists)
    }
}
