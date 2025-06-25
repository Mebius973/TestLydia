//
//  UserListViewCell.swift
//  TestLydia
//
//  Created by David Geoffroy on 25/06/2025.
//


import UIKit

class UserListViewCell: UITableViewCell {
    struct K {
        static let defaultImageName = "defaultProfilePicture"
    }
    
    let cardView = UIView()
    let userImageView = UIImageView()
    let nameLabel = UILabel()
    let chevronImageView = UIImageView()
    
    private var isLoading = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4

        userImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false

        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 24

        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = .systemGray3
        chevronImageView.contentMode = .scaleAspectFit

        contentView.addSubview(cardView)
        cardView.addSubview(userImageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(chevronImageView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            userImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            userImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            userImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            userImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            userImageView.widthAnchor.constraint(equalToConstant: 96),
            userImageView.heightAnchor.constraint(equalToConstant: 96),

            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            
            chevronImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            chevronImageView.widthAnchor.constraint(equalToConstant: 16),
            chevronImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with cellModel: UserCellEntity) {
        nameLabel.text = cellModel.name
        
        guard let rawImage = cellModel.rawImage else {
            userImageView.image = UIImage(named: K.defaultImageName) ?? UIImage(systemName: "person.crop.circle")
            return
        }
        
        userImageView.image = UIImage(data: rawImage)
    }
}
