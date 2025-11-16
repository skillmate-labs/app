//
//  GoalsViewModel.swift
//  skillmate
//
//  Created by Gui Maggiorini on 16/11/25.
//

import Foundation
import Observation

@Observable
class GoalsViewModel {
    private let repo = GoalsRepository()
    
    var goals: [Goal] = []
    var errorMessage: String?
    
    func load() async {
        do {
            let response = try await repo.getAll()
            goals = response.data
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func create(title: String, exp: Experience, hours: Int, days: Int) async {
        do {
            let req = CreateGoalRequest(
                title: title,
                experience: exp,
                hoursPerDay: hours,
                daysPerWeek: days
            )
            
            _ = try await repo.create(req)
            await load()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
