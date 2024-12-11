//
//  DataKeeper.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 26.11.24.
//

import Foundation
import Combine
import CoreData

class DataKeeper {
    let persistentStorage = CoreDataStack.persistent
    
    private var fetchRequest: NSFetchRequest<UserEntityManagedObj>
    var persistentFetchPublisher: AnyPublisher<[UserEntityManagedObj], Error>
    var persistentObservable: CoreDataObservable<UserEntityManagedObj>
    
    init() {
        fetchRequest = UserEntityManagedObj.fetchRequest()
        let nameSortDescriptor = NSSortDescriptor(key: #keyPath(UserEntityManagedObj.name), ascending: true)
        fetchRequest.sortDescriptors = [nameSortDescriptor]
        
        persistentFetchPublisher = persistentStorage.viewContext
            .fetchPublisher(fetchRequest)
        
        persistentObservable = CoreDataObservable<UserEntityManagedObj>(
            fetchRequest: fetchRequest,
            context: persistentStorage.viewContext
        )
    }
    
//    func fetchRemote() -> AnyPublisher<Void, Error> {
//        let result = UsersRequester().initRequest()
//            .decode(type: [UserEntity].self, decoder: JSONDecoder())
//            .replaceError(with: [UserEntity]())
//            .flatMap { list in
//                Publishers.Sequence(sequence: list)
//                    .flatMap { el in
//                        Future<Void, Error> { promise in
//                            let _ = self.persistentStorage.create(entity: el)// UserEntityManagedObj(context: context, user: el)
//                            promise(.success(()))
//                        }
//                    }
//            }
//            .collect()
//            .flatMap { _ in
//                Future<Void, Error> { promise in
//                    do {
//                        try self.persistentStorage.viewContext.save()
//                        promise(.success(()))
//                    } catch {
//                        promise(.failure(error))
//                    }
//                }
//            }
//            .eraseToAnyPublisher()
//        
//        return result
//    }
    
}
