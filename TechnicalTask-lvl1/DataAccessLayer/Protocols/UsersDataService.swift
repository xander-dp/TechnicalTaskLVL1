//
//  DataRepository.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 11.12.24.
//

protocol UsersDataService {
    func fetchLocalData() throws -> [UserEntity]
    func syncronizeRemoteData() async throws
    func save(_ entity: UserEntity) -> Bool
    func delete(_ entity: UserEntity) -> Bool
}
