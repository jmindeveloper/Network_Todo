//
//  CreateTodoViewController.swift
//  TodoList
//
//  Created by J_Min on 2022/07/21.
//

import UIKit
import Combine

enum CreateTodoMode {
    case create, edit
}

class CreateTodoViewController: UIViewController {
    
    static let identifier = "CreateTodoViewController"
    
    // MARK: - Properties
    var createTodoMode: CreateTodoMode?
    var todo: Todo?
    let saveTodoHandler = PassthroughSubject<Todo, Never>()
    let editTodoHandler = PassthroughSubject<Todo, Never>()
    
    @IBOutlet weak var todoTitleTextField: UITextField!
    @IBOutlet weak var todoContentTextView: UITextView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureTodoContentTextView()
        configureView()
    }
}

// MARK: - Method
extension CreateTodoViewController {
    private func configureNavigation() {
        if createTodoMode == .edit {
            navigationItem.title = "Todo 수정"
        } else {
            navigationItem.title = "새로운 Todo"
        }
        navigationItem.largeTitleDisplayMode = .never
        let saveAction = #selector(saveTodoButtonTapped(_:))
        let editAction = #selector(editTodoButtonTapped(_:))
        let saveTodoButton = UIBarButtonItem(
            title: createTodoMode == .create ?  "저장" : "수정",
            style: .plain,
            target: self,
            action: createTodoMode == .create ?
            saveAction : editAction
        )
        navigationItem.rightBarButtonItem = saveTodoButton
    }
    
    private func configureTodoContentTextView() {
        todoContentTextView.layer.borderColor = UIColor.black.cgColor
        todoContentTextView.layer.borderWidth = 1
        todoContentTextView.layer.cornerRadius = 5
        todoContentTextView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    }
    
    private func configureView() {
        guard let todo = todo else { return }
        todoTitleTextField.text = todo.title
        todoContentTextView.text = todo.content
    }
}

// MARK: - TargetMethod
extension CreateTodoViewController {
    @objc private func saveTodoButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = todoTitleTextField.text,
              let content = todoContentTextView.text,
              title != "", content != "" else { return }
        let createDate = getCurrentDate()
        let newTodo = Todo(
            id: UUID().uuidString,
            title: title,
            createDate: createDate,
            content: content,
            isDone: false)
        saveTodoHandler.send(newTodo)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func editTodoButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = todoTitleTextField.text,
              let content = todoContentTextView.text,
              let todo = todo,
              title != "", content != "" else { return }
        let editTodo = Todo(
            id: todo.id,
            title: title,
            createDate: todo.createDate,
            content: content,
            isDone: todo.isDone
        )
        editTodoHandler.send((editTodo))
        navigationController?.popViewController(animated: true)
    }
    
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HH:mm"
        return formatter.string(from: Date())
    }
}
