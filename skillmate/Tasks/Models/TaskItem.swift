//
//  TaskItem.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

struct TaskItem: Codable, Identifiable, Equatable {
    let id: UUID
    let title: String
    var completed: Bool = false
    var difficulty: TaskDifficulty = .normal
    var references: [Reference] = []
}
