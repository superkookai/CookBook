//
//  CookBookApp.swift
//  CookBook
//
//  Created by Weerawut Chaiyasomboon on 02/03/2568.
//

import SwiftUI
import FirebaseCore

//Piggy use function of SessionManager in ContentView not in the @main like this App
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()

    return true
  }
}

@main
struct CookBookApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
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
