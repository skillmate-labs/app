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
    case plans(goalId: UUID)
    case tasks(planId: UUID)
    case task(id: UUID)
    
    var url: URL {
        switch self {
        case .goals:
            APIConfiguration.baseURL.appending(path: "goals")
            
        case .goal(let id):
            APIConfiguration.baseURL
                .appending(path: "goals")
                .appending(path: id.uuidString)
            
        case .plans(let goalId):
            APIConfiguration.baseURL
                .appending(path: "goals")
                .appending(path: goalId.uuidString)
                .appending(path: "plans")
            
        case .tasks(let planId):
            APIConfiguration.baseURL
                .appending(path: "plans")
                .appending(path: planId.uuidString)
                .appending(path: "tasks")
            
        case .task(let id):
            APIConfiguration.baseURL
                .appending(path: "tasks")
                .appending(path: id.uuidString)
        }
    }
}
