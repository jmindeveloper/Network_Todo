//
//  TodoListViewModel.swift
//  TodoList
//
//  Created by J_Min on 2022/07/21.
//

import Foundation
import Combine

class TodoListViewModel {
    
    private let network: NetworkManager
    private var subscriptions = Set<AnyCancellable>()
    let updateTodosHandler = PassthroughSubject<Void, Never>()
    var todos: [Todo] = [] {
        didSet {
            updateTodosHandler.send()
        }
    }
    
    init(network: NetworkManager = NetworkManager()) {
        self.network = network
    }
    
    func fetchTodoList() {
        let resource = Resource<[Todo]>(
            base: "http://localhost:3000",
            path: "/todos/list"
        )
        network.fetchTodoList(resource: resource)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("fetchTodoList: Success")
                }
            } receiveValue: { [weak self] todos in
                self?.todos = todos
            }.store(in: &subscriptions)
    }
    
    func updateTodo(todo: Todo, index: Int = -1) {
        let resource = Resource<Todo>(
            base: "http://localhost:3000",
            path: "/todos/list/\(todo.id)",
            header: ["application/json": "Content-Type"],
            httpMethod: .put
        )
        
        network.updateTodo(resource: resource, todo: todo)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("updateTodo: Success")
                }
            } receiveValue: { [weak self] todo in
                self?.todos[index] = todo
            }.store(in: &subscriptions)
    }
    
    func uploadTodo(todo: Todo) {
        print(#function)
        let resource = Resource<Todo>(
            base: "http://localhost:3000",
            path: "/todos/list",
            header: ["application/json": "Content-Type"],
            httpMethod: .post
        )
        
        network.uploadTodo(resource: resource, todo: todo)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("updateTodo: Success")
                }
            } receiveValue: { [weak self] todo in
                self?.todos.insert(todo, at: 0)
            }.store(in: &subscriptions)
    }
}
