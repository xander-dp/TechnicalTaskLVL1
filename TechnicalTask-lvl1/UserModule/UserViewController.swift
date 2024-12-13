//

import UIKit
import Combine
import CoreData

final class UserViewController: UITableViewController {
    var cancellables = Set<AnyCancellable>()
    
    private let usersViewModel: UsersViewModel
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(usersViewModel: UsersViewModel) {
        self.usersViewModel = usersViewModel
        super.init(style: .grouped)
    }
    
    override func viewDidLoad() {
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .white
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.allowsSelection = false
        self.tableView.register(UINib(nibName: UserCell.xibName, bundle: nil),
                                forCellReuseIdentifier: UserCell.reuseIdentifier)
        
        self.tableView.refreshControl = self.refreshCtrl
        self.view.addSubview(self.activityIndicator)
        self.view.addSubview(self.noConnectionView)

        self.bindViewModel()
    }
    
    private func bindViewModel() {
        self.usersViewModel.$usersList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        self.usersViewModel.$synchronizationInProgres
            .receive(on: DispatchQueue.main)
            .sink { [weak self] inProgress in
                self?.activityIndicator.isHidden = !inProgress
            }
            .store(in: &cancellables)
        
        self.usersViewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                if let message = message {
                    self?.showError(message)
                }
            }
            .store(in: &cancellables)
        
        self.usersViewModel.$connectionEstablished
            .receive(on: DispatchQueue.main)
            .sink { [weak self] connected in
                self?.noConnectionView.isHidden = connected
                
                if connected {
                    self?.usersViewModel.synchronizeRemoteData()
                }
            }
            .store(in: &cancellables)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    @objc private func refresh() {
        self.refreshCtrl.endRefreshing()
        self.activityIndicator.isHidden.toggle()
        self.usersViewModel.synchronizeRemoteData()
    }
    
    private lazy var refreshCtrl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var activityIndicator: ActivityIndicator = {
        ActivityIndicator()
    }()
    
    private lazy var noDataView: UIView = {
        NoDataView()
    }()
    
    private lazy var noConnectionView: NoConnectionView = {
        NoConnectionView()
    }()
}

//MARK: UITableViewDataSource
extension UserViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsCount = self.usersViewModel.usersList.count
        
        if rowsCount == 0 {
            let view = UIView()
            view.backgroundColor = .red
            self.tableView.backgroundView = self.noDataView
        } else {
            self.tableView.backgroundView = nil
        }
        
        return rowsCount
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        headerLabel.text = "Users Table View Title"

        let headerView = UITableViewHeaderFooterView()
        let contentView = headerView.contentView
        contentView.addSubview(headerLabel)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            headerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier, for: indexPath) as? UserCell
        let userData = self.usersViewModel.usersList[indexPath.row]
        
        cell?.configureCell(with: userData)
        
        return cell ?? UITableViewCell()
    }
}

//MARK: UITableViewDelegate
extension UserViewController {
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
            guard let self else { return }
            
            self.usersViewModel.deleteUser(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        deleteAction.image = UIImage(named: "trash_icon")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}


