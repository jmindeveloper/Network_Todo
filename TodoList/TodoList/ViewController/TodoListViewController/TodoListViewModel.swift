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
    let fetchTodoSubject = PassthroughSubject<String, Never>()
    var todos: [Todo] = [] {
        didSet {
            updateTodosHandler.send()
        }
    }
    
    init(network: NetworkManager = NetworkManager()) {
        self.network = network
        fetchTodoList()
    }
    
    private func requestFetchTodoList(_ searchQuery: String = "") -> AnyPublisher<[Todo], Error> {
        let resource = Resource<[Todo]>(
            base: "http://localhost:3000",
            path: "/todos/list",
            params: [
                "_sort": "createDate",
                "_order": "desc",
                "q": searchQuery
            ]
        )
        
        return network.fetchTodoList(resource: resource)
    }
    
    private func fetchTodoList() {
        fetchTodoSubject
            .map { [unowned self] searchQuery in
                requestFetchTodoList(searchQuery)
            }
            .switchToLatest()
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
    
    func updateTodo(todo: Todo, index: Int) {
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
    
    func deleteTodo(id: String, index: Int) {
        let resource = Resource<Todo>(
            base: "http://localhost:3000",
            path: "/todos/list/\(id)",
            httpMethod: .delete
        )
        
        network.deleteTodo(resource: resource)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("deleteTodo: Success")
                }
            } receiveValue: { [weak self] in
                self?.todos.remove(at: index)
            }.store(in: &subscriptions)
    }
}
