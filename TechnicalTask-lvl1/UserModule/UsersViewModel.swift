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
    @Published var synchronizationInProgres = false
    @Published var errorMessage: String?
    
    private let dataService: any UsersDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(dataService: any UsersDataService, connectivityStatePublisher: AnyPublisher<Bool, Never>) {
        self.dataService = dataService
        
        connectivityStatePublisher
            .map { $0 }
            .assign(to: &$connectionEstablished)
        
        self.fetchLocalData()
    }
    
    func fetchLocalData() {
        do {
            self.usersList = try self.dataService.fetchLocalData()
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func synchronizeRemoteData() {
        Task {
            self.synchronizationInProgres = true
            do {
                try await self.dataService.syncronizeRemoteData()
                self.fetchLocalData()
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.synchronizationInProgres = false
        }
        .store(in: &cancellables)
    }
    
    func deleteUser(at index: Int) {
        if self.usersList.indices.contains(index) {
            let entity = self.usersList.remove(at: index)
            self.dataService.delete(entity)
        } else {
            self.errorMessage = "No such index"
        }
    }
    
    deinit {
        cancellables.removeAll()
    }
}
