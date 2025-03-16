//
//  RegisterView.swift
//  CookBook
//
//  Created by Weerawut Chaiyasomboon on 02/03/2568.
//

import SwiftUI

struct RegisterView: View {
    @State private var vm = RegisterViewModel()
    @Environment(\.dismiss) var dismiss
    @Environment(SessionManager.self) var sessionManager
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Username")
                    .font(.system(size: 15))
                TextField("Username", text: $vm.username)
                    .textFieldStyle(AuthTextFieldStyle())
                
                Text("Email")
                    .font(.system(size: 15))
                TextField("Email", text: $vm.email)
                    .textFieldStyle(AuthTextFieldStyle())
                    .keyboardType(.emailAddress)
                
                Text("Password")
                    .font(.system(size: 15))
                PasswordComponentView(showPassword: $vm.showPassword, password: $vm.password)
                
                Button {
                    Task {
                        if let user = await vm.signup() {
                            sessionManager.currentUser = user
                            sessionManager.sessionState = .login
                        }
                    }
                } label: {
                    Text("Sign up")
                }
                .buttonStyle(PrimaryButtonStyle())
                
                HStack {
                    Spacer()
                    
                    Text("Already have account?")
                        .font(.system(size: 14))
                    Button {
                        dismiss()
                    } label: {
                        Text("Login")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    
                    Spacer()
                }
                .padding(.top,20)
            }
            .padding(.horizontal,10)
            
            if vm.isLoading {
                LoadingComponentView()
            }
        }
        .alert("Error", isPresented: $vm.presentAlert) {
            
        } message: {
            Text(vm.errorMessage)
        }

    }
}

#Preview {
    RegisterView()
        .environment(SessionManager(isPreview: true))
}
