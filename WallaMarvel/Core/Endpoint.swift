import Foundation

enum Endpoint {
    case getCharacters(page: Int)
    case getCharacterBy(id: Int)
    case searchCharacters(name: String, page: Int)

    var path: String {
        switch self {
        case .getCharacters, .searchCharacters:
            return "/character"
        case .getCharacterBy(let id):
            return "/character/\(id)"
        }
    }
    
    var method: String {
        switch self {
        case .getCharacters, .getCharacterBy, .searchCharacters:
            return "GET"
        }
    }
    
    var queryParams: [String: String]? {
        switch self {
        case let .getCharacters(page):
            return [
                "page": "\(page)",
                "pageSize": "25"
            ]

        case let .searchCharacters(name, page):
            return [
                "name": name,
                "page": "\(page)",
                "pageSize": "25"
            ]

        default:
            return nil
        }
    }
}
