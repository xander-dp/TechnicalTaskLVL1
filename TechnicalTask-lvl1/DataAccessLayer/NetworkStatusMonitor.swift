//
//  NetworkStatusMonitor.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 13.12.24.
//
import Foundation
import Combine
import Network

final class NetworkStatusMonitor: ConnectivityManager {
    var statePublisher: AnyPublisher<Bool, Never> {
        connectionStateSubject.eraseToAnyPublisher()
    }
    
    private var connectionStateSubject = CurrentValueSubject<Bool, Never>(false)

    init() {
        let monitor = NWPathMonitor()
        monitor.start(queue: DispatchQueue.global(qos: .background))
        
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            
            self.connectionStateSubject.send(path.status == .satisfied)
            print("Current Network status: \(path.status)")
        }
    }
}
