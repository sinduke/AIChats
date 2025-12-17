//
//  CreateAccountView.swift
//  AIChats
//
//  Created by sinduke on 12/1/25.
//

import SwiftUI
import AuthenticationServices

struct CreateAccountView: View {
    var title: String = "Create Account?"
    var subtitle: String = "Don't lose your data. Connect to an SSO account to back up your chats and settings."
    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, content: {
                Text(title)
                    .font(.largeTitle)
                Text(subtitle)
                    .font(.body)
                    .foregroundStyle(.secondary)
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            SignInWithAppleButtonView(type: .signIn, style: .black, cornerRadius: 10)
                .frame(height: 50)
                .anyButton(.pressable) {
                    print("Sign in with Apple tapped")
                }
            Spacer()
        }
        .padding(16)
        .padding(.top, 40)
    }
}

#Preview {
    CreateAccountView()
}
