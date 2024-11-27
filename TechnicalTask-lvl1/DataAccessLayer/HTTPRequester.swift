//
//  HTTPRequester.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 26.11.24.
//
import Foundation
import Combine

class HTTPRequester {
    private let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
    
    var dataPublisher: AnyPublisher<Data, Never>!
    var responsePublisher: AnyPublisher<HTTPURLResponse, URLError>!
    
    private var sharedPublisher: Publishers.Share<URLSession.DataTaskPublisher>
    private init() {
        sharedPublisher = URLSession.shared
            .dataTaskPublisher(for: url)
            .share()
    }
    static var shared: HTTPRequester = {
        let instance = HTTPRequester()

        return instance
    }()
    
    func initRequest() -> AnyPublisher<Data, Never> {
        
        self.dataPublisher = sharedPublisher
            .map { $0.data }
            .catch{ _ in Just(Data()) }
            .share()
            .eraseToAnyPublisher()
        
        return self.dataPublisher
    }
    
    func initStatus() -> AnyPublisher<HTTPURLResponse, URLError> {
        self.responsePublisher = sharedPublisher
            .map { $0.response as! HTTPURLResponse }
            .share()
            .eraseToAnyPublisher()
        
        return self.responsePublisher
    }
}

extension HTTPRequester: Copyable {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
