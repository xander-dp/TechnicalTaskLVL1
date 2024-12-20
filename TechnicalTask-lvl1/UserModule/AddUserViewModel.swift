//
//  AddUserViewModel.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 13.12.24.
//

import Foundation
import Combine

final class AddUserViewModel: ObservableObject {
    @Published var email = ""
    @Published var name = ""
    @Published var city = ""
    @Published var street = ""
    @Published var errorMessage: String?
    
    private let userSavedSuccessSubject = PassthroughSubject<Void, Never>()
    var userSavedSuccessPublisher: AnyPublisher<Void, Never> {
        userSavedSuccessSubject
            .eraseToAnyPublisher()
    }
    
    var isSubmitEnabledPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(isValidNamePublisher, isValidEmailPublisher, isValidCityPublisher, isValidStreetPublisher)
            .map { $0.valid && $1.valid && $2.valid && $3.valid }
            .eraseToAnyPublisher()
    }
    
    var fieldValidityPublisher: AnyPublisher<(type:UserFormFieldType, valid:Bool), Never> {
        Publishers.Merge4(isValidNamePublisher, isValidEmailPublisher, isValidCityPublisher, isValidStreetPublisher)
            .dropFirst(4)
            .eraseToAnyPublisher()
    }
    
    private var isValidNamePublisher: AnyPublisher<(type:UserFormFieldType, valid:Bool), Never> {
        $name
            .map { (.name, self.fieldValidator.validateField(ofType: .name, with: $0)) }
            .eraseToAnyPublisher()
    }
    
    private var isValidEmailPublisher: AnyPublisher<(type:UserFormFieldType, valid:Bool), Never> {
        $email
            .map { (.email, self.fieldValidator.validateField(ofType: .email, with: $0)) }
            .eraseToAnyPublisher()
    }
    
    private var isValidCityPublisher: AnyPublisher<(type:UserFormFieldType, valid:Bool), Never> {
        $city
            .map { (.city, self.fieldValidator.validateField(ofType: .city, with: $0)) }
            .eraseToAnyPublisher()
    }
    
    private var isValidStreetPublisher: AnyPublisher<(type:UserFormFieldType, valid:Bool), Never> {
        $street
            .map { (.street, self.fieldValidator.validateField(ofType: .street, with: $0)) }
            .eraseToAnyPublisher()
    }
    
    private let dataService: UsersDataService
    private let fieldValidator: UserFieldsValidator
    
    init(dataService: UsersDataService, fieldValidator: UserFieldsValidator) {
        self.dataService = dataService
        self.fieldValidator = fieldValidator
    }
    
    func saveButtonTapped() {
        let entity = UserEntity(email: self.email, name: self.name, city: self.city, street: self.street)
        
        do {
            try self.dataService.save(entity)
            self.userSavedSuccessSubject.send()
        } catch {
            self.errorMessage = "User already exist"
        }
    }
}
