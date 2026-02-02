import Foundation

enum Endpoint {
    case getCharacters(page: Int)
    case getCharacterBy(id: Int)
    case searchCharacters(name: String, page: Int)

    var path: String {
        switch self {
        case .getCharacters, .searchCharacters:
            "/character"
        case let .getCharacterBy(id):
            "/character/\(id)"
        }
    }

    var method: String {
        switch self {
        case .getCharacters, .getCharacterBy, .searchCharacters:
            "GET"
        }
    }

    var queryParams: [String: String]? {
        switch self {
        case let .getCharacters(page):
            [
                "page": "\(page)",
                "pageSize": "25"
            ]

        case let .searchCharacters(name, page):
            [
                "name": name,
                "page": "\(page)",
                "pageSize": "25"
            ]

        default:
            nil
        }
    }
}
