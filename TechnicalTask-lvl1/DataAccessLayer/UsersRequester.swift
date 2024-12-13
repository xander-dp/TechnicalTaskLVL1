//
//  HTTPRequester.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 26.11.24.
//
import Foundation
import Combine

enum RequestFailed: Error {
    case withCode(Int)
    case withError(String)
}

final class UsersRequester {
    private let urlStringRepresentation: String
    private let decoder = JSONDecoder()
    
    init(_ urlStringRepresentation: String) {
        self.urlStringRepresentation = urlStringRepresentation
    }
    
    func executeGetRequest() async throws -> [UserEntity] {
        guard let url = URL(string: urlStringRepresentation)
        else {
            print("\(#function) called with invalid URL: \(urlStringRepresentation)")
            throw RequestFailed.withError("Invalid URL: \(urlStringRepresentation)")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        var requestResult: (data: Data, response: URLResponse)
        do {
            requestResult = try await URLSession.shared.data(for: urlRequest)
        } catch {
            print("\(#function) thrown error: \(error)")
            throw RequestFailed.withError(error.localizedDescription)
        }
        
        guard let httpResponse = requestResult.response as? HTTPURLResponse
        else {
            print("\(#function) error during response casting")
            throw RequestFailed.withError("Unable to read response")
        }
        
        if httpResponse.statusCode != 200 {
            print("\(#function) request finished with status code: \(httpResponse.statusCode)")
            throw RequestFailed.withCode(httpResponse.statusCode)
        }
        
        do {
            let dalUsersList = try self.decoder.decode([DALUser].self, from: requestResult.data)
            return dalUsersList.map { $0.toUserEntity() }
        } catch {
            print("\(#function) error during data parsing: \(error)")
            throw RequestFailed.withError(error.localizedDescription)
        }
    }
}