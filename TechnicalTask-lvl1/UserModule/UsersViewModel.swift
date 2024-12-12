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
    @Published var errorMessage: String?
    
    private let dataService: any UsersDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(dataService: any UsersDataService, connectivityStatePublisher: AnyPublisher<Bool, Never>? = nil) {
        self.dataService = dataService
        
        connectivityStatePublisher?
            .map { $0 }
            .assign(to: &$connectionEstablished)
        
        self.fetchLocalData()
    }
    
    func fetchLocalData() {
        do {
            self.usersList = try self.dataService.fetchLocalData()
            print(self.usersList)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func syncronizeRemoteData() {
        Task {
            do {
                try await self.dataService.syncronizeRemoteData()
                self.fetchLocalData()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
        .store(in: &cancellables)
    }
    
    func deleteUser(at index: Int) -> OperationResult {
        let entity = self.usersList.remove(at: index)
        
        if self.dataService.delete(entity) {
            return .success
        } else {
            return .failure("")
        }
    }
    
    deinit {
        cancellables.removeAll()
    }
}
