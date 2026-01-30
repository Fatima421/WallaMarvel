//
//  RestManager.swift
//  WallaMarvel
//
//  Created by Fatima Syed on 30/1/26.
//

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
            throw NetworkError.invalidURL
        }
        
        let request = buildRequest(url: url, method: endpoint.method)
        let (data, response) = try await session.data(for: request)
        try validateResponse(response)
        return try decode(data: data)
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
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }
    
    private func decode<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

extension RestManager {
    func requestWithLog<T: Decodable>(endpoint: Endpoint) async throws -> T {
        debugPrint("[REQUEST] \(endpoint.method) \(baseURL)\(endpoint.path)")
        if let params = endpoint.queryParams {
            debugPrint("[PARAMS] \(params)")
        }
        
        do {
            let result: T = try await request(endpoint: endpoint)
            debugPrint("[SUCCESS] Request completed")
            return result
        } catch {
            debugPrint("[ERROR] \(error.localizedDescription)")
            throw error
        }
    }
}
