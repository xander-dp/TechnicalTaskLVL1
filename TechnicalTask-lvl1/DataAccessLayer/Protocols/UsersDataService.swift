//
//  DataRepository.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 11.12.24.
//

protocol UsersDataService {
    func fetchData() throws -> [UserEntity]
    func syncronizeRemoteData() async throws
    func save(_ entity: UserEntity) throws (DataStorageError)
    func delete(_ entity: UserEntity) throws
}
