import SwiftUI

struct CharacterListView: View {
    @StateObject var viewModel: CharacterListViewModel
        
    var body: some View {
        NavigationStack {
            List(viewModel.characters, id: \.id) { character in
                VStack(alignment: .leading) {
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
    }
    
    private func row(_ character: Character) -> some View {
        HStack(spacing: 12) {
            if let image = character.imageUrl, let url = URL(string: image) {
                ImageView(imageUrl: url)
            }
            
            Text(character.name)
                .font(.headline)
        }
    }
}

#Preview {
    CharacterListView(viewModel: CharacterListViewModel())
}
