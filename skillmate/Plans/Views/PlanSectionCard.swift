//
//  PlanSectionCard.swift
//  skillmate
//
//  Created by Arthur Mariano on 21/11/25.
//

import SwiftUI

struct PlanSectionCard: View {
    @Environment(TaskStore.self) var taskStore
    var plan: PlanSummary
    
    var body: some View {
        DisclosureGroup {
            @Bindable var bindableStore = taskStore
            
            List($bindableStore.tasks) { $task in
                TaskRow(task: $task)
                    .onAppear {
                        if task.id == taskStore.tasks.last?.id {
                            Task {
                                await taskStore.load(for: plan.id)
                            }
                        }
                    }
                    .onChange(of: task) { oldValue, newValue in
                        guard oldValue.completed != newValue.completed ||
                                oldValue.difficulty != newValue.difficulty else {
                            return
                        }
                        
                        Task {
                            await taskStore.update(
                                taskId: newValue.id,
                                completed: newValue.completed,
                                difficulty: newValue.difficulty
                            )
                        }
                    }
            }
            .task {
                await taskStore.load(for: plan.id)
            }
        } label: {
            PlanSectionHeader(plan: plan)
        }
    }
}

#Preview {
    List {
        PlanSectionCard(plan: PlanSummary(
            id: UUID.init(),
            weekStart: Date(),
            weekEnd: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
            weeksToComplete: 10,
            totalTasks: 15,
            completedTasks: 3
        ))
    }
    .environment(TaskStore())
}
