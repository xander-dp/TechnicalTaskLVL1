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
    var finishAction: () -> Void
    var navigationController: UINavigationController?
    
    weak var delegate: UsersListCoordinatorDelegate?

    private weak var usersListViewController: UsersListViewController?
    private let usersListViewModel: UsersListViewModel
    
    init(viewModel: UsersListViewModel, finishAction: @escaping () -> Void) {
        self.usersListViewModel = viewModel
        self.finishAction = finishAction
    }
    
    func start() {
        let viewController = UsersListViewController(usersViewModel: self.usersListViewModel)
        self.navigationController = UINavigationController(rootViewController: viewController)
        
        self.usersListViewController = viewController
        self.usersListViewController?.title = "Users"
        self.usersListViewController?.delegate = self
        
        let addUserButton = UIBarButtonItem(title: "New User",
                                            style: .plain,
                                            target: self,
                                            action: #selector(signOutButtonTapped))
        usersListViewController?.navigationItem.rightBarButtonItem = addUserButton
    }
}

private extension UsersListCoordinator {
    @objc func signOutButtonTapped() {
        delegate?.usersListCoordinatorDidTapAddButton(self)
    }
}

extension UsersListCoordinator: UsersListViewControllerDelegate {
    func usersListViewControllerIsDeiniting(_ sender: UsersListViewController) {
        self.finishAction()
    }
}
