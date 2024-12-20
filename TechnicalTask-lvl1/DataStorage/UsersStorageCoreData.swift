//
//  UsersStorageCoreData.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 27.11.24.
//
import Foundation
import CoreData

enum DataStorageError: Error {
    case errorDuringDataGathering
    case recordAlreadyExist
    case unableToChangeData
    case userNotExist
}

final class UsersStorageCoreData: UsersStorage {
    private let container: NSPersistentContainer
    
    var managedContext: NSManagedObjectContext {
        return self.container.viewContext
    }
    
    init(name: String) {
        self.container = NSPersistentContainer(name: name)
        
        self.container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    func create(entity: UserEntity) throws {
        guard !existing(email: entity.email) else {
            throw DataStorageError.recordAlreadyExist
        }
        
        let user = UserEntityMO(context: self.managedContext, with: entity)
        try user.managedObjectContext?.save()
    }
    
    func read() throws -> [UserEntity] {
        let fetchRequest = UserEntityMO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
        
        let data = try self.managedContext.fetch(fetchRequest)
        return data.map { $0.toUserEntity() }
    }
    
    func delete(entity: UserEntity) throws {
        guard let entity = getEntity(with: entity.email) else {
            throw DataStorageError.userNotExist
        }
        
        self.managedContext.delete(entity)
        try managedContext.save()
    }
    
    private func existing(email: String) -> Bool {
        getEntity(with: email) != nil
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
