//
//  Validator.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 16.12.24.
//

import Foundation

protocol UserFieldsValidator {
    func validateField(ofType fieldType: UserFormFieldType, with value: String) -> Bool
}

class UserFieldsValidatorImplementation: UserFieldsValidator {
    func validateField(ofType fieldType: UserFormFieldType, with value: String) -> Bool {
        let isFieldValid:Bool
        
        if fieldType == .email {
            isFieldValid = NSPredicate(
                format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            )
            .evaluate(with: value)
        } else {
            isFieldValid = !value.isEmpty
        }
        
        return isFieldValid
    }
}
