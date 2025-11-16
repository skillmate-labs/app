//
//  Task.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

struct PlanTask: Codable, Identifiable {
    let id: UUID
    let title: String
    let completed: Bool
    let difficulty: TaskDifficulty
    let createdAt: Date
    let references: [Reference]
}
