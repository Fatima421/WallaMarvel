import Foundation

struct CharactersDataModel: Decodable {
    let info: PaginationInfo
    let data: [CharacterDataModel]
}

struct PaginationInfo: Decodable {
    let count: Int
    let totalPages: Int
    let previousPage: String?
    let nextPage: String?
}
