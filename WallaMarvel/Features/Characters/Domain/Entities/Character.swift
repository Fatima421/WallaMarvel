import Foundation

struct Character: Decodable, Hashable {
    let id: Int
    let name: String
    let imageUrl: String?
    let films: [String]

    init(from response: CharacterDataModel) {
        self.id = response.id
        self.name = response.name
        self.imageUrl = response.imageUrl
        self.films = response.films
    }
}
