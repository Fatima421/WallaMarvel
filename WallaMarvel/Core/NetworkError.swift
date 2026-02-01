import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case serverError
    case unknown
    
    // MARK: - Error Description
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received from server"
        case .decodingError:
            return "Failed to decode response"
        case .serverError:
            return "Server error"
        case .unknown:
            return "Unknown error"
        }
    }
}
