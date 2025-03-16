//
//  HomeViewModel.swift
//  CookBook
//
//  Created by Weerawut Chaiyasomboon on 02/03/2568.
//

import Foundation
import FirebaseAuth

@Observable
class HomeViewModel {
    var showSignOutAlert = false
    var showAddRecipeView = false
    
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            print("ERROR SignOut: \(error.localizedDescription)")
            return false
        }
    }
}
