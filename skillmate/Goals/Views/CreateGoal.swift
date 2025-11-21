//
//  CreateGoal.swift
//  skillmate
//
//  Created by Arthur Mariano on 21/11/25.
//

import SwiftUI

struct CreateGoal: View {
    @Environment(\.dismiss) var dismiss
    @Environment(GoalsStore.self) var store
    @State private var newGoal: Goal = Goal.empty
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $newGoal.title)
                    TextField("Experience", text: $newGoal.experience, axis: .vertical)
                        .lineLimit(4, reservesSpace: true)
                }
                
                Section("Availability") {
                    HStack(spacing: 16) {
                        Image(systemName: "clock")
                            .foregroundStyle(.secondary)
                        Picker("Hours", selection: $newGoal.hoursPerDay) {
                            ForEach(1...24, id: \.self) {
                                Text("\($0) hours")
                            }
                        } currentValueLabel: {
                            Text("\(newGoal.hoursPerDay) hours/day")
                        }
                    }
                    
                    HStack(spacing: 16) {
                        Image(systemName: "calendar")
                            .foregroundStyle(.secondary)
                        Picker("Days", selection: $newGoal.daysPerWeek) {
                            ForEach(1...7, id: \.self) {
                                Text("\($0) days")
                            }
                        } currentValueLabel: {
                            Text("\(newGoal.daysPerWeek) days/week")
                        }
                    }
                }
            }
            .navigationTitle("Create Goal")
            .toolbarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                       dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button(role: .confirm) {
                        Task {
                            await store.create(goal: newGoal)
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        Text("Create Goal")
    }
    .sheet(isPresented: .constant(true)) {
        CreateGoal()
            .environment(GoalsStore())
    }
}
