import Foundation

enum Config {
    static let publicKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "MARVEL_PUBLIC_KEY") as? String else {
            fatalError("MARVEL_PUBLIC_KEY not found")
        }
        return key
    }()
    
    static let privateKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "MARVEL_PRIVATE_KEY") as? String else {
            fatalError("MARVEL_PRIVATE_KEY not found")
        }
        return key
    }()
}
