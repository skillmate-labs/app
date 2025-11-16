//
//  PlanSummary.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

struct PlanSummary: Codable, Identifiable {
    let id: UUID
    let weekStart: Date
    let weekEnd: Date
    let weeksToComplete: Int
    let totalTasks: Int
    let completedTasks: Int
}
