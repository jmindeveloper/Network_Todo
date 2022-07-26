//
//  TodoListModel.swift
//  TodoList
//
//  Created by J_Min on 2022/07/21.
//

import Foundation

struct Todo: Codable {
    let id: String
    var title: String
    let createDate: String
    var content: String
    var isDone: Bool
}
