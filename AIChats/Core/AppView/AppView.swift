//
//  AppView.swift
//  AIChats
//
//  Created by sinduke on 10/29/25.
//

import SwiftUI

struct AppView: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager
    @State var appState: AppState = AppState()
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
            
            do {
                try await userManager.logIn(user: user, isNewUser: false)
                print("Successfully logged in existing user: \(user.uid)")
            } catch {
                // 这里是登录之后但是保存失败的打印
                print("Failed to save user: \(error)")
                // 重试
                try? await Task.sleep(for: .seconds(3))
                await checkUserStatus()
            }
            
        } else {
            do {
                let result = try await authManager.signInAnonymously()
                print("Signed in as: \(result.user.uid)")
                try await userManager.logIn(user: result.user, isNewUser: result.isNewUser)
                print("Successfully logged in as a new user: \(result.user.uid)")
            } catch {
                dump(error)
                // 重试
                try? await Task.sleep(for: .seconds(3))
                await checkUserStatus()
            }
        }
    }
}

#Preview("Onboarding") {
    AppView(appState: AppState(showTabbar: false))
        .environment(UserManager(services: MockUserServiceContainer()))
        .environment(AuthManager(service: MockAuthService(user: nil)))
}

#Preview("Tabbar") {
    AppView(appState: AppState(showTabbar: true))
        .environment(UserManager(services: MockUserServiceContainer(user: .mock)))
        .environment(AuthManager(service: MockAuthService(user: .mock())))
}
