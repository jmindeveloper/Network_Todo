//
//  TodoListTableViewCell.swift
//  TodoList
//
//  Created by J_Min on 2022/07/21.
//

import UIKit

class TodoListTableViewCell: UITableViewCell {

    static let identifier = "TodoListTableViewCell"
    
    // MARK: - Outlet
    @IBOutlet weak var todoTitleLabel: UILabel!
    @IBOutlet weak var todoCreateDateLabel: UILabel!
    
    // MARK: - Method
    func configureCell(with todo: TodoListModel) {
        todoTitleLabel.text = todo.title
        todoCreateDateLabel.text = todo.createDate
    }
}
