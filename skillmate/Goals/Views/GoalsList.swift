//
//  GoalsList.swift
//  skillmate
//
//  Created by Arthur Mariano on 21/11/25.
//

import SwiftUI

struct GoalsList: View {
    @Environment(GoalsStore.self) var store
    @Namespace private var goalNamespace
    @State private var searchText: String = ""
    @State private var isAddingGoal: Bool = false
    @State private var isShowingGoalTabs: Bool = false
    @State private var activeGoalId: UUID?
    
    private var filteredGoals: [Goal] {
        if searchText.isEmpty { return store.goals }
        
        return store.goals.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    
    var body: some View {
        NavigationStack {
            List(filteredGoals) { goal in
                Button {
                    activeGoalId = goal.id
                    isShowingGoalTabs = true
                } label: {
                    GoalCard(goal: goal)
                        .matchedTransitionSource(id: goal.id, in: goalNamespace)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
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
            .toolbarTitleDisplayMode(.inlineLarge)
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
        .fullScreenCover(isPresented: $isShowingGoalTabs, onDismiss: { activeGoalId = nil }) {
            if let binding = activeGoalBinding {
                GoalTabs(
                    goals: store.goals,
                    activeGoalId: binding
                )
                .navigationTransition(.zoom(sourceID: binding.wrappedValue, in: goalNamespace))
            }
        }
    }
}

private extension GoalsList {
    var activeGoalBinding: Binding<UUID>? {
        guard let fallbackId = store.goals.first?.id else { return nil }
        
        return Binding(
            get: {
                activeGoalId ?? fallbackId
            },
            set: { newValue in
                activeGoalId = newValue
            }
        )
    }
}

#Preview {
    GoalsList()
        .environment(GoalsStore())
        .environment(TaskStore())
        .environment(PlansStore())
}
