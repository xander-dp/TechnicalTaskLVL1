//
//  UsersDataService.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 11.12.24.
//

import Foundation

final class UsersDataServiceImplementation: UsersDataService {
    private let requester: UsersRequester
    private let dataStorage: DataStorageFacade
    
    init(requester: UsersRequester, dataStorage: DataStorageFacade) {
        self.requester = requester
        self.dataStorage = dataStorage
    }
    
    func fetchLocalData() throws -> [UserEntity] {
        do {
            let data = try self.dataStorage.read()
            return data
        } catch {
            print(error)
            return [UserEntity]()
        }
    }
    
    func syncronizeRemoteData() async throws {
        do {
            let remoteList = try await requester.executeGetRequest()
            
            for user in remoteList {
                try? self.dataStorage.create(entity: user)
            }
        } catch {
            print(error)
        }
    }
    
    func save(_ entity: UserEntity) -> Bool {
        do {
            try self.dataStorage.create(entity: entity)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func delete(_ entity: UserEntity) -> Bool {
        do {
            try self.dataStorage.delete(entity: entity)
            return true
        } catch {
            print(error)
            return false
        }
    }
}
