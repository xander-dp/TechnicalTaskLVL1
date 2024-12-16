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
    private var addUserCoordinator: AddUserCoordinator?
    
    private let dataRequester: UsersRequester
    private let fieldValidator: UserFieldsValidator
    private let dataStorage: DataStorageFacade
    private let dataService: UsersDataService
    private let connectivityManager: ConnectivityManager
    
    init(window: UIWindow) {
        self.window = window
        
        self.dataRequester = UsersRequester(apiURL)
        self.fieldValidator = UserFieldsValidatorImplementation()
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
        
        self.usersListCoordinator = UsersListCoordinator(viewModel: viewModel, finishAction: { [weak self] in
            self?.usersListCoordinator = nil
        })
        
        self.usersListCoordinator?.delegate = self
        self.usersListCoordinator?.start()
        
        self.window.rootViewController = usersListCoordinator?.navigationController
    }
    
    private func beginAddUserCoordinator() {
        self.addUserCoordinator = AddUserCoordinator(dataService: self.dataService,
                                                     fieldValidator: self.fieldValidator) { [weak self] in
            self?.addUserCoordinator = nil
        }
        
        self.addUserCoordinator?.delegate = self
        self.addUserCoordinator?.start()
        
        if let viewController = self.addUserCoordinator?.rootViewController {
            self.usersListCoordinator?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension AppCoordinator: UsersListCoordinatorDelegate {
    func usersListCoordinatorDidTapAddButton(_ sender: UsersListCoordinator) {
        beginAddUserCoordinator()
    }
}

extension AppCoordinator: AddUserCoordinatorDelegate {
    func addUserCoordinatorDidAddedUser(_ sender: AddUserCoordinator) {
        self.usersListCoordinator?.navigationController?.popViewController(animated: true)
    }
}
