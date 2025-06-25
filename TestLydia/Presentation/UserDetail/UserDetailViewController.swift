//
//  UserDetailViewController.swift
//  TestLydia
//
//  Created by David Geoffroy on 25/06/2025.
//
import UIKit

class UserDetailViewController: UIViewController {
    struct K {
        static let defaultImageName = "defaultProfilePicture"
    }
    
    private let viewModel: UserDetailViewModel
    private let stackView = UIStackView()

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
        
        title = "User Detail"

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

        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading

        addAllFieldsToStackView()

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
    
    private func addAllFieldsToStackView() {
        addFieldToStackView("Gender", viewModel.user.gender)
        addFieldToStackView("Email", viewModel.user.email)
        addFieldToStackView("Phone", viewModel.user.phone)
        addFieldToStackView("Cell", viewModel.user.cell)
        addFieldToStackView("Nationality", viewModel.user.nat)
        addFieldToStackView("Title", viewModel.user.title)
        addFieldToStackView("First Name", viewModel.user.firstName)
        addFieldToStackView("Last Name", viewModel.user.lastName)
        addFieldToStackView("Street Number", "\(viewModel.user.streetNumber)")
        addFieldToStackView("Street Name", viewModel.user.streetName)
        addFieldToStackView("City", viewModel.user.city)
        addFieldToStackView("State", viewModel.user.state)
        addFieldToStackView("Country", viewModel.user.country)
        addFieldToStackView("Postcode", viewModel.user.postcode)
        addFieldToStackView("Coordinates Latitude", viewModel.user.coordinatesLatitude)
        addFieldToStackView("Coordinates Longitude", viewModel.user.coordinatesLongitude)
        addFieldToStackView("Timezone Offset", viewModel.user.timezoneOffset)
        addFieldToStackView("Timezone Description", viewModel.user.timezoneDescription)
        addFieldToStackView("Login UUID", viewModel.user.loginUUID)
        addFieldToStackView("Login Username", viewModel.user.loginUsername)
        addFieldToStackView("Login Password", viewModel.user.loginPassword)
        addFieldToStackView("Login Salt", viewModel.user.loginSalt)
        addFieldToStackView("Login MD5", viewModel.user.loginMD5)
        addFieldToStackView("Login SHA1", viewModel.user.loginSHA1)
        addFieldToStackView("Login SHA256", viewModel.user.loginSHA256)
        addFieldToStackView("Date of Birth", viewModel.user.dobDate)
        addFieldToStackView("Age", "\(viewModel.user.dobAge)")
        addFieldToStackView("Registered Date", viewModel.user.registeredDate)
        addFieldToStackView("Registered Age", "\(viewModel.user.registeredAge)")
        addFieldToStackView("ID Name", viewModel.user.idName)
        addFieldToStackView("ID Value", viewModel.user.idValue)
        addFieldToStackView("Picture Large", viewModel.user.pictureLarge)
        addFieldToStackView("Picture Medium", viewModel.user.pictureMedium)
        addFieldToStackView("Picture Thumbnail", viewModel.user.pictureThumbnail)
    }
    
    private func addFieldToStackView(_ title: String, _ value: String?) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 13, weight: .semibold)

        let valueStack: UIView

        if let string = value, !string.isEmpty {
            if title == "Phone" || title == "Cell" {
                let textView = makeTextView(text: string, detector: .phoneNumber)
                textView.accessibilityIdentifier = title == "Phone" ? "PhoneTextView" : "CellTextView"
                valueStack = textView
            } else if title == "Email" {
                let textView = makeTextView(text: string, detector: .link)
                textView.accessibilityIdentifier = "EmailTextView"
                valueStack = textView
            } else if string.hasPrefix("http") {
                let textView = makeTextView(text: string, detector: .link)
                textView.accessibilityIdentifier = "LinkTextView"
                valueStack = textView
            } else {
                valueStack = makeLabel(text: string)
            }
        } else {
            valueStack = makeLabel(text: "-")
        }

        let pairStack = UIStackView(arrangedSubviews: [titleLabel, valueStack])
        pairStack.axis = .vertical
        pairStack.spacing = 2
        stackView.addArrangedSubview(pairStack)
    }
    
    private func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }

    private func makeTextView(text: String, detector: UIDataDetectorTypes, prefix: String? = nil) -> UITextView {
        let textView = UITextView()
        textView.dataDetectorTypes = detector
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = true
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .link
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.text = prefix != nil ? "\(prefix!)\(text)" : text

        return textView
    }


}
