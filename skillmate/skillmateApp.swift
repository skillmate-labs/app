//
//  skillmateApp.swift
//  skillmate
//
//  Created by Gui Maggiorini on 13/11/25.
//

import SwiftUI
import Firebase

@main
struct skillmateApp: App {
    @State private var authService: AuthService
    
    init() {
        FirebaseApp.configure()
        
        let auth = AuthService()
        _authService = State(initialValue: auth)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authService)
        }
    }
}
