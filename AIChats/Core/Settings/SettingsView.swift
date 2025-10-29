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
    var body: some View {
        NavigationStack {
            List {
                Section("App") {
                    Button("Sign Out") {
                        onSignOutButtonTapped()
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    // MARK: -- Functions
    private func onSignOutButtonTapped() {
        dismiss()
        Task {
            try? await Task.sleep(for: .seconds(2))
            appState.updateViewState(showTabbarView: false)
        }
    }
    
}

#Preview {
    SettingsView()
        .environment(AppState())
}
