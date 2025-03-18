//
//  ProgressComponentView.swift
//  CookBook
//
//  Created by Weerawut Chaiyasomboon on 18/03/2568.
//

import SwiftUI

struct ProgressComponentView: View {
    
    @Binding var value: Float
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()
            
            ProgressView("Uploading...", value: value, total: 1)
                .padding(.horizontal)
        }
    }
}

#Preview {
    ProgressComponentView(value: .constant(0.3))
}
