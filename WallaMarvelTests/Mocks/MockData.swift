@testable import WallaMarvel
import XCTest

enum MockData {
    static let charactersDataModel = CharactersDataModel(
        info: PaginationInfo(count: 2, totalPages: 5, previousPage: nil, nextPage: "page=2"),
        data: [
            CharacterDataModel(id: 1, name: "Mickey Mouse", imageUrl: "https://example.com/mickey.jpg", films: []),
            CharacterDataModel(id: 2, name: "Elsa", imageUrl: "https://example.com/elsa.jpg", films: [])
        ]
    )

    static let characterDataModel = CharacterDataModel(id: 1, name: "Mickey Mouse", imageUrl: "https://example.com/mickey.jpg", films: [])
    static let characters = Characters(from: charactersDataModel, currentPage: 1)

    static let charactersDataModelNoNextPage = CharactersDataModel(
        info: PaginationInfo(count: 2, totalPages: 1, previousPage: nil, nextPage: nil),
        data: [
            CharacterDataModel(id: 1, name: "Mickey Mouse", imageUrl: "https://example.com/mickey.jpg", films: []),
            CharacterDataModel(id: 2, name: "Elsa", imageUrl: "https://example.com/elsa.jpg", films: [])
        ]
    )

    static let charactersWithNoNextPage = Characters(from: charactersDataModelNoNextPage, currentPage: 1)

    static let charactersEmptyDataModel = CharactersDataModel(
        info: PaginationInfo(count: 2, totalPages: 5, previousPage: nil, nextPage: "page=2"),
        data: []
    )

    static let charactersEmpty = Characters(from: charactersEmptyDataModel, currentPage: 1)

    static let singleCharacterDataModel = CharactersDataModel(
        info: PaginationInfo(count: 1, totalPages: 1, previousPage: nil, nextPage: nil),
        data: [
            CharacterDataModel(id: 1, name: "Mickey Mouse", imageUrl: "https://example.com/mickey.jpg", films: [])
        ]
    )

    static let singleCharacter = Characters(from: singleCharacterDataModel, currentPage: 1)
}
