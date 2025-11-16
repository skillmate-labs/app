//
//  PlansViewModel.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation
import Observation

@Observable
class PlansViewModel {
    private let repo = PlansRepository()
    
    var plans: [PlanSummary] = []
    var weeklyPlan: WeeklyPlan?
    var errorMessage: String?
    var nextCursor: String?
    var hasNextPage: Bool = false
    
    func generate(for goalId: UUID) async {
        do {
            weeklyPlan = try await repo.generate(goalId: goalId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func load(goalId: UUID) async {
        do {
            let response = try await repo.list(goalId: goalId, cursor: nil)
            plans = response.data
            nextCursor = response.pageInfo.nextCursor
            hasNextPage = response.pageInfo.hasNextPage
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadMore(goalId: UUID) async {
        guard hasNextPage, let cursor = nextCursor else { return }
        
        do {
            let response = try await repo.list(goalId: goalId, cursor: cursor)
            plans += response.data
            nextCursor = response.pageInfo.nextCursor
            hasNextPage = response.pageInfo.hasNextPage
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
