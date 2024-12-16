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
    private let navigationController: UINavigationController
    
    private var usersListCoordinator: UsersListCoordinator?
    private var addUserCoordinator: AddUserCoordinator?
    
    private let dataRequester: UsersRequester
    private let fieldValidator: UserFieldsValidator
    private let dataStorage: DataStorageFacade
    private let dataService: UsersDataService
    private let connectivityObserver: ConnectivityObserver
    
    init(navigationController: UINavigationController, connectivityObserver: ConnectivityObserver) {
        self.navigationController = navigationController
        self.connectivityObserver = connectivityObserver
        
        self.dataRequester = UsersRequester(apiURL)
        self.fieldValidator = UserFieldsValidatorImplementation()
        self.dataStorage = CoreDataStack(name: dataModelName)
        self.dataService = UsersDataServiceImplementation(requester: dataRequester, dataStorage: dataStorage)
    }
    
    func start() {
        startUsersListCoordinator()
    }
    
    private func startUsersListCoordinator() {
        self.usersListCoordinator = UsersListCoordinator(
            dataService: self.dataService,
            connectivityObserver: self.connectivityObserver
        ) { [weak self] in
            self?.usersListCoordinator = nil
        }
        
        self.usersListCoordinator?.delegate = self
        self.usersListCoordinator?.start()
        
        if let viewController = usersListCoordinator?.rootViewController {
            self.navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    private func beginAddUserCoordinator() {
        self.addUserCoordinator = AddUserCoordinator(
            dataService: self.dataService,
            fieldValidator: self.fieldValidator
        ) { [weak self] in
            self?.addUserCoordinator = nil
        }
        
        self.addUserCoordinator?.delegate = self
        self.addUserCoordinator?.start()
        
        if let viewController = self.addUserCoordinator?.rootViewController {
            self.navigationController.pushViewController(viewController, animated: true)
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
        self.navigationController.popViewController(animated: true)
    }
}
