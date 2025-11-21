//
//  GoalsViewModel.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation

@Observable
class GoalsViewModel {
    private let repo = GoalsRepository()
    
    var goals: [Goal] = []
    var errorMessage: String?
    
    var nextCursor: String?
    var hasNextPage = true
    var isLoading = false
    
    func load() async {
        guard !isLoading else { return }
        guard hasNextPage else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        let cursor = nextCursor
        
        do {
            let response = try await repo.getAll(cursor: cursor)
            
            if cursor == nil {
                goals = response.data
            } else {
                goals += response.data
            }
            
            nextCursor = response.pageInfo.nextCursor
            hasNextPage = response.pageInfo.hasNextPage
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func create(title: String, exp: String, hours: Int, days: Int) async {
        do {
            let req = Goal(
                title: title,
                experience: exp,
                hoursPerDay: hours,
                daysPerWeek: days
            )
            
            _ = try await repo.create(req)
            await reload()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func reload() async {
        goals = []
        nextCursor = nil
        hasNextPage = true
        await load()
    }
}
