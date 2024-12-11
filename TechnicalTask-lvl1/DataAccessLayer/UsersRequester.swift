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

class UsersRequester {
    //private let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
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
        
        var usersList: [UserEntity]
        do {
            let dalUsersList = try self.decoder.decode([DALUser].self, from: requestResult.data)
            usersList = dalUsersList.map { UserEntity(name: $0.name,
                                                      email: $0.email,
                                                      street: $0.address.street,
                                                      city: $0.address.city)}
        } catch {
            print("\(#function) error during data parsing: \(error)")
            throw RequestFailed.withError(error.localizedDescription)
        }
            
        return usersList
    }
}
