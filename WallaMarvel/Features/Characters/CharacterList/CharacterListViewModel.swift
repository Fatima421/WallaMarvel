import Foundation

final class CharacterListViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var characters: [Character] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
        
    private let getCharactersUseCase: GetCharactersUseCaseProtocol
    private var currentPage = 1
    private var canLoadMore = true
    
    // MARK: - Initializer
    
    init(getCharactersUseCase: GetCharactersUseCaseProtocol = AppContainer.shared.makeGetCharactersUseCase()) {
        self.getCharactersUseCase = getCharactersUseCase
        
        Task {
            await loadCharacters()
        }
    }
    
    // MARK: - Load data
    
    private func loadCharacters() async {
        guard !isLoading else { return }
        
        await MainActor.run { isLoading = true }

        await fetchCharacters()

        await MainActor.run { isLoading = false }
    }
    
    func loadMoreCharacters() async {
        guard !isLoadingMore, !isLoading, canLoadMore else { return }
        
        await MainActor.run { isLoadingMore = true }
        currentPage += 1
        
        await fetchCharacters()
        
        await MainActor.run { isLoadingMore = false }
    }
    
    private func fetchCharacters() async {
        do {
            let result = try await getCharactersUseCase.execute(page: currentPage)
            await MainActor.run {
                characters.append(contentsOf: result.data)
                canLoadMore = result.hasNextPage
            }
        } catch {
            if !characters.isEmpty {
                currentPage -= 1
            }
            errorMessage = error.localizedDescription
        }
    }
    
    func refresh() async {
        await loadCharacters()
    }
}
