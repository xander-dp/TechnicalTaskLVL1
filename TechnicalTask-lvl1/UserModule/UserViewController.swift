//

import UIKit
import Combine
import CoreData

class UserViewController: UITableViewController {
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
        self.tableView.register(UINib(nibName: UserCell.xibName, bundle: nil),
                                forCellReuseIdentifier: UserCell.reuseIdentifier)

        self.bindViewModel()
        usersViewModel.syncronizeRemoteData()
    }
    
    private func bindViewModel() {
        self.usersViewModel.$usersList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
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
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
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
            self.tableView.backgroundView = view //TODO: need View representing noDataState
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
}


