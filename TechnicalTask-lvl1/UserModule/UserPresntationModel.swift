//
//  UserViewModel.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 27.11.24.
//

struct UserPresntationModel {
    let name: String
    let email: String
    let city: String
    let street: String
}

extension UserPresntationModel {
    init(entity: UserEntity) {
        self.name = entity.name
        self.email = entity.email
        self.city = entity.address.city
        self.street = entity.address.street
    }
    
    init(managedEntity: UserEntityManagedObj) {
        self.name = managedEntity.name
        self.email = managedEntity.email
        self.city = managedEntity.address.city
        self.street = managedEntity.address.street
    }
}
