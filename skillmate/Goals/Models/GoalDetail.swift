//
//  GoalDetail.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

struct GoalDetail: Codable, Identifiable {
    let id: UUID
    let title: String
    let experience: Experience
    let hoursPerDay: Int
    let daysPerWeek: Int
    let createdAt: Date
}
