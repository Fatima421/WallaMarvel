import Foundation
import UIKit
import Kingfisher

final class ListHeroesTableViewCell: UITableViewCell {
    private enum Constants {
        static let cornerRadius: CGFloat = 8
        static let imageSize: CGFloat = 80
        static let horizontalPadding: CGFloat = 12
        static let verticalPadding: CGFloat = 12
    }
    
    private let heroeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let heroeName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        addSubview(heroeImageView)
        addSubview(heroeName)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            heroeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            heroeImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            heroeImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            heroeImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            
            heroeName.leadingAnchor.constraint(equalTo: heroeImageView.trailingAnchor, constant: Constants.horizontalPadding),
            heroeName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
            heroeName.topAnchor.constraint(equalTo: heroeImageView.topAnchor),
            heroeName.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -Constants.verticalPadding)
        ])
    }
    
    func configure(model: CharacterDataModel) {
        heroeName.text = model.name
        
        let placeholder = UIImage(named: "placeholder")
        
        if let imageUrl = model.thumbnail, let url = URL(string: imageUrl) {
            heroeImageView.kf.setImage(
                with: url,
                placeholder: placeholder,
                options: nil,
                completionHandler: nil
            )
        } else {
            heroeImageView.image = placeholder
        }
    }
}
