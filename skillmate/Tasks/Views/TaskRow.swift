//
//  Task.swift
//  skillmate
//
//  Created by Arthur Mariano on 21/11/25.
//

import SwiftUI

struct TaskRow: View {
    @Binding var task: TaskItem
    
    var body: some View {
        NavigationLink {
            TaskDetail(task: $task)
        } label: {
            HStack(alignment: .top) {
                Menu {
                    if task.completed {
                        Button("Undo") {
                            task.completed = false
                        }
                    }
                    
                    ForEach(TaskDifficulty.allCases, id: \.self) { difficulty in
                        
                        Button(difficulty.rawValue) {
                            task.completed = true
                            task.difficulty = difficulty
                        }
                    }
                } label: {
                    Image(systemName: task.completed ? "inset.filled.circle" : "circle")
                        .contentTransition(.symbolEffect(.replace))
                        .foregroundStyle(task.completed ? task.difficulty.color : .secondary)
                }
                
                VStack(alignment: .leading) {
                    Text(task.title)
                        .font(.callout)
                    
                    Text("\(task.references.count) references")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .foregroundStyle(task.completed ? .secondary : .primary)
                
                Spacer()
            }
            
        }
    }
}

#Preview {
    @Previewable @State var task = TaskItem(
        id: UUID(),
        title: "Aprender Swift",
        completed: true,
        references: [
            Reference(
                id: UUID(),
                name: "Apple Docs",
                description: "This is the most important piece of documetation you will use while learning SwiftUI",
                link: "https://developer.apple.com/documentation"
            )
        ],
    )
    
    NavigationStack {
        List {
            TaskRow(task: $task)
        }
    }
}
