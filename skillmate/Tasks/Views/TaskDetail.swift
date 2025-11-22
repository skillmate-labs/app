//
//  TaskDetail.swift
//  skillmate
//
//  Created by Arthur Mariano on 21/11/25.
//

import SwiftUI

struct TaskDetail: View {
    @Binding var task: TaskItem
    
    var body: some View {
        VStack {
            Form {
                Toggle(isOn: $task.completed) {
                    Label {
                        Text("Completed")
                    } icon: {
                        Image(systemName: task.completed ? "inset.filled.circle" : "circle")
                            .foregroundStyle(task.completed ? task.difficulty.color : .secondary)
                    }
                }
                .contentTransition(.symbolEffect(.replace))
                
                Group {
                    if task.completed {
                        Picker(selection: $task.difficulty) {
                            ForEach(TaskDifficulty.allCases, id: \.self) { difficulty in
                                Text(difficulty.rawValue)
                                    .tag(difficulty)
                            }
                        } label: {
                            Label {
                                Text("Difficulty")
                            } icon: {
                                Image(systemName: "gauge.with.needle")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                
                if !task.references.isEmpty {
                    Section("References") {
                        ForEach(task.references) { reference in
                            ReferenceCard(reference: reference)
                         }
                    }
                }
            }
            .animation(.easeInOut, value: task.completed)
            
        }
        .navigationTitle(task.title)
    }
}

#Preview {
    @Previewable @State var task = TaskItem(
        id: UUID(),
        title: "Aprender Swift",
        references: [
           Reference(
               id: UUID(),
               name: "Useful reference",
               description: "This reference is very very useful and you should definetly check it out",
               link: "https://github.com/arthvm",
           )
        ],
    )
    
    NavigationStack {
        TaskDetail(task: $task)
    }
}
