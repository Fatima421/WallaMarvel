import Foundation

struct CharacterDataModel: Decodable {
    let id: Int
    let name: String
    let thumbnail: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case thumbnail = "imageUrl"
    }
}
