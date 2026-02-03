import Foundation

struct CharacterDataModel: Decodable {
    let id: Int
    let name: String
    let thumbnail: String?
    let films: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case thumbnail = "imageUrl"
        case films
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        thumbnail = try? container.decode(String.self, forKey: .thumbnail)
        films = (try? container.decode([String].self, forKey: .films)) ?? []
    }
}
