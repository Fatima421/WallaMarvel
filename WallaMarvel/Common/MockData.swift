import Foundation

enum MockData {
    static let charactersDataModel = CharactersDataModel(
        info: PaginationInfo(count: 2, totalPages: 5, previousPage: nil, nextPage: "page=2"),
        data: [
            CharacterDataModel(id: 1, name: "Mickey Mouse", imageUrl: "https://example.com/mickey.jpg", films: []),
            CharacterDataModel(id: 2, name: "Elsa", imageUrl: "https://example.com/elsa.jpg", films: []),
            CharacterDataModel(id: 3, name: "Barbie", imageUrl: "https://example.com/barbie.jpg", films: []),
            CharacterDataModel(id: 4, name: "Simba", imageUrl: "https://example.com/simba.jpg", films: []),
            CharacterDataModel(id: 5, name: "Ariel", imageUrl: "https://example.com/ariel.jpg", films: []),
            CharacterDataModel(id: 6, name: "Woody", imageUrl: "https://example.com/woody.jpg", films: [])
        ]
    )

    static let characters = Characters(from: charactersDataModel, currentPage: 1)
}
