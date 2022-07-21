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
    @Published var todos: [TodoListModel] = []
    
    init(network: NetworkManager = NetworkManager()) {
        self.network = network
    }
    
    func fetchTodoList() {
        let resource = Resource<[TodoListModel]>(
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
}
