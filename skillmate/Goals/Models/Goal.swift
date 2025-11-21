//
//  Goal.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

struct Goal: Codable, Identifiable {
    var id: UUID = UUID()
    let title: String
    let experience: String
    var hoursPerDay: Int
    var daysPerWeek: Int
    var createdAt: Date?
}
