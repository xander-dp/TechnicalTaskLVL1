//
//  Untitled.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 27.11.24.
//
import Combine
import CoreData

extension NSManagedObjectContext {
    func fetchPublisher<T: NSManagedObject>(_ request: NSFetchRequest<T>) -> AnyPublisher<[T], Error> {
        Future { promise in
            do {
                let results = try self.fetch(request)
                promise(.success(results))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}

class CoreDataObservable<T: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
    let fetchedResultsController: NSFetchedResultsController<T>

    private var currentChanges:[ItemsChange] = []
    let controllerDidChangeSubject = PassthroughSubject<[ItemsChange], Never>()
    let dataSubject = PassthroughSubject<[T], Error>()
    
    init(fetchRequest: NSFetchRequest<T>, context: NSManagedObjectContext) {
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: "rootCache"
        )
        super.init()
        self.fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
            dataSubject.send(fetchedResultsController.fetchedObjects ?? [])
        } catch {
            dataSubject.send(completion: .failure(error))
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        currentChanges.removeAll()
        controllerDidChangeSubject.send(currentChanges)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            currentChanges.append(.inserted(at: newIndexPath!))
        case .delete:
            currentChanges.append(.deleted(from: indexPath!))
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dataSubject.send(fetchedResultsController.fetchedObjects ?? [])
        controllerDidChangeSubject.send(currentChanges)
    }
}

enum ItemsChange: Hashable {
    case inserted(at: IndexPath)
    case deleted(from: IndexPath)
}
