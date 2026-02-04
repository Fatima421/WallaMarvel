import Kingfisher
import SwiftUI

struct ImageView: View {
    let imageUrl: String?
    var width: CGFloat?
    var height: CGFloat?
    var maxWidth: CGFloat?
    var cornerRadius: CGFloat

    var body: some View {
        if let imageUrl, let url = URL(string: imageUrl) {
            KFImage(url)
                .placeholder {
                    placeholder
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height)
                .frame(maxWidth: maxWidth)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        Image(.placeholder)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: height)
            .frame(maxWidth: maxWidth)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .accessibilityLabel("Placeholder image")
    }
}

#Preview {
    ImageView(
        imageUrl: "https://picsum.photos/200/300",
        cornerRadius: CornerRadius.small
    )
}
