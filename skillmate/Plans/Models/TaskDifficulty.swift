//
//  TaskDifficulty.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

enum TaskDifficulty: String, Codable, CaseIterable, Identifiable {
    case easy = "Easy"
    case normal = "Normal"
    case hard = "Hard"
    
    var id: String { rawValue }
}
