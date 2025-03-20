//
//  HomeViewModel.swift
//  CookBook
//
//  Created by Weerawut Chaiyasomboon on 02/03/2568.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@Observable
class HomeViewModel {
    var showSignOutAlert = false
    var showAddRecipeView = false
    var recipes: [Recipe] = []
    
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            print("ERROR SignOut: \(error.localizedDescription)")
            return false
        }
    }
    
    func fetchRecipes() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        do {
            let snapshot = try await Firestore.firestore().collection("recipes").whereField("userId", isEqualTo: userId).getDocuments()
            for documentSnapshot in snapshot.documents {
                let data = documentSnapshot.data()
                let id = documentSnapshot.documentID
                if let userId = data["userId"] as? String,
                    let image = data["image"] as? String,
                    let instructions = data["instructions"] as? String,
                    let name = data["name"] as? String,
                    let time = data["time"] as? Int {
                    
                    let recipe = Recipe(id: id, name: name, image: image, instructions: instructions, time: time, userId: userId)
                    recipes.append(recipe)
                }
             }
        } catch {
            print("Error fetching recipes: \(error.localizedDescription)")
        }
    }
}
