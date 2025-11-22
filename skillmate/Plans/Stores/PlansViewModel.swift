//
//  PlansViewModel.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

@Observable
class PlansStore {
    private let repo = PlansRepository()
    
    var plans: [PlanSummary] = []
    var weeklyPlan: WeeklyPlan?
    var errorMessage: String?
    var nextCursor: String?
    var hasNextPage: Bool = true
    var isLoading: Bool = false
    
    func load(goalId: UUID) async {
        guard !isLoading else { return }
        guard hasNextPage else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        let cursor = nextCursor
        
        do {
            let response = try await repo.list(goalId: goalId, cursor: cursor)
            
            if cursor == nil {
                plans = response.data
            } else {
                plans += response.data
            }
            
            nextCursor = response.pageInfo.nextCursor
            hasNextPage = response.pageInfo.hasNextPage
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func generate(for goalId: UUID) async {
        do {
            weeklyPlan = try await repo.generate(goalId: goalId)
            await reload(goalId: goalId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func reload(goalId: UUID) async {
        plans = []
        nextCursor = nil
        hasNextPage = true
        
        await load(goalId: goalId)
    }
}
