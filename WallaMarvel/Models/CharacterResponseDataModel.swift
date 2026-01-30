import Foundation

struct CharacterDataContainer: Decodable {
    let info: PaginationInfo
    let data: [CharacterDataModel]
}

struct PaginationInfo: Decodable {
    let count: Int
    let totalPages: Int
    let previousPage: String?
    let nextPage: String?
}
