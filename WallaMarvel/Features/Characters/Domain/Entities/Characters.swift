import Foundation

struct Characters: Decodable {
    let data: [Character]
    let currentPage: Int
    let totalPages: Int
    let hasNextPage: Bool
    let hasPreviousPage: Bool

    init(from response: CharactersDataModel, currentPage: Int) {
        data = response.data.map { Character(from: $0) }
        self.currentPage = currentPage
        totalPages = response.info.totalPages
        hasNextPage = response.info.nextPage != nil
        hasPreviousPage = response.info.previousPage != nil
    }
}
