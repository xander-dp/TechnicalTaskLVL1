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
    //var responsePublisher: AnyPublisher<HTTPURLResponse, URLError>!
    
    private var sharedPublisher: Publishers.Share<URLSession.DataTaskPublisher>
    
    init() {
        sharedPublisher = URLSession.shared
            .dataTaskPublisher(for: url)
            .share()
    }
    
    func initRequest() -> AnyPublisher<Data, Never> {
        sharedPublisher
            .map { $0.data }
            .catch{ _ in Just(Data()) }
            .eraseToAnyPublisher()
    }
}
