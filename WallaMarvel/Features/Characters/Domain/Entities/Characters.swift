import Foundation

struct Characters: Decodable {
    let data: [Character]
    let currentPage: Int
    let totalPages: Int
    let hasNextPage: Bool
    let hasPreviousPage: Bool
    
    init(from response: CharactersDataModel, currentPage: Int) {
        self.data = response.data.map { Character(from: $0) }
        self.currentPage = currentPage
        self.totalPages = response.info.totalPages
        self.hasNextPage = response.info.nextPage != nil
        self.hasPreviousPage = response.info.previousPage != nil
    }
}
