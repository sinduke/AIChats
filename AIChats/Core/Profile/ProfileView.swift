//
//  ProfileView.swift
//  AIChats
//
//  Created by sinduke on 10/29/25.
//

import SwiftUI

struct ProfileView: View {
    @State private var showSettingsView = false
    var body: some View {
        NavigationStack {
            Text("Profile View")
                .navigationTitle("Profile")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        settingsButton
                    }
                }
                .sheet(isPresented: $showSettingsView) {
                    SettingsView()
                }
        }
    }

    // MARK: -- View
    private var settingsButton: some View {
        Button {
            onSettingButtonTapped()
        } label: {
            Image(systemName: "gear")
                .font(.headline)
        }
    }

    // MARK: -- Functions --
    private func onSettingButtonTapped() {
        showSettingsView.toggle()
    }
}

#Preview {
    ProfileView()
}
