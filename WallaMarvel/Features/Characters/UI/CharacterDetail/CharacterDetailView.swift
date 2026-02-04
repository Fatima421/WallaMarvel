import SwiftUI

struct CharacterDetailView: View {
    let character: Character

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.large) {
                ImageView(
                    imageUrl: character.imageUrl,
                    height: ImageSize.large,
                    maxWidth: UIScreen.main.bounds.width,
                    cornerRadius: CornerRadius.none
                )
                .accessibilityElement()
                .accessibilityLabel("Large photo of \(character.name)")

                informationSection
                    .offset(y: ImageSize.offsetValue)
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
                    .accessibilityAddTraits(.isHeader)

                ForEach(character.films, id: \.self) { film in
                    Text(film)
                        .font(.headline)
                        .accessibilityLabel("Film: \(film)")
                }
            } else {
                Text("No films available")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .accessibilityLabel("This character has no films listed")
            }
        }
        .padding(Spacing.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.neutral))
        .clipShape(RoundedCorner(radius: CornerRadius.medium, corners: [.topLeft, .topRight]))
    }
}

#Preview {
    CharacterDetailView(character: MockData.character)
}
