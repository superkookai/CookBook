//
//  CameraPicker.swift
//  CookBook
//
//  Created by Weerawut Chaiyasomboon on 17/03/2568.
//

import Foundation
import SwiftUI

struct CameraPicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    var action: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: CameraPicker
        init(parent: CameraPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                parent.action(image)
            }
            parent.dismiss()
        }
    }
}
