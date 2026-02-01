import Foundation

enum Endpoint {
    case getCharacters(page: Int)
    case getCharacterBy(id: Int)
    
    var path: String {
        switch self {
        case .getCharacters:
            return "/character"
        case .getCharacterBy(let id):
            return "/character/\(id)"
        }
    }
    
    var method: String {
        switch self {
        case .getCharacters, .getCharacterBy:
            return "GET"
        }
    }
    
    var queryParams: [String: String]? {
        switch self {
        case let .getCharacters(page):
            let dict: [String: String] = [
                "page": "\(page)",
                "pageSize": "25",
            ]
            return dict
        default:
            return nil
        }
    }
}
