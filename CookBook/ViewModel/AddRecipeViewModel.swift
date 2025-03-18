//
//  AddRecipeViewModel.swift
//  CookBook
//
//

import Foundation
import SwiftUI
import FirebaseStorage
import FirebaseAuth

@Observable
class AddRecipeViewModel {
    var receipeName = ""
    var preparationTime = 0
    var instructions = ""
    var showImageOptions = false
    var showLibrary = false
    var displayRecipeImage: Image?
    var recipeImage: UIImage?
    var showCamera = false
    var uploadProgress: Float = 0
    var isUploading = false
    
    func upload() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        guard let recipeImage, let imageData = recipeImage.jpegData(compressionQuality: 0.7) else {
            return
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
        } catch {
            isUploading = false
            print("Error uploading image: \(error.localizedDescription)")
        }
    }
}
