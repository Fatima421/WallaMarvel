import Foundation

enum MockData {
    static let charactersDataModel = CharactersDataModel(
        info: PaginationInfo(count: 2, totalPages: 5, previousPage: nil, nextPage: "page=2"),
        data: [
            CharacterDataModel(id: 1, name: "Mickey Mouse", imageUrl: "url1", films: []),
            CharacterDataModel(id: 2, name: "Elsa", imageUrl: "url2", films: []),
            CharacterDataModel(id: 3, name: "Barbie", imageUrl: "url3", films: []),
            CharacterDataModel(id: 4, name: "Simba", imageUrl: "url4", films: []),
            CharacterDataModel(id: 5, name: "Ariel", imageUrl: "url5", films: []),
            CharacterDataModel(id: 6, name: "Woody", imageUrl: "url6", films: [])
        ]
    )

    static let characters = Characters(from: charactersDataModel, currentPage: 1)
}
