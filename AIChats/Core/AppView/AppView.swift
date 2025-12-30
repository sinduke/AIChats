//
//  AppView.swift
//  AIChats
//
//  Created by sinduke on 10/29/25.
//

import SwiftUI

struct AppView: View {
    @State var appState: AppState = AppState()
    @Environment(AuthManager.self) private var authManager
    var body: some View {
        AppViewBuilder(
            showTabbar: appState.showTabbar) {
                TabbarView()
            } onboardingView: {
                WelcomeView()
            }
            .environment(appState)
            .task {
                await checkUserStatus()
            }
            .onChange(of: appState.showTabbar) { _, showTabbar in
                if !showTabbar {
                    Task {
                        await checkUserStatus()
                    }
                }
            }
    }
    // MARK: -- Funcations --
    private func checkUserStatus() async {
        if let user = authManager.auth {
            print("User already authenticated: \(user.uid)")
            dump(user)
        } else {
            do {
                let result = try await authManager.signInAnonymously()
                print("Signed in as: \(result.user.uid)")
            } catch {
                dump(error)
            }
        }
    }
}

#Preview("Onboarding") {
    AppView(appState: AppState(showTabbar: false))
}

#Preview("Tabbar") {
    AppView(appState: AppState(showTabbar: true))
}
