//
//  LoginViewModel.swift
//  CookBook
//
//  Created by Weerawut Chaiyasomboon on 02/03/2568.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@Observable
class LoginViewModel {
    var presentRegisterView = false
    var email = ""
    var password = ""
    var showPassword = false
    var errorMessage: String = ""
    var presentAlert = false
    var isLoading = false
    
    func login() async -> User? {
        isLoading = true
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            let userId = result.user.uid
            let user = try await Firestore.firestore().collection("users").document(userId).getDocument(as: User.self)
            isLoading = false
            return user
        } catch {
            isLoading = false
            self.errorMessage = "Login Failed"
            let errorCode = error._code
            if let authErrorCode = AuthErrorCode(rawValue: errorCode) {
                switch authErrorCode {
                case .wrongPassword:
                    self.errorMessage = "Wrong password"
                case .invalidEmail:
                    self.errorMessage = "Invalid email"
                default:
                    break
                }
            }
            presentAlert = true
            return nil
        }
    }
}
