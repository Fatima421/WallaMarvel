import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case decodingError
    case serverError
    case unknown

    // MARK: - Error Description

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "Invalid URL"
        case .decodingError:
            "Failed to decode response"
        case .serverError:
            "Server error"
        case .unknown:
            "Unknown error"
        }
    }
}
