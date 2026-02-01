import SwiftUI

struct SearchCharacterView: View {
    @StateObject var viewModel = SearchCharacterViewModel()
    @Binding var searchText: String
    
    var body: some View {
        Section {
            if searchText.isEmpty {
                suggestionsSection
            } else {
                searchResultView
            }
        }
        .onChange(of: searchText) { _, newValue in
            viewModel.onSearchTextChanged(newValue)
        }
    }
    
    private var suggestionsSection: some View {
        ForEach(viewModel.suggestionsList, id: \.self) { suggestion in
            Text(suggestion)
                .searchCompletion(suggestion)
        }
    }
    
    private var searchResultView: some View {
        ForEach(viewModel.characters, id: \.self) { character in
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
    
    private func row(_ character: Character) -> some View {
        HStack(spacing: 12) {
            ImageView(imageUrl: character.imageUrl, size: 80)
            
            Text(character.name)
                .font(.headline)
        }
    }
}

#Preview {
    SearchCharacterView(searchText: .constant("Mickey Mouse"))
}
