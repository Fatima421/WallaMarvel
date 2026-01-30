import Foundation

struct Character: Decodable {
    let id: Int
    let name: String
    let imageUrl: String?
    
    init(from response: CharacterDataModel) {
        self.id = response.id
        self.name = response.name
        self.imageUrl = response.imageUrl
    }
}
