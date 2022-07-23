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
    private let session: URLSession
    
    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
    
    /// 전체 투두 리스트 가져오기
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
    
    /// 투두 수정 업데이트 하기
    func updateTodo<T>(resource: Resource<T>, todo: Todo) -> AnyPublisher<T, Error> {
        guard var request = resource.urlRequest else {
            return Fail(error: NetworkError.requestError)
                .eraseToAnyPublisher()
        }
        
        request.httpBody = encodingTodo(todo: todo)
        
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
    
    /// 투두 업로드 하기
    func uploadTodo<T>(resource: Resource<T>, todo: Todo) -> AnyPublisher<T, Error> {
        guard var request = resource.urlRequest else {
            return Fail(error: NetworkError.requestError)
                .eraseToAnyPublisher()
        }
        
        request.httpBody = encodingTodo(todo: todo)
        
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
    
    /// todo 삭제
    func deleteTodo<T>(resource: Resource<T>) -> AnyPublisher<Void, Error> {
        guard let request = resource.urlRequest else {
            return Fail(error: NetworkError.requestError)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap { _, response -> Void in
                guard let response = response as? HTTPURLResponse,
                      (200..<300) ~= response.statusCode else {
                    let response = response as? HTTPURLResponse
                    throw NetworkError.responseError(statusCode: response?.statusCode ?? -1)
                }
                return
            }
            .eraseToAnyPublisher()
    }
    
    /// todo -> json
    private func encodingTodo(todo: Todo) -> Data? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(todo) else { return nil }
        return data
    }
}
