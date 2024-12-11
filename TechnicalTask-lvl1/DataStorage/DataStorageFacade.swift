//
//  DataStorageFacade.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 11.12.24.
//

protocol DataStorageFacade {
    func create(entity: UserEntity)
    func read() -> [UserEntity]
    func delete(entity: UserEntity)
}
