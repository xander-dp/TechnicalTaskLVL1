//
//  AddUserViewController.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 13.12.24.
//

import UIKit
import Combine

protocol AddUserViewControllerDelegate: AnyObject {
    func addUserViewControllerDidSavedEntity(_ sender: AddUserViewController)
    func addUserViewControllerDidDisappear(_ sender: AddUserViewController)
    func addUserViewControllerIsDeiniting(_ sender: AddUserViewController)
}

final class AddUserViewController: UIViewController {
    weak var delegate: AddUserViewControllerDelegate?

    private var cancellables = Set<AnyCancellable>()
    
    private var addUserViewModel: AddUserViewModel!
    private lazy var userForm = AddUserFormView()
    
    //MARK: Lifecycle
    static func instantiate(viewModel: AddUserViewModel) -> AddUserViewController {
        let viewController = AddUserViewController()
        viewController.addUserViewModel = viewModel
        return viewController
    }
    
    override func loadView() {
        self.view = userForm
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
        self.observeViewModel()
        self.setupKeyboardEvents()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.delegate?.addUserViewControllerDidDisappear(self)
    }
    
    deinit {
        delegate?.addUserViewControllerIsDeiniting(self)
    }
    
    //MARK: ViewModel bindings
    private func bindViewModel() {
        guard let addUserViewModel else { return }
        
        userForm.saveButtonTappedPublisher
            .sink { [weak addUserViewModel] in
                addUserViewModel?.saveButtonTapped()
            }
            .store(in: &cancellables)
        
        [userForm.nameTextField, userForm.emailTextField, userForm.cityTextField, userForm.streetTextField].forEach { field in
            guard let fieldType = UserFormFieldType(rawValue: field.tag) else { return }
            
            let keyPath: ReferenceWritableKeyPath<AddUserViewModel, String>
            switch fieldType {
            case .name:
                keyPath = \.name
            case .email:
                keyPath = \.email
            case .city:
                keyPath = \.city
            case .street:
                keyPath = \.street
            }
            
            NotificationCenter.default
                .publisher(for: UITextField.textDidChangeNotification, object: field)
                .map { ($0.object as! UITextField).text ?? "" }
                .assign(to: keyPath, on: addUserViewModel)
                .store(in: &cancellables)
        }
    }
    
    private func observeViewModel() {
        guard let addUserViewModel else { return }
        
        addUserViewModel.$errorMessage
            .sink { [weak self] message in
                guard let message = message else { return }
                self?.showError(message)
            }
            .store(in: &cancellables)
        
        addUserViewModel.isSubmitEnabledPublisher
            .assign(to: \.isEnabled, on: userForm.saveButton)
            .store(in: &cancellables)
        
        addUserViewModel.fieldValidityPublisher
            .sink { [weak userForm] field in
                userForm?.changeState(for: field.type, isValid: field.valid)
            }
            .store(in: &cancellables)
        
        addUserViewModel.userSavedSuccessPublisher
            .sink { [weak self] in
                if let self {
                    self.delegate?.addUserViewControllerDidSavedEntity(self)
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: Keyboard events
private extension AddUserViewController {
    func setupKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(pan)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                                  as? NSValue)?.cgRectValue else { return }
 
        let formView = userForm.stackView
        let extraSpacing = 20.0
        
        let bottomOfForm = formView.convert(formView.bounds, to: self.view).maxY
        let topOfKeyboard = self.view.frame.height - keyboardSize.height - extraSpacing
        let keyboardOverlap = bottomOfForm - topOfKeyboard
        
        if keyboardOverlap > 0 {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.view.frame.origin.y = 0 - keyboardOverlap
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.frame.origin.y = 0
        }
    }
}

private extension AddUserViewController {
    func showError(_ message: String) {
        let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
}
