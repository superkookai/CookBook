//
//  LoadingComponentView.swift
//  CookBook
//
//  Created by Weerawut Chaiyasomboon on 16/03/2568.
//

import SwiftUI

struct LoadingComponentView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()
            
            ProgressView()
                .imageScale(.large)
                .tint(.white)
        }
    }
}

#Preview {
    LoadingComponentView()
}
