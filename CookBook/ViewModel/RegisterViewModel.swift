//
//  RegisterViewModel.swift
//  CookBook
//
//  Created by Weerawut Chaiyasomboon on 02/03/2568.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@Observable
class RegisterViewModel {
    var username = ""
    var email = ""
    var showPassword = false
    var password = ""
    var isLoading: Bool = false
    var errorMessage: String = ""
    var presentAlert: Bool = false
    
    func signup() async -> User? {
        guard validateUsername() else {
            self.errorMessage = "Username must be greater than 3 characters and below 25 characters"
            self.presentAlert = true
            return nil
        }
        
        isLoading = true
        
        guard let usernameDocuments = try? await Firestore.firestore().collection("users").whereField("username", isEqualTo: self.username).getDocuments() else {
            self.errorMessage = "Something has gone wrong. Please try again later."
            self.presentAlert = true
            isLoading = false
            return nil
        }
        
        guard usernameDocuments.documents.count == 0 else {
            self.errorMessage = "Username alredy exists"
            self.presentAlert = true
            isLoading = false
            return nil
        }
        
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let userId = result.user.uid
            let user = User(id: userId, username: username, email: email)
            //Can use async setData(_ data:[String:Any]) but need to do Firestore encoding User first
            try Firestore.firestore().collection("users").document(userId).setData(from: user)
            isLoading = false
            return user
        } catch {
            self.errorMessage = "Signup Failed"
            if let errorCode = AuthErrorCode(rawValue: error._code) {
                switch errorCode {
                case .emailAlreadyInUse:
                    self.errorMessage = "Email already in used"
                case .invalidEmail:
                    self.errorMessage = "Email is invalid"
                case .weakPassword:
                    self.errorMessage = "Weak password"
                default:
                    print("ERROR: \(errorCode)")
                }
            }
            isLoading = false
            presentAlert = true
            return nil
        }
    }
    
    private func validateUsername() -> Bool {
        return username.count >= 3 && username.count < 25
    }
}
