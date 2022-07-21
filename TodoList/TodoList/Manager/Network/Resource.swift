//
//  Resource.swift
//  TodoList
//
//  Created by J_Min on 2022/07/21.
//

import Foundation

enum HTTPMethod {
    case get, post, put, delete
    
    var method: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}

struct Resource<T: Codable> {
    var base: String
    var path: String
    var params: [String: String]
    var header: [String: String]
    var httpMethod: HTTPMethod
    
    var urlRequest: URLRequest? {
        guard var urlComponents = URLComponents(string: base + path) else { return nil }
        let queryItems = params.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        header.forEach {
            request.addValue($0.key, forHTTPHeaderField: $0.value)
        }
        request.httpMethod = httpMethod.method
        
        return request
    }
    
    init(base: String,
         path: String,
         params: [String: String] = [:],
         header: [String: String] = [:],
         httpMethod: HTTPMethod = .get) {
        self.base = base
        self.path = path
        self.params = params
        self.header = header
        self.httpMethod = httpMethod
    }
}
