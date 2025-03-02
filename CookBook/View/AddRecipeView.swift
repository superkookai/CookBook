//
//  AddRecipeView.swift
//  CookBook
//
//

import SwiftUI

struct AddRecipeView: View {
    
    @State var viewModel = AddRecipeViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("What's New")
                    .font(.system(size: 26, weight: .bold))
                    .padding(.top, 20)
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.primaryFormEntry)
                    .frame(height: 200)
                Image(systemName: "photo.fill")
            }
            Text("Receipe Name")
                .font(.system(size: 15, weight: .semibold))
                .padding(.top)
            TextField("", text: $viewModel.receipeName)
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
                
                dismiss()
            }, label: {
                Text("Add Recipe")
            })
            .buttonStyle(PrimaryButtonStyle())
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    AddRecipeView()
}
