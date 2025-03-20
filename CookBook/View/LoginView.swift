//
//  LoginView.swift
//  CookBook
//
//  Created by Weerawut Chaiyasomboon on 02/03/2568.
//

import SwiftUI

struct LoginView: View {
    @State private var vm = LoginViewModel()
    @Environment(SessionManager.self) var sessionManager
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
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
                        if let user = await vm.login() {
                            sessionManager.currentUser = user
                            sessionManager.sessionState = .login
                        }
                    }
                } label: {
                    Text("Login")
                }
                .buttonStyle(PrimaryButtonStyle())
                
                HStack {
                    Spacer()
                    
                    Text("Do not have account?")
                        .font(.system(size: 14))
                    Button {
                        vm.presentRegisterView.toggle()
                    } label: {
                        Text("Register now")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    
                    Spacer()
                }
                .padding(.top,20)
                
            }
            .padding(.horizontal,10)
            .fullScreenCover(isPresented: $vm.presentRegisterView) {
                RegisterView()
            }
            
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
    LoginView()
        .environment(SessionManager())
}

