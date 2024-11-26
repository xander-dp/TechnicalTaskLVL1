//
//  UserEntity.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 25.11.24.
//

import Foundation
import CoreData

// MARK: - UserEntity
public struct UserEntity: Codable {
    let id: Int
    let name, username, email: String
    let phone, website: String?
    let address: Address
    let company: Company?
    
    init(from managedEntity: UserEntityManagedObj) {
        self.id = Int(managedEntity.id)
        self.name = managedEntity.name ?? ""
        self.username = managedEntity.userName
        self.email = managedEntity.email
        self.phone = managedEntity.phone
        self.website = managedEntity.website
        self.address = Address(street: managedEntity.address.street,
                               city: managedEntity.address.city,
                               suite: managedEntity.address.suite,
                               zipcode: managedEntity.address.zipcode,
                               geo: Geo(lat: managedEntity.address.geo?.lat,
                                        lng: managedEntity.address.geo?.lng))
        self.company = Company(name: managedEntity.company?.name,
                               catchPhrase: managedEntity.company?.catchPhrase,
                               bs: managedEntity.company?.bs)
    }
}

// MARK: - Address
public struct Address: Codable {
    let street, city: String
    let suite, zipcode: String?
    let geo: Geo?
}

// MARK: - Geo
public struct Geo: Codable {
    let lat, lng: String?
    
    init?(lat: String?, lng:String?) {
        if lat == nil || lng == nil {
            return nil
        }
        
        self.lat = lat
        self.lng = lng
    }
}

// MARK: - Company
public struct Company: Codable {
    let name, catchPhrase, bs: String?
    
    init?(name: String?, catchPhrase: String?, bs: String?) {
        if name == nil {
            return nil
        }
        
        self.name = name
        self.catchPhrase = catchPhrase
        self.bs = bs
    }
}
