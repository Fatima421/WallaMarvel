import Foundation

struct CharacterDataContainer: Decodable {
    let count: Int
    let limit: Int
    let offset: Int
    let characters: [CharacterDataModel]
    
    enum CodingKeys: String, CodingKey {
        case info, data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let info = try container.decode(PaginationInfo.self, forKey: .info)
        
        self.count = info.count
        self.limit = 0
        self.offset = 0
        
        self.characters = try container.decode([CharacterDataModel].self, forKey: .data)
    }
}

struct PaginationInfo: Decodable {
    let count: Int
    let totalPages: Int
    let previousPage: String?
    let nextPage: String?
}
