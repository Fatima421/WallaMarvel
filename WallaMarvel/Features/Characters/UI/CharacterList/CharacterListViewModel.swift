import Foundation

final class CharacterListViewModel: BaseViewModel {
    // MARK: - Properties

    @Published var characters: [Character] = []
    private var cachedCharacters: [Character] = []

    @Published var isLoadingMore = false
    @Published var searchText: String = ""

    private let getCharactersUseCase: GetCharactersUseCaseProtocol
    private let searchCharactersUseCase: SearchCharactersUseCaseProtocol
    private let debouncer = Debouncer(delay: 0.3)

    private var paginationState = PaginationState()
    private var cachedState = PaginationState()

    let suggestionsList = ["Mickey Mouse", "Barbie", "Elsa", "Simba", "Ariel", "Woody"]

    // MARK: - Initializer

    init(
        getCharactersUseCase: GetCharactersUseCaseProtocol = AppContainer.shared.makeGetCharactersUseCase(),
        searchCharactersUseCase: SearchCharactersUseCaseProtocol = AppContainer.shared.makeSearchCharactersUseCase()
    ) {
        self.getCharactersUseCase = getCharactersUseCase
        self.searchCharactersUseCase = searchCharactersUseCase

        super.init()

        Task {
            await loadCharacters()
        }
    }

    // MARK: - Search

    func handleSearchChange() {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        /// Restore previous results when clearing search
        guard !trimmed.isEmpty else {
            restoreCachedState()
            return
        }

        /// Show loading only in these cases because we don't want to in case of failure or empty
        if state == .none || state == .success {
            state = .loading
        }

        debouncer.debounce { [weak self] in
            self?.performSearch()
        }
    }

    private func performSearch() {
        /// Save current results before searching
        cacheCurrentState()
        /// Reset pagination for new search
        paginationState.reset()
        characters = []

        Task { await loadCharacters() }
    }

    private func cacheCurrentState() {
        cachedState = PaginationState(
            currentPage: paginationState.currentPage,
            canLoadMore: paginationState.canLoadMore
        )
        cachedCharacters = characters
    }

    private func restoreCachedState() {
        characters = cachedCharacters
        paginationState = cachedState
        state = .success
    }

    // MARK: - Load data

    func loadCharacters() async {
        guard state != .loading || !searchText.isEmpty else { return }

        await MainActor.run {
            if state == .none || state == .success {
                state = .loading
            }
        }

        await fetchCharacters()
    }

    func loadMoreCharacters() async {
        /// Prevent multiple simultaneous pagination requests
        guard !isLoadingMore, state != .loading, paginationState.canLoadMore else { return }

        await MainActor.run { isLoadingMore = true }

        await fetchCharacters()

        await MainActor.run { isLoadingMore = false }
    }

    func refresh() async {
        paginationState.reset()
        await MainActor.run {
            characters = []
            state = .none
        }

        await loadCharacters()
    }

    private func fetchCharacters() async {
        do {
            let nextPage = paginationState.nextPage
            let result: Characters = try await fetchResult(page: nextPage)

            await MainActor.run {
                paginationState.currentPage = nextPage
                paginationState.canLoadMore = result.hasNextPage
                state = result.data.isEmpty ? .empty : .success
                characters.append(contentsOf: result.data)
            }
        } catch {
            debugPrint("[ERROR] \(error.localizedDescription)")
            await MainActor.run {
                state = .failure
            }
        }
    }

    /// Use search or regular fetch based on search text presence
    private func fetchResult(page: Int) async throws -> Characters {
        if !searchText.isEmpty {
            try await searchCharactersUseCase.execute(name: searchText, page: page)
        } else {
            try await getCharactersUseCase.execute(page: page)
        }
    }
}
