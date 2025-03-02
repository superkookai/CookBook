//
//  PasswordComponentView.swift
//  CookBook
//
//  Created by Weerawut Chaiyasomboon on 02/03/2568.
//

import SwiftUI

struct PasswordComponentView: View {
    @Binding var showPassword: Bool
    @Binding var password: String
    
    var body: some View { //body is ViewBuilder
        if showPassword {
            TextField("Password", text: $password)
                .textFieldStyle(AuthTextFieldStyle())
                .overlay(alignment: .trailing) {
                    Button {
                        showPassword = false
                    } label: {
                        Image(systemName: "eye")
                            .foregroundStyle(.black)
                            .padding(.bottom)
                    }
                }
        } else {
            VStack {
                SecureField("Password", text: $password)
                    .font(.system(size: 14))
                    
                Rectangle()
                    .frame(height: 1)
                    .padding(.bottom,15)
                    .foregroundStyle(.border)
            }
            .overlay(alignment: .trailing) {
                Button {
                    showPassword = true
                } label: {
                    Image(systemName: "eye.slash")
                        .padding(.bottom)
                        .foregroundStyle(.black)
                }
            }
        }
    }
}

#Preview("Password Component") {
    PasswordComponentView(showPassword: .constant(false), password: .constant(""))
}

struct AuthTextFieldView: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        VStack {
            TextField(title, text: $text)
                .font(.system(size: 14))
                .textInputAutocapitalization(.never)
            
            Rectangle()
                .frame(height: 1)
                .padding(.bottom,15)
                .foregroundStyle(.border)
            
        }
    }
}

#Preview("Custom TextField View") {
    AuthTextFieldView(title: "Email", text: .constant(""))
}
