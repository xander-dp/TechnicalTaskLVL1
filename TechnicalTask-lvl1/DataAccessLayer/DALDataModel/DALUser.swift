//
//  UserEntity.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 25.11.24.
//

import Foundation
import CoreData

// MARK: - UserEntity
public struct DALUser: Codable {
    let id: Int
    let name, username, email: String
    let phone, website: String?
    let address: Address
    let company: Company?
    
    func toUserEntity() -> UserEntity {
        UserEntity(email: self.email,
                   name: self.name,
                   city: self.address.city,
                   street: self.address.street)
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
