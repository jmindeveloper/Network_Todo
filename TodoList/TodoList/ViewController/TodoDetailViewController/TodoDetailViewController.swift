//
//  TodoDetailViewController.swift
//  TodoList
//
//  Created by J_Min on 2022/07/21.
//

import UIKit

class TodoDetailViewController: UIViewController {
    
    static let identifier = "TodoDetailViewController"
    
    // MARK: - Outlet
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var todoTitleLabel: UILabel!
    @IBOutlet weak var todoContentTextView: UITextView!
    
    // MARK: - Properties
    var todo: TodoListModel?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = todo?.title
        configureTodoContentTextView()
    }
}

// MARK: - Method
extension TodoDetailViewController {
    private func configureView() {
        guard let todo = todo else { return }
        createDateLabel.text = todo.createDate
        todoTitleLabel.text = todo.title
        todoContentTextView.text = todo.content
    }
    
    private func configureTodoContentTextView() {
        todoContentTextView.isEditable = false
        todoContentTextView.layer.borderColor = UIColor.black.cgColor
        todoContentTextView.layer.borderWidth = 1
        todoContentTextView.layer.cornerRadius = 5
        todoContentTextView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    }
}
