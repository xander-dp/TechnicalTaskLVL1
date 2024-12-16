//
//  UsersDataService.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 11.12.24.
//

import Foundation

final class UsersDataServiceImplementation: UsersDataService {
    private let requester: UsersDataRequester
    private let dataStorage: UsersStorage
    
    init(requester: UsersDataRequester, dataStorage: UsersStorage) {
        self.requester = requester
        self.dataStorage = dataStorage
    }
    
    func fetchData() throws -> [UserEntity] {
        return try self.dataStorage.read()
    }
    
    func syncronizeRemoteData() async throws {
        let remoteList = try await requester.getUsersData()
        
        for user in remoteList {
            try? self.dataStorage.create(entity: user)
        }
    }
    
    func save(_ entity: UserEntity) throws(DataStorageError) {
        do {
            try self.dataStorage.create(entity: entity)
        } catch {
            if let storageError = error as? DataStorageError {
                throw storageError
            } else {
                print("unhanled error in \(#function): \(error)")
            }
        }
    }
    
    func delete(_ entity: UserEntity) throws {
        try self.dataStorage.delete(entity: entity)
    }
}
