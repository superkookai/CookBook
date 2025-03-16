//
//  HomeView.swift
//  CookBook
//
//  Created by Weerawut Chaiyasomboon on 02/03/2568.
//

import SwiftUI

struct HomeView: View {
    @State private var vm = HomeViewModel()
    @Environment(SessionManager.self) var sessionManager
    
    let spacing: CGFloat = 5
    let padding: CGFloat = 5
    var itemWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return (screenWidth - (spacing*2) - (padding*2)) / 3
    }
    var itemHeight: CGFloat {
        itemWidth * 1.5
    }
    
    var userName: String {
        if let user = sessionManager.currentUser {
            return user.username.capitalized
        } else {
            return "No user login"
        }
    }
    
    fileprivate func RecipeRow(recipe: Recipe) -> some View {
        VStack(alignment: .leading) {
            Image(recipe.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: itemWidth, height: itemHeight)
                .clipShape(.rect(cornerRadius: 8))
            
            Text(recipe.name)
                .lineLimit(1)
                .font(.system(size: 15,weight: .semibold))
                .foregroundStyle(.black)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: spacing) {
                    ForEach(0...2, id: \.self) { index in
                        NavigationLink {
                            RecipeDetailView(recipe: Recipe.mockReceipes[index])
                        } label: {
                            RecipeRow(recipe: Recipe.mockReceipes[index])
                        }
                    }
                }
                .padding(.horizontal, padding)
                
                Spacer()
                
                Button {
                    vm.showAddRecipeView.toggle()
                } label: {
                    Text("Add Recipe")
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal)
                

            }
            .navigationTitle(userName)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        vm.showSignOutAlert.toggle()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.black)
                    }
                }
            }
            .alert("Are you sure you would like to sign out?", isPresented: $vm.showSignOutAlert) {
                
                Button("Sign Out", role: .destructive) {
                    if vm.signOut() {
                        sessionManager.sessionState = .logout
                        sessionManager.currentUser = nil
                    }
                }
                
                Button("Cancel", role: .cancel) {
                    
                }
            }
            .sheet(isPresented: $vm.showAddRecipeView) {
                AddRecipeView()
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(SessionManager(isPreview: true))
}
