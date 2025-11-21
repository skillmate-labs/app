//
//  Endpoint.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

enum Endpoint {
    case goals
    case listGoals(cursor: String?, limit: Int)
    case goal(id: UUID)
    
    // PLANS
    case generatePlan(goalId: UUID)
    case listPlans(goalId: UUID, cursor: String?, limit: Int)
    
    // TASKS
    case listTasks(planId: UUID, cursor: String?, limit: Int)
    case updateTask(id: UUID)
    
    var url: URL {
        switch self {
            
            // MARK: - GOALS
        case .goals:
            return APIConfiguration.baseURL.appending(path: "goals")
            
        case .listGoals(let cursor, let limit):
            var items = [
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
            if let cursor { items.append(URLQueryItem(name: "cursor", value: cursor)) }
            
            return APIConfiguration.baseURL
                .appending(path: "goals")
                .appendingQueryItems(items)
            
        case .goal(let id):
            return APIConfiguration.baseURL
                .appending(path: "goals")
                .appending(path: id.uuidString)
            
            // MARK: - PLANS
        case .generatePlan(let goalId):
            return APIConfiguration.baseURL
                .appending(path: "goals")
                .appending(path: goalId.uuidString)
                .appending(path: "plans")
            
        case .listPlans(let goalId, let cursor, let limit):
            let items = [
                URLQueryItem(name: "cursor", value: cursor),
                URLQueryItem(name: "limit", value: "\(limit)")
            ].compactMap { $0 }
            
            return APIConfiguration.baseURL
                .appending(path: "goals")
                .appending(path: goalId.uuidString)
                .appending(path: "plans")
                .appendingQueryItems(items)
            
            // MARK: - TASKS
        case .listTasks(let planId, let cursor, let limit):
            let items = [
                URLQueryItem(name: "cursor", value: cursor),
                URLQueryItem(name: "limit", value: "\(limit)")
            ].compactMap { $0 }
            
            return APIConfiguration.baseURL
                .appending(path: "plans")
                .appending(path: planId.uuidString)
                .appending(path: "tasks")
                .appendingQueryItems(items)
            
        case .updateTask(let id):
            return APIConfiguration.baseURL
                .appending(path: "tasks")
                .appending(path: id.uuidString)
        }
    }
}
