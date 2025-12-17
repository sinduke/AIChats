//
//  SettingsView.swift
//  AIChats
//
//  Created by sinduke on 10/29/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(AppState.self) var appState
    @State private var isPurchased: Bool = false
    @State private var isAnonymousUser: Bool = true
    @State private var showCreateAccountView: Bool = false
    var body: some View {
        NavigationStack {
            List {
                accountSection
                purchaseSection
                applicationSection
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showCreateAccountView) {
                CreateAccountView()
                    .presentationDetents([.medium])
            }
        }
    }
    // MARK: -- Views
    private var accountSection: some View {
        Section("Account") {
            Text("Sign Out")
                .rowFormatting()
                .anyButton(.pressable, action: {
                    onSignOutButtonTapped()
                })
            
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
                    print("Delete Account Tapped")
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
                Spacer()
                Text(AIUtilities.appVersion ?? "")
            }
            
            HStack {
                Text("Build Number")
                Spacer()
                Text(AIUtilities.buildNumber ?? "")
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
        dismiss()
        Task {
            try? await Task.sleep(for: .seconds(2))
            appState.updateViewState(showTabbarView: false)
        }
    }
    
    private func onCreateAccountButtonTapped() {
        showCreateAccountView = true
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

#Preview {
    SettingsView()
        .environment(AppState())
}
