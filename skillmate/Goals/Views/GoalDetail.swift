//
//  GoalDetail.swift
//  skillmate
//
//  Created by Arthur Mariano on 21/11/25.
//

import SwiftUI

struct GoalDetail: View {
    @Environment(PlansStore.self) private var planStore
    var goal: Goal
    
    var body: some View {
        NavigationStack {
            List(planStore.plans) { plan in
                PlanSectionCard(plan: plan)
                    .onAppear {
                        if plan.id == planStore.plans.last?.id {
                            Task {
                                await planStore.load(goalId: goal.id)
                            }
                        }
                    }
            }
            .task {
                await planStore.load(goalId: goal.id)
                
                if planStore.plans.isEmpty {
                    await planStore.generate(for: goal.id)
                }
                
                if let firstPlan = planStore.plans.first {
                    if Date() > firstPlan.weekEnd {
                        await planStore.generate(for: goal.id)
                    }
                }
            }
            .navigationTitle(goal.title)
            .toolbarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    GoalDetail(goal: Goal(
        title: "Aprender SwiftUI",
        experience: "Ja fiz todos os tutoriais na plataforma da Apple e trabalhei em um projeto simples de TodoList.",
        hoursPerDay: 2,
        daysPerWeek: 5
    ))
    .environment(PlansStore())
}
