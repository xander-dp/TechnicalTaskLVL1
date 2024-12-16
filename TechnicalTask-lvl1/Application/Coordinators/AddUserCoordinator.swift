//
//  AddUserCoordinator.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 15.12.24.
//

import UIKit

protocol AddUserCoordinatorDelegate: AnyObject {
    func addUserCoordinatorDidAddedUser(_ sender: AddUserCoordinator)
}

final class AddUserCoordinator {
    var rootViewController: UIViewController? {
        addUserViewController
    }
    weak var delegate: AddUserCoordinatorDelegate?
    
    private var addUserViewController: AddUserViewController?
    private let finishAction: () -> Void
    private let dataService: UsersDataService
    private let fieldValidator: UserFieldsValidator
    
    init(dataService: UsersDataService, fieldValidator: UserFieldsValidator, finishAction: @escaping () -> Void) {
        self.dataService = dataService
        self.fieldValidator = fieldValidator
        self.finishAction = finishAction
    }
    
    func start() {
        let viewModel = AddUserViewModel(dataService: self.dataService, fieldValidator: self.fieldValidator)
        self.addUserViewController = AddUserViewController.instantiate(viewModel: viewModel)
        self.addUserViewController?.title = "Add New User"
        self.addUserViewController?.delegate = self
    }
}

extension AddUserCoordinator: AddUserViewControllerDelegate {
    func addUserViewControllerDidSavedEntity(_ sender: AddUserViewController) {
        self.delegate?.addUserCoordinatorDidAddedUser(self)
    }
    
    func addUserViewControllerDidDisappear(_ sender: AddUserViewController) {
        self.addUserViewController = nil
    }
    
    func addUserViewControllerIsDeiniting(_ sender: AddUserViewController) {
        finishAction()
    }
}
