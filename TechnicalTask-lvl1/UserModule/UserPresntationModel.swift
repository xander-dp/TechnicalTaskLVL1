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
    init(entity: DALUser) {
        self.name = entity.name
        self.email = entity.email
        self.city = entity.address.city
        self.street = entity.address.street
    }
}
