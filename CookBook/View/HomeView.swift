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
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    let spacing: CGFloat = 10
    let padding: CGFloat = 10
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
            AsyncImage(url: URL(string: recipe.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: itemWidth, height: itemHeight)
                    .clipShape(.rect(cornerRadius: 8))
            } placeholder: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .frame(width: itemWidth, height: itemHeight)
                    
                    Image(systemName: "photo")
                }
            }

//            Image(recipe.image)
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: itemWidth, height: itemHeight)
//                .clipShape(.rect(cornerRadius: 8))
            
            Text(recipe.name)
                .lineLimit(1)
                .font(.system(size: 15,weight: .semibold))
                .foregroundStyle(.black)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(vm.recipes) { recipe in
                            NavigationLink {
                                RecipeDetailView(recipe: recipe)
                            } label: {
                                RecipeRow(recipe: recipe)
                            }
                        }
                    }
                    .padding(.horizontal, padding)
                }
                
//                HStack(spacing: spacing) {
//                    ForEach(0...2, id: \.self) { index in
//                        NavigationLink {
//                            RecipeDetailView(recipe: Recipe.mockReceipes[index])
//                        } label: {
//                            RecipeRow(recipe: Recipe.mockReceipes[index])
//                        }
//                    }
//                }
//                .padding(.horizontal, padding)
                
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
            .sheet(isPresented: $vm.showAddRecipeView, onDismiss: {
                Task {
                    await vm.fetchRecipes()
                }
            }) {
                AddRecipeView()
            }
            .task {
                await vm.fetchRecipes()
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(SessionManager())
}
