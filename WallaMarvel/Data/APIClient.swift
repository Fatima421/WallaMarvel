import Foundation

protocol APIClientProtocol {
    func getHeroes(completionBlock: @escaping (CharacterDataContainer) -> Void)
}

final class APIClient: APIClientProtocol {
    init() { }
    
    func getHeroes(completionBlock: @escaping (CharacterDataContainer) -> Void) {
        let ts = String(Int(Date().timeIntervalSince1970))
        let privateKey = Config.privateKey
        let publicKey = Config.publicKey
        let hash = "\(ts)\(privateKey)\(publicKey)".md5
        let parameters: [String: String] = ["apikey": publicKey,
                                            "ts": ts,
                                            "hash": hash]
        
        let endpoint = "https://gateway.marvel.com:443/v1/public/characters"
        var urlComponent = URLComponents(string: endpoint)
        urlComponent?.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        let urlRequest = URLRequest(url: urlComponent!.url!)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            let dataModel = try! JSONDecoder().decode(CharacterDataContainer.self, from: data!)
            completionBlock(dataModel)
            print(dataModel)
        }.resume()
    }
}
