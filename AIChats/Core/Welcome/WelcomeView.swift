//
//  WelcomeView.swift
//  AIChats
//
//  Created by sinduke on 10/29/25.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(AppState.self) private var appState
    @State private var imageURL: String = Constants.randomImageURL
    @State private var showCreateAccountView: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                ImageLoadView(urlString: imageURL)
                    .ignoresSafeArea()
                
               titleSection
                    .padding(.top, 24)
                
                ctaButtonSection
                    .padding(16)
                
                policyTextSection
                    
            }
            .sheet(isPresented: $showCreateAccountView) {
                CreateAccountView(
                    title: "Sign In",
                    subtitle: "Connect to your account to back up your chats and settings.",
                    onDidSignIn: { isNewUser in
                        handlerDidSignIn(isNewUser: isNewUser)
                    }
                )
                .presentationDetents([.medium])
            }
        }
    }
    // MARK: -- Views
    private var titleSection: some View {
        VStack {
            Text("AI Chats")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text("Github: sinduke/AIChats")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private var ctaButtonSection: some View {
        VStack {
            NavigationLink {
                IntroView()
            } label: {
                Text("Get Started")
                    .callToActionButton()
            }
            Text("Already have an account? Log In")
                .font(.body)
                .underline(true, color: .accent)
                .padding(8)
                .tappableBackground()
                .onTapGesture {
                    onSignInButtonTapped()
                }
        }
    }
    
    private var policyTextSection: some View {
        HStack {
            Link(destination: URL(string: Constants.termsOfServiceURL)!) {
                Text("Terms of Service")
            }
            Circle()
                .frame(width: 4, height: 4)
                .foregroundStyle(.secondary)
            Link(destination: URL(string: Constants.privacyPolicyURL)!) {
                Text("Privacy Policy")
            }
        }
    }
    
    // MARK: -- Funcations --
    private func onSignInButtonTapped() {
        showCreateAccountView = true
    }
    
    private func handlerDidSignIn(isNewUser: Bool) {
        if isNewUser {
            // Show onboarding flow
        } else {
            // Push into tabbar
            appState.updateViewState(showTabbarView: true)
        }
    }
}

#Preview {
    WelcomeView()
}
