import Foundation

struct CharactersDataModel: Decodable {
    let info: PaginationInfo
    let data: [CharacterDataModel]
    
    enum CodingKeys: String, CodingKey {
        case info, data
    }
    
    init(info: PaginationInfo, data: [CharacterDataModel]) {
        self.info = info
        self.data = data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.info = try container.decode(PaginationInfo.self, forKey: .info)
        
        do {
            self.data = try container.decode([CharacterDataModel].self, forKey: .data)
        } catch {
            let single = try container.decode(CharacterDataModel.self, forKey: .data)
            self.data = [single]
        }
    }
}

struct PaginationInfo: Decodable {
    let count: Int
    let totalPages: Int
    let previousPage: String?
    let nextPage: String?
}
