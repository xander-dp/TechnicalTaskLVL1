//
//  DataRequester.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 16.12.24.
//

import Foundation

protocol UsersDataRequester {
    var apiLink: String {get set}
    func getUsersData() async throws -> [UserEntity]
}
