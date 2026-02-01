import Foundation

struct CharacterDataModel: Decodable {
    let id: Int
    let name: String
    let imageUrl: String?
    let films: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case imageUrl
        case films
    }
}
