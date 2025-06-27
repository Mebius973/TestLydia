//
//  UserListViewController.swift
//  TestLydia
//
//  Created by David Geoffroy on 25/06/2025.
//
import UIKit
import Combine

class UserListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let viewModel: UserListViewModel
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: UserListViewModel) {
          self.viewModel = viewModel
          super.init(nibName: nil, bundle: nil)
      }

      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserListViewCell.self, forCellReuseIdentifier: "UserCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        viewModel.dataNeedsReload
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
               self?.tableView.reloadData()
                if self?.refreshControl.isRefreshing == true {
                    self?.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
        
        Task {
            await viewModel.initialLoad()
        }
    }
    
    @objc private func handleRefresh() {
        Task {
            await viewModel.initialLoad()
        }
    }

    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.usersCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserListViewCell else {
                return UITableViewCell()
            }
        
        let cellModel = viewModel.getCellModel(for: indexPath.row)
        cell.configure(with: cellModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Perform your action here, e.g., show user details
        viewModel.showUserDetail(for: indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height * 2, !viewModel.isLoading {
            Task {
                await viewModel.loadMore()
            }
        }
    }
}
