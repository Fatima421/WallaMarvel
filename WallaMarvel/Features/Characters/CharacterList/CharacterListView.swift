import SwiftUI

struct CharacterListView: View {
    @StateObject var viewModel: CharacterListViewModel
        
    var body: some View {
        NavigationStack {
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
