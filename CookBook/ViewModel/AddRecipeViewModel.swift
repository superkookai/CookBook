//
//  AddRecipeViewModel.swift
//  CookBook
//
//

import Foundation
import SwiftUI

@Observable
class AddRecipeViewModel {
    var receipeName = ""
    var preparationTime = 0
    var instructions = ""
    var showImageOptions = false
    var showLibrary = false
    var displayRecipeImage: Image?
    var showCamera = false
}
