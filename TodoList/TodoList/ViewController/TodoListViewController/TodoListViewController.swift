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
    private var dataSource: UITableViewDiffableDataSource<Int, Todo>?
    private let viewModel = TodoListViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureTodoListTableView()
        bindViewModel()
        viewModel.fetchTodoList()
//        configureDataSource()
//        applySnapshot(viewModel.todos)
    }
}

// MARK: - Binding
extension TodoListViewController {
    
    private func bindViewModel() {
        viewModel.updateTodosHandler
            .sink { [weak self] in
//                self?.applySnapshot(todos)
                self?.todoListTableView.reloadSections(IndexSet(0...0), with: .automatic)
            }.store(in: &subscriptions)
    }
    
    private func bindTodoIsDoneHandler(
        cell: TodoListTableViewCell,
        todo: Todo,
        index: Int) {
            var todo = todo
            cell.todoIsDoneHandler
                .sink { [weak self] isDone in
                    todo.isDone = isDone
                    self?.viewModel.updateTodo(todo: todo, index: index)
                }.store(in: &subscriptions)
        }
    
    private func bindingCreateTodoHandler(
        createTodoVC: CreateTodoViewController) {
        createTodoVC.saveTodoHandler
            .sink { [weak self] todo in
                self?.viewModel.uploadTodo(todo: todo)
            }.store(in: &subscriptions)
    }
    
    private func bindingEditTodoHandler(
        detailTodoVC: TodoDetailViewController,
        index: Int) {
        detailTodoVC.editTodoHandler
            .sink { [weak self] todo in
                self?.viewModel.updateTodo(todo: todo, index: index)
            }.store(in: &subscriptions)
    }
}

// MARK: - Method
extension TodoListViewController {
    
    private func configureNavigation() {
        navigationItem.title = "TodoList"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let createTodoButton = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(createTodoButtonTapped(_:))
        )
        navigationItem.rightBarButtonItem = createTodoButton
    }
    
    private func configureTodoListTableView() {
        todoListTableView.estimatedRowHeight = 100
        todoListTableView.rowHeight = UITableView.automaticDimension
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
    }
    
//    private func configureDataSource() {
//        dataSource = UITableViewDiffableDataSource<Int, Todo>(
//            tableView: todoListTableView) {
//                [weak self] tableView, indexPath, todo -> UITableViewCell in
//                let nib = UINib(nibName: TodoListTableViewCell.identifier, bundle: nil)
//                tableView.register(nib, forCellReuseIdentifier: TodoListTableViewCell.identifier)
//                print(indexPath.row)
//                guard let cell = tableView.dequeueReusableCell(
//                    withIdentifier: TodoListTableViewCell.identifier,
//                    for: indexPath) as? TodoListTableViewCell,
//                      let self = self else {
//                    return UITableViewCell()
//                }
//                self.bindTodoIsDoneHandler(
//                    cell: cell,
//                    todo: todo,
//                    index: indexPath.row
//                )
//                cell.configureCell(with: todo)
//
//                return cell
//            }
//    }
//
//    private func applySnapshot(_ todos: [Todo]) {
//        var snapshot = NSDiffableDataSourceSnapshot<Int, Todo>()
//        snapshot.appendSections([1])
//        snapshot.appendItems(todos)
//        print(snapshot.itemIdentifiers)
//        dataSource?.apply(snapshot, animatingDifferences: true)
//    }
}

// MARK: - TargetMethod
extension TodoListViewController {
    @objc private func createTodoButtonTapped(_ sender: UIButton) {
        guard let createTodoVC = UIStoryboard(
            name: CreateTodoViewController.identifier,
            bundle: nil
        ).instantiateViewController(withIdentifier: CreateTodoViewController.identifier) as?
                CreateTodoViewController else { return }
        
        createTodoVC.createTodoMode = .create
        bindingCreateTodoHandler(createTodoVC: createTodoVC)
        
        navigationController?.pushViewController(createTodoVC, animated: true)
    }
}

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nib = UINib(nibName: TodoListTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TodoListTableViewCell.identifier)
        print(indexPath.row)
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TodoListTableViewCell.identifier,
            for: indexPath) as? TodoListTableViewCell else {
            return UITableViewCell()
        }
        
        let todo = viewModel.todos[indexPath.row]
        cell.configureCell(with: todo)
        self.bindTodoIsDoneHandler(
            cell: cell,
            todo: todo,
            index: indexPath.row
        )
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = UIStoryboard.init(name: TodoDetailViewController.identifier, bundle: nil)
            .instantiateViewController(withIdentifier: TodoDetailViewController.identifier) as?
                TodoDetailViewController else { return }
        detailVC.todo = viewModel.todos[indexPath.row]
        bindingEditTodoHandler(detailTodoVC: detailVC, index: indexPath.row)
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
