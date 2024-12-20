//
//  NetworkStatusMonitor.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 13.12.24.
//
import Combine
import Network

final class NetworkStatusMonitor: ConnectivityObserver {
    
    var statePublisher: AnyPublisher<Bool, Never> {
        connectionStateSubject.eraseToAnyPublisher()
    }
    
    private var connectionStateSubject = CurrentValueSubject<Bool, Never>(false)
    private let networkMonitor: NWPathMonitor

    init() {
        self.networkMonitor = NWPathMonitor()
    }
    
    func startObserving() {
        self.networkMonitor.start(queue: DispatchQueue.global(qos: .utility))
        self.networkMonitor.pathUpdateHandler = { [weak connectionStateSubject] path in
            
            connectionStateSubject?.send(path.status == .satisfied)
            print("Current Network status: \(path.status)")
        }
    }
    
    func stopObserving() {
        self.networkMonitor.cancel()
        self.networkMonitor.pathUpdateHandler = nil
    }
}
