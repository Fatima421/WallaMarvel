import SwiftUI
import Kingfisher

struct CharacterDetailView: View {
    let character: CharacterDataModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                heroImageView
                informationSection
                    .offset(y: -30)
            }
        }
    }
        
    private var heroImageView: some View {
        Group {
            if let imageUrl = character.thumbnail,
               let url = URL(string: imageUrl),
               #available(iOS 14.0, *) {
                KFImage(url)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 350)
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    .clipped()
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 350)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.gray.opacity(0.3))
            }
        }
    }
    
    private var informationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !character.films.isEmpty {
                Text("Films")
                    .font(.headline)
                    .fontWeight(.bold)
                
                ForEach(character.films, id: \.self) { film in
                    Text(film)
                        .font(.headline)
                }
            } else {
                Text("No films available")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .topRight]))
    }
}
