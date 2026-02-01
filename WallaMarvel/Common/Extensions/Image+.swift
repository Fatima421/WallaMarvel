import SwiftUI

extension Image {
    /// Return Image as template with options
    func style(size: CGFloat) -> some View {
        renderingMode(.original)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
    }
}
