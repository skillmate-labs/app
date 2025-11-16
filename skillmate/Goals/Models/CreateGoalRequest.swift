//
//  CreateGoalRequest.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

struct CreateGoalRequest: Encodable {
    let title: String
    let experience: Experience
    let hoursPerDay: Int
    let daysPerWeek: Int
}
