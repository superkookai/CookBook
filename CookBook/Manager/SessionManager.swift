//
//  SessionManager.swift
//  CookBook
//
//  Created by Weerawut Chaiyasomboon on 02/03/2568.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

@Observable
class SessionManager {
    var sessionState: SessionState = .logout
    var currentUser: User?
    
    init() {
        if FirebaseApp.allApps == nil {
            FirebaseApp.configure()
        }
        
        if let userId = Auth.auth().currentUser?.uid {
            sessionState = .login
            getCurrentUser(userId: userId)
        } else {
            sessionState = .logout
        }
    }
    
    private func getCurrentUser(userId: String) {
        Task {
            self.currentUser = try await Firestore.firestore().collection("users").document(userId).getDocument(as: User.self)
        }
    }
}
