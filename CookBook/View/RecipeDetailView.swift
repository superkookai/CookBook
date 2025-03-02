//
//  RecipeDetailView.swift
//  CookBook
//
//  Created by Weerawut Chaiyasomboon on 02/03/2568.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack {
            Image(recipe.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 250)
                .clipped()
            
            HStack {
                Text(recipe.name)
                    .font(.system(size: 22,weight: .semibold))
                Spacer()
                Image(systemName: "clock.fill")
                    .font(.system(size: 15))
                Text("\(recipe.time)")
                    .font(.system(size: 15))
            }
            .padding(.top)
            .padding(.horizontal)
            
            Text(recipe.instructions)
                .font(.system(size: 15))
                .padding(.horizontal)
                .padding(.top,10)
            
            Spacer()
            
        }
    }
}

#Preview {
    RecipeDetailView(recipe: Recipe.mockReceipes[0])
}
