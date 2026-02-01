import SwiftUI
import SDWebImageSwiftUI

struct ImageView: View {
    let imageUrl: URL
    
    var body: some View {
        Group {
            WebImage(url: imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(.imagePlaceholder)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .frame(width: 80, height: 80)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    ImageView(imageUrl: URL(string: "https://picsum.photos/200/300")!)
}
