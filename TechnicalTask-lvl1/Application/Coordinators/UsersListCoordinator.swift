//
//  UsersListCoordinator.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 13.12.24.
//

import UIKit

protocol UsersListCoordinatorDelegate: AnyObject {
    func usersListCoordinatorDidTapAddButton(_ sender: UsersListCoordinator)
}

final class UsersListCoordinator {
    let finishAction: () -> Void
    weak var delegate: UsersListCoordinatorDelegate?
    var rootViewController: UIViewController? {
        usersListViewController
    }

    private var usersListViewController: UsersListViewController?
    private let dataService: UsersDataService
    private let connectivityManager: ConnectivityManager
    
    init(dataService: UsersDataService, connectivityManager: ConnectivityManager, finishAction: @escaping () -> Void) {
        self.dataService = dataService
        self.connectivityManager = connectivityManager
        self.finishAction = finishAction
    }
    
    func start() {
        let viewModel = UsersListViewModel(dataService: self.dataService,
                                           connectivityObserver: self.connectivityManager)
        self.usersListViewController = UsersListViewController.instantiate(viewModel: viewModel)
        
        self.usersListViewController?.title = "Users"
        self.usersListViewController?.delegate = self
        
        let addUserButton = UIBarButtonItem(title: "New User",
                                            style: .plain,
                                            target: self,
                                            action: #selector(addUserButtonTapped))
        usersListViewController?.navigationItem.rightBarButtonItem = addUserButton
    }
}

private extension UsersListCoordinator {
    @objc func addUserButtonTapped() {
        delegate?.usersListCoordinatorDidTapAddButton(self)
    }
}

extension UsersListCoordinator: UsersListViewControllerDelegate {
    func usersListViewControllerIsDeiniting(_ sender: UsersListViewController) {
        self.finishAction()
    }
}
