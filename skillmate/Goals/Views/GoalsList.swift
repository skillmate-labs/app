//
//  GoalsList.swift
//  skillmate
//
//  Created by Arthur Mariano on 21/11/25.
//

import SwiftUI

struct GoalsList: View {
    @State private var searchText: String = ""
    private var viewModel = GoalsViewModel()
    
    private var filteredGoals: [Goal] {
        if searchText.isEmpty { return viewModel.goals }
        
        return viewModel.goals.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    
    var body: some View {
        NavigationStack {
            List(viewModel.goals) { goal in
                GoalCard(goal: goal)
            }
            .task() {
                await viewModel.load()
            }
            .navigationTitle("Goals")
            .toolbarTitleDisplayMode(.large)
            .searchable(text: $searchText)
        }
    }
}

#Preview {
    GoalsList()
}
