//
//  SignWithAppleButtons.swift
//  AIChats
//
//  Created by sinduke on 12/1/25.
//

import SwiftUI
@_exported import AuthenticationServices

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct SignInWithAppleButtonView1: View {
    
    public var body: some View {
        SignInWithAppleButton(.signIn) { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            switch result {
            case .success(let auth):
                print("Authorization:", auth)
            case .failure(let error):
                print("Error:", error.localizedDescription)
            }
        }
        
        SignInWithAppleButton(.signIn) { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            switch result {
            case .success(let auth):
                print("Authorization:", auth)
            case .failure(let error):
                print("Error:", error.localizedDescription)
            }
        }
        .frame(height: 50)
        
        SignInWithAppleButton(.continue) { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            switch result {
            case .success(let auth):
                print("Authorization:", auth)
            case .failure(let error):
                print("Error:", error.localizedDescription)
            }
        }
        .frame(width: 44, height: 44)
        .clipShape(.circle)
        
        SignInWithAppleButton(.signUp) { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            switch result {
            case .success(let auth):
                print("Authorization:", auth)
            case .failure(let error):
                print("Error:", error.localizedDescription)
            }
        }
        .frame(height: 50)

        SignInWithAppleButton { request in
            request.requestedScopes = [.email, .fullName]
            request.requestedOperation = .operationLogin
            request.state = .localizedStringWithFormat(NSLocalizedString("Sign in with Apple", comment: ""))
        } onCompletion: { result in
            switch result {
            case .success(let auth):
                print("Authorization:", auth)
            case .failure(let error):
                print("Error:", error.localizedDescription)
            }
        }
        
        SignInWithAppleButton { request in
            request.requestedScopes = [.email, .fullName]
            request.requestedOperation = .operationLogin
            request.state = .localizedStringWithFormat(NSLocalizedString("Sign in with Apple", comment: ""))
        } onCompletion: { result in
            switch result {
            case .success(let auth):
                print("Authorization:", auth)
            case .failure(let error):
                print("Error:", error.localizedDescription)
            }
        }
        .clipShape(.rect(cornerRadius: 100, style: .circular))
        .signInWithAppleButtonStyle(.white)
    }
}

public struct SignInWithAppleButtonView: View {
    public let type: ASAuthorizationAppleIDButton.ButtonType
    public let style: ASAuthorizationAppleIDButton.Style
    public let cornerRadius: CGFloat
    
    public init(
        type: ASAuthorizationAppleIDButton.ButtonType = .signIn,
        style: ASAuthorizationAppleIDButton.Style = .black,
        cornerRadius: CGFloat = 10
    ) {
        self.type = type
        self.style = style
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        ZStack {
            Color.black.opacity(0.001)
            SignInWithAppleButtonRepresentable(type: type, style: style, cornerRadius: cornerRadius)
                .disabled(true)
        }
    }
}

private struct SignInWithAppleButtonRepresentable: UIViewRepresentable {
    let type: ASAuthorizationAppleIDButton.ButtonType
    let style: ASAuthorizationAppleIDButton.Style
    let cornerRadius: CGFloat
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(type: type, style: style)
        button.cornerRadius = cornerRadius
        return button
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    }
    func makeCoordinator() -> Coordinator {
    }
}

#Preview("SignInWithAppleButtonView") {
    ZStack {
        VStack {
            SignInWithAppleButtonView1()
            
            SignInWithAppleButtonView(type: .signIn, style: .black, cornerRadius: 10)
                .frame(height: 50)
        }
        .padding(40)
    }
}
