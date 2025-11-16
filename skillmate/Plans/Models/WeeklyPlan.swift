//
//  WeeklyPlan.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

struct WeeklyPlan: Codable, Identifiable {
    let id: UUID
    let weekStart: Date
    let weekEnd: Date
    let weeksToComplete: Int
    let createdAt: Date
    let tasks: [PlanTask]
}
