import Foundation

struct Character: Decodable, Hashable {
    let id: Int
    let name: String
    let imageUrl: String?
    let films: [String]

    init(from response: CharacterDataModel) {
        id = response.id
        name = response.name
        imageUrl = response.imageUrl
        films = response.films
    }
}
