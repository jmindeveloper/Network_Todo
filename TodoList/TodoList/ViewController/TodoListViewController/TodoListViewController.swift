//
//  TodoListViewController.swift
//  TodoList
//
//  Created by J_Min on 2022/07/21.
//

import UIKit

let todoListMockDatas = [TodoListModel(id: "1", title: "title_1", crateDate: "20220721"),
                         TodoListModel(id: "2", title: "title_2", crateDate: "20220722"),
                         TodoListModel(id: "3", title: "title_3", crateDate: "20220723")]

class TodoListViewController: UIViewController {
    
    static let identifier = "TodoListViewController"
    
    // MARK: - Outlet
    @IBOutlet weak var todoListTableView: UITableView!
    
    // MARK: - Properties
    private var dataSource: UITableViewDiffableDataSource<Int, TodoListModel>?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "TodoList"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        todoListTableView.estimatedRowHeight = 100
        todoListTableView.rowHeight = UITableView.automaticDimension
        configureDataSource()
        applySnapshot()
    }
}

// MARK: - Method
extension TodoListViewController {
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, TodoListModel>(tableView: todoListTableView) {
            tableView, indexPath, item -> UITableViewCell in
            let nib = UINib(nibName: TodoListTableViewCell.identifier, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: TodoListTableViewCell.identifier)
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoListTableViewCell.identifier, for: indexPath) as? TodoListTableViewCell else { return UITableViewCell() }
            cell.configureCell(with: item)
            
            return cell
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, TodoListModel>()
        snapshot.appendSections([1])
        snapshot.appendItems(todoListMockDatas)
        dataSource?.apply(snapshot)
    }
}
