//
//  TodoDetailViewController.swift
//  TodoList
//
//  Created by J_Min on 2022/07/21.
//

import UIKit
import Combine

class TodoDetailViewController: UIViewController {
    
    static let identifier = "TodoDetailViewController"
    
    // MARK: - Outlet
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var todoTitleLabel: UILabel!
    @IBOutlet weak var todoContentTextView: UITextView!
    
    // MARK: - Properties
    var todo: Todo?
    private var subscriptions = Set<AnyCancellable>()
    let editTodoHandler = PassthroughSubject<Todo, Never>()
    let deleteTodoHandler = PassthroughSubject<String, Never>()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigation()
        configureTodoContentTextView()
    }
}

// MARK: - Method
extension TodoDetailViewController {
    private func bindingEiditTodoHandler(
        createTodoVC: CreateTodoViewController
    ) {
        createTodoVC.editTodoHandler
            .sink { [weak self] todo in
                self?.editTodoHandler.send(todo)
                self?.todo = todo
                self?.configureView()
                self?.configureNavigation()
            }.store(in: &subscriptions)
    }
    
    private func configureNavigation() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = todo?.title
        let editTodoButton = UIBarButtonItem(
            title: "수정",
            style: .plain,
            target: self,
            action: #selector(editTodoButtonTapped(_:))
        )
        let deleteTodoButton = UIBarButtonItem(
            image: UIImage(systemName: "trash"),
            style: .plain,
            target: self,
            action: #selector(deleteTodoButtonTapped(_:))
        )
        navigationItem.rightBarButtonItems = [editTodoButton, deleteTodoButton]
    }
    
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

// MARK: - TargetMethod
extension TodoDetailViewController {
    @objc private func editTodoButtonTapped(_ sender: UIBarButtonItem) {
        guard let editTodoVC = UIStoryboard(
            name: CreateTodoViewController.identifier, bundle: nil)
            .instantiateViewController(withIdentifier: CreateTodoViewController.identifier) as?
        CreateTodoViewController else { return }
        
        editTodoVC.createTodoMode = .edit
        editTodoVC.todo = todo
        bindingEiditTodoHandler(createTodoVC: editTodoVC)
        
        self.navigationController?.pushViewController(editTodoVC, animated: true)
    }
    
    @objc private func deleteTodoButtonTapped(_ sender: UIBarButtonItem) {
        guard let todo = todo else { return }
        deleteTodoHandler.send(todo.id)
        navigationController?.popViewController(animated: true)
    }
}
