//
//  CreateAccountView.swift
//  AIChats
//
//  Created by sinduke on 12/1/25.
//

import SwiftUI
import AuthenticationServices

struct CreateAccountView: View {
    @Environment(\.authService) private var authService
    @Environment(\.dismiss) private var dismiss
    var title: String = "Create Account?"
    var subtitle: String = "Don't lose your data. Connect to an SSO account to back up your chats and settings."
    var onDidSignIn: ((_ isNewUser: Bool) -> Void)?
    
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
                    onSignInWithAppleTapped()
                }
            Spacer()
        }
        .padding(16)
        .padding(.top, 40)
    }
    
    // MARK: -- Funcations --
    private func onSignInWithAppleTapped() {
        Task {
            do {
                let result = try await authService.signInWithApple()
                print("Sign in with Apple")
                print("Success: \(result)")
                onDidSignIn?(result.isNewUser)
                dismiss()
            } catch {
                print("Error signing in with Apple: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    CreateAccountView()
}
