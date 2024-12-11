//
//  UsersViewModel.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 10.12.24.
//

import UIKit
import Combine

final class UsersViewModel: ObservableObject {
    @Published var usersList = [UserEntity]()
    @Published var connectionEstablished = false
    
    private let dataService: any UsersDataService
    
    enum OperationResult {
        case success
        case failure
    }
    
    init(dataService: any UsersDataService, connectivityStatePublisher: AnyPublisher<Bool, Never>) {
        self.dataService = dataService
        
        connectivityStatePublisher
            .map { $0 }
            .assign(to: &$connectionEstablished)
    }
    
    func fetchUsersList() {
        self.usersList = self.dataService.fetchDataList()
    }
    
    func deleteUser(at index: Int) -> OperationResult {
        let entity = self.usersList.remove(at: index)
        
        if self.dataService.delete(entity) {
            return .success
        } else {
            return .failure
        }
    }
}
