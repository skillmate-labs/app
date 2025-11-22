//
//  PlansViewModel.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

@MainActor
@Observable
class PlansStore {

    private struct GoalPlansState {
        var plans: [PlanSummary] = []
        var weeklyPlan: WeeklyPlan?
        var errorMessage: String?
        var nextCursor: String?
        var hasNextPage: Bool = true
        var isLoading: Bool = false
    }
    
    private let repo = PlansRepository()
    
    private var goalStates: [UUID: GoalPlansState] = [:]
    
    func plans(for goalId: UUID) -> [PlanSummary] {
        ensureStateExists(for: goalId)
        return goalStates[goalId]?.plans ?? []
    }
    
    func weeklyPlan(for goalId: UUID) -> WeeklyPlan? {
        goalStates[goalId]?.weeklyPlan
    }
    
    func errorMessage(for goalId: UUID) -> String? {
        goalStates[goalId]?.errorMessage
    }
    
    func load(goalId: UUID) async {
        ensureStateExists(for: goalId)
        
        guard goalStates[goalId]?.isLoading == false else { return }
        guard goalStates[goalId]?.hasNextPage == true else { return }
        
        let cursor = goalStates[goalId]?.nextCursor
        
        updateState(for: goalId) { state in
            state.isLoading = true
        }
        defer {
            updateState(for: goalId) { state in
                state.isLoading = false
            }
        }
        
        do {
            let response = try await repo.list(goalId: goalId, cursor: cursor)
            
            updateState(for: goalId) { state in
                if cursor == nil {
                    state.plans = response.data
                } else {
                    state.plans += response.data
                }
                
                state.nextCursor = response.pageInfo.nextCursor
                state.hasNextPage = response.pageInfo.hasNextPage
                state.errorMessage = nil
            }
        } catch {
            updateState(for: goalId) { state in
                state.errorMessage = error.localizedDescription
            }
        }
    }
    
    func generate(for goalId: UUID) async {
        do {
            let weeklyPlan = try await repo.generate(goalId: goalId)
            
            updateState(for: goalId) { state in
                state.weeklyPlan = weeklyPlan
                state.nextCursor = nil
                state.hasNextPage = true
                state.plans = []
            }
            
            await load(goalId: goalId)
        } catch {
            updateState(for: goalId) { state in
                state.errorMessage = error.localizedDescription
            }
        }
    }
    
    func reload(goalId: UUID) async {
        updateState(for: goalId) { state in
            state.plans = []
            state.nextCursor = nil
            state.hasNextPage = true
        }
        await load(goalId: goalId)
    }
    
    private func ensureStateExists(for goalId: UUID) {
        if goalStates[goalId] == nil {
            goalStates[goalId] = GoalPlansState()
        }
    }
    
    private func updateState(for goalId: UUID, _ update: (inout GoalPlansState) -> Void) {
        var state = goalStates[goalId] ?? GoalPlansState()
        update(&state)
        goalStates[goalId] = state
    }
}
