import Foundation

protocol RestManagerProtocol {
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T
}

final class RestManager: RestManagerProtocol {
    
    // MARK: - Properties
    
    private let baseURL: String
    private let session: URLSession
        
    // MARK: - Initializer
    
    init(baseURL: String = "https://api.disneyapi.dev",
         session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        guard let url = buildURL(for: endpoint) else {
            debugPrint("[ERROR] Invalid URL")
            throw NetworkError.invalidURL
        }
        
        debugPrint("[REQUEST] \(endpoint.method) \(url.absoluteString)")
        
        let request = buildRequest(url: url, method: endpoint.method)
        
        do {
            let (data, response) = try await session.data(for: request)
            try validateResponse(response)
            
            if let json = String(data: data, encoding: .utf8) {
                debugPrint("[RESPONSE]")
                debugPrint(json)
            }
            
            return try decode(data: data)
        } catch {
            debugPrint("[ERROR] \(error.localizedDescription)")
            throw error
        }
    }

        
    private func buildURL(for endpoint: Endpoint) -> URL? {
        guard var components = URLComponents(string: baseURL + endpoint.path) else {
            return nil
        }
        
        if let params = endpoint.queryParams {
            components.queryItems = params.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }
        
        return components.url
    }
    
    private func buildRequest(url: URL, method: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            return
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError
        }
    }
    
    private func decode<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
