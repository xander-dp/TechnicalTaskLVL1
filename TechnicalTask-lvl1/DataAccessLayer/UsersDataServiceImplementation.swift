//
//  UsersDataService.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 11.12.24.
//

final class UsersDataServiceImplementation: UsersDataService {
    let requester: UsersRequester
    
    init(requester: UsersRequester) {
        self.requester = requester
    }
    
    func fetchDataList() async throws -> [UserEntity] {
        //stub
        print("\(#function) called")
        
        do {
            try await requester.executeGetRequest()
        } catch {
            print(error)
        }
        
        return [UserEntity]()
    }
    
    func save(_ entity: UserEntity) -> Bool {
        //stub
        print("\(#function) called, with entity: \(entity)")
        return true
    }
    
    func delete(_ entity: UserEntity) -> Bool {
        //stub
        print("\(#function) called, with entity: \(entity)")
        return true
    }
}
