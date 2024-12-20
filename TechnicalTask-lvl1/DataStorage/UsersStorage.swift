//
//  UsersStorage.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 11.12.24.
//

protocol UsersStorage {
    func create(entity: UserEntity) throws
    func read() throws -> [UserEntity]
    func delete(entity: UserEntity) throws
}