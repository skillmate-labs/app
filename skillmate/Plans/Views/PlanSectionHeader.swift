//
//  PlanSection.swift
//  skillmate
//
//  Created by Arthur Mariano on 21/11/25.
//

import SwiftUI

struct PlanSectionHeader: View {
    @Environment(TaskStore.self) private var taskStore
    var plan: PlanSummary
    
    private var completedText: String {
        let tasks = taskStore.tasks(for: plan.id)
        let completed = tasks.isEmpty ? plan.completedTasks : tasks.filter(\.completed).count
        return "\(completed)/\(plan.totalTasks) completed"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(plan.weekStart..<plan.weekEnd, format: .interval.day().month(.abbreviated))
                .font(.title3)
                .fontWeight(.semibold)

            HStack {
                Text("\(plan.weeksToComplete) weeks to go")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(completedText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.bottom, 4)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    PlanSectionHeader(plan: PlanSummary(
        id: UUID.init(),
        weekStart: Date(),
        weekEnd: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
        weeksToComplete: 10,
        totalTasks: 15,
        completedTasks: 3
    ))
    .environment(TaskStore())
}
