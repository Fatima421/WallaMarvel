import Foundation

final class CharacterListViewModel: BaseViewModel {
    
    // MARK: - Properties
    
    @Published var characters: [Character] = []
    @Published var isLoadingMore = false
    @Published var searchText: String = ""

    private let getCharactersUseCase: GetCharactersUseCaseProtocol
    private let searchCharactersUseCase: SearchCharactersUseCaseProtocol
    private let debouncer = Debouncer(delay: 0.3)
    private var currentPage = 1
    private var canLoadMore = false
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
        
        super.init()
        
        Task {
            await loadCharacters()
        }
    }
    
    // MARK: - User actions
    
    func onSearchTextChanged() {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            state = .success
            return
        }
        
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
        guard state != .loading else { return }
        
        await MainActor.run {
            if state == .none || state == .success {
                state = .loading
            }
        }

        await fetchCharacters()
    }
    
    func loadMoreCharacters() async {
        guard !isLoadingMore, state != .loading, canLoadMore else { return }
        
        await MainActor.run { isLoadingMore = true }
        
        await fetchCharacters()
        
        await MainActor.run { isLoadingMore = false }
    }
    
    private func fetchCharacters() async {
        do {
            let nextPage = canLoadMore ? currentPage + 1 : currentPage
            let result: Characters
            
            if !searchText.isEmpty {
                result = try await searchCharactersUseCase.execute(name: searchText, page: nextPage)
            } else {
                result = try await getCharactersUseCase.execute(page: nextPage)
            }
            
            await MainActor.run {
                currentPage = nextPage
                state = result.data.isEmpty ? .empty : .success
                characters.append(contentsOf: result.data)
                canLoadMore = result.hasNextPage
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                state = .failure
            }
        }
    }
    
    func refresh() async {
        await MainActor.run {
            currentPage = 1
            characters = []
            canLoadMore = false
            state = .none
        }
        await loadCharacters()
    }
}
