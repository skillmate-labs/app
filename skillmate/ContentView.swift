//
//  ContentView.swift
//  skillmate
//
//  Created by Gui Maggiorini on 13/11/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthService.self) private var authService: AuthService
    
    var body: some View {
        NavigationStack {
            if authService.isSignedIn {
                GoalsList()
            } else {
                SignUpView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(AuthService())
        .environment(GoalsStore())
        .environment(PlansStore())
        .environment(TaskStore())
}
