//
//  GoalCard.swift
//  skillmate
//
//  Created by Arthur Mariano on 21/11/25.
//

import SwiftUI

struct GoalCard: View {
    let goal: Goal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading) {
                Text(goal.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(goal.experience.isEmpty ? " " : goal.experience)
                    .lineLimit(2, reservesSpace: true)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                    Text("\(goal.hoursPerDay) hour/day")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                    Text("\(goal.daysPerWeek) days/week")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding(4)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    GoalCard(goal: Goal(
        title: "Aprender SwiftUI",
        experience: "Ja fiz todos os tutoriais na plataforma da Apple e trabalhei em um projeto simples de TodoList.",
        hoursPerDay: 2,
        daysPerWeek: 5
    ))
}
