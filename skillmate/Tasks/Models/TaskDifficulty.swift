//
//  TaskDifficulty.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import SwiftUI

enum TaskDifficulty: String, Codable, CaseIterable, Identifiable, Equatable {
    case easy = "Easy"
    case normal = "Normal"
    case hard = "Hard"
    
    var id: String { rawValue }
    
    var color: Color {
        switch self {
        case .easy:
            return .green
        case .normal:
            return .blue
        case .hard:
            return .red
        }
    }
}
