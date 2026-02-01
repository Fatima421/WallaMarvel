import SwiftUI

struct CharacterListView: View {
    @StateObject var viewModel: CharacterListViewModel
    @State private var isSearching = false

    var body: some View {
        NavigationStack {
            if isSearching, viewModel.searchText.isEmpty {
                suggestionsSection
            } else {
                characterList
            }
        }
        .searchable(
            text: $viewModel.searchText,
            isPresented: $isSearching,
            prompt: "Search characters..."
        )
        .onChange(of: viewModel.searchText) {
            viewModel.onSearchTextChanged()
        }
    }
    
    private var characterList: some View {
        List(viewModel.characters, id: \.self) { character in
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
        }
        .navigationTitle("Disney Characters")
        .navigationDestination(for: Character.self) { character in
            CharacterDetailView(character: character)
        }
        .refreshable {
            await viewModel.refresh()
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
    }
    
    private var suggestionsSection: some View {
        List(viewModel.suggestionsList, id: \.self) { suggestion in
            Text(suggestion)
                .searchCompletion(suggestion)
        }
    }
    
    private func row(_ character: Character) -> some View {
        HStack(spacing: 12) {
            ImageView(imageUrl: character.imageUrl, size: 80)
            
            Text(character.name)
                .font(.headline)
        }
    }
}

#Preview {
    CharacterListView(viewModel: CharacterListViewModel())
}
