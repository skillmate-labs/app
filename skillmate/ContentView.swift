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
                VStack(spacing: 16) {
                    VStack {
                        Image(systemName: "globe")
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                        Text("Hello, world!")
                    }
                    
                    Button("Sign Out") {
                        authService.signOut()
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
            } else {
                SignUpView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(AuthService())
}
