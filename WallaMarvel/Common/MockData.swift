import Foundation

enum MockData {
    static let charactersDataModel = CharactersDataModel(
        info: PaginationInfo(count: 2, totalPages: 5, previousPage: nil, nextPage: "page=2"),
        data: [
            CharacterDataModel(id: 1, name: "Mickey Mouse", imageUrl: "url1", films: []),
            CharacterDataModel(id: 2, name: "Elsa", imageUrl: "url2", films: []),
            CharacterDataModel(id: 2, name: "Barbie", imageUrl: "url3", films: []),
            CharacterDataModel(id: 2, name: "Simba", imageUrl: "url3", films: []),
            CharacterDataModel(id: 2, name: "Ariel", imageUrl: "url3", films: []),
            CharacterDataModel(id: 2, name: "Woody", imageUrl: "url3", films: [])
        ]
    )
        
    static let characters = Characters(from: charactersDataModel, currentPage: 1)
}
