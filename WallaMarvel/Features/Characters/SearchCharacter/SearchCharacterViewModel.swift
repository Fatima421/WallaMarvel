import Foundation
import Combine

final class SearchCharacterViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var searchQuery: String = ""
    @Published var characters: [Character] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    
    // MARK: - Properties
    
    let suggestionsList: [String]
    private let searchCharactersUseCase: SearchCharactersUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    private var canLoadMore = true
    private var currentSearchQuery: String = ""

    // MARK: - Initializer
    
    init(searchCharactersUseCase: SearchCharactersUseCaseProtocol = AppContainer.shared.makeSearchCharactersUseCase()) {
        self.searchCharactersUseCase = searchCharactersUseCase
        self.suggestionsList = [
            "Mickey Mouse",
            "Barbie",
            "Elsa",
            "Simba",
            "Ariel",
            "Woody"
        ]
        
        setupSearchDebouncer()
    }
        
    private func setupSearchDebouncer() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - User actions
    
    func onSearchTextChanged(_ text: String) {
        searchQuery = text
    }
    
    // MARK: - Load data
    
    func loadMoreCharacters() async {
        guard !isLoadingMore, !isLoading, canLoadMore, !currentSearchQuery.isEmpty else { return }
        
        await MainActor.run { isLoadingMore = true }
        currentPage += 1
        
        await fetchCharacters(name: currentSearchQuery, isLoadMore: true)
        
        await MainActor.run { isLoadingMore = false }
    }
    
    private func performSearch(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else {
            characters = []
            errorMessage = nil
            currentSearchQuery = ""
            currentPage = 1
            canLoadMore = true
            return
        }
        
        currentSearchQuery = trimmed
        currentPage = 1
        canLoadMore = true
        characters = []
        
        Task {
            await searchCharacters(name: trimmed)
        }
    }
    
    @MainActor
    private func searchCharacters(name: String) async {
        isLoading = true
        errorMessage = nil
        
        await fetchCharacters(name: name, isLoadMore: false)
        
        isLoading = false
    }
    
    private func fetchCharacters(name: String, isLoadMore: Bool) async {
        do {
            let result = try await searchCharactersUseCase.execute(name: name, page: currentPage)
            await MainActor.run {
                if isLoadMore {
                    characters.append(contentsOf: result.data)
                } else {
                    characters = result.data
                }
                canLoadMore = result.hasNextPage
            }
        } catch {
            if isLoadMore && !characters.isEmpty {
                currentPage -= 1
            }
            await MainActor.run {
                errorMessage = error.localizedDescription
                if !isLoadMore {
                    characters = []
                }
            }
        }
    }
}
