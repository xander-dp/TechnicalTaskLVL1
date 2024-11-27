//

import UIKit
import Combine
import CoreData

class UserViewController: UITableViewController {
    var cancellabels = Set<AnyCancellable>()
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>! //persistent
    
    let keeper = DataKeeper()
    override func viewDidLoad() {
        initializeFetchedResultsController()
        
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .white
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.register(UINib(nibName: UserCell.xibName, bundle: nil),
                                forCellReuseIdentifier: UserCell.reuseIdentifier)
        keeper.fetchRemote()
            .sink { compl in
                print(compl)
            } receiveValue: { val in
                print(val)
                CoreDataStack.persistent.create(from: val)
                CoreDataStack.persistent.saveContext()
            }
            .store(in: &cancellabels)
    }
}

//MARK: NSFetchedResultsController
extension UserViewController: NSFetchedResultsControllerDelegate {
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: UserEntityManagedObj.entityName)
        let nameSortDescriptor = NSSortDescriptor(key: #keyPath(UserEntityManagedObj.name), ascending: true)
        request.sortDescriptors = [nameSortDescriptor]
        
        let moc = CoreDataStack.persistent.viewContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: "rootCache")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
     
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            break
        }
    }
     
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError("Unknown case in: \(#function)")
        }
    }
     
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

//MARK: UITableViewDataSource
extension UserViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
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
        cell?.configureCell(with: UserEntity(from: moUserEntity))
        return cell ?? UITableViewCell()
    }
}

//MARK: UITableViewDelegate
extension UserViewController {
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}


