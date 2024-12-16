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
    private let usersListViewModel: UsersListViewModel
    
    init(viewModel: UsersListViewModel, finishAction: @escaping () -> Void) {
        self.usersListViewModel = viewModel
        self.finishAction = finishAction
    }
    
    func start() {
        self.usersListViewController = UsersListViewController.instantiate(viewModel: usersListViewModel)
        
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
