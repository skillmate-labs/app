//
//  UpdateTaskRequest.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

struct UpdateTaskRequest: Encodable {
    let difficulty: TaskDifficulty?
    let completed: Bool?
}
