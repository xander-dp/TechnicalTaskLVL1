//

import UIKit
import Combine
import CoreData

class UserViewController: UITableViewController {
    var cancellabels = Set<AnyCancellable>()
    var fetchedResultsController: NSFetchedResultsController<UserEntityManagedObj>! //persistent

    let keeper = DataKeeper()
    override func viewDidLoad() {
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .white
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.register(UINib(nibName: UserCell.xibName, bundle: nil),
                                forCellReuseIdentifier: UserCell.reuseIdentifier)
        
        self.fetchedResultsController = keeper.persistentObservable.fetchedResultsController
        subscribeOnFRCUpdates()
        subscribeOnDataUpdate()
        
        fetchFromLocal()
        fetchFromApi()
    }
    
    func subscribeOnFRCUpdates() {
        keeper.persistentObservable.controllerDidChangeSubject
            .receive(on: DispatchQueue.main)
            .sink { changes in
                if changes.isEmpty {
                    self.tableView.beginUpdates()
                    print("->Begin TableView UPDATE")
                    return
                }
                
                for change in changes {
                    switch change {
                    case .inserted(at: let indexPath):
                        self.tableView.insertRows(at: [indexPath], with: .fade)
                    case .deleted(from: let indexPath):
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
                self.tableView.endUpdates()
                print("<-End TableView UPDATE")
            }
            .store(in: &cancellabels)
    }
    
    func subscribeOnDataUpdate() {
        keeper.persistentObservable.dataSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching users: \(error)")
                }
            }, receiveValue: { users in
                print("Fetched \(users.count) users")
            })
            .store(in: &cancellabels)
    }
    
    func fetchFromLocal() {
        var cancellableFetch: AnyCancellable?
        cancellableFetch = keeper.persistentFetchPublisher
            .sink { compl in
                cancellableFetch?.cancel()
                print("fetch request completed")
            } receiveValue: { manageObjs in
                print("Fetched \(manageObjs.count) users")
                let VMs = manageObjs.map { UserPresntationModel(managedEntity: $0) }
            }
    }
    
    func fetchFromApi() {
        var cancellableRequest: AnyCancellable?
        cancellableRequest = keeper.fetchRemote()
            .sink { compl in
                cancellableRequest?.cancel()
                print(print("API request completed"))
            } receiveValue: { _ in
            }
    }
}

//MARK: UITableViewDataSource
extension UserViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController?.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        
        let rowsCount = sections[section].numberOfObjects
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
        guard let fetchResult = self.fetchedResultsController?.object(at: indexPath),
        let moUserEntity = (fetchResult as? UserEntityManagedObj)
        else {
            fatalError("Attempt to configure cell without a managed obj")
        }
        cell?.configureCell(with: UserPresntationModel(managedEntity: moUserEntity))
        return cell ?? UITableViewCell()
    }
}

//MARK: UITableViewDelegate
extension UserViewController {
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}


