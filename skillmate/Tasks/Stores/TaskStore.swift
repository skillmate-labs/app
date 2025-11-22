//
//  TasksViewModel.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import SwiftUI

@MainActor
@Observable
class TaskStore {

    private struct PlanTasksState {
        var tasks: [TaskItem] = []
        var errorMessage: String?
        var nextCursor: String?
        var hasNextPage: Bool = true
        var isLoading: Bool = false
    }
    
    private let repo = TasksRepository()
    
    private var planStates: [UUID: PlanTasksState] = [:]
    
    func tasks(for planId: UUID) -> [TaskItem] {
        ensureStateExists(for: planId)
        return planStates[planId]?.tasks ?? []
    }
    
    func binding(for planId: UUID) -> Binding<[TaskItem]> {
        ensureStateExists(for: planId)
        return Binding(
            get: { self.planStates[planId]?.tasks ?? [] },
            set: { newValue in
                let previousValue = self.planStates[planId]?.tasks ?? []
                self.updateState(for: planId) { state in
                    state.tasks = newValue
                }
                self.persistLocalChanges(from: previousValue, to: newValue, planId: planId)
            }
        )
    }
    
    func load(for planId: UUID) async {
        ensureStateExists(for: planId)
        
        guard planStates[planId]?.isLoading == false else { return }
        guard planStates[planId]?.hasNextPage == true else { return }
        
        let cursor = planStates[planId]?.nextCursor
        
        updateState(for: planId) { state in
            state.isLoading = true
        }
        defer {
            updateState(for: planId) { state in
                state.isLoading = false
            }
        }
        
        do {
            let response = try await repo.list(planId: planId, cursor: cursor)
            
            updateState(for: planId) { state in
                if cursor == nil {
                    state.tasks = response.data
                } else {
                    state.tasks += response.data
                }
                
                state.nextCursor = response.pageInfo.nextCursor
                state.hasNextPage = response.pageInfo.hasNextPage
                state.errorMessage = nil
            }
            
        } catch {
            updateState(for: planId) { state in
                state.errorMessage = error.localizedDescription
            }
        }
    }
    
    func update(taskId: UUID, in planId: UUID, completed: Bool? = nil, difficulty: TaskDifficulty? = nil) async {
        ensureStateExists(for: planId)
        
        guard let index = planStates[planId]?.tasks.firstIndex(where: { $0.id == taskId }),
              let current = planStates[planId]?.tasks[index] else { return }
        
        do {
            let req = UpdateTaskRequest(
                difficulty: difficulty ?? current.difficulty,
                completed: completed ?? current.completed
            )
            
            let updated = try await repo.update(taskId: taskId, body: req)
            
            updateState(for: planId) { state in
                state.tasks[index] = updated
            }
            
        } catch {
            updateState(for: planId) { state in
                state.errorMessage = error.localizedDescription
            }
        }
    }
    
    func reload(planId: UUID) async {
        updateState(for: planId) { state in
            state.tasks = []
            state.nextCursor = nil
            state.hasNextPage = true
        }
        
        await load(for: planId)
    }
    
    private func ensureStateExists(for planId: UUID) {
        if planStates[planId] == nil {
            planStates[planId] = PlanTasksState()
        }
    }
    
    private func updateState(for planId: UUID, _ update: (inout PlanTasksState) -> Void) {
        var state = planStates[planId] ?? PlanTasksState()
        update(&state)
        planStates[planId] = state
    }
    
    private func persistLocalChanges(from oldValue: [TaskItem], to newValue: [TaskItem], planId: UUID) {
        guard !oldValue.isEmpty else { return }
        
        let oldTasks = Dictionary(uniqueKeysWithValues: oldValue.map { ($0.id, $0) })
        
        for task in newValue {
            guard let previous = oldTasks[task.id] else { continue }
            guard previous != task else { continue }
            
            Task {
                await self.update(
                    taskId: task.id,
                    in: planId,
                    completed: task.completed,
                    difficulty: task.difficulty
                )
            }
        }
    }
}
