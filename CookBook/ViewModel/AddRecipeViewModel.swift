//
//  AddRecipeViewModel.swift
//  CookBook
//
//

import Foundation
import SwiftUI
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

@Observable
class AddRecipeViewModel {
    var recipeName = ""
    var preparationTime = 0
    var instructions = ""
    
    var showImageOptions = false
    var showLibrary = false
    var displayRecipeImage: Image?
    var recipeImage: UIImage?
    var showCamera = false
    var uploadProgress: Float = 0
    var isUploading = false
    var isLoading = false
    
    var showAlert = false
    var alertTitle = ""
    var alertMessage = ""
    
    func upload() async -> URL? {
        guard let userId = Auth.auth().currentUser?.uid else {
            return nil
        }
        
        guard let recipeImage, let imageData = recipeImage.jpegData(compressionQuality: 0.7) else {
            createAlert(title: "Image Upload Fail", message: "Recipe image could not be upload.")
            return nil
        }
        
        
        let imageId = UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "_")
        let imageName = "\(imageId).jpg"
        let imagePath = "images/\(userId)/\(imageName)"
        let storageRef = Storage.storage().reference(withPath: imagePath)
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        isUploading = true
        do {
            let _ = try await storageRef.putDataAsync(imageData, metadata: metaData) { progress in
                if let progress {
                    let percentComplete = Float(progress.completedUnitCount / progress.totalUnitCount)
                    self.uploadProgress = percentComplete
                }
            }
            isUploading = false
            let downloadURL = try await storageRef.downloadURL()
            return downloadURL
        } catch {
            createAlert(title: "Image Upload Fail", message: "Recipe image could not be upload.")
            isUploading = false
            print("Error uploading image: \(error.localizedDescription)")
            return nil
        }
    }
    
    func addRecipe(imageURL: URL, handler: @escaping (_ success: Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            createAlert(title: "Not Sign In", message: "Please sign in to create recipes")
            handler(false)
            return
        }
        
        guard recipeName.count >= 2, instructions.count >= 5, preparationTime > 0 else {
            createAlert(title: "Invalid inputs", message: "Recipe name must greater than 2 characters. Instructions must greater than 5 characters. And Preparation time must greater than 0")
            handler(false)
            return
        }
                
        isLoading = true
        let ref = Firestore.firestore().collection("recipes").document()
        let recipe = Recipe(id: ref.documentID, name: recipeName, image: imageURL.absoluteString, instructions: instructions, time: preparationTime, userId: userId)
        do {
            try Firestore.firestore().collection("recipes").document(ref.documentID).setData(from: recipe) { error in
                self.isLoading = false
                if let error {
                    self.createAlert(title: "Error Add Recipe", message: "Cannot add recipe, please try again.")
                    print("Error adding recipe: \(error.localizedDescription)")
                    handler(false)
                    return
                }
                handler(true)
            }
        } catch {
            isLoading = false
            createAlert(title: "Error Add Recipe", message: "Cannot add recipe, please try again.")
            print("Error adding recipe: \(error.localizedDescription)")
            handler(false)
        }
    }
    
    private func createAlert(title: String, message: String) {
        self.alertTitle = title
        self.alertMessage = message
        self.showAlert = true
    }
}
