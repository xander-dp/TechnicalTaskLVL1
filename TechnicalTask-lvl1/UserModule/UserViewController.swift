//

import UIKit
import Combine
import CoreData

class UserViewController: UITableViewController {
    var cancellabels = Set<AnyCancellable>()

    override func viewDidLoad() {
        let vm = UsersViewModel(dataService: UsersDataServiceImplementation(
            requester: UsersRequester("https://jsonplaceholder.typicode.com/users")),
                                connectivityStatePublisher: Just(true).eraseToAnyPublisher())
        
        vm.fetchUsersList()
        
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .white
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.register(UINib(nibName: UserCell.xibName, bundle: nil),
                                forCellReuseIdentifier: UserCell.reuseIdentifier)
    }
}

//MARK: UITableViewDataSource
extension UserViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsCount = 0
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
//        guard let fetchResult = self.fetchedResultsController?.object(at: indexPath),
//        let moUserEntity = (fetchResult as? UserEntityManagedObj)
//        else {
//            fatalError("Attempt to configure cell without a managed obj")
//        }
//        cell?.configureCell(with: UserPresntationModel(managedEntity: moUserEntity))
        return cell ?? UITableViewCell()
    }
}

//MARK: UITableViewDelegate
extension UserViewController {
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}


