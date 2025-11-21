//
//  Goal.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

struct Goal: Codable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var experience: String
    var hoursPerDay: Int
    var daysPerWeek: Int
    var createdAt: Date?
}


extension Goal {
    static var empty: Goal {
        Goal(title: "", experience: "", hoursPerDay: 1, daysPerWeek: 1)
    }
}
