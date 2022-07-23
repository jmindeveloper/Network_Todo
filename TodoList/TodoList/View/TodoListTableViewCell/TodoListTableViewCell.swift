//
//  TodoListTableViewCell.swift
//  TodoList
//
//  Created by J_Min on 2022/07/21.
//

import UIKit

class TodoListTableViewCell: UITableViewCell {

    static let identifier = "TodoListTableViewCell"
    var todoIsDoneHandler: ((Bool) -> Void)?
    
    // MARK: - Outlet
    @IBOutlet weak var todoTitleLabel: UILabel!
    @IBOutlet weak var todoCreateDateLabel: UILabel!
    @IBOutlet weak var todoIsDoneSwitch: UISwitch!
    
    // MARK: - Method
    func configureCell(with todo: Todo) {
        todoTitleLabel.text = todo.title
        todoCreateDateLabel.text = todo.createDate
        todoIsDoneSwitch.isOn = todo.isDone
    }
    
    @IBAction func todoIsDoneButtonTapped(_ sender: UISwitch) {
        todoIsDoneHandler?(sender.isOn)
    }
}
