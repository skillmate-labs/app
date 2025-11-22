//
//  TasksViewModel.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

@Observable
class TaskStore {
    
    private let repo = TasksRepository()
    
    var tasks: [TaskItem] = []
    var errorMessage: String?
    
    private var nextCursor: String?
    private var hasNextPage: Bool = true
    private var isLoading: Bool = false
    
    func load(for planId: UUID) async {
        guard !isLoading else { return }
        guard hasNextPage else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        let cursor = nextCursor
        
        do {
            let response = try await repo.list(planId: planId, cursor: cursor)
            
            if cursor == nil {
                tasks = response.data
            } else {
                tasks += response.data
            }
            
            nextCursor = response.pageInfo.nextCursor
            hasNextPage = response.pageInfo.hasNextPage
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func update(taskId: UUID, completed: Bool? = nil, difficulty: TaskDifficulty? = nil) async {
        do {
            guard let index = tasks.firstIndex(where: { $0.id == taskId }) else { return }
            
            let current = tasks[index]
            let req = UpdateTaskRequest(
                difficulty: difficulty ?? current.difficulty,
                completed: completed ?? current.completed
            )
            
            let updated = try await repo.update(taskId: taskId, body: req)
            tasks[index] = updated
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func reload(planId: UUID) async {
        tasks = []
        nextCursor = nil
        hasNextPage = true
        await load(for: planId)
    }
}
