//
//  NetworkManager.swift
//  TodoList
//
//  Created by J_Min on 2022/07/21.
//

import Foundation
import Combine

enum NetworkError: Error {
    case requestError
    case responseError(statusCode: Int)
}

class NetworkManager {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
    
    func fetchTodoList<T>(resource: Resource<T>) -> AnyPublisher<T, Error> {
        guard let request = resource.urlRequest else {
            return Fail(error: NetworkError.requestError)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let response =  response as? HTTPURLResponse,
                      (200..<300) ~= response.statusCode else {
                    let response = response as? HTTPURLResponse
                    throw NetworkError.responseError(statusCode: response?.statusCode ?? -1)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
