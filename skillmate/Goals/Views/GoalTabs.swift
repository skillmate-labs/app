//
//  GoalTabs.swift
//  skillmate
//
//  Created by Gui Maggiorini on 22/11/25.
//

import SwiftUI

struct GoalTabs: View {
    @Environment(\.dismiss) private var dismiss
    let goals: [Goal]
    @Binding var activeGoalId: UUID
    
    private var currentIndex: Int {
        guard let index = goals.firstIndex(where: { $0.id == activeGoalId }) else {
            return 0
        }
        
        return index
    }
    
    var body: some View {
        NavigationStack {
            if goals.isEmpty {
                ContentUnavailableView {
                    Label("Empty goals", systemImage: "book.pages")
                } description: {
                    Text("Create a goal to explore its weekly plans")
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Close", systemImage: "list.dash") {
                            dismiss()
                        }
                    }
                }
            } else {
                TabView(selection: $activeGoalId) {
                    ForEach(goals) { goal in
                        GoalDetail(goal: goal)
                            .tag(goal.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .toolbar {
                    ToolbarSpacer(placement: .bottomBar)
                    
                    ToolbarItem(placement: .bottomBar) {
                        HStack {
                            ForEach(Array(goals.enumerated()), id: \.element.id) { entry in
                                Circle()
                                    .fill(entry.offset == currentIndex ? Color.accentColor : Color.secondary.opacity(0.4))
                                    .frame(width: 8, height: 8)
                                    .onTapGesture {
                                        withAnimation {
                                            activeGoalId = entry.element.id
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                    
                    ToolbarSpacer(placement: .bottomBar)
                    
                    ToolbarItem(placement: .bottomBar) {
                        Button("Close", systemImage: "list.dash") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let goals = [
        Goal(title: "Aprender SwiftUI", experience: "Beginner", hoursPerDay: 2, daysPerWeek: 5),
        Goal(title: "Aprender Combine", experience: "Intermediate", hoursPerDay: 1, daysPerWeek: 4)
    ]
    
    GoalTabs(
        goals: goals,
        activeGoalId: .constant(goals.first!.id)
    )
    .environment(GoalsStore())
    .environment(PlansStore())
}

