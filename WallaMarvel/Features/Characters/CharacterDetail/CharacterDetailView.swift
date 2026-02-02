import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.large) {
                ImageView(
                    imageUrl: character.imageUrl,
                    height: 350,
                    maxWidth: UIScreen.main.bounds.width,
                    cornerRadius: 0)
                informationSection
                    .offset(y: -30)
            }
        }
        .scrollIndicators(.hidden)
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var informationSection: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            if !character.films.isEmpty {
                Text("Films")
                    .font(.title2)
                    .fontWeight(.bold)
                
                ForEach(character.films, id: \.self) { film in
                    Text(film)
                        .font(.headline)
                }
            }
        }
        .padding(Spacing.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .topRight]))
    }
}

#Preview {
    CharacterDetailView(
        character: Character(
            from: CharacterDataModel(
                id: 1,
                name: "Mickey Mouse",
                imageUrl: "https://picsum.photos/200/300",
                films: []
            )
        )
    )
}
