import SwiftUI
import Kingfisher

struct CharacterDetailView: View {
    private enum Constants {
        static let imageHeight: CGFloat = 350
        static let verticalSpacing: CGFloat = 16
        static let contentPadding: CGFloat = 16
        static let imageOffset: CGFloat = -30
        static let cornerRadius: CGFloat = 16
    }
    
    let character: CharacterDataModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: Constants.verticalSpacing) {
                heroImageView
                informationSection
                    .offset(y: Constants.imageOffset)
            }
        }
    }
        
    private var heroImageView: some View {
        Group {
            if let imageUrl = character.thumbnail,
               let url = URL(string: imageUrl),
               #available(iOS 14.0, *) {
                KFImage(url)
                    .placeholder {
                        placeholder
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: Constants.imageHeight)
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    .clipped()
            } else {
                placeholder
            }
        }
    }
    
    private var placeholder: some View {
        Image(.placeholder)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: Constants.imageHeight)
            .frame(maxWidth: .infinity)
    }
    
    private var informationSection: some View {
        VStack(alignment: .leading, spacing: Constants.verticalSpacing) {
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
        .padding(Constants.contentPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.neutral))
        .clipShape(RoundedCorner(radius: Constants.cornerRadius, corners: [.topLeft, .topRight]))
    }
}
