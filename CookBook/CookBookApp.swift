//
//  CookBookApp.swift
//  CookBook
//
//  Created by Weerawut Chaiyasomboon on 02/03/2568.
//

import SwiftUI

@main
struct CookBookApp: App {
    @State private var sessionManager = SessionManager()
    
    var body: some Scene {
        WindowGroup {
            switch sessionManager.sessionState {
            case .login:
                HomeView()
                    .environment(sessionManager)
            case .logout:
                LoginView()
                    .environment(sessionManager)
            }
        }
    }
}
