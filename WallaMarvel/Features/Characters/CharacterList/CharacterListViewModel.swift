import Foundation

final class CharacterListViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var characters: [Character] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""

    private let getCharactersUseCase: GetCharactersUseCaseProtocol
    private let searchCharactersUseCase: SearchCharactersUseCaseProtocol
    private let debouncer = Debouncer(delay: 0.3)
    private var currentPage = 1
    private var canLoadMore = true
    let suggestionsList: [String]
    
    // MARK: - Initializer
    
    init(
        getCharactersUseCase: GetCharactersUseCaseProtocol = AppContainer.shared.makeGetCharactersUseCase(),
        searchCharactersUseCase: SearchCharactersUseCaseProtocol = AppContainer.shared.makeSearchCharactersUseCase()
    ) {
        self.getCharactersUseCase = getCharactersUseCase
        self.searchCharactersUseCase = searchCharactersUseCase

        self.suggestionsList = [
            "Mickey Mouse",
            "Barbie",
            "Elsa",
            "Simba",
            "Ariel",
            "Woody"
        ]
        
        Task {
            await loadCharacters()
        }
    }
    
    // MARK: - User actions
    
    func onSearchTextChanged() {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        debouncer.debounce { [weak self] in
            self?.currentPage = 1
            self?.characters = []
            
            Task {
                await self?.loadCharacters()
            }
        }
    }
    
    // MARK: - Load data
    
    func loadCharacters() async {
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
            let result: Characters
            
            if !searchText.isEmpty {
                result = try await searchCharactersUseCase.execute(name: searchText, page: currentPage)
            } else {
                result = try await getCharactersUseCase.execute(page: currentPage)
            }
            
            await MainActor.run {
                characters.append(contentsOf: result.data)
                canLoadMore = result.hasNextPage
            }
        } catch {
            if !characters.isEmpty {
                currentPage -= 1
            }
            await MainActor.run {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func refresh() async {
        await loadCharacters()
    }
}
