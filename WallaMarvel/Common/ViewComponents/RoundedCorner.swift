import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct DiagonalCutShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        /// Top left
        path.move(to: CGPoint(x: 0, y: 0))
        /// Top right
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        /// Bottom right
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        /// Bottom left
        path.addLine(to: CGPoint(x: 0, y: rect.height - 20))
        path.closeSubpath()

        return path
    }
}
