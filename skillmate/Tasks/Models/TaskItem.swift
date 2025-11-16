//
//  TaskItem.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

struct TaskItem: Codable, Identifiable {
    let id: UUID
    let title: String
    let completed: Bool
    let difficulty: TaskDifficulty
    let references: [Reference]?
}
