//
//  Endpoint.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

enum Endpoint {
    case goals
    case goal(id: UUID)
    
    case generatePlan(goalId: UUID)
    case listPlans(goalId: UUID, cursor: String?, limit: Int)
    
    case tasks(planId: UUID)
    case task(id: UUID)
    
    var url: URL {
        switch self {
            
            // MARK: - Goals
        case .goals:
            return APIConfiguration.baseURL
                .appending(path: "goals")
            
        case .goal(let id):
            return APIConfiguration.baseURL
                .appending(path: "goals")
                .appending(path: id.uuidString)
            
            // MARK: - Generate weekly plan
        case .generatePlan(let goalId):
            return APIConfiguration.baseURL
                .appending(path: "goals")
                .appending(path: goalId.uuidString)
                .appending(path: "plans")
            
            // MARK: - List weekly plans
        case .listPlans(let goalId, let cursor, let limit):
            var items: [URLQueryItem] = [
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
            if let cursor {
                items.append(.init(name: "cursor", value: cursor))
            }
            
            return APIConfiguration.baseURL
                .appending(path: "goals")
                .appending(path: goalId.uuidString)
                .appending(path: "plans")
                .appendingQueryItems(items)
            
            // MARK: - Tasks
        case .tasks(let planId):
            return APIConfiguration.baseURL
                .appending(path: "plans")
                .appending(path: planId.uuidString)
                .appending(path: "tasks")
            
        case .task(let id):
            return APIConfiguration.baseURL
                .appending(path: "tasks")
                .appending(path: id.uuidString)
        }
    }
}
