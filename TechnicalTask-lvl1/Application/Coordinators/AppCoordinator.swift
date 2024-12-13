//
//  AppCoordinator.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 13.12.24.
//

import UIKit

fileprivate let apiURL = "https://jsonplaceholder.typicode.com/users"
fileprivate let dataModelName = "UserDataModel"

final class AppCoordinator {
    var navigationController: UINavigationController? {
        window.rootViewController as? UINavigationController
    }
    
    private var window: UIWindow
    private var usersListCoordinator: UsersListCoordinator?
    
    private let dataRequester: UsersRequester
    private let dataStorage: DataStorageFacade
    private let dataService: UsersDataService
    private let connectivityManager: ConnectivityManager
    
    init(window: UIWindow) {
        self.window = window
        
        self.dataRequester = UsersRequester(apiURL)
        self.dataStorage = CoreDataStack(name: dataModelName)
        self.dataService = UsersDataServiceImplementation(requester: dataRequester, dataStorage: dataStorage)
        self.connectivityManager = NetworkStatusMonitor()
    }
    
    func start() {
        startUsersListCoordinator()
    }
    
    private func startUsersListCoordinator() {
        let viewModel = UsersListViewModel(dataService: self.dataService,
                                           connectivityStatePublisher: self.connectivityManager.statePublisher)
        
        usersListCoordinator = UsersListCoordinator(viewModel: viewModel, finishAction: { [weak self] in
            self?.usersListCoordinator = nil
        })
        
        usersListCoordinator?.delegate = self
        usersListCoordinator?.start()
        
        window.rootViewController = usersListCoordinator?.navigationController
    }
    
    private func beginAddUserCoordinator() {
        let dummyController = UIViewController()
        self.usersListCoordinator?.navigationController?.pushViewController(dummyController, animated: true)
    }
}

extension AppCoordinator: UsersListCoordinatorDelegate {
    func usersListCoordinatorDidTapAddButton(_ sender: UsersListCoordinator) {
        beginAddUserCoordinator()
    }
}
