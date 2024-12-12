//
//  CoreDataStack.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 27.11.24.
//
import Foundation
import CoreData

enum DataStorageError: Error {
    case errorDuringDataGathering
    case recordAlreadyExist(String)
    case unableToChangeData(String)
    case userNotExist(String)
}

final class CoreDataStack: DataStorageFacade {
    private let container: NSPersistentContainer
    
    var managedContext: NSManagedObjectContext {
        return self.container.viewContext
    }
    
    init(name: String) {
        self.container = NSPersistentContainer(name: name)
        
        self.container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Unable to load store: \(error)")
            }
        }
    }
    
    func create(entity: UserEntity) throws {
        if !existing(email: entity.email) {
            let user = UserEntityMO(context: self.managedContext, with: entity)
            
            do {
                try user.managedObjectContext?.save()
            } catch {
                print("Error during Data creation: \(error)")
                throw DataStorageError.unableToChangeData(error.localizedDescription)
            }
        }
    }
    
    func read() throws -> [UserEntity] {
        let fetchRequest = UserEntityMO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
        
        do {
            let data = try self.managedContext.fetch(fetchRequest)
            return data.map { $0.toUserEntity() }
        } catch {
            throw DataStorageError.errorDuringDataGathering
        }
    }
    
    func delete(entity: UserEntity) throws {
        if let entity = getEntity(with: entity.email) {
            self.managedContext.delete(entity)
            do {
                try managedContext.save()
            } catch {
                print("Error during deletion of \(entity): \(error)")
                throw DataStorageError.unableToChangeData(error.localizedDescription)
            }
        } else {
            throw DataStorageError.userNotExist(entity.email)
        }
    }
    
    private func existing(email: String) -> Bool {
        if getEntity(with: email) != nil {
            return true
        } else {
            return false
        }
    }
    
    private func getEntity(with email: String) -> UserEntityMO? {
          do {
              let lhs = NSExpression(forConstantValue: email)
              let rhs = NSExpression(forKeyPath: "email")
              let predicate = NSComparisonPredicate(leftExpression: lhs, rightExpression: rhs, modifier: .direct, type: .equalTo)
              
              let request = UserEntityMO.fetchRequest()
              request.predicate = predicate
              request.fetchLimit = 1
              
              let entity = try self.managedContext.fetch(request)
              return entity.first
          } catch {
              print("Unable to find entity with email: \(email)")
              return nil
          }
      }
}
