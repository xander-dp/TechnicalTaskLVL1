//
//  UserEntity.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 25.11.24.
//

import Foundation

// MARK: - UserEntity
struct UserEntity: Codable {
    let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
}

// MARK: - Address
struct Address: Codable {
    let street, suite, city, zipcode: String
    let geo: Geo
}

// MARK: - Geo
struct Geo: Codable {
    let lat, lng: String
}

// MARK: - Company
struct Company: Codable {
    let name, catchPhrase, bs: String
}
