//
//  UsersDataService.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 11.12.24.
//

final class UsersDataServiceImplementation: UsersDataService {
    
    func fetchDataList() -> [UserEntity] {
        //stub
        print("\(#function) called")
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
