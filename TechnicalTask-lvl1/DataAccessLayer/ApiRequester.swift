//
//  RequesterImplementation.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 10.12.24.
//
import Combine

protocol APIRequester {
    func executeGetRequest<T: Codable>() async throws -> [T]
}
