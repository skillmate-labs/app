//
//  PlanSection.swift
//  skillmate
//
//  Created by Arthur Mariano on 21/11/25.
//

import SwiftUI

struct PlanSectionHeader: View {
    var plan: PlanSummary
    
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
                
                Text("\(plan.completedTasks)/\(plan.totalTasks) completed")
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
}
