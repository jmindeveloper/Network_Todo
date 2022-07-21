//
//  TodoListViewController.swift
//  TodoList
//
//  Created by J_Min on 2022/07/21.
//

import UIKit

class TodoListViewController: UIViewController {
    
    static let identifier = "TodoListViewController"
    
    // MARK: - Outlet
    @IBOutlet weak var todoListTableView: UITableView!
    
    // MARK: - Properties
    private var dataSource: UITableViewDiffableDataSource<Int, String>?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "TodoList"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        configureDataSource()
    }
}

// MARK: - Method
extension TodoListViewController {
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, String>(tableView: todoListTableView) {
            tableView, indexPath, item -> UITableViewCell in
            let nib = UINib(nibName: TodoListTableViewCell.identifier, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: TodoListTableViewCell.identifier)
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoListTableViewCell.identifier, for: indexPath) as? TodoListTableViewCell else { return UITableViewCell() }
            
            return cell
        }
    }
}
