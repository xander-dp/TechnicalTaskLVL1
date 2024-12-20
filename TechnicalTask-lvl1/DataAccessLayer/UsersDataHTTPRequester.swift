//
//  HTTPRequester.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 26.11.24.
//
import Foundation

enum RequestFailed: Error {
    case withCode(Int)
    case withError(String)
}

final class UsersDataHTTPRequester: UsersDataRequester {
    var apiLink: String
    var decoder = JSONDecoder()
    
    init(_ apiLink: String) {
        self.apiLink = apiLink
    }
    
    func getUsersData() async throws -> [UserEntity] {
        guard let url = URL(string: self.apiLink) else {
            throw RequestFailed.withError("Ivalid URL: \(self.apiLink)")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let requestResult: (data: Data, response: URLResponse)
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
        
        if !(200...299).contains(httpResponse.statusCode) {
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
