//
//  DataKeeper.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 26.11.24.
//

import Foundation
import Combine

protocol DataKeeperOutput {
    //map data on UserEntity
    //publish Remote UserEntity
}

class DataKeeper {
    private let requester = HTTPRequester.shared
    
    func fetchRemote() -> AnyPublisher<[UserEntity], Never> {
        return requester.initRequest()
            .decode(type: [UserEntity].self, decoder: JSONDecoder())
            .replaceError(with: [UserEntity]())
            .eraseToAnyPublisher()
    }
}
