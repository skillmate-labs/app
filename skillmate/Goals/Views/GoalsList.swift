//
//  GoalsList.swift
//  skillmate
//
//  Created by Arthur Mariano on 21/11/25.
//

import SwiftUI

struct GoalsList: View {
    @Environment(GoalsStore.self) var store
    @State private var searchText: String = ""
    @State private var isAddingGoal: Bool = false
    
    private var filteredGoals: [Goal] {
        if searchText.isEmpty { return store.goals }
        
        return store.goals.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    
    var body: some View {
        NavigationStack {
            List(filteredGoals) { goal in
                NavigationLink {
                    GoalDetail(goal: goal)
                } label: {
                    GoalCard(goal: goal)
                }
                .onAppear {
                    guard searchText.isEmpty else { return }
                    guard goal.id == store.goals.last?.id else { return }
                    
                    Task {
                        await store.load()
                    }
                }
            }
            .task() {
                await store.load()
            }
            .refreshable {
                await store.reload()
            }
            .navigationTitle("Goals")
            .toolbarTitleDisplayMode(.large)
            .searchable(text: $searchText)
            .toolbar {
                DefaultToolbarItem(kind: .search, placement: .bottomBar)
                
                ToolbarSpacer(placement: .bottomBar)
                
                ToolbarItem(placement: .bottomBar) {
                    Button("Add goal", systemImage: "plus") {
                        isAddingGoal.toggle()
                    }
                }
            }
            .overlay {
                if store.goals.isEmpty, searchText.isEmpty {
                    ContentUnavailableView {
                        Label("Empty goals", systemImage: "book.pages")
                    } description: {
                        Text("Your goals will appear here when you create them")
                    }
                }
                
                if filteredGoals.isEmpty, !searchText.isEmpty {
                    ContentUnavailableView.search
                }
            }
            .sheet(isPresented: $isAddingGoal) {
                CreateGoal()
            }
        }
    }
}

#Preview {
    GoalsList()
        .environment(GoalsStore())
        .environment(TaskStore())
        .environment(PlansStore())
}
