//
//  UserDetailViewController.swift
//  TestLydia
//
//  Created by Mebius on 25/06/2025.
//
import UIKit

class UserDetailViewController: UIViewController {
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

       let label = UILabel()
       label.text = "Hello UIKit 👋"
       label.font = .systemFont(ofSize: 24)
       label.textColor = .label
       label.translatesAutoresizingMaskIntoConstraints = false

       view.addSubview(label)

       NSLayoutConstraint.activate([
           label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
       ])
    }
}
