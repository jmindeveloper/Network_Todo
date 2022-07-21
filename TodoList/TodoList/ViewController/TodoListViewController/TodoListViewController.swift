//
//  TodoListViewController.swift
//  TodoList
//
//  Created by J_Min on 2022/07/21.
//

import UIKit
import Combine

class TodoListViewController: UIViewController {
    
    static let identifier = "TodoListViewController"
    
    // MARK: - Outlet
    @IBOutlet weak var todoListTableView: UITableView!
    
    // MARK: - Properties
    private var dataSource: UITableViewDiffableDataSource<Int, TodoListModel>?
    private let viewModel = TodoListViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "TodoList"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        todoListTableView.estimatedRowHeight = 100
        todoListTableView.rowHeight = UITableView.automaticDimension
        bindViewModel()
        viewModel.fetchTodoList()
        configureDataSource()
        applySnapshot(viewModel.todos)
    }
}

// MARK: - Binding ViewModel
extension TodoListViewController {
    
    private func bindViewModel() {
        viewModel.$todos
            .sink { [weak self] todos in
                self?.applySnapshot(todos)
            }.store(in: &subscriptions)
    }
}

// MARK: - Method
extension TodoListViewController {
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, TodoListModel>(
            tableView: todoListTableView) {
            tableView, indexPath, item -> UITableViewCell in
            let nib = UINib(nibName: TodoListTableViewCell.identifier, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: TodoListTableViewCell.identifier)
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TodoListTableViewCell.identifier,
                for: indexPath) as? TodoListTableViewCell else {
                return UITableViewCell()
            }
            cell.configureCell(with: item)
            
            return cell
        }
    }
    
    private func applySnapshot(_ todos: [TodoListModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, TodoListModel>()
        snapshot.appendSections([1])
        snapshot.appendItems(todos)
        dataSource?.apply(snapshot)
    }
}
