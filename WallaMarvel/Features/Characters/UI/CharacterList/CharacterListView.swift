import SwiftUI

struct CharacterListView: View {
    @StateObject var viewModel: CharacterListViewModel
    @State private var isSearching = false

    var body: some View {
        NavigationStack {
            BaseView(
                viewModel: viewModel,
                content: { content },
                loadingView: AnyView(loadingView),
                emptyView: AnyView(emptyView),
                errorView: AnyView(errorView)
            )
            .navigationTitle("Disney Characters")
            .searchable(
                text: $viewModel.searchText,
                isPresented: $isSearching,
                prompt: "Search characters..."
            )
            .onChange(of: viewModel.searchText) {
                viewModel.onSearchTextChanged()
            }
        }
    }

    private var loadingView: some View {
        characterList(MockData.characters.data)
            .redacted(reason: .placeholder)
            .accessibilityElement()
            .accessibilityLabel("Loading characters")
    }

    private var emptyView: some View {
        EmptyPlaceholder(type: .empty)
    }

    private var errorView: some View {
        EmptyPlaceholder(type: .error {
            Task {
                await viewModel.refresh()
            }
        })
    }

    private var content: some View {
        Group {
            if isSearching, viewModel.searchText.isEmpty {
                suggestionsSection
            } else if isSearching, viewModel.state == .loading {
                loadingView
            } else {
                characterList(viewModel.characters)
            }
        }
    }

    private func characterList(_ characters: [Character]) -> some View {
        List(characters, id: \.self) { character in
            NavigationLink(value: character) {
                row(character)
                    .onAppear {
                        if character.id == viewModel.characters.last?.id {
                            Task {
                                await viewModel.loadMoreCharacters()
                            }
                        }
                    }
            }
            .accessibilityLabel("Character \(character.name)")
            .accessibilityHint("Double tap to view details")
        }
        .navigationDestination(for: Character.self) { character in
            CharacterDetailView(character: character)
        }
        .refreshable {
            if !isSearching {
                await Task {
                    await viewModel.refresh()
                }.value
            }
        }
    }

    private func row(_ character: Character) -> some View {
        HStack(spacing: Spacing.medium) {
            ImageView(
                imageUrl: character.imageUrl,
                width: 80,
                height: 80,
                cornerRadius: 8
            )

            Text(character.name)
                .font(.headline)
        }
    }

    private var suggestionsSection: some View {
        List(viewModel.suggestionsList, id: \.self) { suggestion in
            Text(suggestion)
                .searchCompletion(suggestion)
                .accessibilityLabel("Search for \(suggestion)")
        }
    }
}

#Preview {
    CharacterListView(viewModel: CharacterListViewModel())
}
