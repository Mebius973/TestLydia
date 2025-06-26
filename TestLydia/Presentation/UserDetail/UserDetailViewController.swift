//
//  UserDetailViewController.swift
//  TestLydia
//
//  Created by Mebius on 25/06/2025.
//
import UIKit

class UserDetailViewController: UIViewController {
    struct K {
        static let defaultImageName = "defaultProfilePicture"
    }
    
    private let viewModel: UserDetailViewModel

    init(viewModel: UserDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground

        if let data = viewModel.user.rawProfilePicture, let image = UIImage(data: data) {
            imageView.image = image
        } else {
            imageView.image = UIImage(named: K.defaultImageName)
            
        }

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading

        // Helper to add a label pair
        func addField(_ title: String, _ value: String?) {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
            let valueLabel = UILabel()
            valueLabel.text = value ?? "-"
            valueLabel.font = .systemFont(ofSize: 16)
            valueLabel.textColor = .secondaryLabel
            valueLabel.numberOfLines = 0
            let pairStack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
            pairStack.axis = .vertical
            pairStack.spacing = 2
            stackView.addArrangedSubview(pairStack)
        }

        // Add all fields
        addField("Gender", viewModel.user.gender)
        addField("Email", viewModel.user.email)
        addField("Phone", viewModel.user.phone)
        addField("Cell", viewModel.user.cell)
        addField("Nationality", viewModel.user.nat)
        addField("Title", viewModel.user.title)
        addField("First Name", viewModel.user.firstName)
        addField("Last Name", viewModel.user.lastName)
        addField("Street Number", "\(viewModel.user.streetNumber)")
        addField("Street Name", viewModel.user.streetName)
        addField("City", viewModel.user.city)
        addField("State", viewModel.user.state)
        addField("Country", viewModel.user.country)
        addField("Postcode", viewModel.user.postcode)
        addField("Coordinates Latitude", viewModel.user.coordinatesLatitude)
        addField("Coordinates Longitude", viewModel.user.coordinatesLongitude)
        addField("Timezone Offset", viewModel.user.timezoneOffset)
        addField("Timezone Description", viewModel.user.timezoneDescription)
        addField("Login UUID", viewModel.user.loginUUID)
        addField("Login Username", viewModel.user.loginUsername)
        addField("Login Password", viewModel.user.loginPassword)
        addField("Login Salt", viewModel.user.loginSalt)
        addField("Login MD5", viewModel.user.loginMD5)
        addField("Login SHA1", viewModel.user.loginSHA1)
        addField("Login SHA256", viewModel.user.loginSHA256)
        addField("Date of Birth", viewModel.user.dobDate)
        addField("Age", "\(viewModel.user.dobAge)")
        addField("Registered Date", viewModel.user.registeredDate)
        addField("Registered Age", "\(viewModel.user.registeredAge)")
        addField("ID Name", viewModel.user.idName)
        addField("ID Value", viewModel.user.idValue)
        addField("Picture Large", viewModel.user.pictureLarge)
        addField("Picture Medium", viewModel.user.pictureMedium)
        addField("Picture Thumbnail", viewModel.user.pictureThumbnail)

        contentView.addSubview(imageView)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),

            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -32)
        ])
    }
}
