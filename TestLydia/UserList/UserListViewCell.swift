//
//  UserListViewCell.swift
//  TestLydia
//
//  Created by Mebius on 25/06/2025.
//


import UIKit

class UserListViewCell: UITableViewCell {
    let userImageView = UIImageView()
    let titleLabel = UILabel()
    let firstNameLabel = UILabel()
    let lastNameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 24

        contentView.addSubview(userImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(firstNameLabel)
        contentView.addSubview(lastNameLabel)

        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            userImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 48),
            userImageView.heightAnchor.constraint(equalToConstant: 48),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            firstNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            firstNameLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            firstNameLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            firstNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            lastNameLabel.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 4),
            lastNameLabel.leadingAnchor.constraint(equalTo: firstNameLabel.leadingAnchor),
            lastNameLabel.trailingAnchor.constraint(equalTo: firstNameLabel.trailingAnchor),
            lastNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with user: User) {
        titleLabel.text = user.name.title
        firstNameLabel.text = user.name.first
        lastNameLabel.text = user.name.last
        if let url = URL(string: user.picture.medium) {
            // Simple async image loading (for demo only)
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.userImageView.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self.userImageView.image = nil
                    }
                }
            }
        } else {
            userImageView.image = nil
        }
    }
}
