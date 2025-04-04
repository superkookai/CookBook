//
//  AddRecipeView.swift
//  CookBook
//
//

import SwiftUI
import PhotosUI

struct AddRecipeView: View {
    
    @State var viewModel = AddRecipeViewModel()
    @StateObject private var imageLoaderViewModel = ImageLoaderViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("What's New")
                    .font(.system(size: 26, weight: .bold))
                    .padding(.top, 20)
                ZStack {
                    Group {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.primaryFormEntry)
                            .frame(height: 200)
                        Image(systemName: "photo.fill")
                    }
                    
                    if let image = viewModel.displayRecipeImage {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 6)
                            )
                    }
                }
                .contentShape(.rect(cornerRadius: 6))
                .onTapGesture {
                    viewModel.showImageOptions.toggle()
                }
                
                Text("Receipe Name")
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.top)
                TextField("", text: $viewModel.recipeName)
                    .textFieldStyle(CapsuleTextFieldStyle())
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                Text("Preparation Time")
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.top)
                Picker(selection: $viewModel.preparationTime) {
                    ForEach(0...120, id: \.self) { time in
                        if time % 5 == 0 {
                            Text("\(time) mins")
                                .font(.system(size: 15))
                                .tag(time)
                        }
                    }
                } label: {
                    Text("Prep Time")
                }
                Text("Cooking Instructions")
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.top)
                TextEditor(text: $viewModel.instructions)
                    .frame(height: 150)
                    .background(Color.primaryFormEntry)
                    .scrollContentBackground(.hidden)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Button(action: {
                    //Add Recipe
                    Task {
                        if let imageURL = await viewModel.upload() {
                            viewModel.addRecipe(imageURL: imageURL) { success in
                                if success {
                                    dismiss()
                                }
                            }
                        }
                    }
                }, label: {
                    Text("Add Recipe")
                })
                .buttonStyle(PrimaryButtonStyle())
                
                Spacer()
            }
            .padding(.horizontal)
            .photosPicker(isPresented: $viewModel.showLibrary, selection: $imageLoaderViewModel.imageSelection, matching: .images, photoLibrary: .shared())
            .onChange(of: imageLoaderViewModel.imageToUpload, { _, newValue in
                if let newValue {
                    viewModel.displayRecipeImage = Image(uiImage: newValue)
                    viewModel.recipeImage = newValue
                }
            })
            .confirmationDialog("Upload an image to your recipe", isPresented: $viewModel.showImageOptions, titleVisibility: .visible) {
                
                Button {
                    viewModel.showLibrary = true
                } label: {
                    Text("Upload from Library")
                }
                
                Button {
                    viewModel.showCamera = true
                } label: {
                    Text("Upload from Camera")
                }
                
            }
            .fullScreenCover(isPresented: $viewModel.showCamera) {
                CameraPicker { uiImage in
                    viewModel.displayRecipeImage = Image(uiImage: uiImage)
                    viewModel.recipeImage = uiImage
                }
            }
            
            if viewModel.isUploading {
                ProgressComponentView(value: $viewModel.uploadProgress)
            }
            
            if viewModel.isLoading {
                LoadingComponentView()
            }
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button {
                //just dismiss
            } label: {
                Text("OK")
            }

        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    AddRecipeView()
}
