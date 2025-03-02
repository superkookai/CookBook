//
//  AuthTextFieldStyle.swift
//  CookBook
//
//  Created by Weerawut Chaiyasomboon on 02/03/2568.
//

import Foundation
import SwiftUI

struct AuthTextFieldStyle: TextFieldStyle {
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack {
            configuration
                .font(.system(size: 14))
                .textInputAutocapitalization(.never)
            
            Rectangle()
                .frame(height: 1)
                .padding(.bottom,15)
                .foregroundStyle(.border)
        }
    }
}
