//
//  ConnectivityObserver.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 10.12.24.
//
import Combine

protocol ConnectivityManager {
    var statePublisher: AnyPublisher<Bool, Never> { get }
}
