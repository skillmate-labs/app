//
//  TasksViewModel.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation
import Observation

@Observable
class TasksViewModel {
    
    private let repo = TasksRepository()
    
    var tasks: [TaskItem] = []
    var errorMessage: String?
    
    private var nextCursor: String?
    private var hasNextPage: Bool = false
    
    func load(for planId: UUID) async {
        do {
            let response = try await repo.list(planId: planId, cursor: nil)
            
            self.tasks = response.data
            self.nextCursor = response.pageInfo.nextCursor
            self.hasNextPage = response.pageInfo.hasNextPage
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func loadMore(for planId: UUID) async {
        guard hasNextPage, let cursor = nextCursor else { return }
        
        do {
            let response = try await repo.list(planId: planId, cursor: cursor)
            
            self.tasks += response.data
            self.nextCursor = response.pageInfo.nextCursor
            self.hasNextPage = response.pageInfo.hasNextPage
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func update(taskId: UUID, completed: Bool?, difficulty: TaskDifficulty?) async {
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
}
