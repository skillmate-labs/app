//
//  TaskResponse.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

struct TaskResponse: Codable {
    let data: [TaskItem]
    let pageInfo: PageInfo
    
    struct PageInfo: Codable {
        let nextCursor: String?
        let hasNextPage: Bool
    }
}
