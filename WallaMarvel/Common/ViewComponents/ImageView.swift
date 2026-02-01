import SwiftUI
import SDWebImageSwiftUI

struct ImageView: View {
    let imageUrl: String?
    let size: CGFloat
    
    var body: some View {
        if let imageUrl, let url = URL(string: imageUrl) {
            WebImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } placeholder: {
                placeholder
            }
        } else {
            placeholder
        }
    }
    
    private var placeholder: some View {
        Image(.placeholder)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    ImageView(imageUrl: "https://picsum.photos/200/300", size: 80)
}
