//
//  CoreDataStack.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 27.11.24.
//
import Foundation
import CoreData

class CoreDataStack {
    static let modelName = "Model"
    
    enum StorageType {
        case persistent
        case temporary
    }
    
    private let container: NSPersistentContainer
    
    static var persistent: CoreDataStack = {
        return CoreDataStack(name: modelName, in: .persistent)
    }()
    
    static var temp: CoreDataStack = {
        return CoreDataStack(name: modelName, in: .temporary)
    }()
    
    var viewContext: NSManagedObjectContext {
        return self.container.viewContext
    }
    
    func saveContext() {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func create(entitiesFrom array: [DALUser]) {
        for user in array {
            self.create(entity: user)
        }
    }
    
    func create(entity: DALUser) {
        if !existing(email: entity.email) {
            let _ = UserEntityManagedObj(context: viewContext, user: entity)
            saveContext()
        }
    }
    
    func existing(email: String) -> Bool {
        let fetchRequest = NSFetchRequest<UserEntityManagedObj>(entityName: UserEntityManagedObj.entityName)
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(UserEntityManagedObj.email), email)
        do {
            let result = try viewContext.count(for: fetchRequest)
            return result > 0
        } catch {
            return false
        }
    }
    
    private init(name: String, in storageType: StorageType) {
        self.container = NSPersistentContainer(name: name)
        
        if storageType  == .temporary {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            self.container.persistentStoreDescriptions = [description]
        }
        
        self.container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unable to load store \(error), \(error.userInfo)")
            }
        }
    }
}
