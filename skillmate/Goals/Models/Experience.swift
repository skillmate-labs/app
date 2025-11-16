//
//  Experience.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

enum Experience: String, Codable, CaseIterable, Identifiable {
    case trainee = "Trainee"
    case junior = "Junior"
    case mid = "Mid-Level"
    case senior = "Senior"
    case expert = "Expert"
    
    var id: String { rawValue }
}
