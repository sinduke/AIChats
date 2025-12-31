//
//  SettingsView.swift
//  AIChats
//
//  Created by sinduke on 10/29/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager
    @Environment(AppState.self) private var appState
    
    @State private var isPurchased: Bool = false
    @State private var isAnonymousUser: Bool = false
    @State private var showCreateAccountView: Bool = false
    
    @State private var showAlert: AnyAppAlert?
    var body: some View {
        NavigationStack {
            List {
                accountSection
                purchaseSection
                applicationSection
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showCreateAccountView, onDismiss: {
                setAnonymousAccountState()
            }, content: {
                CreateAccountView()
                    .presentationDetents([.medium])
            })
            .showCustomAlert($showAlert)
            .onAppear {
                setAnonymousAccountState()
            }
        }
    }
    // MARK: -- Views
    private var accountSection: some View {
        Section("Account") {
            
            if isAnonymousUser {
                Text("Save & back-up account")
                    .rowFormatting()
                    .anyButton(.pressable, action: {
                        onCreateAccountButtonTapped()
                    })
            } else {
                Text("Sign Out")
                    .rowFormatting()
                    .anyButton(.pressable, action: {
                        onSignOutButtonTapped()
                    })
            }
            Text("Delete Account")
                .foregroundStyle(.red)
                .rowFormatting()
                .anyButton(.pressable, action: {
                    onDeleteAccountButtonTapped()
                })
        }
    }
    
    private var purchaseSection: some View {
        Section("Purchases") {
            HStack {
                Text("Account Status: \(isPurchased ? "Premium" : "Free" )")
                Spacer()
                if isPurchased {
                    Text("Manage")
                        .badgeButton()
                }
            }
            .rowFormatting()
            .anyButton(.pressable, action: {
                print("Delete Account Tapped")
            })
            .disabled(!isPurchased)
        }
    }
    
    private var applicationSection: some View {
        Section {
            HStack {
                Text("Version")
                    .badge(AIUtilities.appVersion ?? "")
            }
            
            HStack {
                Text("Build Number")
                    .badge(AIUtilities.buildNumber ?? "")
            }
            
            Text("Contact Us")
                .foregroundStyle(.blue)
                .rowFormatting()
                .anyButton {
                    
                }
        } header: {
            Text("Application")
        } footer: {
            Text("AIChats © 2025. All rights reserved.")
                .font(.footnote)
        }
    }
    
    // MARK: -- Functions
    private func onSignOutButtonTapped() {
        print("Sign Out Tapped")
        Task {
            do {
                try authManager.signOut()
                try userManager.signOut()
                
                await dismissScreen()
            } catch {
                showAlert = AnyAppAlert(error: error)
            }
        }
    }
    
    private func dismissScreen() async {
        dismiss()
        try? await Task.sleep(for: .seconds(2))
        appState.updateViewState(showTabbarView: false)
    }
    
    private func onCreateAccountButtonTapped() {
        showCreateAccountView = true
    }

    private func setAnonymousAccountState() {
        isAnonymousUser = authManager.auth?.isAnonymous == true
    }
    
    private func onDeleteAccountButtonTapped() {
        showAlert = AnyAppAlert(
            title: "Delete Account?",
            message: "This will permanently delete your account and all your data. Are you sure you want to do this?",
            buttons: {
                AnyView(
                    Group {
                        Button(role: .destructive, action: {
                            onDeleteAccountConfirmation()
                        })
                    }
                )
            }
        )
    }
    
    private func onDeleteAccountConfirmation() {
        Task {
            do {
                try await authManager.deleteAccount()
                try await userManager.deleteCurrentUser()
                
                await dismissScreen()
            } catch {
                showAlert = AnyAppAlert(error: error)
            }
        }
    }
}

fileprivate extension View {
    func rowFormatting() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 4)
            .listRowBackground(Color(uiColor: .systemBackground))
    }
}

#Preview("No Authentication") {
    SettingsView()
        .environment(AuthManager(service: MockAuthService(user: nil)))
        .environment(UserManager(services: MockUserServiceContainer()))
        .environment(AppState())
}

#Preview("Anomymous User") {
    SettingsView()
        .environment(AuthManager(service: MockAuthService(user: UserAuthInfo.mock(isAnonymous: true))))
        .environment(UserManager(services: MockUserServiceContainer(user: .mock)))
        .environment(AppState())
}

#Preview("Not anonymous User") {
    SettingsView()
        .environment(AuthManager(service: MockAuthService(user: UserAuthInfo.mock(isAnonymous: false))))
        .environment(UserManager(services: MockUserServiceContainer(user: .mock)))
        .environment(AppState())
}
