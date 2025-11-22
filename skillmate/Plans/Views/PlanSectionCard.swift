//
//  PlanSectionCard.swift
//  skillmate
//
//  Created by Arthur Mariano on 21/11/25.
//

import SwiftUI

struct PlanSectionCard: View {
    @Environment(TaskStore.self) var taskStore
    @State private var isTasksExpanded: Bool = true
    var plan: PlanSummary
    
    var body: some View {
        DisclosureGroup(isExpanded: $isTasksExpanded) {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 12) {
                    ForEach(taskStore.binding(for: plan.id)) { $task in
                        TaskRow(task: $task)
                            .buttonStyle(.plain)
                            .onAppear {
                                if task.id == taskStore.tasks(for: plan.id).last?.id {
                                    Task {
                                        await taskStore.load(for: plan.id)
                                    }
                                }
                            }
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
