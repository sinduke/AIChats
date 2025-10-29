//
//  WelcomeView.swift
//  AIChats
//
//  Created by sinduke on 10/29/25.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to AIChats!")
                    .frame(maxHeight: .infinity)
                NavigationLink {
                    CompletedView()
                } label: {
                    Text("Get Started")
                        .callToActionButton()
                }
            }
            .padding(16)
        }
    }
}

#Preview {
    WelcomeView()
}
