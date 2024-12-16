//
//  UserEntity.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 25.11.24.
//

import Foundation
import CoreData

// MARK: - UserEntity
struct DALUser: Codable {
    let name: String
    let email: String
    let address: Address
    
    func toUserEntity() -> UserEntity {
        UserEntity(email: self.email,
                   name: self.name,
                   city: self.address.city,
                   street: self.address.street)
    }
}

// MARK: - Address
public struct Address: Codable {
    let street: String
    let city: String
}
