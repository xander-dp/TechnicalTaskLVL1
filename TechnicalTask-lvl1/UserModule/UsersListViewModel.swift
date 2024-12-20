//
//  UsersViewModel.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 10.12.24.
//

import UIKit
import Combine

final class UsersListViewModel: ObservableObject {
    @Published var usersList = [UserEntity]()
    @Published var connectionEstablished = false
    @Published var synchronizationInProgres = false
    @Published var errorMessage: String?
    
    private let dataService: UsersDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(dataService: any UsersDataService, connectivityObserver: ConnectivityObserver) {
        self.dataService = dataService
        
        connectivityObserver.statePublisher
            .map { $0 }
            .assign(to: &$connectionEstablished)
    }
    
    func fetchLocalData() {
        do {
            self.usersList = try self.dataService.fetchData()
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
            try! self.dataService.delete(entity)
        } else {
            self.errorMessage = "No such index"
        }
    }
    
    deinit {
        cancellables.removeAll()
    }
}
