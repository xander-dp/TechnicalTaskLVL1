//
//  AddUserView.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 15.12.24.
//

import UIKit
import Combine

enum UserFormFieldType: Int {
    case name = 101
    case email = 102
    case city = 103
    case street = 104
}

final class AddUserFormView: UIView {
    private let saveButtonSubject = PassthroughSubject<Void, Never>()
    var saveButtonTappedPublisher: AnyPublisher<Void, Never> {
        saveButtonSubject.eraseToAnyPublisher()
    }
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 24
        return view
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("SAVE", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.layer.cornerRadius = 24
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var nameTextField: UITextField = createTextField(for: .name)
    lazy var emailTextField: UITextField = createTextField(for: .email)
    lazy var cityTextField: UITextField = createTextField(for: .city)
    lazy var streetTextField: UITextField = createTextField(for: .street)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .white
        
        self.addSubview(stackView)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(cityTextField)
        stackView.addArrangedSubview(streetTextField)
        stackView.addArrangedSubview(saveButton)
        
        activateContstraints()
    }
    
    private func activateContstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            nameTextField.heightAnchor.constraint(equalToConstant: 48),
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            cityTextField.heightAnchor.constraint(equalToConstant: 48),
            streetTextField.heightAnchor.constraint(equalToConstant: 48),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func saveButtonTapped() {
        saveButtonSubject.send()
    }
    
    func changeState(for type: UserFormFieldType, isValid: Bool) {
        let formFields = [nameTextField, emailTextField, cityTextField, streetTextField]
        if let field = formFields.first(where: { $0.tag == type.rawValue }) {
            field.layer.borderColor = isValid ? UIColor.black.cgColor : UIColor.red.cgColor
        }
    }
}

private extension AddUserFormView {
    func createTextField(for type: UserFormFieldType) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = type.rawValue
        
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 12
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 2
        
        switch type {
        case .name:
            textField.placeholder = "Full Name"
            textField.textContentType = .name
        case .email:
            textField.placeholder = "your_email@domain.com"
            textField.textContentType = .emailAddress
        case .city:
            textField.placeholder = "City"
            textField.textContentType = .addressCity
        case .street:
            textField.placeholder = "Street"
            textField.textContentType = .streetAddressLine1
        }

        if type == .email {
            textField.keyboardType = .emailAddress
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
        } else {
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.autocapitalizationType = .words
        }
        
        return textField
    }
}
