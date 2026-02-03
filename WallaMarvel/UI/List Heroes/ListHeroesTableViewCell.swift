import Foundation
import UIKit
import Kingfisher

final class ListHeroesTableViewCell: UITableViewCell {
    private let heroeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
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
            heroeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            heroeImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            heroeImageView.widthAnchor.constraint(equalToConstant: 80),
            heroeImageView.heightAnchor.constraint(equalToConstant: 80),
            
            heroeName.leadingAnchor.constraint(equalTo: heroeImageView.trailingAnchor, constant: 12),
            heroeName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            heroeName.topAnchor.constraint(equalTo: heroeImageView.topAnchor),
            heroeName.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12)
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
