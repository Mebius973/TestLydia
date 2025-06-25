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
    private let footerLabel: UILabel = UILabel()
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
        setupUI()
        setupCombine()
        
        Task {
            await viewModel.initialLoad()
        }
    }
    
    private func setupUI() {
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
        
        #if DEBUG
        if ProcessInfo.processInfo.environment["UI_TEST_MODE"] == "1" {
            let testRefreshButton = UIBarButtonItem(title: "🔄", style: .plain, target: self, action: #selector(handleRefresh))
            let testScrollToBottomButton = UIBarButtonItem(title: "↓", style: .plain, target: self, action: #selector(scrollToBottom))
            navigationItem.leftBarButtonItem = testRefreshButton
            navigationItem.rightBarButtonItem = testScrollToBottomButton
        }
        #endif

        
        setupFooterMessage()
    }
    
    #if DEBUG
    @objc private func scrollToBottom() {
        let lastSection = tableView.numberOfSections - 1
        guard lastSection >= 0 else { return }

        let lastRow = tableView.numberOfRows(inSection: lastSection) - 1
        guard lastRow >= 0 else { return }

        let indexPath = IndexPath(row: lastRow, section: lastSection)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    #endif
    
    private func setupFooterMessage() {
        footerLabel.text = "To see more, please reconnect to the internet."
        footerLabel.textAlignment = .center
        footerLabel.textColor = .secondaryLabel
        footerLabel.font = UIFont.systemFont(ofSize: 15)
        footerLabel.numberOfLines = 0
        footerLabel.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60)
        tableView.tableFooterView = footerLabel
        
        footerLabel.isHidden = true
    }
    
    private func setupCombine() {
        viewModel.dataNeedsReload
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
               self?.tableView.reloadData()
                if self?.refreshControl.isRefreshing == true {
                    self?.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
        
        viewModel.initErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                if self?.refreshControl.isRefreshing == true {
                    self?.refreshControl.endRefreshing()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }
            .store(in: &cancellables)
        
        viewModel.loadMoreErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.footerLabel.isHidden = false
            }
            .store(in: &cancellables)
    }
    
    @objc private func handleRefresh() {
        Task {
            await viewModel.refresh()
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
