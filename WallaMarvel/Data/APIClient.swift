import Foundation

protocol APIClientProtocol {
    func getMarvelHeroes(completionBlock: @escaping (CharacterDataContainer) -> Void)
    func getHeroes(completionBlock: @escaping (CharacterDataContainer) -> Void)
}

final class APIClient: APIClientProtocol {
    init() { }
    
    private func performRequest<T: Decodable>(
        endpoint: String,
        parameters: [String: String]? = nil,
        completion: @escaping (T) -> Void
    ) {
        
        guard var components = URLComponents(string: endpoint) else { return }
        
        if let parameters {
            components.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        
        guard let url = components.url else { return }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data, error == nil else { return }
            
            do {
                let model = try JSONDecoder().decode(T.self, from: data)
                completion(model)
                debugPrint(model)
            } catch {
                debugPrint(error)
            }
            
        }.resume()
    }
    
    func getMarvelHeroes(completionBlock: @escaping (CharacterDataContainer) -> Void) {
        let ts = String(Int(Date().timeIntervalSince1970))
        let privateKey = Config.privateKey
        let publicKey = Config.publicKey
        let hash = "\(ts)\(privateKey)\(publicKey)".md5

        let parameters = [
            "apikey": Config.publicKey,
            "ts": ts,
            "hash": hash
        ]

        performRequest(
            endpoint: "https://gateway.marvel.com/v1/public/characters",
            parameters: parameters,
            completion: completionBlock
        )
    }
    
    func getHeroes(completionBlock: @escaping (CharacterDataContainer) -> Void) {
        performRequest(
            endpoint: "https://api.disneyapi.dev/character",
            completion: completionBlock
        )
    }
}
