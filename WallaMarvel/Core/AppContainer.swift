import Foundation

final class AppContainer {
    static let shared = AppContainer()
    
    private init() {}
    
    // MARK: - Network Layer
    
    private lazy var restManager: RestManagerProtocol = {
        RestManager()
    }()
    
    private lazy var apiClient: APIClientProtocol = {
        APIClient(restManager: restManager)
    }()
    
    // MARK: - Data Sources
    
    private lazy var characterDataSource: CharacterDataSourceProtocol = {
        CharacterDataSource(apiClient: apiClient)
    }()
    
    // MARK: - Repositories
    
    private lazy var characterRepository: CharacterRepositoryProtocol = {
        CharacterRepository(dataSource: characterDataSource)
    }()
    
    // MARK: - Use Cases
    
    func makeGetCharactersUseCase() -> GetCharactersUseCaseProtocol {
        GetCharactersUseCase(repository: characterRepository)
    }
    
    func makeGetCharacterUseCase() -> GetCharacterUseCaseProtocol {
        GetCharacterUseCase(repository: characterRepository)
    }
}
